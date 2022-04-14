import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tenant.dart';

class UserTenantItem extends StatelessWidget {
  final String title;
  final String id;
  final String description;
  final String photo1;

  const UserTenantItem(
      {Key? key,
      required this.title,
      required this.id,
      required this.description,
      required this.photo1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Card(
      child: Column(
        children: [
          ClipRRect(
            child: GestureDetector(
              onTap: () {
                // Navigator.of(context)
                //     .pushNamed(UserRoomDetailScreen.routeName, arguments: id);
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
            maxLines: 2,
            textAlign: TextAlign.justify,
          )
        ],
      ),
    );
  }
}
