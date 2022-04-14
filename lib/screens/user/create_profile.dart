import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/user.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({Key? key}) : super(key: key);
  static const routeName = '/Create-profile';

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  bool _innit = true;
  final _form = GlobalKey<FormState>();
  File? _photo1Stored;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? userId;
  String? bio;
  String? email;
  String? gender;
  String? location;
  String photo = 'https://img.icons8.com/color/344/user.png';
  User _editedUser = User(
      id: '',
      firstName: '',
      lastName: '',
      phoneNumber: '',
      userId: '',
      bio: '',
      email: '',
      gender: '',
      profile: '',
      location: '');
  var _innitValues = {
    'firstName': '',
    'lastName': '',
    'phoneNumber': '',
    'bio': '',
    'email': '',
    'gender': '',
    'location': '',
    'profile': '',
  };

  List<DropdownMenuItem<String>> get genderDropDown {
    List<DropdownMenuItem<String>> menuItems = const [
      DropdownMenuItem(child: Text("Male"), value: "Male"),
      DropdownMenuItem(child: Text("Female"), value: "Female"),
      DropdownMenuItem(child: Text("Others"), value: "Others"),
    ];
    return menuItems;
  }

  String genderSelectedValue = 'Male';
  String genderDropDownValue = 'Male';

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

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    var users = User(
      id: '',
      firstName: firstName.toString(),
      lastName: lastName.toString(),
      phoneNumber: phoneNumber.toString(),
      userId: '',
      bio: bio.toString(),
      email: email.toString(),
      profile: '',
      gender: gender.toString(),
      location: location.toString(),
    );
    if (_editedUser.id != '') {
      gender ??= _editedUser.gender;
      if (_photo1Stored != null) {
        await Provider.of<Users>(context, listen: false).updateUserWithPhoto(
            users, _photo1Stored!, _editedUser.id, gender.toString());
      } else {
        await Provider.of<Users>(context, listen: false)
            .updateUserWithoutPhoto(users, _editedUser.id, gender.toString());
      }
    } else {
      try {
        await Provider.of<Users>(context, listen: false)
            .addUser(users, _photo1Stored!);
        Navigator.of(context).pop();
      } catch (e) {
        await showDialog<Null>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text('An Error Occurred'),
                  content: const Text('Something Went wrong'),
                  actions: [
                    FlatButton(
                        child: const Text('Okay'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                ));
      }
    }
  }

  @override
  void didChangeDependencies() {
    if (_innit) {
      try {
        final String? userId =
            ModalRoute.of(context)!.settings.arguments as String;
        if (userId != null) {
          final user = Provider.of<Users>(context, listen: false).userObj;
          _editedUser = user!;
          _innitValues = {
            'firstName': _editedUser.firstName,
            'lastName': _editedUser.lastName,
            'phoneNumber': _editedUser.phoneNumber,
            'bio': _editedUser.bio,
            'email': _editedUser.email,
            'gender': _editedUser.gender,
            'location': _editedUser.location,
            'profile': _editedUser.profile,
          };
          photo = _editedUser.profile;
        }
      } catch (e) {}
    }
    _innit = false;
    super.didChangeDependencies();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _editedUser.id == '' ? 'Create Profile' : 'Update Profile',
          style: const TextStyle(fontSize: 15),
        ),
        centerTitle: true,
        actions: [
          TextButton(onPressed: _saveForm, child: const Icon(Icons.add))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Lets start with formality'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: TextFormField(
                    initialValue: _innitValues['firstName'],
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(fontSize: 15),
                      labelText: 'First Name ',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Provide your First Name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      firstName = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: TextFormField(
                    initialValue: _innitValues['lastName'],
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(fontSize: 15),
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Provide your Last Name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      lastName = value;
                    },
                  ),
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
                const Text(
                    'Now only if you could fill up your contact details'),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: TextFormField(
                    initialValue: _innitValues['phoneNumber'],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(fontSize: 15),
                      labelText: 'Phone Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Provide your Phone Name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      phoneNumber = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: TextFormField(
                    initialValue: _innitValues['location'],
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(fontSize: 15),
                      labelText: 'Location',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Provide your location';
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
                    initialValue: _innitValues['email'],
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(fontSize: 15),
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Provide your Email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value;
                    },
                  ),
                ),
                const Divider(),
                const Text('Finally! Write something about yourself'),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: TextFormField(
                    initialValue: _innitValues['bio'],
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(fontSize: 15),
                      labelText: 'Bio',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Provide your bio';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      bio = value;
                    },
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
