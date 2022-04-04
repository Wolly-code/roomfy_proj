import 'package:flutter/material.dart';
import 'package:roomfy_proj/screens/room/post_room_ad.dart';
import 'package:roomfy_proj/screens/tenant/post_tenant_ad.dart';

class PostAd extends StatelessWidget {
  const PostAd({Key? key}) : super(key: key);
  static const routeName = '/post-ad';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Post Ad',
          ),
        ),
      ),
      body: Column(
        children: const [
          CardCreator(
            buttonDescription: 'Post Room Ad',
            title: 'Room Ad',
            icon: Icon(Icons.bed),
            description:
                'Advertise one or more rooms for rent int he same property.',
            check: true,
          ),
          CardCreator(
            buttonDescription: 'Post Tenant Ad',
            title: 'Tenant Ad',
            icon: Icon(Icons.person),
            description: 'Let other users know about you or your search',
            check: false,
          ),
        ],
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
      required this.check})
      : super(key: key);
  final Icon icon;
  final String title;
  final String description;
  final String buttonDescription;
  final bool check;

  @override
  Widget build(BuildContext context) {
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
                        Navigator.of(context).pushNamed(PostRoomAd.routeName);
                      },
                      child: Text(buttonDescription))
                  : TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(PostTenantAd.routeName);
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
