import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../../app/theme.dart';
import '../../../core/core_constants/colors.dart';
import '../../../core/core_constants/label.dart';
import '../../../data/locator.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/dialog_service.dart';
import '../../shared_widgets/custom_app_bar.dart';
import '../../shared_widgets/custom_textfield.dart';
import '../../shared_widgets/default_button.dart';
import '../../shared_widgets/loader.dart';
import 'auth_widgets/scanning_widget.dart';

class WalletInfo extends StatefulWidget {
  const WalletInfo({super.key});

  @override
  State<WalletInfo> createState() => _WalletInfoState();
}

class _WalletInfoState extends State<WalletInfo> {
  AuthVm? authVm;
  final _globalKey = GlobalKey<FormState>();
  final _walletCtrl = TextEditingController();
  MobileScannerController? scannerController;

  @override
  void initState() {
    // TODO: implement initState
    authVm = context.read<AuthVm>();
    super.initState();
    scannerController = MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    setState(() {
      _walletCtrl.text = authVm?.walletAddress ?? "";
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final authVm = Provider.of<AuthVm>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Stack(
          children: [
            Form(
              key: _globalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Gap(20.h),
                  const CustomLoginAppBar(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Gap(20.h),
                            Text(
                              Label.walletAccountLabel,
                              style: AppThemes.getCustomTextStyle(fontFamily: "Zain", weight: FontWeight.w900, color: AppColors.primaryColor, fontSize: 38, lineHeight: 1.33),
                              textAlign: TextAlign.center,
                            )
                                .animate(delay: 100.ms)
                                .slide(
                              begin: const Offset(0, -0.3),
                              end: const Offset(0, 0), // End at center
                              duration: 600.ms,
                              curve: Curves.easeOutBack,
                            )
                                .fade(begin: 0, end: 1, duration: 600.ms),
                            Gap(4.h),
                            Text(
                              Label.walletMessageLabel,
                              style: AppThemes.getCustomTextStyle(fontFamily: "Zain", weight: FontWeight.w700, color: AppColors.primaryColor, fontSize: 16, lineHeight: 1.33),
                              textAlign: TextAlign.center,
                            )
                                .animate(delay: 100.ms)
                                .slide(
                              begin: const Offset(0, -0.3),
                              end: const Offset(0, 0), // End at center
                              duration: 600.ms,
                              curve: Curves.easeOutBack,
                            )
                                .fade(begin: 0, end: 1, duration: 600.ms),
                            Gap(0.15.sh),
                            //TODO update wallet info with information
                            CustomTextField(
                              labelText: 'Wallet Number',
                              hintText: "Enter wallet number",
                              keyboardType: TextInputType.text,
                              controller: _walletCtrl,
                              suffixIcon: GestureDetector(
                                onTap: (){
                                  //TODO: scan qr code
                                  locator<DialogService>().showCustomModal(context: context, customModal:
                                  ScanningWidget(
                                      mobileScannerController: scannerController!,
                                      onCapture: (barcodeCapture) {
                                        setState(() {
                                          _walletCtrl.text = barcodeCapture.barcodes.first.displayValue ?? "";
                                        });
                                        Navigator.pop(context);
                                      }));
                                },
                                child: Icon(Icons.qr_code_2_outlined, color: AppColors.primaryColor,),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'The wallet number must not be empty';
                                }
                                return null;
                              },
                            ),
                            Gap(50.h),
                            DefaultButton(
                              onBtnTap: () async {
                                if (_globalKey.currentState!.validate()) {
                                  final wallet = _walletCtrl.text.trim();
                                  Map<String, dynamic> walletMap = {'address': wallet};
                                  //TODO update wallet info with information
                                  await authVm.updateWalletAddress(walletMap);
                                }
                              },
                              btnText: Label.submitLabel,
                              isIconPresent: false,
                              btnColor: AppColors.purple,
                              btnTextColor: AppColors.white,
                            ),
                            Gap(30.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Gap(16.h),
                ],
              ),
            ),
            Visibility(visible: authVm.isLoading, child: const Loader()),
          ],
        ),
      ),
    );
  }
}
