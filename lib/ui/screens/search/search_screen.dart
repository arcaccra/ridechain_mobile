import 'package:flutter/material.dart';

import '../../../app/theme.dart';


class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Search Screen", style: AppThemes.appBeauSansMedium,),
      )
    );
  }
}
