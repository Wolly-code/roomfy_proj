import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/tenant.dart';
import 'package:roomfy_proj/screens/post_ad.dart';
import 'package:roomfy_proj/widgets/tenant/user_tenant_item.dart';

import '../../error/no_data.dart';

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
        onPressed: () {
          Navigator.of(context).pushNamed(PostAd.routeName);
        },
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
                      builder: (ctx, tenantData, _) => tenantData.owned.isEmpty
                          ? NoFileScreen()
                          : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                                itemCount: tenantData.owned.length,
                                itemBuilder: (ctx, i) => UserTenantItem(
                                  title: tenantData.owned[i].title,
                                  id: tenantData.owned[i].id,
                                  photo1: tenantData.owned[i].photo1,
                                  description: tenantData.owned[i].description,
                                ),
                              ),
                          ),
                    ),
                    onRefresh: () => _refreshRooms(),
                  ),
      ),
    );
  }
}
