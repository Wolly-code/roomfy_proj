import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/room_booking.dart';
import 'package:roomfy_proj/providers/tenant.dart';
import '../../screens/tenant/user_appointment_detail.dart';

class UserAppointmentItem extends StatefulWidget {
  const UserAppointmentItem({Key? key, required this.item}) : super(key: key);
  final Appointment item;

  @override
  State<UserAppointmentItem> createState() => _UserAppointmentItemState();
}

class _UserAppointmentItemState extends State<UserAppointmentItem> {
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
    final tenantData = Provider.of<Tenants>(context, listen: false)
        .findByID(widget.item.tenant.toString());
    return Card(
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(tenantData.photo1),
        ),
        title: Text(tenantData.title),
        subtitle: Text(
          'Appointment created by: ${widget.item.user}',
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
              Navigator.of(context).pushNamed(
                  UserAppointmentCreatedDetail.routeName,
                  arguments: widget.item.id.toString());
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
