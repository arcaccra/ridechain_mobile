import 'package:flutter/material.dart';

import '../../../app/theme.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Text("Scan Screen", style: AppThemes.appBeauSansMedium,),
        )
    );
  }
}
