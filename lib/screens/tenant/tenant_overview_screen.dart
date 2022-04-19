import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/room_booking.dart';
import '../../providers/tenant.dart';
import '../../providers/user.dart';
import '../../widgets/tenant/tenants_grid_view.dart';

class TenantView extends StatefulWidget {
  const TenantView({Key? key}) : super(key: key);
  static const routeName = '/tenant-view';

  @override
  State<TenantView> createState() => _TenantViewState();
}

class _TenantViewState extends State<TenantView> {
  var _isInit = true;
  var _isLoading = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Tenants>(context, listen: false).fetchAndSetTenant();
      Provider.of<Users>(context, listen: false).getAllUserData();
      Provider.of<Bookings>(context,listen: false).fetchAppointmentData();
      Provider.of<Tenants>(context).fetchAndSetTenant().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tenant'),
          actions: const [],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : const TenantGrid());
  }
}
