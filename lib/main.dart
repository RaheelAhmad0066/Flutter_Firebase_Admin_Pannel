import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'Dashbord.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(GetMaterialApp(
    theme: ThemeData(backgroundColor: Colors.white),
    home: splash_screen(),
  ));
}

class splash_screen extends StatefulWidget {
  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  @override
  void initState() {
    // TODO: implement initState

    Timer(Duration(seconds: 3), () => Get.to(Dashbord()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        'assets/image (2).png',
        fit: BoxFit.cover,
      ),
    );
  }
}
