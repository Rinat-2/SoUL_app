import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/auth.dart';
//import 'package:ui/screens/welcome_screen.dart';
import 'package:ui/user.dart';

import 'widgets/bottom_navigation.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);

    final bool isLoggedIn = user != null;

    return isLoggedIn ? BottomNavigation() : AuthorizationPage();
  }
}
