import 'dart:developer';
import 'dart:typed_data';

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:cbor/cbor.dart' as cborlib;
// ignore: depend_on_referenced_packages (cbor is a direct dep)
import 'package:flutter/foundation.dart';
import 'package:ridex/data/locator.dart';
import 'package:ridex/data/models/ride_model.dart';
import 'package:ridex/services/blockfrost_service.dart';
import 'package:ridex/services/cardano_wallet_service.dart';
import 'package:ridex/services/trip_firebase_service.dart';
import 'package:uuid/uuid.dart';

enum PaymentState { idle, building, signing, submitting, confirming, done, failed }

class PaymentProvider extends ChangeNotifier {
  PaymentState _state = PaymentState.idle;
  String? _txHash;
  String? _errorMessage;
  int _actualNetworkFeeLovelace = 0;

  PaymentState get state => _state;
  String? get txHash => _txHash;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state != PaymentState.idle &&
      _state != PaymentState.done &&
      _state != PaymentState.failed;

  /// Actual on-chain network fee in ADA (available after building step).
  double get actualNetworkFeeAda => _actualNetworkFeeLovelace / 1_000_000;

  // ── Main payment flow ─────────────────────────────────────────────────────

  /// Executes the full passenger → driver on-chain ADA payment.
  Future<bool> payForRide({
    required RideModel ride,
    required String passengerAddress,
    required String passengerName,
    required String passengerId,
  }) async {
    _reset();

    final walletSvc = locator<CardanoWalletService>();
    final blockfrost = locator<BlockfrostService>();
    final firestore = locator<TripFirebaseService>();

    final driverAddress = ride.driver?.user?.walletAddress;
    if (driverAddress == null || driverAddress.isEmpty) {
      return _fail('Driver has no wallet address linked. Payment cannot proceed.');
    }

    final priceAda = double.tryParse(ride.pricePerSeat ?? '0') ?? 0.0;
    final priceLovelace = (priceAda * 1_000_000).toInt();

    try {
      // ── 1. Build unsigned transaction ─────────────────────────────────────
      _setState(PaymentState.building);

      final utxos = await blockfrost.getUtxos(passengerAddress);
      if (utxos.isEmpty) {
        return _fail(
          'No UTXOs found for your wallet. Please fund your Cardano address first.',
        );
      }

      final totalAvailable = utxos.fold<int>(0, (s, u) => s + u.lovelace);
      if (totalAvailable < priceLovelace + 200000) {
        return _fail(
          'Insufficient balance. You need at least '
          '${(priceLovelace + 200000) / 1_000_000} ADA.',
        );
      }

      final currentSlot = await blockfrost.getLatestSlot();

      // Map Blockfrost UTXOs to catalyst_cardano_serialization inputs
      final txInputs = utxos.map((u) {
        return TransactionUnspentOutput(
          input: TransactionInput(
            transactionId: TransactionHash.fromHex(u.txHash),
            index: u.txIndex,
          ),
          output: TransactionOutput(
            address: ShelleyAddress.fromBech32(passengerAddress),
            amount: Balance(coin: Coin(u.lovelace)),
          ),
        );
      }).toSet();

      final txBuilder = TransactionBuilder(
        config: TransactionBuilderConfig(
          feeAlgo: TieredFee(
            constant: 155381,
            coefficient: 44,
            refScriptByteCost: 15,
          ),
          maxTxSize: 16384,
          maxValueSize: 5000,
          coinsPerUtxoByte: Coin(4310),
        ),
        inputs: txInputs,
        ttl: SlotBigNum(currentSlot + 7200),
        networkId: NetworkId.mainnet,
      );

      final builtBody = txBuilder
          .withOutput(
            TransactionOutput(
              address: ShelleyAddress.fromBech32(driverAddress),
              amount: Balance(coin: Coin(priceLovelace)),
            ),
          )
          .withChangeAddressIfNeeded(ShelleyAddress.fromBech32(passengerAddress))
          .buildBody();

      _actualNetworkFeeLovelace = builtBody.fee?.value ?? 170000;
      notifyListeners();

      // Wrap body in an unsigned Transaction (empty witness set) and encode to hex
      final unsignedTx = Transaction(
        body: builtBody,
        witnessSet: const TransactionWitnessSet(),
        isValid: true,
        auxiliaryData: null,
      );
      final unsignedTxHex = _txToHex(unsignedTx);

      // ── 2. Sign ───────────────────────────────────────────────────────────
      _setState(PaymentState.signing);

      final signedTxHex = await walletSvc.signTransaction(
        unsignedTxHex: unsignedTxHex,
        signerAddress: passengerAddress,
      );

      // ── 3. Submit to Blockfrost ───────────────────────────────────────────
      _setState(PaymentState.submitting);
      final hash = await blockfrost.submitTransaction(signedTxHex);
      _txHash = hash;

      // ── 4. Record in Firestore ────────────────────────────────────────────
      await firestore.completePayment(
        paymentId: const Uuid().v4(),
        username: passengerName,
        tripId: ride.uuid ?? '',
        userId: passengerId,
        amount: priceAda,
      );

      // ── 5. Await on-chain confirmation ────────────────────────────────────
      _setState(PaymentState.confirming);
      final confirmed = await blockfrost.awaitConfirmation(hash);
      if (!confirmed) {
        // Transaction submitted but confirmation polling timed out.
        // It is still in the mempool and will land — treat as success.
        log('[PaymentProvider] tx in mempool, confirmation polling timed out: $hash');
      }

      _setState(PaymentState.done);
      return true;
    } catch (e, st) {
      log('[PaymentProvider] error: $e', stackTrace: st);
      return _fail(e.toString());
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  void reset() => _reset();

  void _reset() {
    _state = PaymentState.idle;
    _txHash = null;
    _errorMessage = null;
    _actualNetworkFeeLovelace = 0;
    notifyListeners();
  }

  void _setState(PaymentState s) {
    _state = s;
    notifyListeners();
  }

  bool _fail(String message) {
    _errorMessage = message;
    _state = PaymentState.failed;
    notifyListeners();
    return false;
  }

  /// Encodes a [Transaction] to CBOR and returns the hex string.
  String _txToHex(Transaction tx) {
    final bytes = Uint8List.fromList(cborlib.cbor.encode(tx.toCbor()));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
