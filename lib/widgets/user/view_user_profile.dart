import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roomfy_proj/screens/user/create_profile.dart';

import '../../providers/user.dart';
import 'number_widget.dart';

class ViewUserProfile extends StatefulWidget {
  final User user;

  const ViewUserProfile({Key? key, required this.user}) : super(key: key);

  @override
  State<ViewUserProfile> createState() => _ViewUserProfileState();
}

class _ViewUserProfileState extends State<ViewUserProfile> {
  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.user.profile, scale: 10),
            ),
            width: double.infinity,
            height: 200,
          ),
        ),
        const SizedBox(height: 24),
        _profileName(context, widget.user.firstName, widget.user.lastName),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: const Divider(
            height: 10,
            color: Colors.black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: _heading(context, "Account Details"),
        ),
        _detailsCard(
            widget.user.email.toString(), widget.user.phoneNumber.toString()),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: const Divider(
            height: 10,
            color: Colors.black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _heading(context, "Profile Details"),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(
                        CreateProfile.routeName,
                        arguments: widget.user.id);
                  },
                  icon: const Icon(Icons.edit))
            ],
          ),
        ),
        _settingsCard(widget.user.userId, widget.user.bio, widget.user.location,
            widget.user.gender),
      ],
    );
  }
}

Widget _settingsCard(String name, String bio, String location, String gender) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      elevation: 4,
      child: Column(
        children: [
          //row for each deatails
          ListTile(
            leading: const Icon(CupertinoIcons.profile_circled),
            title: Text(name),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.male),
            title: Text(gender),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.map),
            title: Text(location),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.map),
            title: Text(bio),
          ),
          const Divider(
            height: 0.6,
            color: Colors.black87,
          ),
        ],
      ),
    ),
  );
}

Widget _profileName(BuildContext context, String firstname, String lastName) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.80, //80% of width,
    child: Center(
      child: Text(
        firstname + " " + lastName,
        style: const TextStyle(
            color: Colors.black, fontSize: 24, fontWeight: FontWeight.w800),
      ),
    ),
  );
}

Widget _heading(BuildContext context, String heading) {
  return SizedBox(
    //color: Colors.red,
    width: MediaQuery.of(context).size.width * 0.6, //80% of width,
    child: Text(
      heading,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
    ),
  );
}

Widget nameWidget(User user) => Column(
      children: [
        Text(
          user.firstName + ' ' + user.lastName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: const TextStyle(color: Colors.grey),
        )
      ],
    );

Widget buildAbout(User user) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bio',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            user.bio,
            style: const TextStyle(fontSize: 16, height: 1.4),
          ),
        ],
      ),
    );

Widget _detailsCard(String email, String phoneNumber) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      elevation: 4,
      child: Column(
        children: [
          //row for each deatails
          ListTile(
            leading: const Icon(Icons.mail),
            title: Text(email),
          ),
          const Divider(
            height: 0.6,
            color: Colors.black87,
          ),

          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(phoneNumber),
          ),
          const Divider(
            height: 0.6,
            color: Colors.black87,
          ),
        ],
      ),
    ),
  );
}
