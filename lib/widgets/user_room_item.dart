import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/room.dart';
import 'package:roomfy_proj/screens/room/edit_room_screen.dart';

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
    final scaffold = Scaffold.of(context);
    return Card(
      child: Column(
        children: [
          ClipRRect(
            child: GestureDetector(
              onTap: () {},
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
            maxLines: 2,
            textAlign: TextAlign.justify,
          )
        ],
      ),
    );
  }
}
// ListTile(
// title: Text(title),
// leading: const CircleAvatar(
// backgroundImage: NetworkImage(
// 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/141766588.jpg?k=0cff52d11a4eb89efeac6f8895bce920a9a4d5bf5e1d68fd01935608efa325fd&o=&hp=1'),
// ),
// trailing: SizedBox(
// width: 100,
// child: Row(
// children: [
// IconButton(
// onPressed: () {
// Navigator.of(context)
//     .pushNamed(EditRoomScreen.routeName, arguments: id);
// },
// icon: const Icon(Icons.edit),
// ),
// IconButton(
// onPressed: () async {
// try {
// await Provider.of<Rooms>(context, listen: false)
//     .deleteRoom(id);
// } catch (error) {
// scaffold.showSnackBar(
// const SnackBar(content: Text('Deleting failed')));
// }
// },
// icon: const Icon(Icons.delete),
// color: Theme.of(context).errorColor,
// ),
// ],
// ),
// ),
// );
