import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../error/no_data.dart';
import '../../providers/room_booking.dart';
import '../../providers/tenant.dart';
import '../../providers/user.dart';
import '../../widgets/tenant/user_appointment_item.dart';

class UserBookedAppointmentScreen extends StatefulWidget {
  const UserBookedAppointmentScreen({Key? key}) : super(key: key);
  static const routeName = '/user-booked-appointment-screen';

  @override
  State<UserBookedAppointmentScreen> createState() =>
      _UserBookedAppointmentScreenState();
}

class _UserBookedAppointmentScreenState
    extends State<UserBookedAppointmentScreen> {
  Future? _fetchFuture;

  Future _refreshAppointment() async {
    Provider.of<Tenants>(context, listen: false).fetchAndSetTenant();
    Provider.of<Users>(context, listen: false).getAllUserData();
    return Provider.of<Bookings>(context, listen: false).fetchAppointmentData();
  }
  @override
  void initState() {
    _fetchFuture = _refreshAppointment();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _fetchFuture,
        builder: (ctx, snapShot) =>
        snapShot.connectionState == ConnectionState.waiting
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : RefreshIndicator(
          child: Consumer<Bookings>(
            builder: (ctx, bookingData, _) =>
            bookingData.yourAppointment.isEmpty
                ? NoFileScreen()
                : ListView.builder(
              itemCount: bookingData.yourAppointment.length,
              itemBuilder: (ctx, i) => UserAppointmentItem(
                  item: bookingData.yourAppointment[i]),
            ),
          ),
          onRefresh: () => _refreshAppointment(),
        ),
      ),
    );

  }
}
