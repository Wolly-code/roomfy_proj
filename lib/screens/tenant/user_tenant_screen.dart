import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/tenant.dart';
import 'package:roomfy_proj/widgets/tenant/user_tenant_item.dart';
import '../../screens/app_drawer.dart';
import 'edit_tenant_screen.dart';

class UserTenantScreen extends StatefulWidget {
  const UserTenantScreen({Key? key}) : super(key: key);
  static const routeName = '/User-tenant';

  @override
  _UserTenantScreenState createState() => _UserTenantScreenState();
}

class _UserTenantScreenState extends State<UserTenantScreen> {
  Future? _fetchFuture;

  Future _refreshRooms() async {
    return Provider.of<Tenants>(context, listen: false).fetchAndSetTenant();
  }

  @override
  void initState() {
    _fetchFuture = _refreshRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final roomData = Provider.of<Tenants>(context);
    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: _fetchFuture,
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    child: Consumer<Tenants>(
                      builder: (ctx, tenantData, _) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: tenantData.owned.length,
                          itemBuilder: (ctx, i) => UserTenantItem(
                              title: tenantData.owned[i].title,
                              id: tenantData.owned[i].id),
                        ),
                      ),
                    ),
                    onRefresh: () => _refreshRooms(),
                  ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
