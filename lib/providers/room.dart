import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:roomfy_proj/exceptions/http_exception.dart';

class Room with ChangeNotifier {
  final String id;
  final String title;
  final String poster;
  final String posterId;
  final String description;
  final String created;
  final String email;
  final String phoneNumber;
  final String location;
  final String propertyType;
  final int totalRooms;
  final int price;
  final int securityDeposit;
  final bool internet;
  final bool parking;
  final bool balcony;
  final bool yard;
  final bool disableAccess;
  final bool garage;
  final bool status;
  final String photo1;
  final String photo2;

  Room({
    required this.id,
    required this.title,
    required this.poster,
    required this.posterId,
    required this.description,
    required this.created,
    required this.email,
    required this.phoneNumber,
    required this.location,
    required this.propertyType,
    required this.totalRooms,
    required this.price,
    required this.securityDeposit,
    required this.internet,
    required this.parking,
    required this.balcony,
    required this.yard,
    required this.disableAccess,
    required this.garage,
    required this.status,
    required this.photo1,
    required this.photo2,
  });
}

class Rooms with ChangeNotifier {
  List<Room> _rooms = [];
  List<Room> _ownedRoom = [];
  final String authToken;
  final String userId;
  List<Room> _displayRooms = [];

  Rooms(this.authToken, this.userId, this._rooms);

  List<Room> get ownedRoom {
    return [..._ownedRoom];
  }

  List<Room> get rooms {
    return [..._rooms];
  }

  List<Room> get displayRooms {
    return [..._displayRooms];
  }

