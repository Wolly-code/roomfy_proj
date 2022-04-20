import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:roomfy_proj/exceptions/http_exception.dart';
import 'package:roomfy_proj/providers/room.dart';

class Tenant with ChangeNotifier {
  final String id;
  final String fullName;
  final String email;
  final String poster;
  final String gender;
  final String phoneNumber;
  final String occupation;
  final int age;
  final bool petOwner;
  final String location;
  final int budget;
  final String preference;
  final String title;
  final String description;
  final String created;
  final bool status;
  final String photo1;
  bool isFavorite;

  Tenant(
      {required this.id,
      required this.fullName,
      required this.email,
      required this.poster,
      required this.gender,
      required this.phoneNumber,
      required this.occupation,
      required this.age,
      required this.petOwner,
      required this.location,
      required this.budget,
      required this.preference,
      required this.title,
      required this.description,
      required this.created,
      required this.status,
      required this.photo1,
      this.isFavorite = false});

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String id) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    Uri url = Uri.parse('http://10.0.2.2:8000/tenant/fav/');
    try {
      final response = await http.post(url,
          body: json.encode({'id': id}),
          headers: {
            'Authorization': 'Token $token',
            'Content-Type': 'application/json'
          });
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}

class tenantFavourite {
  int? id;
  bool? favourite;
  int? tenant;
  String? user;

  tenantFavourite({this.id, this.favourite, this.tenant, this.user});

  tenantFavourite.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    favourite = json['favourite'];
    tenant = json['tenant'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['favourite'] = this.favourite;
    data['tenant'] = this.tenant;
    data['user'] = this.user;
    return data;
  }
}

class Tenants with ChangeNotifier {
  List<Tenant> _tenants = [];
  List<Tenant> _owned = [];
  final String authToken;
  final String userId;
  List<Tenant> _displayTenants = [];
  List<tenantFavourite> _loadedFavorites = [];

  Tenants(this.authToken, this.userId, this._tenants);

  List<Tenant> get owned {
    return [..._owned];
  }

  List<Tenant> get displayTenants {
    return [..._displayTenants];
  }

  List<Tenant> get tenants {
    return [..._tenants];
  }

  Tenant findByID(String id) {
    return _tenants.firstWhere((tenant) => tenant.id == id);
  }

