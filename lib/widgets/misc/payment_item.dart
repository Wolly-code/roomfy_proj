import 'package:flutter/material.dart';
import 'package:roomfy_proj/providers/room_booking.dart';
import 'package:roomfy_proj/screens/misc/payment_overview_screen.dart';
import 'package:roomfy_proj/screens/misc/user_payment_detail_screen.dart';

class UserPaymentItem extends StatefulWidget {
  final Payment payment;

  const UserPaymentItem({Key? key, required this.payment}) : super(key: key);

  @override
  State<UserPaymentItem> createState() => _UserPaymentItemState();
}

class _UserPaymentItemState extends State<UserPaymentItem> {
  final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: Colors.blue[300],
    minimumSize: const Size(88, 36),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    bool _customTileExpanded = false;
    return Card(
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Text(
            'NRS ' + widget.payment.amount.toString(),
            style: const TextStyle(color: Colors.black),
          ),
        ),
        title: Text(widget.payment.remarks.toString()),
        subtitle: Text(
          'Payment done by: ${widget.payment.user}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Icon(
          _customTileExpanded
              ? Icons.arrow_drop_down_circle
              : Icons.arrow_drop_down,
        ),
        children: <Widget>[
          ElevatedButton(
            style: elevatedButtonStyle,
            onPressed: () {
              Navigator.of(context).pushNamed(UserPaymentDetailScreen.routeName,
                  arguments: widget.payment.id.toString());
            },
            child: const Text('View Your Appointment'),
          )
        ],
        onExpansionChanged: (bool expanded) {
          setState(() => _customTileExpanded = expanded);
        },
      ),
    );
  }
}
