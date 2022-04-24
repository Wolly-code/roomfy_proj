import 'package:flutter/material.dart';
import 'package:roomfy_proj/screens/tenant/user_booked_appointment.dart';
import 'package:roomfy_proj/screens/tenant/user_tenant_appointment.dart';

class MyTenantAppointment extends StatefulWidget {
  const MyTenantAppointment({Key? key}) : super(key: key);
  static const routeName = '/Tenant-Appointment-List';

  @override
  State<MyTenantAppointment> createState() => _MyTenantAppointmentState();
}

class _MyTenantAppointmentState extends State<MyTenantAppointment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              title: const Text('My Tenant Appointment'),
              bottom: const TabBar(tabs: [
                Tab(
                  text: 'Your Appointment',
                ),
                Tab(text: 'Your Advert Appointment'),
              ])),
          body: const TabBarView(
            children: [
              UserTenantAppointmentScreen(),
              UserBookedAppointmentScreen()
            ],
          ),
        ),
      ),
    );
  }
}