  Future<void> fetchAndSetFavourite() async {
    Uri url = Uri.parse('http://10.0.2.2:8000/tenant/getFav/');
    var data = [];
    List<tenantFavourite> results = [];
    try {
      final response =
          await http.get(url, headers: {'Authorization': 'Token $authToken'});
      final List<Favourite> loadedFavorites = [];
      if (response.statusCode == 200) {
        data = json.decode(response.body);
        results = data.map((e) => tenantFavourite.fromJson(e)).toList();
        _loadedFavorites = results;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndSetTenant() async {
    fetchAndSetFavourite();
    Uri url = Uri.parse('http://10.0.2.2:8000/tenant/viewall');
    final response =
        await http.get(url, headers: {'Authorization': 'Token $authToken'});
    final List<Tenant> loadedTenant = [];
    try {
      final extractedData = json.decode(response.body);
      for (var i = 0; i < extractedData.length; i++) {
        var currentElement = extractedData[i];
        loadedTenant.add(Tenant(
          id: currentElement['id'].toString(),
          fullName: currentElement['full_name'],
          poster: currentElement['poster'],
          gender: currentElement['gender'],
          phoneNumber: currentElement['phone_number'],
          occupation: currentElement['occupation'],
          age: currentElement['age'],
          petOwner: currentElement['pet_owner'],
          location: currentElement['location'],
          budget: currentElement['Budget'],
          preference: currentElement['Preference'],
          title: currentElement['Title'],
          description: currentElement['description'],
          created: currentElement['created'],
          status: currentElement['status'],
          photo1: currentElement['photo1'],
          email: currentElement['email'],
          isFavorite: favouriteItem(currentElement['id']) == null
              ? false
              : favouriteItem(currentElement['id']) ?? false,
        ));
      }
      _displayTenants =
          loadedTenant.where((element) => element.status == true).toList();
      _owned =
          loadedTenant.where((element) => element.poster == userId).toList();
      _tenants = loadedTenant.reversed.toList();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Tenant>> fetchQuery({String? query}) async {
    fetchAndSetFavourite();
    Uri url = Uri.parse('http://10.0.2.2:8000/tenant/viewall');
    final response =
        await http.get(url, headers: {'Authorization': 'Token $authToken'});
    final List<Tenant> loadedTenant = [];
    try {
      final extractedData = json.decode(response.body);
      for (var i = 0; i < extractedData.length; i++) {
        var currentElement = extractedData[i];
        loadedTenant.add(Tenant(
          id: currentElement['id'].toString(),
          fullName: currentElement['full_name'],
          poster: currentElement['poster'],
          gender: currentElement['gender'],
          phoneNumber: currentElement['phone_number'],
          occupation: currentElement['occupation'],
          age: currentElement['age'],
          petOwner: currentElement['pet_owner'],
          location: currentElement['location'],
          budget: currentElement['Budget'],
          preference: currentElement['Preference'],
          title: currentElement['Title'],
          description: currentElement['description'],
          created: currentElement['created'],
          status: currentElement['status'],
          photo1: currentElement['photo1'],
          email: currentElement['email'],
          isFavorite: favouriteItem(currentElement['id']) == null
              ? false
              : favouriteItem(currentElement['id']) ?? false,
        ));
      }
      if (query != null) {
        _displayTenants = loadedTenant
            .where((element) =>
                element.title.toLowerCase().contains((query.toLowerCase())) ||
                element.fullName.toLowerCase().contains((query.toLowerCase())))
            .toList();
      }
      return _displayTenants;
    } catch (error) {
      rethrow;
    }
  }

  bool? favouriteItem(int id) {
    return _loadedFavorites
        .firstWhere((element) => element.tenant == id,
            orElse: () => tenantFavourite(favourite: false))
        .favourite;
  }

  Future<void> deleteTenant(String id) async {
    Uri url = Uri.parse('http://10.0.2.2:8000/tenant/$id');
    final response =
        await http.delete(url, headers: {'Authorization': 'Token $authToken'});
    if (response.statusCode >= 400) {
      throw HttpException('Could not delete tenant');
    }
    await fetchAndSetTenant();
    notifyListeners();
  }

  Future<void> updateStatus(String id, bool status) async {
    Uri url = Uri.parse('http://10.0.2.2:8000/tenant/$id');
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
    await fetchAndSetTenant();
    notifyListeners();
  }

  Future<void> addTenantAd(
      Tenant tenant, File photo1, String gender, String occupation) async {
    Uri url = Uri.parse('http://10.0.2.2:8000/tenant/viewall');
    try {
      var stream = http.ByteStream(DelegatingStream.typed(photo1.openRead()));
      var length = await photo1.length();
      var request = http.MultipartRequest("POST", url);
      request.headers["authorization"] = 'Token $authToken';
      request.fields['Title'] = tenant.title;
      request.fields['description'] = tenant.description;
      request.fields['phone_number'] = tenant.phoneNumber;
      request.fields['location'] = tenant.location;
      request.fields['full_name'] = tenant.fullName;
      request.fields['gender'] = gender;
      request.fields['occupation'] = occupation;
      request.fields['age'] = tenant.age.toString();
      request.fields['pet_owner'] = tenant.petOwner.toString();
      request.fields['Budget'] = tenant.budget.toString();
      request.fields['email'] = tenant.email;
      request.fields['Preference'] = tenant.preference.toString();
      request.fields['status'] = tenant.status.toString();
      var multipartFile1 = http.MultipartFile('photo1', stream, length,
          filename: basename(photo1.path));
      request.files.add(multipartFile1);
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> updateTenantwithPhoto(Tenant tenant, File photo, String id,
      String gender, String occupation) async {
    Uri url = Uri.parse('http://10.0.2.2:8000/tenant/$id');
    try {
      var stream = http.ByteStream(DelegatingStream.typed(photo.openRead()));
      var length = await photo.length();
      var request = http.MultipartRequest("PUT", url);
      request.headers["authorization"] = 'Token $authToken';
      request.fields['Title'] = tenant.title;
      request.fields['description'] = tenant.description;
      request.fields['phone_number'] = tenant.phoneNumber;
      request.fields['location'] = tenant.location;
      request.fields['full_name'] = tenant.fullName;
      request.fields['gender'] = gender;
      request.fields['occupation'] = occupation;
      request.fields['age'] = tenant.age.toString();
      request.fields['pet_owner'] = tenant.petOwner.toString();
      request.fields['Budget'] = tenant.budget.toString();
      request.fields['email'] = tenant.email;
      request.fields['Preference'] = tenant.preference.toString();
      request.fields['status'] = tenant.status.toString();
      var multipartFile1 = http.MultipartFile('photo1', stream, length,
          filename: basename(photo.path));
      request.files.add(multipartFile1);
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
    } catch (error) {
      rethrow;
    }
    await fetchAndSetTenant();
    notifyListeners();
  }

  Future<void> updateTenantWithoutPhoto(
      Tenant tenant, String id, String gender, String occupation) async {
    Uri url = Uri.parse('http://10.0.2.2:8000/tenant/$id');
    try {
      var response = await http.patch(url,
          headers: {
            'Authorization': 'Token $authToken',
            'Content-Type': 'application/json'
          },
          body: json.encode({
            'Title': tenant.title,
            'description': tenant.description,
            'phone_number': tenant.phoneNumber,
            'location': tenant.location,
            'full_name': tenant.fullName,
            'gender': gender,
            'occupation': occupation,
            'age': tenant.age,
            'pet_owner': tenant.petOwner,
            'Budget': tenant.budget,
            'email': tenant.email,
            'Preference': tenant.preference,
          }));
    } catch (e) {
      rethrow;
    }
    await fetchAndSetTenant();
    notifyListeners();
  }

  Future<String> createAppointment(String id, String date) async {
    Uri url = Uri.parse('http://10.0.2.2:8000/tenant/booking');
    try {
      var response = await http.post(url,
          headers: {
            'Authorization': 'Token $authToken',
            'Content-Type': 'application/json'
          },
          body: json.encode({
            "appointment_date": date,
            "Tenant": id,
          }));
      print(response.body);
      if (response.statusCode == 201) {
        return 'Appointment Created Successfully';
      } else if (response.statusCode == 400) {
        return 'You have already created a appointment with this user';
      } else {
        return 'Unable to create Appointment';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> reportTenant(String description, String id) async {
    Uri url = Uri.parse('http://10.0.2.2:8000/tenant/$id/report');
    try {
      var response = await http.post(
        url,
        headers: {
          'Authorization': 'Token $authToken',
          'Content-Type': 'application/json'
        },
        body: json.encode(
          {'description': description},
        ),
      );
      print(response.statusCode);
      print(response.body);
    } catch (e) {
      rethrow;
    }
  }

  List<Tenant> get favoriteItems {
    return _displayTenants.where((element) => element.isFavorite).toList();
  }
}
