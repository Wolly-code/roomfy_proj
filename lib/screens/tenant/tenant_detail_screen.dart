import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tenant.dart';

class TenantDetailScreen extends StatefulWidget {
  const TenantDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/tenant-detail';

  @override
  _TenantDetailScreenState createState() => _TenantDetailScreenState();
}

class _TenantDetailScreenState extends State<TenantDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final tenantId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedTenant = Provider.of<Tenants>(context).findByID(tenantId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedTenant.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                'https://media.istockphoto.com/photos/funny-best-friends-concept-human-taking-a-selfie-with-dog-picture-id1024311036?k=20&m=1024311036&s=612x612&w=0&h=vZkjFMmxmj2VPHfcuRSz6LLwoOEkFHPtvWVCs5ytTQQ=',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              loadedTenant.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            const SizedBox(
              height: 10,
            ),
            Text('Ad: #' + loadedTenant.id,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                )),
            const SizedBox(
              height: 10,
            ),
            Text('Poster: ' + loadedTenant.poster,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                )),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedTenant.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
