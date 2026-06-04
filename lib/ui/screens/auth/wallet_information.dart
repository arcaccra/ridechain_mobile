import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../../app/theme.dart';
import '../../../core/core_constants/colors.dart';
import '../../../data/locator.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/dialog_service.dart';
import '../../shared_widgets/custom_textfield.dart';
import '../../shared_widgets/default_button.dart';
import '../../shared_widgets/loader.dart';
import '../navigation/app_navigation_screen.dart';
import 'auth_widgets/scanning_widget.dart';

class WalletInfo extends StatefulWidget {
  const WalletInfo({super.key});

  @override
  State<WalletInfo> createState() => _WalletInfoState();
}

class _WalletInfoState extends State<WalletInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _walletCtrl = TextEditingController();
  late final MobileScannerController _scannerCtrl;

  @override
  void initState() {
    super.initState();
    _scannerCtrl = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
    final authVm = context.read<AuthVm>();
    if (authVm.walletAddress != null) {
      _walletCtrl.text = authVm.walletAddress!;
    }
  }

  @override
  void dispose() {
    _walletCtrl.dispose();
    _scannerCtrl.dispose();
    super.dispose();
  }

  Future<void> _save(AuthVm authVm) async {
    if (!_formKey.currentState!.validate()) return;
    final wallet = _walletCtrl.text.trim();
    final success =
        await authVm.updateWalletAddress({'address': wallet});
    if (!mounted) return;
    if (success) {
      locator<DialogService>().showSnackBar(
          'Wallet saved', 'Your Cardano address has been linked.');
      Get.offAll(() => const AppNavigationScreen(),
          transition: Transition.leftToRight);
    }
  }

  void _scanQr(BuildContext context) {
    locator<DialogService>().showCustomModal(
      context: context,
      customModal: ScanningWidget(
        mobileScannerController: _scannerCtrl,
        onCapture: (capture) {
          setState(() {
            _walletCtrl.text =
                capture.barcodes.first.displayValue ?? '';
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthVm>();
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                Padding(
                  padding: EdgeInsets.only(top: 8.h, left: 8.w),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        size: 20),
                    color: AppColors.primaryColor,
                    onPressed: () => Get.back(),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Gap(16.h),

                          // Wallet icon
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.purple,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet_outlined,
                              color: Colors.white,
                              size: 36,
                            ),
                          )
                              .animate()
                              .fade(begin: 0, end: 1, duration: 400.ms)
                              .scale(
                                  begin: const Offset(0.8, 0.8),
                                  end: const Offset(1, 1),
                                  duration: 400.ms,
                                  curve: Curves.easeOut),

                          Gap(24.h),

                          Text(
                            'Link your wallet',
                            style: AppThemes.getCustomTextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 28,
                              weight: FontWeight.w700,
                              color: AppColors.primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          )
                              .animate(delay: 80.ms)
                              .fade(begin: 0, end: 1, duration: 400.ms),

                          Gap(8.h),

                          Text(
                            'Add your Cardano address to receive ADA and pay for rides.',
                            style: AppThemes.getCustomTextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              weight: FontWeight.w400,
                              color: const Color(0xFF6B7280),
                            ),
                            textAlign: TextAlign.center,
                          )
                              .animate(delay: 120.ms)
                              .fade(begin: 0, end: 1, duration: 400.ms),

                          Gap(32.h),

                          // Field label
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Cardano wallet address',
                              style: AppThemes.getCustomTextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                weight: FontWeight.w500,
                                color: const Color(0xFF374151),
                              ),
                            ),
                          ),
                          Gap(6.h),

                          // Wallet address field
                          CustomTextField(
                            controller: _walletCtrl,
                            hintText: 'addr1qx9k7..3p8m2lr0z..n8x2pn',
                            keyboardType: TextInputType.text,
                            fillColor: const Color(0xFFEEEAF8),
                            prefixIcon: const Icon(
                              Icons.account_balance_wallet_outlined,
                              color: Color(0xFF9CA3AF),
                              size: 20,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () => _scanQr(context),
                              child: const Padding(
                                padding: EdgeInsets.all(12),
                                child: Icon(Icons.qr_code_2_outlined,
                                    color: Color(0xFF6B7280), size: 22),
                              ),
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Please enter your wallet address'
                                : null,
                          ).animate(delay: 160.ms)
                              .fade(begin: 0, end: 1, duration: 400.ms),

                          Gap(16.h),

                          // Security note
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEEAF8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.shield_outlined,
                                    color: AppColors.purple, size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'We store your public address only. Your keys never leave your wallet.',
                                    style: AppThemes.getCustomTextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13,
                                      weight: FontWeight.w400,
                                      color: const Color(0xFF6B7280),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).animate(delay: 200.ms)
                              .fade(begin: 0, end: 1, duration: 400.ms),

                          Gap(24.h),

                          // Don't have a wallet yet?
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Don\'t have a wallet yet?',
                              style: AppThemes.getCustomTextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                weight: FontWeight.w400,
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                          ),
                          Gap(10.h),

                          // Wallet provider pills
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              spacing: 10,
                              children: ['Lace', 'Nami', 'Eternl']
                                  .map((name) => _WalletPill(name: name))
                                  .toList(),
                            ),
                          ).animate(delay: 240.ms)
                              .fade(begin: 0, end: 1, duration: 400.ms),

                          Gap(24.h),
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
                  child: DefaultButton(
                    onBtnTap: () => _save(authVm),
                    btnText: 'Save',
                    btnColor: AppColors.purple,
                    btnTextColor: AppColors.white,
                  ),
                ),
              ],
            ),

            if (authVm.isLoading) const Loader(),
          ],
        ),
      ),
    );
  }
}

class _WalletPill extends StatelessWidget {
  final String name;
  const _WalletPill({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        name,
        style: AppThemes.getCustomTextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          weight: FontWeight.w500,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
