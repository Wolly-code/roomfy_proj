import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/tenant.dart';
import 'package:roomfy_proj/screens/tenant/tenant_detail_screen.dart';

import '../../providers/room_booking.dart';
import '../../providers/user.dart';
import '../user/user_profile.dart';

class UserAppointmentCreatedDetail extends StatefulWidget {
  const UserAppointmentCreatedDetail({Key? key}) : super(key: key);
  static const routeName = '/User-Tenant-Appointment-Detail';

  @override
  State<UserAppointmentCreatedDetail> createState() =>
      _UserAppointmentCreatedDetailState();
}

class _UserAppointmentCreatedDetailState
    extends State<UserAppointmentCreatedDetail> {
  bool _isinnit = true;
  User? userData;
  Tenant? tenantData;
  Appointment? appointmentData;

  @override
  void didChangeDependencies() {
    if (_isinnit) {
      final appointmentID =
          ModalRoute.of(context)!.settings.arguments as String;
      final appointmentDatas =
          Provider.of<Bookings>(context).findAppointmentByID(appointmentID);
      final tenantDatas = Provider.of<Tenants>(context)
          .findByID(appointmentDatas.tenant.toString());
      final userDatas = Provider.of<Users>(context)
          .findByID(appointmentDatas.user.toString());
      userData = userDatas;
      tenantData = tenantDatas;
      appointmentData = appointmentDatas;
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
      appBar:
          AppBar(title: Text('Appointment #${appointmentData!.id.toString()}')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appointment Created by:',
              style: TextStyle(fontSize: 20),
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
                            arguments: appointmentData!.user);
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
            const Text(
              'For the Tenant Advert: ',
              style: TextStyle(fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(tenantData!.photo1, scale: 10),
                  ),
                  title: Text(tenantData!.title),
                  subtitle: Text(tenantData!.description),
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
                            TenantDetailScreen.routeName,
                            arguments: tenantData!.id);
                      },
                      child: const Text('View Tenant'),
                    )
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded = expanded);
                  },
                ),
              ),
            ),
            Text(
              'on the Date ${DateFormat('yyyy-MM-dd').format(DateTime.parse(appointmentData!.appointmentDate.toString()))}',
              style: const TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
