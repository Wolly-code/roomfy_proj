import 'package:flutter/material.dart';
import 'package:roomfy_proj/widgets/room_item.dart';
import '../providers/room.dart';
import 'package:provider/provider.dart';

class RoomsGrid extends StatelessWidget {
  const RoomsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final roomData = Provider.of<Rooms>(context);
    final rooms = roomData.displayRooms;
    return rooms.isEmpty
        ? const Center(
            child: Text("NO ROOM DATA FOUND"),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 4 / 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 40),
            itemCount: rooms.length,
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: rooms[i],
              child: const RoomItem(),
            ),
          );
  }
}
