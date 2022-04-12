import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/screens/user/create_profile.dart';
import 'package:roomfy_proj/screens/user/view_user_profile.dart';

import '../../providers/user.dart';
import '../../screens/user/user_profile_overview.dart';

class UserProfileWid extends StatelessWidget {
  const UserProfileWid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<Users>(context);
    final user = userData.userObj;
    return user == null
        ? TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(CreateProfile.routeName);
            },
            child: Text('Create User'))
        : ViewUserProfile(user: user);
  }
}
