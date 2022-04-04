import 'package:flutter/material.dart';
import 'package:roomfy_proj/screens/room/user_room_screen.dart';
import 'package:roomfy_proj/screens/tenant/user_tenant_screen.dart';

class MyAdverts extends StatefulWidget {
  const MyAdverts({Key? key}) : super(key: key);
  static const routeName = 'my-adverts';

  @override
  _MyAdvertsState createState() => _MyAdvertsState();
}

class _MyAdvertsState extends State<MyAdverts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('My Ads'),
              bottom: const TabBar(tabs: [
            Tab(text: 'Room',),
            Tab(text: 'Tenant'),
          ])),
          body: const TabBarView(
            children: [UserRoomScreen(), UserTenantScreen()],
          ),
        ),
      ),
    );
  }
}

// Row(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: [
// TextButton(
// style: ButtonStyle(
// padding: MaterialStateProperty.all<EdgeInsets>(
// const EdgeInsets.symmetric(vertical: 5, horizontal: 20)),
// backgroundColor:
// MaterialStateProperty.all<Color>(KPrimaryColor)),
// onPressed: () {},
// child: const Text(
// 'Rooms',
// style: TextStyle(
// color: Colors.white,
// ),
// ),
// ),
// TextButton(
// style: ButtonStyle(
// padding: MaterialStateProperty.all<EdgeInsets>(
// const EdgeInsets.symmetric(vertical: 5, horizontal: 20)),
// backgroundColor:
// MaterialStateProperty.all<Color>(KPrimaryColor)),
// onPressed: () {},
// child: const Text(
// 'Tenants',
// style: TextStyle(
// color: Colors.white,
// ),
// ),
// ),
// ],
// ),
