import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/user.dart';
import 'package:roomfy_proj/widgets/room/user_room_booking_item.dart';
import '../../providers/booking.dart';
import '../../providers/room.dart';

class UserRoomBookedScreen extends StatefulWidget {
  const UserRoomBookedScreen({Key? key}) : super(key: key);
  static const routeName = '/user-room-booked-screen';

  @override
  _UserRoomBookedScreenState createState() => _UserRoomBookedScreenState();
}

class _UserRoomBookedScreenState extends State<UserRoomBookedScreen> {
  Future? _fetchFuture;

  Future _refreshBookings() async {
    await Provider.of<Users>(context).getAllUserData();
    await Provider.of<Rooms>(context).fetchAndSetRoom();
    return Provider.of<Bookings>(context, listen: false).fetchBookingData();
  }

  @override
  void initState() {
    _fetchFuture = _refreshBookings();
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
                      builder: (ctx, bookingData, _) => Padding(
                        padding: const EdgeInsets.all(10),
                        child: ListView.builder(
                          itemCount: bookingData.yourBooked.length,
                          itemBuilder: (ctx, i) =>
                              UserBookingItem(item: bookingData.yourBooked[i]),
                        ),
                      ),
                    ),
                    onRefresh: () => _refreshBookings(),
                  ),
      ),
    );
  }
}
