import 'package:chat_me/screens/route.dart';
import 'package:chat_me/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:chat_me/business_logic/auth_provider.dart';

import 'loading_screen.dart';

enum AuthStatus { unKnown, notLoggedIn, loggedIn }

class StartupScreen extends StatefulWidget {
  static const String id = "StartupScreen";
  const StartupScreen({Key? key}) : super(key: key);
  @override
  _StartupScreenState createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  AuthStatus _authStatus = AuthStatus.unKnown;
  String currentUid = "";
  String state = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    didChangeDependencies();
  }

  void didChangeDependencies() async {
    super.didChangeDependencies();
    //get the state and check current user, set authstatus based on state
    state = await Provider.of<AuthProvider>(context, listen: false).onStartUp();
    if (state == "success") {
      setState(() {
        _authStatus = AuthStatus.loggedIn;
      });
    } else {
      setState(() {
        _authStatus = AuthStatus.notLoggedIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget retVal = const WelcomeScreen();
    switch (_authStatus) {
      case AuthStatus.unKnown:
        retVal = const LoadingScreen();
        break;
      case AuthStatus.notLoggedIn:
        retVal = const WelcomeScreen();
        break;
      case AuthStatus.loggedIn:
        retVal = const RouteScreen();
        break;
      default:
    }
    return retVal;
  }
}
