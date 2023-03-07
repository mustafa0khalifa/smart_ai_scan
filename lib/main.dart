import 'package:flutter/material.dart';
import 'package:sample/Screens/ReadID/Widgets/ScanID/scan_UAEID.dart';
import 'package:sample/Screens/ReadID/readID.dart';



void main() {
  runApp(const MRZApp());
}


class MRZApp extends StatelessWidget {
  const MRZApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter MRZ Scanner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ReadID(),
    );
  }
}