import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/room_booking.dart';
import 'package:roomfy_proj/widgets/misc/payment_item.dart';

import '../../error/no_data.dart';
import '../../providers/room.dart';

class UserPaymentScreen extends StatefulWidget {
  const UserPaymentScreen({Key? key, required this.stage}) : super(key: key);
  final bool stage;

  @override
  State<UserPaymentScreen> createState() => _UserPaymentScreenState();
}

class _UserPaymentScreenState extends State<UserPaymentScreen> {
  Future? _fetchFuture;

  Future _refreshRooms() async {
    Provider.of<Rooms>(context, listen: false).fetchAndSetRoom();
    return Provider.of<Bookings>(context, listen: false).fetchPaymentDetails();
  }

  @override
  void initState() {
    _fetchFuture = _refreshRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final paymentData = Provider.of<Bookings>(context);

    return Scaffold(
      body: FutureBuilder(
        future: _fetchFuture,
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => _refreshRooms(),
                child: Consumer<Bookings>(
                  builder: widget.stage
                      ? (ctx, paymentData, _) => paymentData.ownPayment.isEmpty
                          ? NoFileScreen()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.builder(
                                  itemCount: paymentData.ownPayment.length,
                                  itemBuilder: (ctx, i) => UserPaymentItem(
                                      payment: paymentData.ownPayment[i])),
                            )
                      : (ctx, paymentData, _) => paymentData.yourPayment.isEmpty
                          ? NoFileScreen()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.builder(
                                  itemCount: paymentData.yourPayment.length,
                                  itemBuilder: (ctx, i) => UserPaymentItem(
                                      payment: paymentData.yourPayment[i])),
                            ),
                ),
              ),
      ),
    );
  }
}
