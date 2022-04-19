import 'package:flutter/material.dart';

class ReportRoom extends StatefulWidget {
  const ReportRoom({Key? key}) : super(key: key);
  static const routeName = '/Report-room';

  @override
  State<ReportRoom> createState() => _ReportRoomState();
}

class _ReportRoomState extends State<ReportRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
