import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/auth.dart';
import 'package:roomfy_proj/providers/room.dart';
import 'package:roomfy_proj/screens/room/room_detail_screen.dart';
import 'package:roomfy_proj/screens/room/room_overview_screen.dart';

class RoomItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final room = Provider.of<Room>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
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
          leading: Consumer<Room>(
            builder: (ctx, room, child) => IconButton(
                onPressed: () {
                  room.toggleFavoriteStatus(authData.token.toString(), room.id);
                },
                icon: Icon(
                    room.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Theme.of(context).accentColor)),
          ),
          backgroundColor: Colors.black38,
          title: Text(
            room.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
