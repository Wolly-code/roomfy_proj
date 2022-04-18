import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/room.dart';
import 'package:roomfy_proj/providers/user.dart';
import 'package:roomfy_proj/screens/room/room_booking_screen.dart';

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
                  Text(
                    loadedRoom.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 30),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Ad: #' + loadedRoom.id,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
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
                  Text(
                    loadedRoom.description,
                    textAlign: TextAlign.left,
                    softWrap: true,
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
                  Text('${loadedRoom.totalRooms} rooms'),
                  Text('in ${loadedRoom.location}'),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Icon(Icons.attach_money_rounded, size: 29),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Rent',
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              loadedRoom.price.toString() + ' / Daily',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            children: [
                              const Text('Minimum Stay'),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                    loadedRoom.minimumBookingDays.toString() +
                                        ' Days'),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  const Text(
                    'Amenities',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  amenities(
                    name: 'Garage',
                    loadedRoom: loadedRoom.garage,
                    icon: const Icon(Icons.garage),
                  ),
                  amenities(
                    name: 'Internet',
                    loadedRoom: loadedRoom.internet,
                    icon: const Icon(Icons.wifi),
                  ),
                  amenities(
                    name: 'Parking',
                    loadedRoom: loadedRoom.parking,
                    icon: const Icon(Icons.directions_car),
                  ),
                  amenities(
                    name: 'Balcony',
                    loadedRoom: loadedRoom.balcony,
                    icon: const Icon(Icons.balcony),
                  ),
                  amenities(
                    name: 'Yard',
                    loadedRoom: loadedRoom.yard,
                    icon: const Icon(Icons.yard),
                  ),
                  const Divider(),
                  const Text(
                    'Amenities',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: 180,
                        child: ListTile(
                          leading: const Icon(Icons.wheelchair_pickup_outlined),
                          trailing: Text(
                            'Disabled Access',
                            textAlign: TextAlign.start,
                            style: loadedRoom.disableAccess
                                ? const TextStyle(
                                    decoration: TextDecoration.none)
                                : const TextStyle(
                                    decoration: TextDecoration.lineThrough),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const Text(
                    'Property Type',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.09,
                    child: ListTile(
                      leading: loadedRoom.propertyType == "Apartment"
                          ? const Icon(Icons.apartment)
                          : const Icon(Icons.house),
                      trailing: Text(loadedRoom.propertyType),
                    ),
                  ),
                  ElevatedButton(
                    style: raisedButtonStyle,
                    onPressed: () {
                      Navigator.of(context).pushNamed(BookingScreen.routeName,
                          arguments: loadedRoom.id);
                    },
                    child: const Text('Book'),
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
    return Row(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.07,
          width: 120,
          child: ListTile(
            leading: widget.icon,
            trailing: Text(
              widget.name,
              textAlign: TextAlign.start,
              style: widget.loadedRoom
                  ? const TextStyle(decoration: TextDecoration.none)
                  : const TextStyle(decoration: TextDecoration.lineThrough),
            ),
          ),
        ),
      ],
    );
  }
}
