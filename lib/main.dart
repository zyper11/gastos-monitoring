import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_management/bloc/wallet_bloc.dart';
import 'package:gastos_management/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<WalletBloc>(
      create: (context) => WalletBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sqflite Tutorial',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: Home(),
      ),
    );
  }
}

// SplashScreen(
//       seconds: 5,
//       title: Text(
//         'Wallet Monitoring',
//         style: TextStyle(
//             fontFamily: 'Do Hyeon', fontSize: 40.0, color: Colors.purple[900]),
//       ),
//       backgroundColor: Colors.white,
//       image: Image.asset('images/splash.png'),
//       loaderColor: Colors.purple[900],
//       photoSize: 150,
//       navigateAfterSeconds: Home(),
//     );
