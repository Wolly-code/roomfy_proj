import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/room.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PostRoomAd extends StatefulWidget {
  const PostRoomAd({Key? key}) : super(key: key);
  static const routeName = '/post-room-ad';

  @override
  _PostRoomAdState createState() => _PostRoomAdState();
}

class _PostRoomAdState extends State<PostRoomAd> {
  final _form = GlobalKey<FormState>();
  File? _photo1Stored;
  File? _photo2Stored;
  var _editedRoom = Room(
      id: '',
      title: '',
      poster: '',
      posterId: '',
      description: '',
      created: '',
      email: '',
      phoneNumber: '',
      location: '',
      propertyType: '',
      totalRooms: 0,
      price: 0,
      internet: false,
      parking: false,
      balcony: false,
      yard: false,
      disableAccess: false,
      garage: false,
      status: true,
      photo1: '',
      photo2: '',
      securityDeposit: 0);

  Future<void> _photo1(int id) async {
    final picker = ImagePicker();
    final XFile? imageFile =
        await picker.pickImage(source: ImageSource.gallery, maxWidth: 600);
    if (imageFile == null) {
      return;
    }
    final File? saveFile = File(imageFile.path);
    setState(() {
      if (id == 0) {
        _photo1Stored = saveFile;
      } else {
        _photo2Stored = saveFile;
      }
    });
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = const [
      DropdownMenuItem(child: Text("Apartment"), value: "Apartment"),
      DropdownMenuItem(child: Text("House"), value: "House"),
      DropdownMenuItem(child: Text("Others"), value: "Others"),
    ];
    return menuItems;
  }

