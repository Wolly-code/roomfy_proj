import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../error/no_result_found.dart';
import '../../providers/tenant.dart';
import 'tenant_item.dart';

class TenantGrid extends StatefulWidget {
  const TenantGrid({Key? key, required this.showFavs}) : super(key: key);
  final bool showFavs;

  @override
  State<TenantGrid> createState() => _TenantGridState();
}

class _TenantGridState extends State<TenantGrid> {
  @override
  Widget build(BuildContext context) {
    final tenantData = Provider.of<Tenants>(context);
    final tenant =
        widget.showFavs ? tenantData.favoriteItems : tenantData.displayTenants;
    return tenant.isEmpty
        ? NoResultFoundScreen()
        : GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 4 / 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 40),
            itemCount: tenant.length,
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: tenant[i],
              child: const TenantItem(),
            ),
          );
  }
}
