import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/tenant.dart';
import 'dart:developer';

class PostTenantAd extends StatefulWidget {
  const PostTenantAd({Key? key}) : super(key: key);
  static const routeName = '/post-tenant-ad';

  @override
  _PostTenantAdState createState() => _PostTenantAdState();
}

class _PostTenantAdState extends State<PostTenantAd> {
  final _form = GlobalKey<FormState>();
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
  String? preference;
  String? title;
  bool petOwner = false;

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

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    try {
      var tenant = Tenant(
        id: '',
        fullName: name.toString(),
        poster: '',
        gender: gender.toString(),
        phoneNumber: phoneNumber.toString(),
        occupation: occupation.toString(),
        age: int.parse(age.toString()),
        petOwner: petOwner,
        location: location.toString(),
        budget: int.parse(budget.toString()),
        preference: preference.toString(),
        title: title.toString(),
        description: description.toString(),
        created: '',
        status: true,
        photo1: '',
        email: email.toString(),
      );
      if (_photo1Stored == null) {
        await showDialog<Null>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text('No Photo Found'),
                  content: const Text('You forgot to upload your image'),
                  actions: [
                    TextButton(
                        child: const Text('Okay'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                ));
      } else {
        if (gender == null || occupation == null) {
          gender = gender == null ? gender = 'Male' : gender = gender;
          occupation = occupation == null
              ? occupation = 'Student'
              : occupation = occupation;
          await Provider.of<Tenants>(context, listen: false)
              .addTenantAd(tenant, _photo1Stored!, gender!, occupation!);
        } else {
          await Provider.of<Tenants>(context, listen: false)
              .addTenantAd(tenant, _photo1Stored!, gender!, occupation!);
        }
        const snackBar = SnackBar(
          duration: Duration(seconds: 2),
          content: Text("Tenant Advertisement Created Successfully"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pop();
      }
    } catch (error) {
      await showDialog<Null>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('An Error Occurred'),
                content: const Text('Something Went wrong'),
                actions: [
                  TextButton(
                      child: const Text('Okay'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          TextButton(
            onPressed: _saveForm,
            child: const Padding(
              padding: EdgeInsets.all(9),
              child: Text('Place Ad'),
            ),
          )
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
                const Text('ABOUT ME'),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: TextFormField(
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
                  value: petOwner,
                  onChanged: (value) {
                    setState(() {
                      petOwner = value is bool ? value : false;
                    });
                  },
                ),
                const Divider(),
                const Center(
                  child: Text(
                    'PHOTO',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Center(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                        ),
                        child: _photo1Stored != null
                            ? GestureDetector(
                                onTap: () async {
                                  _photo1();
                                },
                                child: Image.file(
                                  _photo1Stored!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              )
                            : Container(
                                height: 100,
                                width: 100,
                                child: IconButton(
                                  onPressed: () async {
                                    _photo1();
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                                decoration: BoxDecoration(border: Border.all()),
                              ),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
