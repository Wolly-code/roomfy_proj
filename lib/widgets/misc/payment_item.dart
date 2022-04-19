import 'package:flutter/material.dart';
import 'package:roomfy_proj/providers/room_booking.dart';

class UserPaymentItem extends StatelessWidget {
  final Payment payment;

  const UserPaymentItem({Key? key, required this.payment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(payment.amount.toString()),
        ],
      ),
    );
  }
}
