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
  String gender;
  final String profile;
  final String location;

  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.userId,
      required this.bio,
      required this.email,
      required this.gender,
      required this.profile,
      required this.location});
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

  User findByID(String id) {
    return _user.firstWhere((element) => element.userId == id);
  }

  Future<void> fetchAndSetUser() async {
    Uri url = Uri.parse('http://10.0.2.2:8000/api/profile');
    try {
      final response =
          await http.get(url, headers: {'Authorization': 'Token $authToken'});
      final extractedData = json.decode(response.body);
      for (var i = 0; i < extractedData.length; i++) {
        var currentElement = extractedData[i];
        userObj = User(
            id: currentElement['id'].toString(),
            firstName: currentElement['first_name'],
            lastName: currentElement['last_name'],
            phoneNumber: currentElement['phone_number'],
            userId: currentElement['user'],
            bio: currentElement['bio'],
            email: currentElement['email'],
            profile: currentElement['profile_pic'],
            gender: currentElement['gender'],
            location: currentElement['location']);
      }
      notifyListeners();
    } catch (error) {
      print('Error Caught at while fetching user');
      rethrow;
    }
  }

  Future<void> getAllUserData() async {
    Uri url = Uri.parse('http://10.0.2.2:8000/api/profile/all');
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
          profile: currentElement['profile_pic'],
          gender: currentElement['gender'],
          location: currentElement['location'],
        ));
      }
      _user = loadedUser.reversed.toList();
      notifyListeners();
    } catch (error) {
      print('Error Caught at while getting all user data');
      rethrow;
    }
  }

  Future<void> addUser(User user, File photo, String gender) async {
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
      request.fields["location"] = user.location;
      request.fields["gender"] = gender;
      var multipartFile = http.MultipartFile('profile_pic', stream, length,
          filename: basename(photo.path));
      request.files.add(multipartFile);
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateUserWithPhoto(
      User user, File photo, String id, String gender) async {
    Uri url = Uri.parse('http://10.0.2.2:8000/api/profile/$id');
    try {
      var stream = http.ByteStream(DelegatingStream.typed(photo.openRead()));
      var length = await photo.length();
      var request = http.MultipartRequest("PUT", url);
      request.headers["authorization"] = 'Token $authToken';
      request.fields["first_name"] = user.firstName;
      request.fields["last_name"] = user.lastName;
      request.fields["phone_number"] = user.phoneNumber;
      request.fields["bio"] = user.bio;
      request.fields["email"] = user.email;
      request.fields["location"] = user.location;
      request.fields["gender"] = gender;
      var multipartFile = http.MultipartFile('profile_pic', stream, length,
          filename: basename(photo.path));
      request.files.add(multipartFile);
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      print(response.statusCode);
      print(respStr);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateUserWithoutPhoto(
      User user, String id, String gender) async {
    Uri url = Uri.parse('http://10.0.2.2:8000/api/profile/$id');
    try {
      var response = await http.patch(url,
          headers: {
            'Authorization': 'Token $authToken',
            'Content-Type': 'application/json'
          },
          body: json.encode({
            'first_name': user.firstName,
            'last_name': user.lastName,
            'phone_number': user.phoneNumber,
            'bio': user.bio,
            'email': user.email,
            'gender': gender,
            'location': user.location,
          }));
      print(response.statusCode);
      print(response.body);
    } catch (e) {}
  }
}
