import 'package:flutter/material.dart';
import 'package:roomfy_proj/screens/room/user_room_detail_screen.dart';

class UserRoomItem extends StatelessWidget {
  final String title;
  final String id;
  final String description;
  final String photo1;

  UserRoomItem(
      {required this.title,
      required this.id,
      required this.description,
      required this.photo1});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
          child: Column(
            children: [
              ClipRRect(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        UserRoomDetailScreen.routeName,
                        arguments: id);
                  },
                  child: Image.network(
                    photo1,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150,
                  ),
                ),
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 20),
              ),
              const Divider(),
              Text(
                description,
                maxLines: 3,
                textAlign: TextAlign.justify,
              )
            ],
          ),
        ),
      ),
    );
  }
}
