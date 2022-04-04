import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/constraints.dart';
import 'package:roomfy_proj/screens/app_drawer.dart';
import 'package:roomfy_proj/screens/room/edit_room_screen.dart';
import 'package:roomfy_proj/widgets/user_room_item.dart';
import '../../providers/room.dart';
import '../post_ad.dart';

class UserRoomScreen extends StatefulWidget {
  const UserRoomScreen({Key? key}) : super(key: key);
  static const routeName = '/User-room';

  @override
  _UserRoomScreenState createState() => _UserRoomScreenState();
}

class _UserRoomScreenState extends State<UserRoomScreen> {
  Future? _fetchFuture;

  Future _refreshRooms() async {
    return Provider.of<Rooms>(context, listen: false).fetchAndSetRoom();
  }

  @override
  void initState() {
    _fetchFuture = _refreshRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final roomData = Provider.of<Rooms>(context);
    return Scaffold(
      floatingActionButton: IconButton(
          color: KPrimaryColor,
          onPressed: () {
            Navigator.of(context).popAndPushNamed(PostAd.routeName);
            // Navigator.of(context).pop();
          },
          icon: const Icon(Icons.add)),
      body: FutureBuilder(
        future: _fetchFuture,
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshRooms(),
                    child: Consumer<Rooms>(
                      builder: (ctx, roomData, _) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: roomData.ownedRoom.length,
                          itemBuilder: (ctx, i) => UserRoomItem(
                            id: roomData.ownedRoom[i].id,
                            title: roomData.ownedRoom[i].title,
                            description: roomData.ownedRoom[i].description,
                            photo1: roomData.ownedRoom[i].photo1,
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
