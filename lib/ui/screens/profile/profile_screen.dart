import 'package:flutter/material.dart';

import '../../../app/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Text("Profile Screen", style: AppThemes.appBeauSansMedium,),
        )
    );
  }
}
