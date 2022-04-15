import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/user.dart';
import 'package:roomfy_proj/screens/room/post_room_ad.dart';
import 'package:roomfy_proj/screens/tenant/post_tenant_ad.dart';
import 'package:roomfy_proj/screens/user/create_profile.dart';

class PostAd extends StatefulWidget {
  const PostAd({Key? key}) : super(key: key);
  static const routeName = '/post-ad';

  @override
  State<PostAd> createState() => _PostAdState();
}

class _PostAdState extends State<PostAd> {
  Future? _fetchFuture;

  Future _refreshRooms() async {
    return Provider.of<Users>(context, listen: false).fetchAndSetUser();
  }

  @override
  void initState() {
    _fetchFuture = _refreshRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<Users>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Post Ad',
          ),
        ),
      ),
      body: FutureBuilder(
        future: _fetchFuture,
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      CardCreator(
                        buttonDescription: 'Post Room Ad',
                        title: 'Room Ad',
                        icon: Icon(Icons.bed),
                        description:
                            'Advertise one or more rooms for rent int he same property.',
                        check: true,
                        users: users.userObj,
                      ),
                      CardCreator(
                        buttonDescription: 'Post Tenant Ad',
                        title: 'Tenant Ad',
                        icon: Icon(Icons.person),
                        description:
                            'Let other users know about you or your search',
                        check: false,
                        users: users.userObj,
                      ),
                    ],
                  ),
      ),
    );
  }
}

class CardCreator extends StatelessWidget {
  const CardCreator(
      {Key? key,
      required this.icon,
      required this.title,
      required this.description,
      required this.buttonDescription,
      required this.check,
      required this.users})
      : super(key: key);
  final Icon icon;
  final String title;
  final String description;
  final String buttonDescription;
  final bool check;
  final User? users;

  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 2),
      content:
          const Text("You can't post an Advert without creating a Profile"),
      action: SnackBarAction(
        label: 'Create Profile',
        onPressed: () async {
          Navigator.of(context).pushNamed(CreateProfile.routeName);
        },
      ),
    );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Card(
        borderOnForeground: true,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              icon,
              Text(title),
              const SizedBox(
                height: 10,
              ),
              Text(description),
              const Divider(
                color: Colors.black12,
              ),
              check
                  ? TextButton(
                      onPressed: () {
                        try {
                          if (users != null) {
                            Navigator.of(context)
                                .pushNamed(PostRoomAd.routeName);
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: Text(buttonDescription))
                  : TextButton(
                      onPressed: () {
                        try {
                          if (users != null) {
                            Navigator.of(context)
                                .pushNamed(PostTenantAd.routeName);
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: Text(buttonDescription),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
