import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../app/theme.dart';
import '../../../core/core_constants/colors.dart';
import '../../../providers/auth_provider.dart';

class BottomCardWidget extends StatefulWidget {
  const BottomCardWidget({
    super.key,
    required this.onDestinationSubmit,
    required this.locationController,
  });

  final void Function(String destination) onDestinationSubmit;
  final TextEditingController locationController;

  @override
  State<BottomCardWidget> createState() => _BottomCardWidgetState();
}

class _BottomCardWidgetState extends State<BottomCardWidget> {
  bool _searching = false;
  final FocusNode _focusNode = FocusNode();

  static const _suggestedPlaces = [
    (emoji: '🛍️', name: 'Accra Mall', subtitle: 'Spintex Road, Accra'),
    (emoji: '✈️', name: 'Kotoka International Airport', subtitle: 'Airport Rd, Accra'),
    (emoji: '🏥', name: 'Korle-Bu Hospital', subtitle: 'Korle Bu, Accra'),
    (emoji: '🏫', name: 'University of Ghana', subtitle: 'Legon, Accra'),
  ];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && !_searching) {
        setState(() => _searching = true);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final text = widget.locationController.text.trim();
    if (text.isNotEmpty) {
      setState(() => _searching = false);
      _focusNode.unfocus();
      widget.onDestinationSubmit(text);
    }
  }

  void _selectSuggestion(String name) {
    widget.locationController.text = name;
    _submit();
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthVm>();
    return _searching
        ? _buildSearchState(authVm)
        : _buildIdleState(authVm);
  }

  Widget _buildIdleState(AuthVm authVm) {
    final firstName = _firstName(authVm);
    final balance = authVm.userWallet?.balance?.ada;
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Greeting row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.purple,
                ),
                child: Center(
                  child: Text(
                    firstName.isNotEmpty ? firstName[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting,',
                      style: AppThemes.getCustomTextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        weight: FontWeight.w400,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    Text(
                      'Where are you headed, $firstName?',
                      style: AppThemes.getCustomTextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        weight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              // ADA balance chip
              if (balance != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEAF8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${balance.toStringAsFixed(2)} ₳',
                    style: AppThemes.getCustomTextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      weight: FontWeight.w700,
                      color: AppColors.purple,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 18),
          const Divider(color: Color(0xFFF3F4F6), height: 1),
          const SizedBox(height: 14),

          // Current location row
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.purple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Current location',
                  style: AppThemes.getCustomTextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    weight: FontWeight.w500,
                    color: const Color(0xFF374151),
                  ),
                ),
              ),
            ],
          ),

          // Dotted connector
          Padding(
            padding: const EdgeInsets.only(left: 4.5),
            child: _DottedLine(height: 20),
          ),

          // Where to? row
          GestureDetector(
            onTap: () {
              setState(() => _searching = true);
              _focusNode.requestFocus();
            },
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Where to?',
                    style: AppThemes.getCustomTextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      weight: FontWeight.w400,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ),
                const Icon(Icons.search_rounded,
                    color: Color(0xFF9CA3AF), size: 20),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // SUGGESTED label
          Text(
            'SUGGESTED',
            style: AppThemes.getCustomTextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              weight: FontWeight.w600,
              color: const Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 10),

          // Suggestion chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _suggestedPlaces.take(2).map((place) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => _selectSuggestion(place.name),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(place.emoji,
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Text(
                            place.name,
                            style: AppThemes.getCustomTextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              weight: FontWeight.w500,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchState(AuthVm authVm) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Search header
          Padding(
            padding: EdgeInsets.fromLTRB(8, 14.h, 16, 0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: AppColors.primaryColor, size: 22),
                  onPressed: () {
                    setState(() => _searching = false);
                    _focusNode.unfocus();
                    widget.locationController.clear();
                  },
                ),
                Expanded(
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEAF8),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: AppColors.purple, width: 1.5),
                    ),
                    child: TextField(
                      controller: widget.locationController,
                      focusNode: _focusNode,
                      autofocus: true,
                      style: AppThemes.getCustomTextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        weight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search destination…',
                        hintStyle: AppThemes.getCustomTextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          weight: FontWeight.w400,
                          color: const Color(0xFF9CA3AF),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        suffixIcon: GestureDetector(
                          onTap: _submit,
                          child: const Icon(Icons.search_rounded,
                              color: AppColors.purple, size: 20),
                        ),
                      ),
                      onSubmitted: (_) => _submit(),
                      textInputAction: TextInputAction.search,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          const Divider(color: Color(0xFFF3F4F6), height: 1),

          // Suggestion list
          ..._suggestedPlaces.map((place) {
            return InkWell(
              onTap: () => _selectSuggestion(place.name),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEAF8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(place.emoji,
                            style: const TextStyle(fontSize: 18)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            place.name,
                            style: AppThemes.getCustomTextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              weight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          Text(
                            place.subtitle,
                            style: AppThemes.getCustomTextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              weight: FontWeight.w400,
                              color: const Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded,
                        color: Color(0xFF9CA3AF), size: 20),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  String _firstName(AuthVm authVm) {
    final full = authVm.currentUser?.fullName ?? '';
    if (full.isEmpty) return 'there';
    return full.split(' ').first;
  }
}

class _DottedLine extends StatelessWidget {
  final double height;
  const _DottedLine({required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1,
      height: height,
      child: CustomPaint(painter: _DottedLinePainter()),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD1D5DB)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const dashHeight = 4.0;
    const dashSpace = 3.0;
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_DottedLinePainter old) => false;
}
