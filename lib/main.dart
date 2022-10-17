import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/doc_id.dart';
import 'controller/page_controller.dart';
import 'controller/status_changer.dart';
import 'firebase_options.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PageModel()),
        ChangeNotifierProvider(create: (context) => DocId()),
        ChangeNotifierProvider(create: (context) => StatusChanger()),
      ],
      child: const MyApp(),
    ),
  );

  //   ChangeNotifierProvider(
  //   create: (context) => PageModel(),
  //   builder: (context, child) => const MyApp(),
  // )
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}
