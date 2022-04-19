import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/error/no_data.dart';
import 'package:roomfy_proj/widgets/room/user_room_booking_item.dart';
import '../../providers/room_booking.dart';
import '../../providers/room.dart';
import '../../providers/user.dart';

class UserRoomBookingScreen extends StatefulWidget {
  const UserRoomBookingScreen({Key? key}) : super(key: key);
  static const routeName = '/user-room-booking-screen';

  @override
  _UserRoomBookingScreenState createState() => _UserRoomBookingScreenState();
}

class _UserRoomBookingScreenState extends State<UserRoomBookingScreen> {
  Future? _fetchFuture;

  Future _refreshBookings() async {
    Provider.of<Rooms>(context, listen: false).fetchAndSetRoom();
    Provider.of<Users>(context, listen: false).getAllUserData();
    return Provider.of<Bookings>(context, listen: false).fetchBookingData();
  }

  @override
  void initState() {
    _fetchFuture = _refreshBookings();
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
                          bookingData.ownBooking.isEmpty
                              ? NoFileScreen()
                              : Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: ListView.builder(
                                    itemCount: bookingData.ownBooking.length,
                                    itemBuilder: (ctx, i) => UserBookingItem(
                                        item: bookingData.ownBooking[i]),
                                  ),
                                ),
                    ),
                    onRefresh: () => _refreshBookings(),
                  ),
      ),
    );
  }
}
