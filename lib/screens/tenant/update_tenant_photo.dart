import 'package:flutter/material.dart';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/room.dart';
import 'package:roomfy_proj/providers/tenant.dart';

class UpdateTenantImage extends StatefulWidget {
  const UpdateTenantImage({Key? key}) : super(key: key);

  @override
  State<UpdateTenantImage> createState() => _UpdateTenantImageState();
}

class _UpdateTenantImageState extends State<UpdateTenantImage> {
  final _form = GlobalKey<FormState>();
  Tenant? tenant;
  bool _innit = true;
  File? _photo1Stored;
  String? photo1;

  Future<void> _photo1(int id) async {
    final picker = ImagePicker();
    final XFile? imageFile =
        await picker.pickImage(source: ImageSource.gallery, maxWidth: 600);
    if (imageFile == null) {
      return;
    }
    final File? saveFile = File(imageFile.path);
    setState(() {
      _photo1Stored = saveFile;
    });
  }
@override
  void didChangeDependencies() {
  if (_innit) {
    try {
      final String? tenantID =
      ModalRoute.of(context)!.settings.arguments as String;
      final temp = Provider.of<Tenants>(context).findByID(tenantID!);
      tenant = temp;
      photo1 = temp.photo1;
    } catch (error) {
      rethrow;
    }
  }
  _innit = false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
