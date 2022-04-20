import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/screens/misc/report_tenant_room.dart';
import '../../providers/room_booking.dart';
import '../../providers/tenant.dart';
import '../../providers/user.dart';
import '../user/user_profile.dart';

class TenantDetailScreen extends StatefulWidget {
  const TenantDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/tenant-detail';

  @override
  _TenantDetailScreenState createState() => _TenantDetailScreenState();
}

class _TenantDetailScreenState extends State<TenantDetailScreen> {
  @override
  Widget build(BuildContext context) {
    int count = 0;
    final tenantId = ModalRoute.of(context)!.settings.arguments as String;
    bool _customTileExpanded = false;
    final loadedTenant = Provider.of<Tenants>(context).findByID(tenantId);
    final userData = Provider.of<Users>(context, listen: false)
        .findByID(loadedTenant.poster);
    Future<void> _createAppointment() async {
      if (count == 0) {
        var response = await Provider.of<Tenants>(context, listen: false)
            .createAppointment(loadedTenant.id, DateTime.now().toString());
        final snackBar = SnackBar(
          duration: const Duration(seconds: 2),
          content: Text(response),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        count++;
      } else {
        const snackBar = SnackBar(
          duration: Duration(seconds: 2),
          content:
              Text('You have already created an appointment for this post'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedTenant.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedTenant.photo1,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              loadedTenant.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            const SizedBox(
              height: 10,
            ),
            Text('Ad: #' + loadedTenant.id,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                )),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(userData.profile, scale: 10),
                  ),
                  title: Text(userData.firstName + " " + userData.lastName),
                  subtitle: Text('Location: ' + userData.location),
                  trailing: Icon(
                    _customTileExpanded
                        ? Icons.arrow_drop_down_circle
                        : Icons.arrow_drop_down,
                  ),
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(UserProfile.routeName,
                            arguments: loadedTenant.poster);
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
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedTenant.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: _createAppointment,
                      child: const Text('Create Appointment Now')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(ReportTenantScreen.routeName);
                      },
                      child: const Text('Report')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
