import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Text("History Screen", style: AppThemes.appBeauSansMedium,),
        )
    );
  }
}
