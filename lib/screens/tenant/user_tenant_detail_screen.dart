import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/tenant.dart';

class UserTenantDetailScreen extends StatefulWidget {
  const UserTenantDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/User-tenant-detail-screen';

  @override
  State<UserTenantDetailScreen> createState() => _UserTenantDetailScreenState();
}

class _UserTenantDetailScreenState extends State<UserTenantDetailScreen> {
  final _form = GlobalKey<FormState>();
  bool _innit = true;
  File? _photo1Stored;
  String? email;
  String? name;
  String? phoneNumber;
  String? gender;
  String? occupation;
  int? age;
  String? location;
  String? description;
  int? budget;
  bool petOwner = false;
  String? preference;
  String? title;
  String photo = 'https://img.icons8.com/color/344/user.png';
  Tenant _editedTenant = Tenant(
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
      photo1: '',
      email: '');

  Future<void> _photo1() async {
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

  List<DropdownMenuItem<String>> get genderDropDown {
    List<DropdownMenuItem<String>> menuItems = const [
      DropdownMenuItem(child: Text("Male"), value: "Male"),
      DropdownMenuItem(child: Text("Female"), value: "Female"),
      DropdownMenuItem(child: Text("Others"), value: "Others"),
    ];
    return menuItems;
  }

  String genderSelectedValue = "Male";
  String genderDropDownValue = 'Male';

  List<DropdownMenuItem<String>> get occupationDropDown {
    List<DropdownMenuItem<String>> menuItems = const [
      DropdownMenuItem(child: Text("Student"), value: "Student"),
      DropdownMenuItem(child: Text("Professional"), value: "Professional"),
      DropdownMenuItem(child: Text("Others"), value: "Others"),
    ];
    return menuItems;
  }

  String occupationSelectedValue = "Student";
  String occupationDropDownValue = 'Student';

  @override
  void didChangeDependencies() {
    if (_innit) {
      final String? tenantID =
          ModalRoute.of(context)!.settings.arguments as String;
      final temp = Provider.of<Tenants>(context).findByID(tenantID!);
      _editedTenant = temp;
      photo = _editedTenant.photo1;
    }
    _innit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    var tenant = Tenant(
        id: '',
        fullName: name.toString(),
        email: email.toString(),
        poster: '',
        gender: '',
        phoneNumber: phoneNumber.toString(),
        occupation: occupation.toString(),
        age: age!,
        petOwner: petOwner,
        location: location!,
        budget: budget!,
        preference: preference!,
        title: title!,
        description: description!,
        created: '',
        status: _editedTenant.status,
        photo1: '');
    gender ??= _editedTenant.gender;
    occupation ??= _editedTenant.occupation;
    if (_photo1Stored != null) {
      await Provider.of<Tenants>(context, listen: false).updateTenantwithPhoto(
          tenant, _photo1Stored!, _editedTenant.id, gender!, occupation!);
    } else {
      await Provider.of<Tenants>(context, listen: false)
          .updateTenantWithoutPhoto(
              tenant, _editedTenant.id, gender!, occupation!);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    String textButton = _editedTenant.status ? 'Deactivate' : 'Activate';

    return Scaffold(
      appBar: AppBar(
        title: Text(_editedTenant.title),
        centerTitle: true,
        actions: [
          TextButton(onPressed: _saveForm, child: const Text('Update'))
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () async {
                          final snackBar = SnackBar(
                            duration: const Duration(seconds: 2),
                            content: Text(
                                'Your Advertisement has been ${textButton}d'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () async {
                                bool newStatus = !_editedTenant.status;
                                await Provider.of<Tenants>(context,
                                        listen: false)
                                    .updateStatus(_editedTenant.id, newStatus);
                              },
                            ),
                          );
                          setState(() {
                            if (textButton == 'Deactivate') {
                              textButton = 'Activate';
                            } else {
                              textButton = 'Deactivate';
                            }
                          });

                          await Provider.of<Tenants>(context, listen: false)
                              .updateStatus(
                                  _editedTenant.id, _editedTenant.status);

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        child: Text(
                          textButton,
                          style: const TextStyle(fontSize: 20),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('ABOUT ME'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: _photo1Stored != null
                          ? Stack(
                              clipBehavior: Clip.none,
                              fit: StackFit.expand,
                              children: [
                                CircleAvatar(
                                  backgroundImage: FileImage(_photo1Stored!),
                                  radius: 200.00,
                                ),
                                Positioned(
                                  right: -16,
                                  bottom: 0,
                                  child: SizedBox(
                                    height: 46,
                                    width: 46,
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        side: const BorderSide(
                                            color: Colors.white),
                                      ),
                                      color: const Color(0xFFF5F6F9),
                                      onPressed: _photo1,
                                      child: const Center(
                                          child:
                                              Icon(Icons.camera_alt_outlined)),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Stack(
                              clipBehavior: Clip.none,
                              fit: StackFit.expand,
                              children: [
                                CircleAvatar(
                                  backgroundImage: photo != ''
                                      ? NetworkImage(photo)
                                      : NetworkImage(photo),
                                  radius: 200.00,
                                ),
                                Positioned(
                                  right: -16,
                                  bottom: 0,
                                  child: SizedBox(
                                    height: 46,
                                    width: 46,
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        side: const BorderSide(
                                            color: Colors.white),
                                      ),
                                      color: const Color(0xFFF5F6F9),
                                      onPressed: _photo1,
                                      child: const Center(
                                          child:
                                              Icon(Icons.camera_alt_outlined)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: TextFormField(
                    initialValue: _editedTenant.email,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(fontSize: 15),
                      labelText: 'Email ',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Provide a value';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: TextFormField(
                    initialValue: _editedTenant.fullName,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(fontSize: 15),
                      labelText: 'Full Name ',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Provide a value';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      name = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: TextFormField(
                    initialValue: _editedTenant.phoneNumber,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(fontSize: 15),
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Provide a value';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      phoneNumber = value;
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Text('Gender: '),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: DropdownButton(
                        value: genderSelectedValue,
                        items: genderDropDown,
                        onChanged: (String? newValue) {
                          setState(() {
                            genderSelectedValue = newValue!;
                          });
                          gender = newValue!;
                        }),
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Text('Occupation: '),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: DropdownButton(
                        value: occupationSelectedValue,
                        items: occupationDropDown,
                        onChanged: (String? newValue) {
                          setState(() {
                            occupationSelectedValue = newValue!;
                          });
                          occupation = newValue!;
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: TextFormField(
                    initialValue: _editedTenant.age.toString(),
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(fontSize: 15),
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Provide a value';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      age = int.parse(value!);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: TextFormField(
                    initialValue: _editedTenant.location,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(fontSize: 15),
                      labelText: 'Location',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Provide a value';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      location = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: TextFormField(
                    initialValue: _editedTenant.description,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(fontSize: 15),
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Provide a value';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      description = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: TextFormField(
                    initialValue: _editedTenant.budget.toString(),
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(fontSize: 15),
                      labelText: 'Budget',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Provide a value';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      budget = int.parse(value!);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: TextFormField(
                    initialValue: _editedTenant.preference,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(fontSize: 15),
                      labelText: 'Preference',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Provide a value';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      preference = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: TextFormField(
                    initialValue: _editedTenant.title,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(fontSize: 15),
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Provide a value';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      title = value;
                    },
                  ),
                ),
                CheckboxListTile(
                  title: Row(
                    children: const [
                      Icon(Icons.directions_car),
                      SizedBox(
                        width: 20,
                      ),
                      Text('Pet Owner'),
                    ],
                  ),
                  value: _editedTenant.petOwner,
                  onChanged: (value) {
                    setState(() {
                      petOwner = value is bool ? value : false;
                    });
                  },
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red, // background// foreground
                      ),
                      onPressed: () async {
                        await showDialog<Null>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Delete Post'),
                                  content: const Text(
                                      'Are you sure you want to delete your post?'),
                                  actions: [
                                    TextButton(
                                        child: const Text('Yes'),
                                        onPressed: () {
                                          Provider.of<Tenants>(context,
                                                  listen: false)
                                              .deleteTenant(_editedTenant.id);
                                          const snackBar = SnackBar(
                                            duration: Duration(seconds: 2),
                                            content: Text(
                                                'Your Advertisement has been deleted'),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                          Navigator.of(context).pop();
                                        }),
                                    TextButton(
                                        child: const Text('No'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        })
                                  ],
                                ));
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Remove Advertisement',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
