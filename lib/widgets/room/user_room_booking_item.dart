import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:roomfy_proj/providers/booking.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/screens/room/user_room_booking_detail.dart';
import '../../providers/room.dart';

class UserBookingItem extends StatefulWidget {
  const UserBookingItem({Key? key, required this.item}) : super(key: key);
  final Booking item;

  @override
  _UserBookingItemState createState() => _UserBookingItemState();
}

class _UserBookingItemState extends State<UserBookingItem> {
  var _expanded = false;
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
    final roomData =
        Provider.of<Rooms>(context, listen: false).findByID(widget.item.room);
    return Card(
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(roomData.photo1),
        ),
        title: Text(roomData.title),
        subtitle: Text(
          'Booked by ${widget.item.user}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Icon(
          _customTileExpanded
              ? Icons.arrow_drop_down_circle
              : Icons.arrow_drop_down,
        ),
        children: <Widget>[
          ElevatedButton(
            style: raisedButtonStyle,
            onPressed: () {
              Navigator.of(context).pushNamed(UserRoomBookingDetail.routeName,
                  arguments: widget.item.id);
            },
            child: const Text('View Your Booking'),
          )
        ],
        onExpansionChanged: (bool expanded) {
          setState(() => _customTileExpanded = expanded);
        },
      ),
    );
  }
}
