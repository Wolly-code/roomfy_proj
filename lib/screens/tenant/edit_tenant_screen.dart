import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/tenant.dart';

class EditTenantScreen extends StatefulWidget {
  const EditTenantScreen({Key? key}) : super(key: key);
  static const routeName = '/edit-tenant-screen';

  @override
  _EditTenantScreenState createState() => _EditTenantScreenState();
}

class _EditTenantScreenState extends State<EditTenantScreen> {
  final _form = GlobalKey<FormState>();
  var _editedTenant = Tenant(
      id: '',
      fullName: '',
      poster: '',
      gender: '',
      phoneNumber: '',
      occupation: '',
      age: 0,
      petOwner: false,
      location: '',
      budget: 0,
      preference: '',
      title: '',
      description: '',
      created: '',
      status: false,
      photo1: '');
  var _innit = true;
  var _isLoading = false;
  var _innitValues = {
    'full_name': '',
    'gender': '',
    'phone_number': '',
    'occupation': '',
    'age': '',
    'pet_owner': '',
    'location': '',
    'Budget': '',
    'Preference': '',
    'Title': '',
    'description': '',
    'status': '',
  };

  @override
  void didChangeDependencies() {
    if (_innit) {
      try {
        final String? tenantID =
            ModalRoute.of(context)!.settings.arguments as String;
        if (tenantID != null) {
          final tenant = Provider.of<Tenants>(context).findByID(tenantID);
          _editedTenant = tenant;
          _innitValues = {
            'full_name': _editedTenant.fullName,
            'gender': _editedTenant.gender,
            'phone_number': _editedTenant.phoneNumber,
            'occupation': _editedTenant.occupation,
            'age': _editedTenant.age.toString(),
            'pet_owner': _editedTenant.petOwner.toString(),
            'location': _editedTenant.location,
            'Budget': _editedTenant.budget.toString(),
            'Preference': _editedTenant.preference,
            'Title': _editedTenant.title,
            'description': _editedTenant.description,
            'status': _editedTenant.status.toString(),
          };
        }
      } catch (error) {
        print('Caught the null here at edit tenant screen');
      }
    }
    _innit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
