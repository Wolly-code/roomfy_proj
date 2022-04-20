import 'package:flutter/material.dart';
import 'package:roomfy_proj/widgets/room/room_item.dart';
import '../../error/no_result_found.dart';
import '../../providers/room.dart';
import 'package:provider/provider.dart';

import '../search_widget.dart';

class RoomsGrid extends StatefulWidget {
  const RoomsGrid({Key? key, required this.showFavs}) : super(key: key);
  final bool showFavs;

  @override
  State<RoomsGrid> createState() => _RoomsGridState();
}

class _RoomsGridState extends State<RoomsGrid> {
  List<Room>? rooms;
  String query = '';

  @override
  Widget build(BuildContext context) {
    final roomData = Provider.of<Rooms>(context);
    final rooms =
    widget.showFavs ? roomData.favoriteItems : roomData.displayRooms;
    return rooms.isEmpty
        ? NoResultFoundScreen()
        : GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 4 / 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 40),
          itemCount: rooms.length,
          itemBuilder: (ctx, i) =>
              ChangeNotifierProvider.value(
                value: rooms[i],
                child: const RoomItem(),
              ),
        );
  }

//   Widget buildSearch() =>
//       const SearchWidget(
//           text: query?, hintText: 'Location or Title', onChanged: searchRoom);
//
//   void searchRoom(String query) {
//     final rooms = Provider
//         .of<Rooms>(context, listen: false)
//         .displayRooms;
//     final roomData = rooms.where((room) {
//       final titleLower = room.title.toLowerCase();
//       final locationLower = room.location.toLowerCase();
//       final searchLower = query.toLowerCase()
//       return titleLower.contains(searchLower) ||
//           locationLower.contains(searchLower);
//     }).toList();
//     setState(() {
//       this.query = query;
//       this.rooms = roomData;
//     });
//   }
}
