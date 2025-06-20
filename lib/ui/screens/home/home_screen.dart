import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Text("Home Screen", style: AppThemes.appBeauSansMedium,),
        )
    );
  }
}
