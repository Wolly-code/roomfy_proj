import 'package:flutter/material.dart';
import 'package:roomfy_proj/screens/misc/payment_overview_screen.dart';

class MyPaymentDetail extends StatefulWidget {
  const MyPaymentDetail({Key? key}) : super(key: key);
  static const routeName = '/My-Payment-Detail';

  @override
  State<MyPaymentDetail> createState() => _MyPaymentDetailState();
}

class _MyPaymentDetailState extends State<MyPaymentDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              title: const Text('My Ads'),
              bottom: const TabBar(tabs: [
                Tab(
                  text: 'Your Payments',
                ),
                Tab(text: 'Payment done to you'),
              ])),
          body: const TabBarView(
            children: [
              UserPaymentScreen(
                stage: true,
              ),
              UserPaymentScreen(
                stage: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
