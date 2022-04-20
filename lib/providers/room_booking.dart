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
  int duration;

  Booking(
      {required this.id,
      required this.user,
      required this.room,
      required this.checkIn,
      required this.checkOut,
      required this.duration,
      required this.roomOwner});
}

// class Payment with ChangeNotifier {
//   String id;
//   String roomOwner;
//   String userID;
//   String paymentID;
//   String amount;
//   String paymentDate;
//   String roomID;
//
//   Payment(
//       {required this.id,
//       required this.roomOwner,
//       required this.userID,
//       required this.paymentDate,
//       required this.amount,
//       required this.paymentID,
//       required this.roomID});
// }
class Payment {
  int? id;
  String? roomOwner;
  String? user;
  String? paymentID;
  int? amount;
  String? paymentDate;
  String? remarks;
  int? room;

  Payment(
      {this.id,
      this.roomOwner,
      this.user,
      this.paymentID,
      this.amount,
      this.paymentDate,
      this.remarks,
      this.room});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomOwner = json['room_owner'];
    user = json['user'];
    paymentID = json['Payment_ID'];
    amount = json['Amount'];
    paymentDate = json['Payment_date'];
    remarks = json['remarks'];
    room = json['room'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['room_owner'] = roomOwner;
    data['user'] = user;
    data['Payment_ID'] = paymentID;
    data['Amount'] = amount;
    data['Payment_date'] = paymentDate;
    data['remarks'] = remarks;
    data['room'] = room;
    return data;
  }
}

class Appointment {
  int? id;
  String? user;
  String? tenantPoster;
  String? appointmentDate;
  int? tenant;

  Appointment(
      {this.id,
      this.user,
      this.tenantPoster,
      this.appointmentDate,
      this.tenant});

  Appointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    tenantPoster = json['tenant_poster'];
    appointmentDate = json['appointment_date'];
    tenant = json['Tenant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user'] = user;
    data['tenant_poster'] = tenantPoster;
    data['appointment_date'] = appointmentDate;
    data['Tenant'] = tenant;
    return data;
  }
}

class Bookings with ChangeNotifier {
  List<Booking> _bookings = [];
  List<Booking> _yourBooked = [];
  List<Booking> _ownBookings = [];
  final String authToken;
  final String userId;
  List<Appointment> _allAppointment = [];
  List<Appointment> _yourAppointment = [];
  List<Appointment> _ownAppointment = [];
  List<Payment> _allPayment = [];
  List<Payment> _yourPayment = [];
  List<Payment> _ownPayment = [];

  Bookings(this.authToken, this.userId, this._bookings);

  List<Payment> get allPayment {
    return [..._allPayment];
  }

  List<Payment> get ownPayment {
    return [..._ownPayment];
  }

  List<Payment> get yourPayment {
    return [..._yourPayment];
  }

  List<Appointment> get allAppointment {
    return [..._allAppointment];
  }

  List<Appointment> get yourAppointment {
    return [..._yourAppointment];
  }

  List<Appointment> get ownAppointment {
    return [..._ownAppointment];
  }

  List<Booking> get ownBooking {
    return [..._ownBookings];
  }

  List<Booking> get getBooking {
    return [..._bookings];
  }

  List<Booking> get yourBooked {
    return [..._yourBooked];
  }

  Future<void> fetchAppointmentData() async {
    Uri url = Uri.parse('http://10.0.2.2:8000/tenant/booking');
    var data = [];
    List<Appointment> results = [];
    try {
      final response =
          await http.get(url, headers: {'Authorization': 'Token $authToken'});
      if (response.statusCode == 200) {
        data = json.decode(response.body);
        results = data.map((e) => Appointment.fromJson(e)).toList();
        _allAppointment = results;
        _ownAppointment =
            results.where((element) => element.user == userId).toList();
        _yourAppointment =
            results.where((element) => element.tenantPoster == userId).toList();
      }
      notifyListeners();
    } catch (e) {
      print('Null here at fetch');
      rethrow;
    }
  }

  Future<void> fetchBookingData() async {
    Uri url = Uri.parse('http://10.0.2.2:8000/rooms/booking');

    final List<Booking> loadedBooking = [];
    try {
      final response =
          await http.get(url, headers: {'Authorization': 'Token $authToken'});
      final extractedData = json.decode(response.body);
      for (var i = 0; i < extractedData.length; i++) {
        var currentElement = extractedData[i];
        loadedBooking.add(Booking(
            id: currentElement['id'].toString(),
            user: currentElement['user'].toString(),
            room: currentElement['room'].toString(),
            checkIn: currentElement['check_in'],
            checkOut: currentElement['check_out'],
            roomOwner: currentElement['room_owner'],
            duration: currentElement['duration']));
      }
      _bookings = loadedBooking.reversed.toList();
      _ownBookings =
          loadedBooking.where((element) => element.user == userId).toList();

      _yourBooked = loadedBooking
          .where((element) => element.roomOwner == userId)
          .toList();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<String> postRoomBooking(
      String checkIn, String checkOut, String roomId, int duration) async {
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
            'duration': duration,
          }));
      // String message = json.decode();
      if (response.statusCode >= 400) {
        return response.body;
      }
      return 'Booking was successful';
    } catch (e) {
      rethrow;
    }
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
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchPaymentDetails() async {
    List<Payment> results = [];
    var data = [];
    Uri url = Uri.parse('http://10.0.2.2:8000/rooms/payment/');
    try {
      var response = await http.get(
        url,
        headers: {
          'Authorization': 'Token $authToken',
        },
      );
      if (response.statusCode == 200) {
        data = json.decode(response.body);
        results = data.map((e) => Payment.fromJson(e)).toList();
        _allPayment = results;
        _ownPayment =
            results.where((element) => element.user == userId).toList();
        _yourPayment =
            results.where((element) => element.roomOwner == userId).toList();
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> reportRoom(String description, String id) async {
    Uri url = Uri.parse('http://10.0.2.2:8000/rooms/$id/report');
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

  Payment findPaymentByID(String id) {
    return _allPayment.firstWhere((element) => element.id.toString() == id);
  }

  Appointment findAppointmentByID(String id) {
    return _allAppointment.firstWhere((element) => element.id.toString() == id);
  }

  Booking findByID(String id) {
    return _bookings.firstWhere((element) => element.id == id);
  }
}
