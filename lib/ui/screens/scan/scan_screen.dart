import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../app/theme.dart';
import '../../../core/core_constants/colors.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen>
    with SingleTickerProviderStateMixin {
  late final MobileScannerController _scanner;
  late final AnimationController _lineCtrl;
  late final Animation<double> _lineAnim;

  bool _torchOn = false;
  bool _rewardVisible = false;
  bool _hasScanned = false;

  @override
  void initState() {
    super.initState();
    _scanner = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      torchEnabled: false,
    );
    _lineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _lineAnim = CurvedAnimation(parent: _lineCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _scanner.dispose();
    _lineCtrl.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) return;
    final code = capture.barcodes.firstOrNull?.displayValue;
    if (code == null) return;
    setState(() {
      _hasScanned = true;
      _rewardVisible = true;
    });
  }

  void _toggleTorch() {
    _scanner.toggleTorch();
    setState(() => _torchOn = !_torchOn);
  }

  void _scanAnother() {
    setState(() {
      _hasScanned = false;
      _rewardVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full-screen camera feed
          Positioned.fill(
            child: MobileScanner(
              controller: _scanner,
              onDetect: _onDetect,
            ),
          ),

          // Dark vignette overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.75,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.72),
                  ],
                ),
              ),
            ),
          ),

          // Safe area content
          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                  child: Row(
                    children: [
                      _DarkButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        onTap: () {},
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Scan QR',
                        style: AppThemes.getCustomTextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          weight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      _DarkButton(
                        icon: _torchOn
                            ? Icons.flash_on_rounded
                            : Icons.flash_off_rounded,
                        size: 18,
                        onTap: _toggleTorch,
                        active: _torchOn,
                      ),
                    ],
                  ),
                ),

                // Viewfinder
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: 260,
                      height: 260,
                      child: Stack(
                        children: [
                          // Corner brackets
                          CustomPaint(
                            size: const Size(260, 260),
                            painter: _CornerPainter(),
                          ),
                          // Animated scan line
                          AnimatedBuilder(
                            animation: _lineAnim,
                            builder: (context, _) {
                              return Positioned(
                                top: 20 + (_lineAnim.value * 200),
                                left: 20,
                                right: 20,
                                child: Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        AppColors.purple
                                            .withValues(alpha: 0.8),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom label + controls
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
                  child: Column(
                    children: [
                      Text(
                        'Scan your ride QR',
                        style: AppThemes.getCustomTextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 20,
                          weight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Earn 0.05 ₳ for verified trips',
                        style: AppThemes.getCustomTextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          weight: FontWeight.w400,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _DarkButton(
                            icon: Icons.image_outlined,
                            size: 22,
                            onTap: () {},
                          ),
                          const SizedBox(width: 20),
                          _DarkButton(
                            icon: _torchOn
                                ? Icons.flash_on_rounded
                                : Icons.flash_off_rounded,
                            size: 22,
                            onTap: _toggleTorch,
                            active: _torchOn,
                          ),
                          const SizedBox(width: 20),
                          _DarkButton(
                            icon: Icons.help_outline_rounded,
                            size: 22,
                            onTap: () {},
                          ),
                        ],
                      ),
                      // Space for the floating nav bar
                      Gap(80.h),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Reward card (slides up from bottom when scanned)
          if (_rewardVisible)
            Positioned(
              left: 16,
              right: 16,
              bottom: 90.h,
              child: _RewardCard(onScanAnother: _scanAnother)
                  .animate()
                  .slideY(
                    begin: 0.3,
                    end: 0,
                    duration: 400.ms,
                    curve: Curves.easeOutBack,
                  )
                  .fade(begin: 0, end: 1, duration: 300.ms),
            ),
        ],
      ),
    );
  }
}

// ── Dark icon button ──────────────────────────────────────────────────────────
class _DarkButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback onTap;
  final bool active;

  const _DarkButton({
    required this.icon,
    required this.size,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: active
              ? AppColors.purple.withValues(alpha: 0.8)
              : Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: Colors.white, size: size),
      ),
    );
  }
}

// ── Corner brackets painter ───────────────────────────────────────────────────
class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.purple
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const len = 30.0;
    const r = 14.0;

    // Top-left
    canvas.drawLine(
        const Offset(r, 0), const Offset(r + len, 0), paint);
    canvas.drawLine(
        const Offset(0, r), const Offset(0, r + len), paint);
    canvas.drawArc(const Rect.fromLTWH(0, 0, r * 2, r * 2),
        3.14159, 3.14159 / 2, false, paint);

    // Top-right
    canvas.drawLine(
        Offset(size.width - r - len, 0), Offset(size.width - r, 0), paint);
    canvas.drawLine(Offset(size.width, r),
        Offset(size.width, r + len), paint);
    canvas.drawArc(
        Rect.fromLTWH(size.width - r * 2, 0, r * 2, r * 2),
        3.14159 * 1.5,
        3.14159 / 2,
        false,
        paint);

    // Bottom-left
    canvas.drawLine(Offset(r, size.height),
        Offset(r + len, size.height), paint);
    canvas.drawLine(Offset(0, size.height - r),
        Offset(0, size.height - r - len), paint);
    canvas.drawArc(
        Rect.fromLTWH(0, size.height - r * 2, r * 2, r * 2),
        3.14159 / 2,
        3.14159 / 2,
        false,
        paint);

    // Bottom-right
    canvas.drawLine(Offset(size.width - r - len, size.height),
        Offset(size.width - r, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height - r),
        Offset(size.width, size.height - r - len), paint);
    canvas.drawArc(
        Rect.fromLTWH(
            size.width - r * 2, size.height - r * 2, r * 2, r * 2),
        0,
        3.14159 / 2,
        false,
        paint);
  }

  @override
  bool shouldRepaint(_CornerPainter old) => false;
}

// ── Reward card ───────────────────────────────────────────────────────────────
class _RewardCard extends StatelessWidget {
  final VoidCallback onScanAnother;
  const _RewardCard({required this.onScanAnother});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF16A34A),
                ),
                child: const Icon(Icons.check_rounded,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reward earned!',
                      style: AppThemes.getCustomTextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        weight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    Text(
                      'Trip verified on chain',
                      style: AppThemes.getCustomTextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        weight: FontWeight.w400,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '+0.05 ₳',
                style: AppThemes.getCustomTextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 20,
                  weight: FontWeight.w700,
                  color: AppColors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onScanAnother,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purple,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                elevation: 0,
              ),
              child: Text(
                'Scan another',
                style: AppThemes.getCustomTextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  weight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
