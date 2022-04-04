import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tenant.dart';

class UserTenantItem extends StatelessWidget {
  final String title;
  final String id;

  const UserTenantItem({Key? key, required this.title, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: const CircleAvatar(
        backgroundImage: NetworkImage(
          'https://media.istockphoto.com/photos/funny-best-friends-concept-human-taking-a-selfie-with-dog-picture-id1024311036?k=20&m=1024311036&s=612x612&w=0&h=vZkjFMmxmj2VPHfcuRSz6LLwoOEkFHPtvWVCs5ytTQQ=',
        ),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
