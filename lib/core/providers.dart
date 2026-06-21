


import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:ridex/providers/payment_provider.dart';
import 'package:ridex/providers/rides_provider.dart';

import '../providers/auth_provider.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<AuthVm>.value(value: AuthVm()),
  ChangeNotifierProvider<RideProvider>.value(value: RideProvider()),
  ChangeNotifierProvider<PaymentProvider>.value(value: PaymentProvider()),
];