import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/user.dart';
import '../../widgets/user/user_profile_wid.dart';

class UserProfileOverview extends StatefulWidget {
  const UserProfileOverview({Key? key}) : super(key: key);
  static const routeName = '/User-Profile';

  @override
  State<UserProfileOverview> createState() => _UserProfileOverviewState();
}

class _UserProfileOverviewState extends State<UserProfileOverview> {
  var _isInit = true;
  var _isLoading = true;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile    '),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const UserProfileWid(),
    );
  }
}
