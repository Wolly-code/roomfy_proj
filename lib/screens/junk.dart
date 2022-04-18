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
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 250,
      ),
      height: _expanded ? min(150, 200) : 95,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text(roomData.title),
              subtitle: Text(
                'Booked by ${widget.item.user}',
                style: const TextStyle(fontSize: 12),
              ),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(roomData.photo1),
              ),
              trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                  icon:
                  Icon(_expanded ? Icons.expand_less : Icons.expand_more)),
            ),
            AnimatedContainer(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              duration: const Duration(
                milliseconds: 250,
              ),
              height: _expanded ? min(50, 150) : 0,
              child: ListView(
                children: [
                  ElevatedButton(
                    style: raisedButtonStyle,
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                          UserRoomBookingDetail.routeName,
                          arguments: widget.item.id);
                    },
                    child: Text('View Your Booking'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),


    );
  }
}

