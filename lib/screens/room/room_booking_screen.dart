import 'package:esewa_pnp/esewa.dart';
import 'package:esewa_pnp/esewa_pnp.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/booking.dart';
import '../../providers/room.dart';
import '../../providers/user.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);
  static const routeName = 'Booking-screen';

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  var innit = true;
  var title = '';
  final _form = GlobalKey<FormState>();
  String checkIn = '';
  String checkOut = '';
  DateTime? checkInDate;
  DateTime? checkOutDate;
  Room? room;
  User? user;
  ESewaResult? paymentDetail;
  int? duration;

  @override
  void didChangeDependencies() {
    if (innit) {
      try {
        final String? roomID =
            ModalRoute.of(context)!.settings.arguments as String;
        final Room roomData = Provider.of<Rooms>(context).findByID(roomID!);
        final User? userData = Provider.of<Users>(context).userObj;
        user = userData;
        room = roomData;
      } catch (e) {
        rethrow;
      }
    }
    innit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ESewaConfiguration _configuration = ESewaConfiguration(
        clientID: "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R",
        secretKey: "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==",
        environment: ESewaConfiguration.ENVIRONMENT_TEST //ENVIRONMENT_LIVE
        );
    ESewaPnp _eSewaPnp = ESewaPnp(configuration: _configuration);
    ESewaPayment _payment = ESewaPayment(
        amount: room!.securityDeposit.toDouble(),
        productName: room!.title,
        productID: room!.id,
        callBackURL: "example.com");

    Future<void> _saveForm() async {
      final isValid = _form.currentState!.validate();
      if (!isValid) {
        return;
      }
      if (duration! < room!.minimumBookingDays) {
        String respMsg =
            'The minimum stay for this room is at least ${room!.minimumBookingDays} Days';
        final snackBar = SnackBar(
          duration: const Duration(seconds: 2),
          content: Text(respMsg),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      if (paymentDetail?.status != 'COMPLETE') {
        const snackBar = SnackBar(
          duration: Duration(seconds: 2),
          content: Text('Please complete the payment before booking'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      _form.currentState!.save();
      try {
        // if (room!.poster == user!.userId) {
        //   const snackBar = SnackBar(
        //     duration: Duration(seconds: 2),
        //     content: Text('You cant book your own post!'),
        //   );
        //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //   return;
        // }

        var respMsg = await Provider.of<Bookings>(context, listen: false)
            .postRoomBooking(checkIn, checkOut, room!.id, duration!);
        final snackBar = SnackBar(
          duration: const Duration(seconds: 2),
          content: Text(respMsg),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } catch (e) {
        rethrow;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.add))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextField(
                decoration: InputDecoration(
                  icon: const Icon(Icons.calendar_today),
                  labelText:
                      checkIn == '' ? "Check In Date" : checkIn = checkIn,
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);

                    setState(() {
                      checkIn = formattedDate;
                      checkInDate =
                          pickedDate; //set output date to TextField value.
                    });
                  } else {}
                },
              ),
              TextField(
                decoration: InputDecoration(
                  icon: const Icon(Icons.calendar_today),
                  labelText:
                      checkOut == '' ? "Check Out Date" : checkOut = checkOut,
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);

                    setState(() {
                      checkOut = formattedDate;
                      checkOutDate = pickedDate;
                    });
                    final firstDate = checkInDate;
                    final secondDate = checkOutDate;
                    final difference =
                        secondDate?.difference(firstDate!).inDays;
                    if (difference! <= room!.minimumBookingDays) {
                      String respMsg =
                          'The minimum stay for this room is at least ${room!.minimumBookingDays} Days';
                      final snackBar = SnackBar(
                        duration: const Duration(seconds: 2),
                        content: Text(respMsg),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    duration = difference;
                  } else {
                    print("Date is not selected");
                  }
                },
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    'Firstly Before booking you have to pay the security deposit the post owner has stated'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Security Deposit: NRS ${room!.securityDeposit}/-',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              ESewaPaymentButton(
                _eSewaPnp,
                amount: room!.securityDeposit >= 1000
                    ? 999
                    : room!.securityDeposit.toDouble(),
                callBackURL: "https://example.com",
                productId: room!.id,
                productName: room!.title,
                onSuccess: (ESewaResult result) async {
                  paymentDetail = result;
                  await Provider.of<Bookings>(context, listen: false)
                      .postPaymentDetails(
                          paymentDetail!.productId,
                          room!.securityDeposit.toDouble(),
                          user!.userId,
                          room!.id,
                          'Security Deposit');
                },
                onFailure: (ESewaPaymentException e) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
