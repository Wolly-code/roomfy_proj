import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/room.dart';
import 'package:roomfy_proj/screens/room/booking_screen.dart';

class RoomDetailScreen extends StatefulWidget {
  const RoomDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/room-detail';

  @override
  _RoomDetailScreenState createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final roomId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedRoom =
        Provider.of<Rooms>(context, listen: false).findByID(roomId);
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
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedRoom.photo1,
                fit: BoxFit.cover,
              ),
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
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          child: Text('SK'),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          children: const [
                            Text(
                              'Suhant KC',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 16),
                            ),
                            Text(
                              '9860137229',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    loadedRoom.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                  const Divider(),
                  const Text(
                    'OVERVIEW',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text('${loadedRoom.totalRooms} rooms'),
                  Text('in ${loadedRoom.location}'),
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
