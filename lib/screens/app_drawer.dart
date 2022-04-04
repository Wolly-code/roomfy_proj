import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/auth.dart';
import 'package:roomfy_proj/screens/room/user_room_booking_screen.dart';
import 'package:roomfy_proj/screens/room/user_room_screen.dart';
import 'package:roomfy_proj/screens/tenant/user_tenant_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.add_shopping_cart),
            title: const Text('Room Screen'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserRoomScreen.routeName);
              // Navigator.of(context).pushReplacement(
              //     CustomRoute(builder: (ctx) => const OrdersScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.add_shopping_cart),
            title: const Text('Tenant Screen'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserTenantScreen.routeName);
              // Navigator.of(context).pushReplacement(
              //     CustomRoute(builder: (ctx) => const OrdersScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.account_box),
            title: const Text('View Room Bookings'),
            onTap: () {
              Navigator.of(context).pushNamed(UserRoomBookingScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),

        ],
      ),
    );
  }
}
