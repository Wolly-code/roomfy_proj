// import 'package:flutter/material.dart';
// import 'package:roomfy_proj/providers/room.dart';
// import 'package:provider/provider.dart';
//
// class EditRoomScreen extends StatefulWidget {
//   static const routeName = '/edit-room-screen';
//
//   const EditRoomScreen({Key? key}) : super(key: key);
//
//   @override
//   _EditRoomScreenState createState() => _EditRoomScreenState();
// }
//
// class _EditRoomScreenState extends State<EditRoomScreen> {
//   final _form = GlobalKey<FormState>();
//   final _descriptionFocusNode = FocusNode();
//   final _phoneNumber = FocusNode();
//   final _location = FocusNode();
//   final _propertyType = FocusNode();
//   final _totalRooms = FocusNode();
//   final _price = FocusNode();
//   var _editedRoom = Room(
//       id: '',
//       title: '',
//       poster: '',
//       posterId: '',
//       description: '',
//       created: '',
//       email: '',
//       phoneNumber: '',
//       location: '',
//       propertyType: '',
//       totalRooms: 0,
//       price: 0,
//       internet: false,
//       parking: false,
//       balcony: false,
//       yard: false,
//       disableAccess: false,
//       garage: false,
//       status: false,
//       photo1: '',
//       photo2: '');
//   var innit = true;
//   var _isLoading = false;
//   var _innitValues = {
//     'title': '',
//     'description': '',
//     'created': '',
//     'email': '',
//     'phoneNumber': '',
//     'location': '',
//     'propertyType': '',
//     'totalRooms': '0',
//     'price': '0',
//     'internet': 'false',
//     'parking': 'false',
//     'balcony': 'false',
//     'yard': 'false',
//     'disableAccess': 'false',
//     'garage': 'false',
//     'status': 'false',
//   };
//
//   @override
//   void didChangeDependencies() {
//     if (innit) {
//       try {
//         final String? roomID =
//             ModalRoute.of(context)!.settings.arguments as String;
//         if (roomID != null) {
//           final room =
//               Provider.of<Rooms>(context, listen: false).findByID(roomID);
//           _editedRoom = room;
//           _innitValues = {
//             'title': _editedRoom.title,
//             'description': _editedRoom.description,
//             'created': _editedRoom.created,
//             'email': _editedRoom.email,
//             'phoneNumber': _editedRoom.phoneNumber,
//             'location': _editedRoom.location,
//             'propertyType': _editedRoom.propertyType,
//             'totalRooms': _editedRoom.totalRooms.toString(),
//             'price': _editedRoom.price.toString(),
//             'internet': _editedRoom.internet.toString(),
//             'parking': _editedRoom.parking.toString(),
//             'balcony': _editedRoom.balcony.toString(),
//             'yard': _editedRoom.yard.toString(),
//             'disableAccess': _editedRoom.disableAccess.toString(),
//             'garage': _editedRoom.garage.toString(),
//             'status': _editedRoom.status.toString(),
//           };
//         }
//       } catch (error) {
//         rethrow;
//       }
//     }
//     innit = false;
//     super.didChangeDependencies();
//   }
//
//   @override
//   void dispose() {
//     _location.dispose();
//     _propertyType.dispose();
//     _totalRooms.dispose();
//     _price.dispose();
//     _phoneNumber.dispose();
//     _descriptionFocusNode.dispose();
//     super.dispose();
//   }
//
//   Future<void> _saveForm() async {
//     final isValid = _form.currentState!.validate();
//     if (!isValid) {
//       return;
//     }
//     _form.currentState!.save();
//     setState(() {
//       _isLoading = true;
//     });
//     if (_editedRoom.id != '') {
//       await Provider.of<Rooms>(context, listen: false)
//           .updateRoom(_editedRoom.id, _editedRoom);
//     } else {
//       try {
//         await Provider.of<Rooms>(context, listen: false).addRoom(_editedRoom);
//       } catch (error) {
//         await showDialog<Null>(
//             context: context,
//             builder: (ctx) => AlertDialog(
//                   title: const Text('An Error Occurred'),
//                   content: const Text('Something went wrong'),
//                   actions: [
//                     FlatButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: const Text('Okay'))
//                   ],
//                 ));
//       }
//     }
//     setState(() {
//       _isLoading = false;
//     });
//     Navigator.of(context).pop();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Edit Product'),
//           actions: [
//             IconButton(
//               onPressed: _saveForm,
//               icon: const Icon(Icons.save),
//             ),
//           ],
//         ),
//         body: _isLoading
//             ? const Center(
//                 child: CircularProgressIndicator(),
//               )
//             : Container()
//         // Padding(
//         //         padding: const EdgeInsets.all(15),
//         //         child: Form(
//         //           key: _form,
//         //           child: ListView(
//         //             children: [
//         //               TextFormField(
//         //                 initialValue: _innitValues['title'],
//         //                 decoration: const InputDecoration(labelText: 'Title'),
//         //                 textInputAction: TextInputAction.next,
//         //                 onFieldSubmitted: (_) {
//         //                   FocusScope.of(context)
//         //                       .requestFocus(_descriptionFocusNode);
//         //                 },
//         //                 validator: (value) {
//         //                   if (value!.isEmpty) {
//         //                     return 'Please provide a value';
//         //                   }
//         //                   return null;
//         //                 },
//         //                 onSaved: (value) {
//         //                   _editedRoom = Room(
//         //                       id: _editedRoom.id,
//         //                       title: value.toString(),
//         //                       poster: _editedRoom.poster,
//         //                       posterId: _editedRoom.posterId,
//         //                       description: _editedRoom.description,
//         //                       created: _editedRoom.created,
//         //                       email: _editedRoom.email,
//         //                       phoneNumber: _editedRoom.phoneNumber,
//         //                       location: _editedRoom.location,
//         //                       propertyType: _editedRoom.propertyType,
//         //                       totalRooms: _editedRoom.totalRooms,
//         //                       price: _editedRoom.price,
//         //                       internet: _editedRoom.internet,
//         //                       parking: _editedRoom.parking,
//         //                       balcony: _editedRoom.balcony,
//         //                       yard: _editedRoom.yard,
//         //                       disableAccess: _editedRoom.disableAccess,
//         //                       garage: _editedRoom.garage,
//         //                       status: _editedRoom.status,
//         //                       photo1: '');
//         //                 },
//         //               ),
//         //               TextFormField(
//         //                 initialValue: _innitValues['description'],
//         //                 decoration:
//         //                     const InputDecoration(labelText: 'Description'),
//         //                 keyboardType: TextInputType.multiline,
//         //                 maxLines: 3,
//         //                 focusNode: _descriptionFocusNode,
//         //                 validator: (value) {
//         //                   if (value!.isEmpty) {
//         //                     return 'Please provide a value';
//         //                   }
//         //                   if (value.length < 10) {
//         //                     return 'Too Short';
//         //                   }
//         //                   return null;
//         //                 },
//         //                 onSaved: (value) {
//         //                   _editedRoom = Room(
//         //                       id: _editedRoom.id,
//         //                       title: _editedRoom.title,
//         //                       poster: _editedRoom.poster,
//         //                       posterId: _editedRoom.posterId,
//         //                       description: value.toString(),
//         //                       created: _editedRoom.created,
//         //                       email: _editedRoom.email,
//         //                       phoneNumber: _editedRoom.phoneNumber,
//         //                       location: _editedRoom.location,
//         //                       propertyType: _editedRoom.propertyType,
//         //                       totalRooms: _editedRoom.totalRooms,
//         //                       price: _editedRoom.price,
//         //                       internet: _editedRoom.internet,
//         //                       parking: _editedRoom.parking,
//         //                       balcony: _editedRoom.balcony,
//         //                       yard: _editedRoom.yard,
//         //                       disableAccess: _editedRoom.disableAccess,
//         //                       garage: _editedRoom.garage,
//         //                       status: _editedRoom.status,
//         //                       photo1: '');
//         //                 },
//         //               ),
//         //               TextFormField(
//         //                 initialValue: _innitValues['email'],
//         //                 decoration: const InputDecoration(labelText: 'Email'),
//         //                 textInputAction: TextInputAction.next,
//         //                 onFieldSubmitted: (_) {
//         //                   FocusScope.of(context).requestFocus(_phoneNumber);
//         //                 },
//         //                 validator: (value) {
//         //                   if (value!.isEmpty) {
//         //                     return 'Please provide a value';
//         //                   }
//         //                   return null;
//         //                 },
//         //                 onSaved: (value) {
//         //                   _editedRoom = Room(
//         //                       id: _editedRoom.id,
//         //                       title: _editedRoom.title,
//         //                       poster: _editedRoom.poster,
//         //                       posterId: _editedRoom.posterId,
//         //                       description: _editedRoom.description,
//         //                       created: _editedRoom.created,
//         //                       email: value!,
//         //                       phoneNumber: _editedRoom.phoneNumber,
//         //                       location: _editedRoom.location,
//         //                       propertyType: _editedRoom.propertyType,
//         //                       totalRooms: _editedRoom.totalRooms,
//         //                       price: _editedRoom.price,
//         //                       internet: _editedRoom.internet,
//         //                       parking: _editedRoom.parking,
//         //                       balcony: _editedRoom.balcony,
//         //                       yard: _editedRoom.yard,
//         //                       disableAccess: _editedRoom.disableAccess,
//         //                       garage: _editedRoom.garage,
//         //                       status: _editedRoom.status,
//         //                       photo1: '');
//         //                 },
//         //               ),
//         //               TextFormField(
//         //                 initialValue: _innitValues['phoneNumber'],
//         //                 decoration:
//         //                     const InputDecoration(labelText: 'Phone Number'),
//         //                 textInputAction: TextInputAction.next,
//         //                 keyboardType: TextInputType.number,
//         //                 focusNode: _phoneNumber,
//         //                 onFieldSubmitted: (_) {
//         //                   FocusScope.of(context).requestFocus(_location);
//         //                 },
//         //                 validator: (value) {
//         //                   if (value!.isEmpty) {
//         //                     return 'Please provide a value';
//         //                   }
//         //                   return null;
//         //                 },
//         //                 onSaved: (value) {
//         //                   _editedRoom = Room(
//         //                       id: _editedRoom.id,
//         //                       title: _editedRoom.title,
//         //                       poster: _editedRoom.poster,
//         //                       posterId: _editedRoom.posterId,
//         //                       description: _editedRoom.description,
//         //                       created: _editedRoom.created,
//         //                       email: _editedRoom.email,
//         //                       phoneNumber: value!,
//         //                       location: _editedRoom.location,
//         //                       propertyType: _editedRoom.propertyType,
//         //                       totalRooms: _editedRoom.totalRooms,
//         //                       price: _editedRoom.price,
//         //                       internet: _editedRoom.internet,
//         //                       parking: _editedRoom.parking,
//         //                       balcony: _editedRoom.balcony,
//         //                       yard: _editedRoom.yard,
//         //                       disableAccess: _editedRoom.disableAccess,
//         //                       garage: _editedRoom.garage,
//         //                       status: _editedRoom.status,
//         //                       photo1: '');
//         //                 },
//         //               ),
//         //               TextFormField(
//         //                 decoration: const InputDecoration(labelText: 'Location'),
//         //                 initialValue: _innitValues['location'],
//         //                 textInputAction: TextInputAction.next,
//         //                 focusNode: _location,
//         //                 onFieldSubmitted: (_) {
//         //                   FocusScope.of(context).requestFocus(_propertyType);
//         //                 },
//         //                 validator: (value) {
//         //                   if (value!.isEmpty) {
//         //                     return 'Please provide a value';
//         //                   }
//         //                   return null;
//         //                 },
//         //                 onSaved: (value) {
//         //                   _editedRoom = Room(
//         //                       id: _editedRoom.id,
//         //                       title: _editedRoom.title,
//         //                       poster: _editedRoom.poster,
//         //                       posterId: _editedRoom.posterId,
//         //                       description: _editedRoom.description,
//         //                       created: _editedRoom.created,
//         //                       email: _editedRoom.email,
//         //                       phoneNumber: _editedRoom.phoneNumber,
//         //                       location: value!,
//         //                       propertyType: _editedRoom.propertyType,
//         //                       totalRooms: _editedRoom.totalRooms,
//         //                       price: _editedRoom.price,
//         //                       internet: _editedRoom.internet,
//         //                       parking: _editedRoom.parking,
//         //                       balcony: _editedRoom.balcony,
//         //                       yard: _editedRoom.yard,
//         //                       disableAccess: _editedRoom.disableAccess,
//         //                       garage: _editedRoom.garage,
//         //                       status: _editedRoom.status,
//         //                       photo1: '');
//         //                 },
//         //               ),
//         //               TextFormField(
//         //                 initialValue: _innitValues['propertyType'],
//         //                 focusNode: _propertyType,
//         //                 decoration:
//         //                     const InputDecoration(labelText: 'Property Type'),
//         //                 textInputAction: TextInputAction.next,
//         //                 onFieldSubmitted: (_) {
//         //                   FocusScope.of(context).requestFocus(_totalRooms);
//         //                 },
//         //                 validator: (value) {
//         //                   if (value!.isEmpty) {
//         //                     return 'Please provide a value';
//         //                   }
//         //                   return null;
//         //                 },
//         //                 onSaved: (value) {
//         //                   _editedRoom = Room(
//         //                       id: _editedRoom.id,
//         //                       title: _editedRoom.title,
//         //                       poster: _editedRoom.poster,
//         //                       posterId: _editedRoom.posterId,
//         //                       description: _editedRoom.description,
//         //                       created: _editedRoom.created,
//         //                       email: _editedRoom.email,
//         //                       phoneNumber: _editedRoom.phoneNumber,
//         //                       location: _editedRoom.location,
//         //                       propertyType: value!,
//         //                       totalRooms: _editedRoom.totalRooms,
//         //                       price: _editedRoom.price,
//         //                       internet: _editedRoom.internet,
//         //                       parking: _editedRoom.parking,
//         //                       balcony: _editedRoom.balcony,
//         //                       yard: _editedRoom.yard,
//         //                       disableAccess: _editedRoom.disableAccess,
//         //                       garage: _editedRoom.garage,
//         //                       status: _editedRoom.status,
//         //                       photo1: '');
//         //                 },
//         //               ),
//         //               TextFormField(
//         //                 initialValue: _innitValues['totalRooms'],
//         //                 focusNode: _totalRooms,
//         //                 decoration:
//         //                     const InputDecoration(labelText: 'Total Rooms'),
//         //                 onFieldSubmitted: (_) {
//         //                   FocusScope.of(context).requestFocus(_price);
//         //                 },
//         //                 keyboardType: TextInputType.number,
//         //                 validator: (value) {
//         //                   if (value!.isEmpty) {
//         //                     return 'Please provide the number of empty rooms';
//         //                   }
//         //                   if (double.tryParse(value) == null) {
//         //                     return 'Please enter a valid number';
//         //                   }
//         //                   if (double.parse(value) <= 0) {
//         //                     return 'Please enter a value greater than 0';
//         //                   }
//         //                   return null;
//         //                 },
//         //                 onSaved: (value) {
//         //                   _editedRoom = Room(
//         //                       id: _editedRoom.id,
//         //                       title: _editedRoom.title,
//         //                       poster: _editedRoom.poster,
//         //                       posterId: _editedRoom.posterId,
//         //                       description: _editedRoom.description,
//         //                       created: _editedRoom.created,
//         //                       email: _editedRoom.email,
//         //                       phoneNumber: _editedRoom.phoneNumber,
//         //                       location: _editedRoom.location,
//         //                       propertyType: _editedRoom.propertyType,
//         //                       totalRooms: int.parse(value!),
//         //                       price: _editedRoom.price,
//         //                       internet: _editedRoom.internet,
//         //                       parking: _editedRoom.parking,
//         //                       balcony: _editedRoom.balcony,
//         //                       yard: _editedRoom.yard,
//         //                       disableAccess: _editedRoom.disableAccess,
//         //                       garage: _editedRoom.garage,
//         //                       status: _editedRoom.status,
//         //                       photo1: '');
//         //                 },
//         //               ),
//         //               TextFormField(
//         //                 initialValue: _innitValues['price'],
//         //                 focusNode: _price,
//         //                 decoration: const InputDecoration(labelText: 'Price'),
//         //                 keyboardType: TextInputType.number,
//         //                 validator: (value) {
//         //                   if (value!.isEmpty) {
//         //                     return 'Please provide a price';
//         //                   }
//         //                   if (double.tryParse(value) == null) {
//         //                     return 'Please enter a valid number';
//         //                   }
//         //                   if (double.parse(value) <= 0) {
//         //                     return 'Please enter a value greater than 0';
//         //                   }
//         //                   return null;
//         //                 },
//         //                 onSaved: (value) {
//         //                   _editedRoom = Room(
//         //                       id: _editedRoom.id,
//         //                       title: _editedRoom.title,
//         //                       poster: _editedRoom.poster,
//         //                       posterId: _editedRoom.posterId,
//         //                       description: _editedRoom.description,
//         //                       created: _editedRoom.created,
//         //                       email: _editedRoom.email,
//         //                       phoneNumber: _editedRoom.phoneNumber,
//         //                       location: _editedRoom.location,
//         //                       propertyType: _editedRoom.propertyType,
//         //                       totalRooms: _editedRoom.totalRooms,
//         //                       price: int.parse(value!),
//         //                       internet: _editedRoom.internet,
//         //                       parking: _editedRoom.parking,
//         //                       balcony: _editedRoom.balcony,
//         //                       yard: _editedRoom.yard,
//         //                       disableAccess: _editedRoom.disableAccess,
//         //                       garage: _editedRoom.garage,
//         //                       status: _editedRoom.status,
//         //                       photo1: '');
//         //                 },
//         //               ),
//         //               CheckboxListTile(
//         //                 title: const Text('Internet'),
//         //                 value: _editedRoom.internet,
//         //                 onChanged: (value) {
//         //                   setState(() {
//         //                     _editedRoom = Room(
//         //                         id: _editedRoom.id,
//         //                         title: _editedRoom.title,
//         //                         poster: _editedRoom.poster,
//         //                         posterId: _editedRoom.posterId,
//         //                         description: _editedRoom.description,
//         //                         created: _editedRoom.created,
//         //                         email: _editedRoom.email,
//         //                         phoneNumber: _editedRoom.phoneNumber,
//         //                         location: _editedRoom.location,
//         //                         propertyType: _editedRoom.propertyType,
//         //                         totalRooms: _editedRoom.totalRooms,
//         //                         price: _editedRoom.price,
//         //                         internet: value is bool ? value : false,
//         //                         parking: _editedRoom.parking,
//         //                         balcony: _editedRoom.balcony,
//         //                         yard: _editedRoom.yard,
//         //                         disableAccess: _editedRoom.disableAccess,
//         //                         garage: _editedRoom.garage,
//         //                         status: _editedRoom.status,
//         //                         photo1: '');
//         //                   });
//         //                 },
//         //               ),
//         //               CheckboxListTile(
//         //                 title: const Text('Parking'),
//         //                 value: _editedRoom.parking,
//         //                 onChanged: (value) {
//         //                   setState(() {
//         //                     _editedRoom = Room(
//         //                         id: _editedRoom.id,
//         //                         title: _editedRoom.title,
//         //                         poster: _editedRoom.poster,
//         //                         posterId: _editedRoom.posterId,
//         //                         description: _editedRoom.description,
//         //                         created: _editedRoom.created,
//         //                         email: _editedRoom.email,
//         //                         phoneNumber: _editedRoom.phoneNumber,
//         //                         location: _editedRoom.location,
//         //                         propertyType: _editedRoom.propertyType,
//         //                         totalRooms: _editedRoom.totalRooms,
//         //                         price: _editedRoom.price,
//         //                         internet: _editedRoom.internet,
//         //                         parking: value is bool ? value : false,
//         //                         balcony: _editedRoom.balcony,
//         //                         yard: _editedRoom.yard,
//         //                         disableAccess: _editedRoom.disableAccess,
//         //                         garage: _editedRoom.garage,
//         //                         status: _editedRoom.status,
//         //                         photo1: '');
//         //                   });
//         //                 },
//         //               ),
//         //               CheckboxListTile(
//         //                 title: const Text('Balcony'),
//         //                 value: _editedRoom.balcony,
//         //                 onChanged: (value) {
//         //                   setState(() {
//         //                     _editedRoom = Room(
//         //                         id: _editedRoom.id,
//         //                         title: _editedRoom.title,
//         //                         poster: _editedRoom.poster,
//         //                         posterId: _editedRoom.posterId,
//         //                         description: _editedRoom.description,
//         //                         created: _editedRoom.created,
//         //                         email: _editedRoom.email,
//         //                         phoneNumber: _editedRoom.phoneNumber,
//         //                         location: _editedRoom.location,
//         //                         propertyType: _editedRoom.propertyType,
//         //                         totalRooms: _editedRoom.totalRooms,
//         //                         price: _editedRoom.price,
//         //                         internet: _editedRoom.internet,
//         //                         parking: _editedRoom.parking,
//         //                         balcony: value is bool ? value : false,
//         //                         yard: _editedRoom.yard,
//         //                         disableAccess: _editedRoom.disableAccess,
//         //                         garage: _editedRoom.garage,
//         //                         status: _editedRoom.status,
//         //                         photo1: '');
//         //                   });
//         //                 },
//         //               ),
//         //               CheckboxListTile(
//         //                 title: const Text('Disable Access'),
//         //                 value: _editedRoom.disableAccess,
//         //                 onChanged: (value) {
//         //                   setState(() {
//         //                     _editedRoom = Room(
//         //                       id: _editedRoom.id,
//         //                       title: _editedRoom.title,
//         //                       poster: _editedRoom.poster,
//         //                       posterId: _editedRoom.posterId,
//         //                       description: _editedRoom.description,
//         //                       created: _editedRoom.created,
//         //                       email: _editedRoom.email,
//         //                       phoneNumber: _editedRoom.phoneNumber,
//         //                       location: _editedRoom.location,
//         //                       propertyType: _editedRoom.propertyType,
//         //                       totalRooms: _editedRoom.totalRooms,
//         //                       price: _editedRoom.price,
//         //                       internet: _editedRoom.internet,
//         //                       parking: _editedRoom.parking,
//         //                       balcony: _editedRoom.balcony,
//         //                       yard: _editedRoom.yard,
//         //                       disableAccess: value is bool ? value : false,
//         //                       garage: _editedRoom.garage,
//         //                       status: _editedRoom.status,
//         //                       photo1: '',
//         //                     );
//         //                   });
//         //                 },
//         //               ),
//         //               CheckboxListTile(
//         //                 title: const Text('Garage'),
//         //                 value: _editedRoom.garage,
//         //                 onChanged: (value) {
//         //                   setState(() {
//         //                     _editedRoom = Room(
//         //                       id: _editedRoom.id,
//         //                       title: _editedRoom.title,
//         //                       poster: _editedRoom.poster,
//         //                       posterId: _editedRoom.posterId,
//         //                       description: _editedRoom.description,
//         //                       created: _editedRoom.created,
//         //                       email: _editedRoom.email,
//         //                       phoneNumber: _editedRoom.phoneNumber,
//         //                       location: _editedRoom.location,
//         //                       propertyType: _editedRoom.propertyType,
//         //                       totalRooms: _editedRoom.totalRooms,
//         //                       price: _editedRoom.price,
//         //                       internet: _editedRoom.internet,
//         //                       parking: _editedRoom.parking,
//         //                       balcony: _editedRoom.balcony,
//         //                       yard: _editedRoom.yard,
//         //                       disableAccess: _editedRoom.disableAccess,
//         //                       garage: value is bool ? value : false,
//         //                       status: _editedRoom.status,
//         //                       photo1: '',
//         //                     );
//         //                   });
//         //                 },
//         //               ),
//         //               CheckboxListTile(
//         //                 title: const Text('Status'),
//         //                 value: _editedRoom.status,
//         //                 onChanged: (value) {
//         //                   setState(() {
//         //                     _editedRoom = Room(
//         //                       id: _editedRoom.id,
//         //                       title: _editedRoom.title,
//         //                       poster: _editedRoom.poster,
//         //                       posterId: _editedRoom.posterId,
//         //                       description: _editedRoom.description,
//         //                       created: _editedRoom.created,
//         //                       email: _editedRoom.email,
//         //                       phoneNumber: _editedRoom.phoneNumber,
//         //                       location: _editedRoom.location,
//         //                       propertyType: _editedRoom.propertyType,
//         //                       totalRooms: _editedRoom.totalRooms,
//         //                       price: _editedRoom.price,
//         //                       internet: _editedRoom.internet,
//         //                       parking: _editedRoom.parking,
//         //                       balcony: _editedRoom.balcony,
//         //                       yard: _editedRoom.yard,
//         //                       disableAccess: _editedRoom.disableAccess,
//         //                       garage: _editedRoom.garage,
//         //                       status: value is bool ? value : false,
//         //                       photo1: '',
//         //                     );
//         //                   });
//         //                 },
//         //               ),
//         //             ],
//         //           ),
//         //         ),
//         //       ),
//         );
//   }
// }
