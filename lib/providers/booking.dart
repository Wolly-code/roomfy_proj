import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Booking with ChangeNotifier {
  String id;
  String user;
  String room;
  String checkIn;
  String checkOut;

  Booking(
      {required this.id,
      required this.user,
      required this.room,
      required this.checkIn,
      required this.checkOut});
}

class Bookings with ChangeNotifier {
  List<Booking> _bookings = [];
  final String authToken;
  final String userId;

  Bookings(this.authToken, this.userId, this._bookings);

  List<Booking> get getBooking {
    return [..._bookings];
  }

  Future<void> fetchBookingData() async {
    Uri url = Uri.parse('http://10.0.2.2:8000/rooms/booking');
    final response =
        await http.get(url, headers: {'Authorization': 'Token $authToken'});
    final List<Booking> loadedBooking = [];
    try {
      final extractedData = json.decode(response.body);
      for (var i = 0; i < extractedData.length; i++) {
        var currentElement = extractedData[i];
        loadedBooking.add(Booking(
            id: currentElement['id'].toString(),
            user: currentElement['user'].toString(),
            room: currentElement['room'].toString(),
            checkIn: currentElement['check_in'],
            checkOut: currentElement['check_out']));
        _bookings = loadedBooking.reversed.toList();
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }
}
