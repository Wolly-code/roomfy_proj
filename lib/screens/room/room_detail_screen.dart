import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/room.dart';
import 'package:roomfy_proj/providers/user.dart';
import 'package:roomfy_proj/screens/misc/report_room_screen.dart';
import 'package:roomfy_proj/screens/misc/report_tenant_room.dart';
import 'package:roomfy_proj/screens/room/room_booking_screen.dart';

import '../user/create_profile.dart';
import '../user/user_profile.dart';

class RoomDetailScreen extends StatefulWidget {
  const RoomDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/room-detail';

  @override
  _RoomDetailScreenState createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  @override
  Widget build(BuildContext context) {
    bool _customTileExpanded = false;
    final roomId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedRoom =
        Provider.of<Rooms>(context, listen: false).findByID(roomId);
    final _hasUser = Provider.of<Users>(context, listen: false);
    final userData =
        Provider.of<Users>(context, listen: false).findByID(loadedRoom.poster);
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: Colors.black87,
      primary: Colors.grey[300],
      minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedRoom.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(height: 300.0),
              items: [
                loadedRoom.photo1,
                loadedRoom.photo2,
              ].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: const BoxDecoration(color: Colors.amber),
                      child: Image.network(
                        i,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10),
                    child: Text(
                      loadedRoom.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 30),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    subtitle: Text(
                      'Ad: #' + loadedRoom.id,
                    ),
                    title: Text(
                      loadedRoom.description,
                      textAlign: TextAlign.left,
                      softWrap: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(userData.profile, scale: 10),
                        ),
                        title:
                            Text(userData.firstName + " " + userData.lastName),
                        subtitle: Text(userData.userId),
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
                                  UserProfile.routeName,
                                  arguments: userData.userId);
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
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'OVERVIEW',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.attach_money_rounded,
                      size: 45,
                    ),
                    title: const Text(
                      'Rent',
                      style: TextStyle(fontSize: 15),
                    ),
                    subtitle: Text(
                      loadedRoom.price.toString() + ' / Daily',
                      style: const TextStyle(fontSize: 17),
                    ),
                    trailing: Text('Minimum Booking: ' +
                        loadedRoom.minimumBookingDays.toString() +
                        ' Days'),
                  ),
                  Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.bed),
                        title:
                            Text(loadedRoom.totalRooms.toString() + ' / rooms'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.map),
                        title: Text(loadedRoom.location),
                      ),
                      ListTile(
                        leading: const Text('Security Deposit: '),
                        title: Text(loadedRoom.securityDeposit.toString()),
                      ),
                    ],
                  ),
                  const Divider(),
                  const Divider(),
                  const Text(
                    'Amenities',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        amenities(
                          name: 'Garage',
                          loadedRoom: loadedRoom.garage,
                          icon: const Icon(Icons.garage),
                        ),
                        const Divider(),
                        amenities(
                          name: 'Internet',
                          loadedRoom: loadedRoom.internet,
                          icon: const Icon(Icons.wifi),
                        ),
                        const Divider(),
                        amenities(
                          name: 'Parking',
                          loadedRoom: loadedRoom.parking,
                          icon: const Icon(Icons.directions_car),
                        ),
                        const Divider(),
                        amenities(
                          name: 'Balcony',
                          loadedRoom: loadedRoom.balcony,
                          icon: const Icon(Icons.balcony),
                        ),
                        const Divider(),
                        amenities(
                          name: 'Yard',
                          loadedRoom: loadedRoom.yard,
                          icon: const Icon(Icons.yard),
                        ),
                        const Divider(),
                        amenities(
                          name: 'Furnished',
                          loadedRoom: loadedRoom.furnished,
                          icon: const Icon(Icons.bed),
                        ),
                        const Divider(),
                        amenities(
                          name: 'Disabled Access',
                          loadedRoom: loadedRoom.disableAccess,
                          icon: const Icon(Icons.wheelchair_pickup_outlined),
                        ),
                        const Divider(
                          height: 0.6,
                          color: Colors.black87,
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  const Text(
                    'Property Type',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: loadedRoom.propertyType == 'Apartment'
                          ? const Icon(Icons.apartment)
                          : const Icon(Icons.house),
                      title: Text(loadedRoom.propertyType),
                    ),
                  ),
                  const Divider(),
                  const Text(
                    'Contact Detail',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.mail),
                        title: Text(loadedRoom.email),
                      ),
                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: Text(loadedRoom.phoneNumber),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: raisedButtonStyle,
                        onPressed: () {
                          if (_hasUser.userObj == null) {
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
                          } else {
                            Navigator.of(context).pushNamed(
                                BookingScreen.routeName,
                                arguments: loadedRoom.id);
                          }
                        },
                        child: const Text('Book'),
                      ),
                      ElevatedButton(
                        style: raisedButtonStyle,
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              ReportRoomScreen.routeName,
                              arguments: loadedRoom.id);
                        },
                        child: const Text('Report'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class amenities extends StatefulWidget {
  final Icon icon;
  final String name;
  final bool loadedRoom;

  const amenities(
      {Key? key,
      required this.name,
      required this.loadedRoom,
      required this.icon})
      : super(key: key);

  @override
  State<amenities> createState() => _amenitiesState();
}

class _amenitiesState extends State<amenities> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: widget.icon,
      title: widget.loadedRoom
          ? Text('Has ${widget.name}')
          : Text('No ${widget.name}'),
    );
  }
}
