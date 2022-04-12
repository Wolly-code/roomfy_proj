import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class User with ChangeNotifier {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String userId;
  final String bio;
  final String email;
  final String profile;

  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.userId,
      required this.bio,
      required this.email,
      required this.profile});
}

class Users with ChangeNotifier {
  final String authToken;
  final String userId;
  List<User> _user = [];
  User? userObj;

  Users(
    this.authToken,
    this.userId,
    this._user,
  );

  List<User> get users {
    return [..._user];
  }

  Future<void> fetchAndSetUser() async {
    Uri url = Uri.parse('http://10.0.2.2:8000/api/profile');
    final List<User> loadedUser = [];

    try {
      final response =
          await http.get(url, headers: {'Authorization': 'Token $authToken'});
      final extractedData = json.decode(response.body);
      for (var i = 0; i < extractedData.length; i++) {
        var currentElement = extractedData[i];
        loadedUser.add(User(
            id: currentElement['id'].toString(),
            firstName: currentElement['first_name'],
            lastName: currentElement['last_name'],
            phoneNumber: currentElement['phone_number'],
            userId: currentElement['user'],
            bio: currentElement['bio'],
            email: currentElement['email'],
            profile: currentElement['profile_pic']));
        userObj = User(
            id: currentElement['id'].toString(),
            firstName: currentElement['first_name'],
            lastName: currentElement['last_name'],
            phoneNumber: currentElement['phone_number'],
            userId: currentElement['user'],
            bio: currentElement['bio'],
            email: currentElement['email'],
            profile: currentElement['profile_pic']);
      }
      _user = loadedUser.reversed.toList();
      notifyListeners();
    } catch (error) {
      print('Error Caught at while fetching user');
      rethrow;
    }
  }

  Future<void> addUser(User user, File photo) async {
    Uri url = Uri.parse('http://10.0.2.2:8000/api/profile');
    try {
      var stream = http.ByteStream(DelegatingStream.typed(photo.openRead()));
      var length = await photo.length();
      var request = http.MultipartRequest("POST", url);
      request.headers["authorization"] = 'Token $authToken';
      request.fields["first_name"] = user.firstName;
      request.fields["last_name"] = user.lastName;
      request.fields["phone_number"] = user.phoneNumber;
      request.fields["bio"] = user.bio;
      request.fields["email"] = user.email;
      var multipartFile = http.MultipartFile('profile_pic', stream, length,
          filename: basename(photo.path));
      request.files.add(multipartFile);
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
    } catch (error) {
      rethrow;
    }
  }
}
