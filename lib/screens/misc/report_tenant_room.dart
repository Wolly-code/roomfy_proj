import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/tenant.dart';

class ReportTenantScreen extends StatefulWidget {
  const ReportTenantScreen({Key? key}) : super(key: key);
  static const routeName = '/Report-room';

  @override
  State<ReportTenantScreen> createState() => _ReportTenantScreenState();
}

class _ReportTenantScreenState extends State<ReportTenantScreen> {
  bool _innit = true;
  bool _validate = false;
  final _formKey = GlobalKey<FormState>();
  String? _description;
  String? _id;

  @override
  void didChangeDependencies() {
    if (_innit) {
      final id = ModalRoute.of(context)!.settings.arguments as String;
      _id = id;
    }
    _innit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _saveReport() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    await Provider.of<Tenants>(context, listen: false)
        .reportTenant(_description!, _id!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Room Ad'),
        centerTitle: true,
        actions: [
          TextButton(onPressed: _saveReport, child: const Text('Place Report'))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Enter you reason for reporting this room'),
            ),
            const SizedBox(
              height: 25,
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Text is empty';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
