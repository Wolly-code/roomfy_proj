import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/user.dart';
import 'package:roomfy_proj/widgets/user/view_user_profile.dart';
import '../../widgets/user/user_profile_wid.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);
  static const routeName = '/User-Profile-View';

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  var _isInit = true;
  var _isLoading = true;
  String? id;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final userID = ModalRoute.of(context)!.settings.arguments as String;
      id = userID;
      setState(() {
        _isLoading = true;
      });
      Provider.of<Users>(context).fetchAndSetUser().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<Users>(context);
    final user = userData.findByID(id!);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: ViewUserProfile(user: user),
    );
  }
}
