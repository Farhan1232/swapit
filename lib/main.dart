import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swapit/Screen/AppearanceScreen.dart';
import 'package:swapit/Screen/background_replacement_screen.dart';
import 'package:swapit/Screen/body_enhancement_screen.dart';
import 'package:swapit/Screen/face_swapping_screen.dart';
import 'package:swapit/Screen/home_screen.dart';
import 'package:swapit/Screen/login_screen.dart';
import 'package:swapit/Screen/text_to_image_screen.dart';
import 'package:swapit/provider/TextToImageProvider.dart';
import 'package:swapit/provider/ThemeProvider.dart';
import 'package:swapit/provider/auth_provider.dart';
import 'package:swapit/provider/background_replacement_provider.dart';
import 'package:swapit/provider/body_enhancement_provider.dart';
import 'package:swapit/provider/face_swap_provider.dart';
import 'package:swapit/provider/navigation_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: Platform.isAndroid
        ? const FirebaseOptions(
            // apiKey: "",
            // appId: "",
            // messagingSenderId: "",
            // projectId: "",

// please add your own Firebase creditionls
          )
        : null,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => TextToImageProvider()),
        ChangeNotifierProvider(create: (_) => BackgroundProvider()),
        ChangeNotifierProvider(create: (_) => FaceSwapProvider()),
        ChangeNotifierProvider(create: (_) => BodyEnhancementProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Adjusted screen size for better scaling
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (context, child) {
        return Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'SwapIt App',
              theme: ThemeData(primarySwatch: Colors.blue),
              initialRoute: authProvider.user == null ? '/' : '/home',
              routes: {
                '/': (context) => LoginScreen(),
                '/home': (context) => HomeScreen(),
                '/text-to-image': (context) => TextToImageScreen(),
                '/face-swapping': (context) => FaceSwappingScreen(),
                '/body-enhancement': (context) => BodyEnhancementScreen(),
                '/background-replacement': (context) => BackgroundReplacementScreen(),
                '/appearance-screen': (context) => AppearanceScreen(),
              },
            );
          },
        );
      },
    );
  }
}
