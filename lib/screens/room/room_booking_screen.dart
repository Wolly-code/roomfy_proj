import 'package:esewa_pnp/esewa.dart';
import 'package:esewa_pnp/esewa_pnp.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/room.dart';

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
  var checkOut = '';
  String? message;
  Room? room;

  @override
  void didChangeDependencies() {
    if (innit) {
      try {
        final String? roomID =
            ModalRoute.of(context)!.settings.arguments as String;
        final Room roomData = Provider.of<Rooms>(context).findByID(roomID!);
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
        productName: "Recharge Card",
        productID: "RE1",
        callBackURL: "example.com");

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
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
                      checkIn =
                          formattedDate; //set output date to TextField value.
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
                    print(
                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    print(
                        formattedDate); //formatted date output using intl package =>  2021-03-16
                    //you can implement different kind of Date Format here according to your requirement

                    setState(() {
                      checkOut =
                          formattedDate; //set output date to TextField value.
                    });
                  } else {
                    print("Date is not selected");
                  }
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      final _res =
                          await _eSewaPnp.initPayment(payment: _payment);
                      message = _res.message;
                      print(message);
                    } catch (error) {
                      print('The Transaction was unsuccessful');
                    }
                  },
                  child: const Text('ESEWA')),
            ],
          ),
        ),
      ),
    );
  }
}
