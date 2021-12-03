import 'package:chat_me/screens/chat_list_screen.dart';
import 'package:chat_me/screens/email_screen.dart';
import 'package:chat_me/screens/search_screen.dart';
import 'package:chat_me/screens/loading_screen.dart';
import 'package:chat_me/screens/login_screen.dart';
import 'package:chat_me/screens/profile_screen.dart';
import 'package:chat_me/screens/registration_screen.dart';
import 'package:chat_me/screens/route.dart';
import 'package:chat_me/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:chat_me/screens/startup_screen.dart';
import 'business_logic/providers/auth_provider.dart';
import 'business_logic/firebase_initialization.dart';
import 'business_logic/providers/image_upload_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  FirebaseService service = FirebaseService();
  await service.initializeFlutterFire();
  //Change the color or the status bar
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Color(0xFF000000)));
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<AuthProvider>(
      create: (_) => AuthProvider(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      builder: () => MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
          ChangeNotifierProvider<ImageUploadProvider>(
              create: (_) => ImageUploadProvider())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              //primarySwatch: Colors.blue,
              primaryColor: const Color(0xFF1A237E),
              primaryColorDark: const Color(0xFF000051),
              primaryColorLight: const Color(0xFF514aac),
              primaryColorBrightness: Brightness.dark,
              backgroundColor: const Color(0xFFE1E2E1),
              // scaffoldBackgroundColor: Colors
              //     .transparent,
              iconTheme: IconThemeData(
                color: Colors.amber[10],
              ),
              textTheme:
                  TextTheme(caption: TextStyle(color: Colors.amber[10]))),
          initialRoute: StartupScreen.id,
          routes: {
            ChatListScreen.id: (context) => const ChatListScreen(),
            LoadingScreen.id: (context) => const LoadingScreen(),
            StartupScreen.id: (context) => const StartupScreen(),
            WelcomeScreen.id: (context) => const WelcomeScreen(),
            LoginScreen.id: (context) => const LoginScreen(),
            RegistrationScreen.id: (context) => const RegistrationScreen(),
            EmailScreen.id: (context) => const EmailScreen(),
            RouteScreen.id: (context) => const RouteScreen(),
            ProfileScreen.id: (context) => const ProfileScreen(),
            SearchScreen.id: (context) => const SearchScreen(),
          },
        ),
      ),
    );
  }
}
