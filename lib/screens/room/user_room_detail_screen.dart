import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/room.dart';
import 'package:roomfy_proj/screens/room/update_room_photo.dart';
import 'package:roomfy_proj/screens/room/user_room_screen.dart';

class UserRoomDetailScreen extends StatefulWidget {
  const UserRoomDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/User-Room-Detail-Screen';

  @override
  State<UserRoomDetailScreen> createState() => _UserRoomDetailScreenState();
}

class _UserRoomDetailScreenState extends State<UserRoomDetailScreen> {
  var _innit = true;
  final _form = GlobalKey<FormState>();
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

  @override
  void didChangeDependencies() {
    if (_innit) {
      try {
        final String? roomID =
            ModalRoute.of(context)!.settings.arguments as String;
        final temp = Provider.of<Rooms>(context).findByID(roomID!);
        _editedRoom = temp;
      } catch (error) {
        rethrow;
      }
    }
    _innit = false;
    super.didChangeDependencies();
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
          .updateRoomDetail(_editedRoom.id, _editedRoom);
      await Provider.of<Rooms>(context, listen: false).fetchAndSetRoom();
      Navigator.of(context).pop();
    } catch (error) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    String textButton = _editedRoom.status ? 'Deactivate' : 'Activate';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Advert#' + _editedRoom.id.toString(),
        ),
        centerTitle: true,
        actions: [
          TextButton(onPressed: _saveForm, child: const Text('Update Ad'))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
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
                        content:
                            Text('Your Advertisement has been ${textButton}d'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () async {
                            bool newStatus = !_editedRoom.status;
                            await Provider.of<Rooms>(context, listen: false)
                                .updateStatus(_editedRoom.id, newStatus);
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

                      await Provider.of<Rooms>(context, listen: false)
                          .updateStatus(_editedRoom.id, _editedRoom.status);

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: Text(
                      textButton,
                      style: const TextStyle(fontSize: 20),
                    )),
              ),
            ),
            Form(
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
                        initialValue: _editedRoom.phoneNumber,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(fontSize: 15),
                          labelText: 'Phone Number',
                          hintText: 'Optional',
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
                      initialValue: _editedRoom.email,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(fontSize: 15),
                        labelText: 'Email',
                        hintText: 'Optional',
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
                        initialValue: _editedRoom.location,
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
                                }),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        initialValue: _editedRoom.totalRooms.toString(),
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
                        initialValue: _editedRoom.description,
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
                        initialValue: _editedRoom.title,
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
                    const Text('Upload Photo'),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            UpdateRoomImage.routeName,
                            arguments: _editedRoom.id);
                      },
                      child: const Text('Tap to Change Image'),
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
                                              Provider.of<Rooms>(context,
                                                      listen: false)
                                                  .deleteRoom(_editedRoom.id);
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
          ],
        ),
      ),
    );
  }
}