  Future<void> fetchAndSetRoom() async {
    Uri url = Uri.parse('http://10.0.2.2:8000/rooms/viewall');
    final response =
        await http.get(url, headers: {'Authorization': 'Token $authToken'});
    final List<Room> loadedRoom = [];
    try {
      // print(json.decode(response.body));
      final extractedData = json.decode(response.body);
      for (var i = 0; i < extractedData.length; i++) {
        var currentElement = extractedData[i];
        loadedRoom.add(Room(
          id: currentElement['id'].toString(),
          title: currentElement['title'],
          poster: currentElement['poster'],
          posterId: currentElement['poster_id'].toString(),
          description: currentElement['description'],
          created: currentElement['created'],
          email: currentElement['email'],
          phoneNumber: currentElement['phone_number'],
          totalRooms: currentElement['total_rooms'],
          price: currentElement['price'],
          internet: currentElement['internet'],
          parking: currentElement['parking'],
          balcony: currentElement['Balcony'],
          yard: currentElement['Yard'],
          disableAccess: currentElement['Disabled_Access'],
          garage: currentElement['Garage'],
          status: currentElement['status'],
          location: currentElement['location'],
          propertyType: currentElement['property_type'],
          photo1: currentElement['photo1'],
          photo2: currentElement['photo2'],
          securityDeposit: currentElement['security_deposit'],
        ));
      }
      _displayRooms =
          loadedRoom.where((element) => element.status == true).toList();
      _ownedRoom =
          loadedRoom.where((element) => element.poster == userId).toList();
      _rooms = loadedRoom.reversed.toList();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addRoom(Room room, File photo1, File photo2) async {
    Uri url = Uri.parse('http://10.0.2.2:8000/rooms/viewall');
    try {
      var stream1 = http.ByteStream(DelegatingStream.typed(photo1.openRead()));
      var stream2 = http.ByteStream(DelegatingStream.typed(photo2.openRead()));
      var length1 = await photo1.length();
      var length2 = await photo2.length();
      var request = http.MultipartRequest("POST", url);
      request.headers["authorization"] = 'Token $authToken';
      request.fields["title"] = room.title;
      request.fields["description"] = room.description;
      request.fields["email"] = room.description;
      request.fields["phone_number"] = room.phoneNumber;
      request.fields["location"] = room.location;
      request.fields["email"] = room.email;
      request.fields["property_type"] = room.propertyType;
      request.fields["total_rooms"] = room.totalRooms.toString();
      request.fields["price"] = room.price.toString();
      request.fields["internet"] = room.internet.toString();
      request.fields["parking"] = room.parking.toString();
      request.fields["Balcony"] = room.balcony.toString();
      request.fields["Yard"] = room.yard.toString();
      request.fields["Disabled_Access"] = room.disableAccess.toString();
      request.fields["Garage"] = room.garage.toString();
      request.fields["status"] = room.status.toString();
      request.fields["security_deposit"] = room.securityDeposit.toString();
      var multipartFile1 = http.MultipartFile('photo1', stream1, length1,
          filename: basename(photo1.path));
      var multipartFile2 = http.MultipartFile('photo2', stream2, length2,
          filename: basename(photo2.path));
      request.files.add(multipartFile1);
      request.files.add(multipartFile2);
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
    } catch (err) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> updateRoomPhoto(File photo1, File photo2, String id) async {
    Uri url = Uri.parse('http://10.0.2.2:8000/api/hospital/$id');
    try {
      var stream1 = http.ByteStream(DelegatingStream.typed(photo1.openRead()));
      var stream2 = http.ByteStream(DelegatingStream.typed(photo2.openRead()));
      var length1 = await photo1.length();
      var length2 = await photo2.length();
      var request = http.MultipartRequest("PUT", url);
      request.headers["authorization"] = 'Token $authToken';
      var multipartFile1 = http.MultipartFile('photo1', stream1, length1,
          filename: basename(photo1.path));
      var multipartFile2 = http.MultipartFile('photo2', stream2, length2,
          filename: basename(photo2.path));
      request.files.add(multipartFile1);
      request.files.add(multipartFile2);
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      print(respStr);
      print(response.statusCode);
    } catch (err) {
      rethrow;
    }
  }

  Future<void> deleteRoom(String id) async {
    Uri url = Uri.parse('http://10.0.2.2:8000/rooms/$id');
    final existingRoomIndex = _rooms.indexWhere((room) => room.id == id);
    Room? existingRoom = _rooms[existingRoomIndex];
    _rooms.insert(existingRoomIndex, existingRoom);
    notifyListeners();
    _rooms.removeAt(existingRoomIndex);
    final response =
        await http.delete(url, headers: {'Authorization': 'Token $authToken'});
    if (response.statusCode >= 400) {
      throw HttpException('Could not delete room');
    }
    existingRoom = null;
  }

  Future<void> updateRoomDetail(String id, Room room) async {
    print(room.id);
    print(id);
    final roomIndex = _rooms.indexWhere((room) => room.id == id);
    if (roomIndex >= 0) {
      Uri url = Uri.parse('http://10.0.2.2:8000/rooms/$id');
      try {
        var response = await http.patch(url,
            body: json.encode({
              'title': room.title,
              'description': room.description,
              'email': room.email,
              'phone_number': room.phoneNumber,
              'location': room.location,
              'property_type': room.propertyType,
              'total_rooms': room.totalRooms,
              'price': room.price,
              'internet': room.internet,
              'parking': room.parking,
              'Balcony': room.balcony,
              'security_deposit': room.securityDeposit,
              'Yard': room.yard,
              'Disabled_Access': room.disableAccess,
              'Garage': room.garage,
              'status': room.status,
            }),
            headers: {
              'Authorization': 'Token $authToken',
              'Content-Type': 'application/json'
            });
        print(response.body);
        print(response.statusCode);
        _rooms[roomIndex] = room;
      } catch (err) {
        rethrow;
      }
      notifyListeners();
    } else {}
  }

  Room findByID(String id) {
    return _rooms.firstWhere((room) => room.id == id);
  }

  Room findByUser(String poster) {
    return _rooms.firstWhere((room) => room.poster == poster);
  }

  Future<void> updateStatus(String id, bool status) async {
    Uri url = Uri.parse('http://10.0.2.2:8000/rooms/$id');
    bool newStatus = !status;
    try {
      final response = await http.patch(url,
          headers: {
            'Authorization': 'Token $authToken',
            'Content-Type': 'application/json'
          },
          body: json.encode({
            "status": newStatus,
          }));
    } catch (exp) {
      rethrow;
    }
    notifyListeners();
  }
}
