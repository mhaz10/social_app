import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/layout_screen.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/modules/onBoarding/onBoarding_screen.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/bloc_observer.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://vkmznmdiqbyjnnffuzwp.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZrbXpubWRpcWJ5am5uZmZ1endwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc0NjMxNzcsImV4cCI6MjA1MzAzOTE3N30.SJgV3exVQXgiY0VEOPpDSB1h8Ah1hDxiLafelaHaI3w',
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();

  bool? onBoarding = CacheHelper.getData(key: 'OnBoarding');
  token = CacheHelper.getData(key: 'token');
  runApp(MyApp(onBoarding: onBoarding, token: token));
}

Widget startWidget(bool? onBoarding, String? token) {
  if (onBoarding != null) {
    if (token != null) {
      return LayoutScreen();
    } else {
      return LoginScreen();
    }
  } else {
    return OnboardingScreen();
  }
}


class MyApp extends StatelessWidget {
  final bool? onBoarding;
  final String? token;

  const MyApp({super.key, this.onBoarding, this.token});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialAppCubit()..getUserData()..getPost(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: startWidget(onBoarding, token),
      ),
    );
  }
}
