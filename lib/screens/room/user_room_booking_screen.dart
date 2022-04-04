import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/widgets/user_booking_item.dart';
import '../../providers/booking.dart';

class UserRoomBookingScreen extends StatefulWidget {
  const UserRoomBookingScreen({Key? key}) : super(key: key);
  static const routeName = '/user-room-booking-screen';

  @override
  _UserRoomBookingScreenState createState() => _UserRoomBookingScreenState();
}

class _UserRoomBookingScreenState extends State<UserRoomBookingScreen> {
  Future? _fetchFuture;

  Future _refreshBookings() async {
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
      appBar: AppBar(
        title: const Text('Your Bookings'),
      ),
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
                          itemCount: bookingData.getBooking.length,
                          itemBuilder: (ctx, i) =>
                              UserBookingItem(item: bookingData.getBooking[i]),
                        ),
                      ),
                    ),
                    onRefresh: () => _refreshBookings(),
                  ),
      ),
    );
  }
}
