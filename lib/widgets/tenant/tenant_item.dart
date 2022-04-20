import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/screens/tenant/tenant_detail_screen.dart';
import '../../providers/auth.dart';
import '../../providers/tenant.dart';

class TenantItem extends StatelessWidget {
  const TenantItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tenant = Provider.of<Tenant>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(TenantDetailScreen.routeName, arguments: tenant.id);
          },
          child: Image.network(
            tenant.photo1,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Tenant>(
            builder: (ctx, tenant, child) => IconButton(
                onPressed: () {
                  tenant.toggleFavoriteStatus(
                      authData.token.toString(), tenant.id);
                },
                icon: Icon(
                    tenant.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Theme.of(context).accentColor)),
          ),
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
