import 'package:flutter/material.dart';

import '../../providers/user.dart';

class ViewUserProfile extends StatelessWidget {
  final User user;

  const ViewUserProfile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.profile,scale: 10),
            ),
            width: double.infinity,
            height: 200,
          ),
        )
      ],
    );
  }
}
