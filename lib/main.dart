import 'package:amazon/AuthContoller/authContoller.dart';
import 'package:amazon/Home/HomeScreen.dart';
import 'package:amazon/MainScreen/MainScreen.dart';
import 'package:amazon/constants/LoderScreen.dart';
import 'package:amazon/constants/global_variables.dart';
import 'package:amazon/constants/utils.dart';
import 'package:amazon/login/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        title: 'Amazon',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: ref.watch(USerDetailsFormain).when(
            data: (data) {
              if (data == null) {
                return LoginScreen();
              }
              return HomeScreen(
                CurrentUserID: data.UserUId,
                Email: data.Email,
                name: data.name,
              );
            },
            error: (e, trace) {
              print(e.toString());
            },
            loading: () => LoderScreen()));
  }
}
