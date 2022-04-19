import 'package:flutter/material.dart';
import 'package:roomfy_proj/screens/room/user_room_booked_screen.dart';
import 'package:roomfy_proj/screens/room/user_room_booking_screen.dart';

class MyRoomBookings extends StatefulWidget {
  const MyRoomBookings({Key? key}) : super(key: key);
  static const routeName = '/Room-Booking-List';

  @override
  State<MyRoomBookings> createState() => _MyRoomBookingsState();
}

class _MyRoomBookingsState extends State<MyRoomBookings> {
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
                  text: 'Your Booking',
                ),
                Tab(text: 'Your Room Booking'),
              ])),
          body: const TabBarView(
            children: [UserRoomBookingScreen(), UserRoomBookedScreen()],
          ),
        ),
      ),
    );
  }
}
