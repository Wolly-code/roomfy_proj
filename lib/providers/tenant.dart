import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:roomfy_proj/exceptions/http_exception.dart';

class Tenant with ChangeNotifier {
  final String id;
  final String fullName;
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

  Tenant({
    required this.id,
    required this.fullName,
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
  });
}

class Tenants with ChangeNotifier {
  List<Tenant> _tenants = [];
  List<Tenant> _owned = [];
  final String authToken;
  final String userId;

  Tenants(this.authToken, this.userId, this._tenants);

  List<Tenant> get owned {
    return [..._owned];
  }

  List<Tenant> get tenants {
    return [..._tenants];
  }

  Tenant findByID(String id) {
    return _tenants.firstWhere((tenant) => tenant.id == id);
  }

  Future<void> fetchAndSetTenant() async {
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
        ));
        _owned =
            loadedTenant.where((element) => element.poster == userId).toList();
        _tenants = loadedTenant.reversed.toList();
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteRoom(String id) async {
    Uri url = Uri.parse('http://10.0.2.2:8000/tenant/$id');
    final existingTenantIndex =
        _tenants.indexWhere((element) => element.id == id);
    Tenant? existingTenant = _tenants[existingTenantIndex];
    _tenants.insert(existingTenantIndex, existingTenant);
    notifyListeners();
    _tenants.removeAt(existingTenantIndex);
    final response =
        await http.delete(url, headers: {'Authorization': 'Token $authToken'});
    if (response.statusCode >= 400) {
      throw HttpException('Could not delete tenant');
    }
    existingTenant = null;
  }

  Future<void> updateTenant(String id, Tenant tenant) async {
    final tenantIndex = _tenants.indexWhere((element) => element.id == id);
    if (tenantIndex >= 0) {
      Uri url = Uri.parse('http://10.0.2.2:8000/tenant/$id');
      http.patch(url,
          body: json.encode({
            'full_name': tenant.title,
            'gender': tenant.gender,
            'phone_number': tenant.phoneNumber,
            'occupation': tenant.occupation,
            'age': tenant.age,
            'pet_owner': tenant.petOwner,
            'location': tenant.location,
            'Budget': tenant.budget,
            'Preference': tenant.preference,
            'Title': tenant.title,
            'description': tenant.description,
            'status': tenant.status,
          }),
          headers: {
            'Authorization': 'Token $authToken',
            'Content-Type': 'application/json'
          });
      _tenants[tenantIndex] = tenant;
      notifyListeners();
    } else {}
  }

  Future<void> addTenantAd(Tenant tenant, File photo1) async {
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
      request.fields['gender'] = tenant.gender;
      request.fields['occupation'] = tenant.occupation;
      request.fields['age'] = tenant.age.toString();
      request.fields['pet_owner'] = tenant.petOwner.toString();
      request.fields['Budget'] = tenant.budget.toString();
      request.fields['Preference'] = tenant.preference.toString();
      request.fields['status'] = tenant.status.toString();
      var multipartFile1 = http.MultipartFile('photo1', stream, length,
          filename: basename(photo1.path));
      request.files.add(multipartFile1);
      var response = await request.send();
      print(response);
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> addTenant(Tenant tenant) async {
    Uri url = Uri.parse('http://10.0.2.2:8000/tenant/viewall');
    try {
      final response = await http.post(url,
          headers: {
            'Authorization': 'Token $authToken',
            'Content-Type': 'application/json'
          },
          body: json.encode({
            'full_name': tenant.title,
            'gender': tenant.gender,
            'phone_number': tenant.phoneNumber,
            'occupation': tenant.occupation,
            'age': tenant.age,
            'pet_owner': tenant.petOwner,
            'location': tenant.location,
            'Budget': tenant.budget,
            'Preference': tenant.preference,
            'Title': tenant.title,
            'description': tenant.description,
            'status': tenant.status,
          }));
      final res = json.decode(response.body);
      final newTenant = Tenant(
          id: res['id'].toString(),
          fullName: tenant.fullName,
          poster: res['poster'],
          gender: tenant.gender,
          phoneNumber: tenant.phoneNumber,
          occupation: tenant.occupation,
          age: tenant.age,
          petOwner: tenant.petOwner,
          location: tenant.location,
          budget: tenant.budget,
          preference: tenant.preference,
          title: tenant.title,
          description: tenant.description,
          created: res['created'],
          status: tenant.status,
          photo1: res['photo1']);
      _tenants.add(newTenant);
    } catch (error) {
      rethrow;
    }
  }
}
