import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/room.dart';
import 'package:roomfy_proj/screens/room/room_detail_screen.dart';
import 'package:roomfy_proj/screens/room/room_overview_screen.dart';

class RoomItem extends StatelessWidget {
  const RoomItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final room = Provider.of<Room>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(RoomDetailScreen.routeName, arguments: room.id);
          },
          child: Image.network(
            room.photo1,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black38,
          title: Text(
            room.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.local_attraction_outlined)),
        ),
      ),
    );
  }
}
