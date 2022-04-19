import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/room_booking.dart';
import 'package:roomfy_proj/widgets/tenant/user_tenant_item.dart';

import '../../error/no_data.dart';
import '../../providers/room.dart';
import '../../providers/tenant.dart';
import '../../providers/user.dart';
import '../../widgets/tenant/user_appointment_item.dart';

class UserTenantAppointmentScreen extends StatefulWidget {
  const UserTenantAppointmentScreen({Key? key}) : super(key: key);
  static const routeName = '/user-tenant-appointment-screen';

  @override
  State<UserTenantAppointmentScreen> createState() =>
      _UserTenantAppointmentScreenState();
}

class _UserTenantAppointmentScreenState
    extends State<UserTenantAppointmentScreen> {
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
    final bookingData = Provider.of<Bookings>(context);
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
                          bookingData.ownAppointment.isEmpty
                              ? NoFileScreen()
                              : ListView.builder(
                                  itemCount: bookingData.allAppointment.length,
                                  itemBuilder: (ctx, i) => UserAppointmentItem(
                                      item: bookingData.ownAppointment[i]),
                                ),
                    ),
                    onRefresh: () => _refreshAppointment(),
                  ),
      ),
    );
  }
}
