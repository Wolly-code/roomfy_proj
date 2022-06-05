import 'package:flutter/material.dart';
import 'package:roomfy_proj/providers/user.dart';
import 'package:roomfy_proj/screens/post_ad.dart';
import 'package:roomfy_proj/screens/room/room_overview_screen.dart';
import 'package:roomfy_proj/screens/tenant/tenant_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/screens/user_tab_screen.dart';
import '../providers/auth.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int currentIndex = 0;
  final screens = [
    const MainViewSmall(),
    const UserTab(),
    const PostAd(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 25,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        fixedColor: Colors.black,
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.push_pin),
            label: 'Post Ad',
          ),
        ],
      ),
    );
  }
}

class MainViewSmall extends StatefulWidget {
  const MainViewSmall({Key? key}) : super(key: key);

  @override
  _MainViewSmallState createState() => _MainViewSmallState();
}

class _MainViewSmallState extends State<MainViewSmall> {
  Future? _fetchFuture;

  Future _refreshUsers() async {

    return Provider.of<Users>(context, listen: false).getAllUserData();
  }

  @override
  void initState() {
    _fetchFuture = _refreshUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String? userName = Provider.of<Auth>(context).userId;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Roomfy",
          ),
        ),
      ),
      body: FutureBuilder(
        future: _fetchFuture,
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Hello ' + userName!,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    height: 150,
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.supervisor_account),
                    title: const Text('Search For Tenant'),
                    onTap: () {
                      Navigator.of(context).pushNamed(TenantView.routeName);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.location_searching),
                    title: const Text('Search For Room'),
                    onTap: () {
                      Navigator.of(context).pushNamed(RoomView.routeName);
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
