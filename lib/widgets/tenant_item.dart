import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/screens/tenant/tenant_detail_screen.dart';
import '../providers/tenant.dart';

class TenantItem extends StatelessWidget {
  const TenantItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tenant = Provider.of<Tenant>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(TenantDetailScreen.routeName, arguments: tenant.id);
          },
          child: Image.network(
            'https://media.istockphoto.com/photos/funny-best-friends-concept-human-taking-a-selfie-with-dog-picture-id1024311036?k=20&m=1024311036&s=612x612&w=0&h=vZkjFMmxmj2VPHfcuRSz6LLwoOEkFHPtvWVCs5ytTQQ=',
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            tenant.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.local_attraction_outlined)),
        ),
      ),
    );
  }
}
