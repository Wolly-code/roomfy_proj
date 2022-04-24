import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/auth.dart';
import 'package:roomfy_proj/screens/misc/my_payment_details.dart';
import 'package:roomfy_proj/screens/my_adverts.dart';
import 'package:roomfy_proj/screens/room/my_room_bookings.dart';
import 'package:roomfy_proj/screens/tenant/my_tenant_appointment.dart';
import 'package:roomfy_proj/screens/user/user_profile_overview.dart';

class UserTab extends StatelessWidget {
  const UserTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Account'),
        ),
      ),
      body: Column(
        children: [
          const Divider(),
          ListTile(
            leading: const Icon(Icons.account_box),
            title: const Text('User Profile'),
            onTap: () {
              Navigator.of(context).pushNamed(UserProfileOverview.routeName);
            },
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 18,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.account_tree_outlined),
            title: const Text('My Ads'),
            onTap: () {
              Navigator.of(context).pushNamed(MyAdverts.routeName);
            },
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 18,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.chat_rounded),
            title: const Text('View Room Bookings'),
            onTap: () {
              Navigator.of(context).pushNamed(MyRoomBookings.routeName);
            },
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 18,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.chat_rounded),
            title: const Text('View Tenant Appointment'),
            onTap: () {
              Navigator.of(context).pushNamed(MyTenantAppointment.routeName);
            },
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 18,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.attach_money_rounded),
            title: const Text('View Payment Detail'),
            onTap: () {
              Navigator.of(context).pushNamed(MyPaymentDetail.routeName);
            },
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 18,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).popAndPushNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
