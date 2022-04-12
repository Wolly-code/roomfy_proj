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
  final _form = GlobalKey<FormState>();
  File? _photo1Stored;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? userId;
  String? bio;
  String? email;

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
    try {
      var user = User(
          id: '',
          firstName: firstName.toString(),
          lastName: lastName.toString(),
          phoneNumber: phoneNumber.toString(),
          userId: '',
          bio: bio.toString(),
          email: email.toString(),
          profile: '');
      await Provider.of<Users>(context, listen: false)
          .addUser(user, _photo1Stored!);
      Navigator.of(context).pop();
    } catch (error) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Profile',
          style: TextStyle(fontSize: 15),
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
                                const CircleAvatar(
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
                  padding: const EdgeInsets.all(8.0),
                  child: const Text('Lets start with formality'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: TextFormField(
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
                const Divider(),
                const Text(
                    'Now only if you could fill up your contact details'),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: TextFormField(
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