  String selectedValue = "Apartment";
  String dropdownValue = 'One';

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    try {
      await Provider.of<Rooms>(context, listen: false)
          .addRoom(_editedRoom, _photo1Stored!, _photo2Stored!);
      Navigator.of(context).pop();
    } catch (error) {
      rethrow;
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
              padding: EdgeInsets.all(8.0),
              child: Text('Place Ad'),
            ),
          ),
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
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(fontSize: 15),
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedRoom = Room(
                          id: _editedRoom.id,
                          title: _editedRoom.title,
                          poster: _editedRoom.poster,
                          posterId: _editedRoom.posterId,
                          description: _editedRoom.description,
                          created: _editedRoom.created,
                          email: _editedRoom.email,
                          phoneNumber: value.toString(),
                          location: _editedRoom.location,
                          propertyType: _editedRoom.propertyType,
                          totalRooms: _editedRoom.totalRooms,
                          price: _editedRoom.price,
                          internet: _editedRoom.internet,
                          parking: _editedRoom.parking,
                          balcony: _editedRoom.balcony,
                          yard: _editedRoom.yard,
                          disableAccess: _editedRoom.disableAccess,
                          garage: _editedRoom.garage,
                          status: _editedRoom.status,
                          photo1: '',
                          photo2: '',
                          securityDeposit: _editedRoom.securityDeposit,
                        );
                      },
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(fontSize: 15),
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please provide a value';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedRoom = Room(
                        id: _editedRoom.id,
                        title: _editedRoom.title,
                        poster: _editedRoom.poster,
                        posterId: _editedRoom.posterId,
                        description: _editedRoom.description,
                        created: _editedRoom.created,
                        email: value.toString(),
                        phoneNumber: _editedRoom.phoneNumber,
                        location: _editedRoom.location,
                        propertyType: _editedRoom.propertyType,
                        totalRooms: _editedRoom.totalRooms,
                        price: _editedRoom.price,
                        internet: _editedRoom.internet,
                        parking: _editedRoom.parking,
                        balcony: _editedRoom.balcony,
                        yard: _editedRoom.yard,
                        disableAccess: _editedRoom.disableAccess,
                        garage: _editedRoom.garage,
                        status: _editedRoom.status,
                        photo1: '',
                        photo2: '',
                        securityDeposit: _editedRoom.securityDeposit,
                      );
                    },
                  ),
                  const Divider(),
                  const Text(
                    'PROPERTY DETAILS',
                    style: TextStyle(fontSize: 15),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(fontSize: 15),
                        labelText: 'Location',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a valid location';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedRoom = Room(
                          id: _editedRoom.id,
                          title: _editedRoom.title,
                          poster: _editedRoom.poster,
                          posterId: _editedRoom.posterId,
                          description: _editedRoom.description,
                          created: _editedRoom.created,
                          email: _editedRoom.email,
                          phoneNumber: _editedRoom.phoneNumber,
                          location: value.toString(),
                          propertyType: _editedRoom.propertyType,
                          totalRooms: _editedRoom.totalRooms,
                          price: _editedRoom.price,
                          internet: _editedRoom.internet,
                          parking: _editedRoom.parking,
                          balcony: _editedRoom.balcony,
                          yard: _editedRoom.yard,
                          disableAccess: _editedRoom.disableAccess,
                          garage: _editedRoom.garage,
                          status: _editedRoom.status,
                          photo1: '',
                          photo2: '',
                          securityDeposit: _editedRoom.securityDeposit,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(fontSize: 15),
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a valid location';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedRoom = Room(
                          id: _editedRoom.id,
                          title: _editedRoom.title,
                          poster: _editedRoom.poster,
                          posterId: _editedRoom.posterId,
                          description: _editedRoom.description,
                          created: _editedRoom.created,
                          email: _editedRoom.email,
                          phoneNumber: _editedRoom.phoneNumber,
                          location: _editedRoom.location,
                          propertyType: _editedRoom.propertyType,
                          totalRooms: _editedRoom.totalRooms,
                          price: int.parse(value!),
                          internet: _editedRoom.internet,
                          parking: _editedRoom.parking,
                          balcony: _editedRoom.balcony,
                          yard: _editedRoom.yard,
                          disableAccess: _editedRoom.disableAccess,
                          garage: _editedRoom.garage,
                          status: _editedRoom.status,
                          photo1: '',
                          photo2: '',
                          securityDeposit: _editedRoom.securityDeposit,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(fontSize: 15),
                        labelText: 'Security Deposit',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a valid location';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedRoom = Room(
                          id: _editedRoom.id,
                          title: _editedRoom.title,
                          poster: _editedRoom.poster,
                          posterId: _editedRoom.posterId,
                          description: _editedRoom.description,
                          created: _editedRoom.created,
                          email: _editedRoom.email,
                          phoneNumber: _editedRoom.phoneNumber,
                          location: _editedRoom.location,
                          propertyType: _editedRoom.propertyType,
                          totalRooms: _editedRoom.totalRooms,
                          price: _editedRoom.price,
                          internet: _editedRoom.internet,
                          parking: _editedRoom.parking,
                          balcony: _editedRoom.balcony,
                          yard: _editedRoom.yard,
                          disableAccess: _editedRoom.disableAccess,
                          garage: _editedRoom.garage,
                          status: _editedRoom.status,
                          photo1: '',
                          photo2: '',
                          securityDeposit: int.parse(value!),
                        );
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Apartment Type:',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: DropdownButtonHideUnderline(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: DropdownButton(
                              value: selectedValue,
                              items: dropdownItems,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedValue = newValue!;
                                });
                                if (newValue != null) {
                                  _editedRoom = Room(
                                    id: _editedRoom.id,
                                    title: _editedRoom.title,
                                    poster: _editedRoom.poster,
                                    posterId: _editedRoom.posterId,
                                    description: _editedRoom.description,
                                    created: _editedRoom.created,
                                    email: _editedRoom.email,
                                    phoneNumber: _editedRoom.phoneNumber,
                                    location: _editedRoom.location,
                                    propertyType: newValue.toString(),
                                    totalRooms: _editedRoom.totalRooms,
                                    price: _editedRoom.price,
                                    internet: _editedRoom.internet,
                                    parking: _editedRoom.parking,
                                    balcony: _editedRoom.balcony,
                                    yard: _editedRoom.yard,
                                    disableAccess: _editedRoom.disableAccess,
                                    garage: _editedRoom.garage,
                                    status: _editedRoom.status,
                                    photo1: '',
                                    photo2: '',
                                    securityDeposit:
                                        _editedRoom.securityDeposit,
                                  );
                                } else {
                                  _editedRoom = Room(
                                    id: _editedRoom.id,
                                    title: _editedRoom.title,
                                    poster: _editedRoom.poster,
                                    posterId: _editedRoom.posterId,
                                    description: _editedRoom.description,
                                    created: _editedRoom.created,
                                    email: _editedRoom.email,
                                    phoneNumber: _editedRoom.phoneNumber,
                                    location: _editedRoom.location,
                                    propertyType: 'Apartment',
                                    totalRooms: _editedRoom.totalRooms,
                                    price: _editedRoom.price,
                                    internet: _editedRoom.internet,
                                    parking: _editedRoom.parking,
                                    balcony: _editedRoom.balcony,
                                    yard: _editedRoom.yard,
                                    disableAccess: _editedRoom.disableAccess,
                                    garage: _editedRoom.garage,
                                    status: _editedRoom.status,
                                    photo1: '',
                                    photo2: '',
                                    securityDeposit:
                                        _editedRoom.securityDeposit,
                                  );
                                }
                              }),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(fontSize: 15),
                        labelText: 'Total number of rooms',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a valid number of room';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedRoom = Room(
                          id: _editedRoom.id,
                          title: _editedRoom.title,
                          poster: _editedRoom.poster,
                          posterId: _editedRoom.posterId,
                          description: _editedRoom.description,
                          created: _editedRoom.created,
                          email: _editedRoom.email,
                          phoneNumber: _editedRoom.phoneNumber,
                          location: _editedRoom.location,
                          propertyType: _editedRoom.propertyType,
                          totalRooms: int.parse(value!),
                          price: _editedRoom.price,
                          internet: _editedRoom.internet,
                          parking: _editedRoom.parking,
                          balcony: _editedRoom.balcony,
                          yard: _editedRoom.yard,
                          disableAccess: _editedRoom.disableAccess,
                          garage: _editedRoom.garage,
                          status: _editedRoom.status,
                          photo1: '',
                          photo2: '',
                          securityDeposit: _editedRoom.securityDeposit,
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  const Text('AMENITIES'),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Which of the following amenities are available at the property?',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  CheckboxListTile(
                    title: Row(
                      children: const [
                        Icon(Icons.directions_car),
                        SizedBox(
                          width: 20,
                        ),
                        Text('Parking'),
                      ],
                    ),
                    value: _editedRoom.parking,
                    onChanged: (value) {
                      setState(() {
                        _editedRoom = Room(
                          id: _editedRoom.id,
                          title: _editedRoom.title,
                          poster: _editedRoom.poster,
                          posterId: _editedRoom.posterId,
                          description: _editedRoom.description,
                          created: _editedRoom.created,
                          email: _editedRoom.email,
                          phoneNumber: _editedRoom.phoneNumber,
                          location: _editedRoom.location,
                          propertyType: _editedRoom.propertyType,
                          totalRooms: _editedRoom.totalRooms,
                          price: _editedRoom.price,
                          internet: _editedRoom.internet,
                          parking: value is bool ? value : false,
                          balcony: _editedRoom.balcony,
                          yard: _editedRoom.yard,
                          disableAccess: _editedRoom.disableAccess,
                          garage: _editedRoom.garage,
                          status: _editedRoom.status,
                          photo1: '',
                          photo2: '',
                          securityDeposit: _editedRoom.securityDeposit,
                        );
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Row(
                      children: const [
                        Icon(Icons.wifi),
                        SizedBox(
                          width: 20,
                        ),
                        Text('Internet'),
                      ],
                    ),
                    value: _editedRoom.internet,
                    onChanged: (value) {
                      setState(() {
                        _editedRoom = Room(
                          id: _editedRoom.id,
                          title: _editedRoom.title,
                          poster: _editedRoom.poster,
                          posterId: _editedRoom.posterId,
                          description: _editedRoom.description,
                          created: _editedRoom.created,
                          email: _editedRoom.email,
                          phoneNumber: _editedRoom.phoneNumber,
                          location: _editedRoom.location,
                          propertyType: _editedRoom.propertyType,
                          totalRooms: _editedRoom.totalRooms,
                          price: _editedRoom.price,
                          internet: value is bool ? value : false,
                          parking: _editedRoom.parking,
                          balcony: _editedRoom.balcony,
                          yard: _editedRoom.yard,
                          disableAccess: _editedRoom.disableAccess,
                          garage: _editedRoom.garage,
                          status: _editedRoom.status,
                          photo1: '',
                          photo2: '',
                          securityDeposit: _editedRoom.securityDeposit,
                        );
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Row(
                      children: const [
                        Icon(Icons.balcony),
                        SizedBox(
                          width: 20,
                        ),
                        Text('Balcony'),
                      ],
                    ),
                    value: _editedRoom.balcony,
                    onChanged: (value) {
                      setState(() {
                        _editedRoom = Room(
                          id: _editedRoom.id,
                          title: _editedRoom.title,
                          poster: _editedRoom.poster,
                          posterId: _editedRoom.posterId,
                          description: _editedRoom.description,
                          created: _editedRoom.created,
                          email: _editedRoom.email,
                          phoneNumber: _editedRoom.phoneNumber,
                          location: _editedRoom.location,
                          propertyType: _editedRoom.propertyType,
                          totalRooms: _editedRoom.totalRooms,
                          price: _editedRoom.price,
                          internet: _editedRoom.internet,
                          parking: _editedRoom.parking,
                          balcony: value is bool ? value : false,
                          yard: _editedRoom.yard,
                          disableAccess: _editedRoom.disableAccess,
                          garage: _editedRoom.garage,
                          status: _editedRoom.status,
                          photo1: '',
                          photo2: '',
                          securityDeposit: _editedRoom.securityDeposit,
                        );
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Row(
                      children: const [
                        Icon(Icons.yard),
                        SizedBox(
                          width: 20,
                        ),
                        Text('Yard'),
                      ],
                    ),
                    value: _editedRoom.yard,
                    onChanged: (value) {
                      setState(() {
                        _editedRoom = Room(
                          id: _editedRoom.id,
                          title: _editedRoom.title,
                          poster: _editedRoom.poster,
                          posterId: _editedRoom.posterId,
                          description: _editedRoom.description,
                          created: _editedRoom.created,
                          email: _editedRoom.email,
                          phoneNumber: _editedRoom.phoneNumber,
                          location: _editedRoom.location,
                          propertyType: _editedRoom.propertyType,
                          totalRooms: _editedRoom.totalRooms,
                          price: _editedRoom.price,
                          internet: _editedRoom.internet,
                          parking: _editedRoom.parking,
                          balcony: _editedRoom.balcony,
                          yard: value is bool ? value : false,
                          disableAccess: _editedRoom.disableAccess,
                          garage: _editedRoom.garage,
                          status: _editedRoom.status,
                          photo1: '',
                          photo2: '',
                          securityDeposit: _editedRoom.securityDeposit,
                        );
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Row(
                      children: const [
                        Icon(Icons.wheelchair_pickup_outlined),
                        SizedBox(
                          width: 20,
                        ),
                        Text('Disabled Access'),
                      ],
                    ),
                    value: _editedRoom.disableAccess,
                    onChanged: (value) {
                      setState(() {
                        _editedRoom = Room(
                          id: _editedRoom.id,
                          title: _editedRoom.title,
                          poster: _editedRoom.poster,
                          posterId: _editedRoom.posterId,
                          description: _editedRoom.description,
                          created: _editedRoom.created,
                          email: _editedRoom.email,
                          phoneNumber: _editedRoom.phoneNumber,
                          location: _editedRoom.location,
                          propertyType: _editedRoom.propertyType,
                          totalRooms: _editedRoom.totalRooms,
                          price: _editedRoom.price,
                          internet: _editedRoom.internet,
                          parking: _editedRoom.parking,
                          balcony: _editedRoom.balcony,
                          yard: _editedRoom.yard,
                          disableAccess: value is bool ? value : false,
                          garage: _editedRoom.garage,
                          status: _editedRoom.status,
                          photo1: '',
                          photo2: '',
                          securityDeposit: _editedRoom.securityDeposit,
                        );
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Row(
                      children: const [
                        Icon(Icons.garage),
                        SizedBox(
                          width: 20,
                        ),
                        Text('Garage'),
                      ],
                    ),
                    value: _editedRoom.garage,
                    onChanged: (value) {
                      setState(() {
                        _editedRoom = Room(
                          id: _editedRoom.id,
                          title: _editedRoom.title,
                          poster: _editedRoom.poster,
                          posterId: _editedRoom.posterId,
                          description: _editedRoom.description,
                          created: _editedRoom.created,
                          email: _editedRoom.email,
                          phoneNumber: _editedRoom.phoneNumber,
                          location: _editedRoom.location,
                          propertyType: _editedRoom.propertyType,
                          totalRooms: _editedRoom.totalRooms,
                          price: _editedRoom.price,
                          internet: _editedRoom.internet,
                          parking: _editedRoom.parking,
                          balcony: _editedRoom.balcony,
                          yard: _editedRoom.yard,
                          disableAccess: _editedRoom.disableAccess,
                          garage: value is bool ? value : false,
                          status: _editedRoom.status,
                          photo1: '',
                          photo2: '',
                          securityDeposit: _editedRoom.securityDeposit,
                        );
                      });
                    },
                  ),
                  const Divider(),
                  const Text(
                    'DESCRIPTION',
                    style: TextStyle(fontSize: 15),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(fontSize: 15),
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a title';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedRoom = Room(
                          id: _editedRoom.id,
                          title: value.toString(),
                          poster: _editedRoom.poster,
                          posterId: _editedRoom.posterId,
                          description: _editedRoom.description,
                          created: _editedRoom.created,
                          email: _editedRoom.email,
                          phoneNumber: _editedRoom.phoneNumber,
                          location: _editedRoom.location,
                          propertyType: _editedRoom.propertyType,
                          totalRooms: _editedRoom.totalRooms,
                          price: _editedRoom.price,
                          internet: _editedRoom.internet,
                          parking: _editedRoom.parking,
                          balcony: _editedRoom.balcony,
                          yard: _editedRoom.yard,
                          disableAccess: _editedRoom.disableAccess,
                          garage: _editedRoom.garage,
                          status: _editedRoom.status,
                          photo1: '',
                          photo2: '',
                          securityDeposit: _editedRoom.securityDeposit,
                        );
                      },
                    ),
                  ),
                  const Text(
                      'Include details about the rooms and the property , local area and what a potential roommate should expect from you.'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(fontSize: 15),
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a Description';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedRoom = Room(
                          id: _editedRoom.id,
                          title: _editedRoom.title,
                          poster: _editedRoom.poster,
                          posterId: _editedRoom.posterId,
                          description: value.toString(),
                          created: _editedRoom.created,
                          email: _editedRoom.email,
                          phoneNumber: _editedRoom.phoneNumber,
                          location: _editedRoom.location,
                          propertyType: _editedRoom.propertyType,
                          totalRooms: _editedRoom.totalRooms,
                          price: _editedRoom.price,
                          internet: _editedRoom.internet,
                          parking: _editedRoom.parking,
                          balcony: _editedRoom.balcony,
                          yard: _editedRoom.yard,
                          disableAccess: _editedRoom.disableAccess,
                          garage: _editedRoom.garage,
                          status: _editedRoom.status,
                          photo1: '',
                          photo2: '',
                          securityDeposit: _editedRoom.securityDeposit,
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  const Text(
                    'PHOTOS',
                    style: TextStyle(fontSize: 15),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _photo1Stored != null
                              ? GestureDetector(
                                  onTap: () async {
                                    _photo1(0);
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
                                      _photo1(0);
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                ),
                          alignment: Alignment.center,
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _photo2Stored != null
                              ? GestureDetector(
                                  onTap: () async {
                                    _photo1(1);
                                  },
                                  child: Image.file(
                                    _photo2Stored!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                )
                              : Container(
                                  height: 100,
                                  width: 100,
                                  child: IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        _photo1(1);
                                      });
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                ),
                          alignment: Alignment.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
