import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/room.dart';
import '../../providers/room_booking.dart';
import '../../providers/user.dart';
import '../room/room_detail_screen.dart';
import '../user/user_profile.dart';

class UserPaymentDetailScreen extends StatefulWidget {
  const UserPaymentDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/User-payment-detail-screen';

  @override
  State<UserPaymentDetailScreen> createState() =>
      _UserPaymentDetailScreenState();
}

class _UserPaymentDetailScreenState extends State<UserPaymentDetailScreen> {
  bool _isinnit = true;
  Room? roomData;
  User? userData;
  Payment? paymentData;

  @override
  void didChangeDependencies() {
    if (_isinnit) {
      final paymentID = ModalRoute.of(context)!.settings.arguments as String;
      final paymentDatas =
          Provider.of<Bookings>(context).findPaymentByID(paymentID);
      final roomDatas =
          Provider.of<Rooms>(context).findByID(paymentDatas.room.toString());
      final userDatas =
          Provider.of<Users>(context).findByID(paymentDatas.user.toString());
      userData = userDatas;
      paymentData = paymentDatas;
      roomData = roomDatas;
    }
    super.didChangeDependencies();
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: Colors.grey[300],
    minimumSize: const Size(88, 36),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    bool _customTileExpanded = false;
    return Scaffold(
      appBar: AppBar(title: Text('Payment #${paymentData!.id.toString()}')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Paid by User:',
              style: TextStyle(fontSize: 18),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(userData!.profile, scale: 10),
                  ),
                  title: Text(userData!.firstName + " " + userData!.lastName),
                  subtitle: Text('Location: ' + userData!.location),
                  trailing: Icon(
                    _customTileExpanded
                        ? Icons.arrow_drop_down_circle
                        : Icons.arrow_drop_down,
                  ),
                  children: <Widget>[
                    ElevatedButton(
                      style: raisedButtonStyle,
                      onPressed: () {
                        Navigator.of(context).pushNamed(UserProfile.routeName,
                            arguments: paymentData!.user);
                      },
                      child: const Text('View User'),
                    )
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded = expanded);
                  },
                ),
              ),
            ),
            Text(
              'Payment Detail: ${paymentData!.remarks}',
              style: TextStyle(fontSize: 18),
            ),
            Card(
              child: ListTile(
                leading: Image.asset(
                  'assets/esewa/logo_dark.png',
                  fit: BoxFit.cover,
                ),
                trailing: Text('Total Amount: ${paymentData!.amount}'),
              ),
            ),
            const Text(
              'Room Booked for:',
              style: TextStyle(fontSize: 18),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(roomData!.photo1, scale: 10),
                  ),
                  title: Text(roomData!.title),
                  subtitle: Text(roomData!.description),
                  trailing: Icon(
                    _customTileExpanded
                        ? Icons.arrow_drop_down_circle
                        : Icons.arrow_drop_down,
                  ),
                  children: <Widget>[
                    ElevatedButton(
                      style: raisedButtonStyle,
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            RoomDetailScreen.routeName,
                            arguments: roomData!.id);
                      },
                      child: const Text('View Room'),
                    )
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded = expanded);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
