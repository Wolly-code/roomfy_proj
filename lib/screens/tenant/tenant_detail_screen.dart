import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/screens/misc/report_tenant_room.dart';
import '../../providers/room_booking.dart';
import '../../providers/tenant.dart';
import '../../providers/user.dart';
import '../user/create_profile.dart';
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
    final _hasUser= Provider.of<Users>(context,listen: false);
    final userData = Provider.of<Users>(context, listen: false)
        .findByID(loadedTenant.poster);
    final user = Provider.of<Users>(context, listen: false).userObj;
    Future<void> _createAppointment() async {
      if(_hasUser.userObj==null){
        final snackBar = SnackBar(
          duration: const Duration(seconds: 2),
          content:
          const Text("You can't book an Advert without creating a Profile"),
          action: SnackBarAction(
            label: 'Create Profile',
            onPressed: () async {
              Navigator.of(context).pushNamed(CreateProfile.routeName);
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      if (loadedTenant.poster == user?.userId) {
        const snackBar = SnackBar(
          duration: Duration(seconds: 2),
          content:
              Text('You cannot create appointment in your own advertisement'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
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
            const Text('Tenant Details'),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 4,
                    child: Column(
                      children: [
                        //row for each deatails
                        ListTile(
                          leading: const Icon(CupertinoIcons.profile_circled),
                          title: Text(loadedTenant.fullName),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.male),
                          title: Text(loadedTenant.gender),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.map),
                          title: Text(loadedTenant.location),
                        ),
                        const Divider(),
                        ListTile(
                          leading:
                              const Icon(Icons.supervised_user_circle_sharp),
                          title: Text(loadedTenant.description),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.mail),
                          title: Text(loadedTenant.email),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.phone),
                          title: Text(loadedTenant.phoneNumber),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.monetization_on),
                          title: Text('NRS ' +
                              loadedTenant.budget.toString() +
                              '/ month'),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.cake),
                          title: Text(loadedTenant.age.toString()),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.cases_outlined),
                          title: Text(loadedTenant.occupation),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Text('Pref: '),
                          title: Text(loadedTenant.preference),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.pets),
                          title: loadedTenant.petOwner
                              ? const Text('Pet Owner')
                              : const Text('Not a pet owner'),
                        ),
                        const Divider(
                          height: 0.6,
                          color: Colors.black87,
                        ),
                      ],
                    ),
                  ),
                )
              ],
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
                        Navigator.of(context).pushNamed(
                            ReportTenantScreen.routeName,
                            arguments: loadedTenant.id);
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
