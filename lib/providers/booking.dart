import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Booking with ChangeNotifier {
  String id;
  String user;
  String room;
  String checkIn;
  String checkOut;
  String roomOwner;

  Booking(
      {required this.id,
      required this.user,
      required this.room,
      required this.checkIn,
      required this.checkOut,
      required this.roomOwner});
}

class Payment with ChangeNotifier {
  String id;
  String roomOwner;
  String userID;
  String paymentID;
  String amount;
  String paymentDate;
  String roomID;

  Payment(
      {required this.id,
      required this.roomOwner,
      required this.userID,
      required this.paymentDate,
      required this.amount,
      required this.paymentID,
      required this.roomID});
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
            checkOut: currentElement['check_out'],
            roomOwner: currentElement['room_owner']));
        _bookings = loadedBooking.reversed.toList();
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<String> postRoomBooking(
      String checkIn, String checkOut, String roomId) async {
    Uri url = Uri.parse('http://10.0.2.2:8000/rooms/booking');
    try {
      var response = await http.post(url,
          headers: {
            'Authorization': 'Token $authToken',
            'Content-Type': 'application/json'
          },
          body: json.encode({
            "room": roomId,
            "check_in": checkIn,
            "check_out": checkOut,
          }));
      // String message = json.decode();
      if (response.statusCode >= 400) {
        return response.body;
      }
      return 'Booking was successfull';
      print(response.body);
      print(response.statusCode);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndSetPayments() async {
    Uri url = Uri.parse('http://10.0.2.2:8000/rooms/payment/');
    try {
      var response =
          await http.get(url, headers: {"Authorization": 'Token $authToken'});
      print(response.body);
    } catch (e) {}
  }

  Future<void> postPaymentDetails(String? paymentID, double? amount,
      String user, String room, String remark) async {
    Uri url = Uri.parse('http://10.0.2.2:8000/rooms/payment/');
    try {
      var response = await http.post(url,
          headers: {
            'Authorization': 'Token $authToken',
            'Content-Type': 'application/json'
          },
          body: json.encode({
            "Payment_ID": paymentID,
            "Amount": amount,
            "user": user,
            "room": room,
            "remarks": remark,
          }));
    } catch (e) {}
  }
}
