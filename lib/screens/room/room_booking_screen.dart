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
  var checkIn = '';
  var checkOut = '';

  @override
  void didChangeDependencies() {
    if (innit) {
      try {
        final String? roomID =
            ModalRoute.of(context)!.settings.arguments as String;
        final roomData = Provider.of<Rooms>(context).findByID(roomID!);
        title = roomData.title;
      } catch (e) {
        rethrow;
      }
    }
    innit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
                decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_today),
                  labelText: "Check Out Date",
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
                  } else {
                  }
                },
              ),
              TextField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_today),
                  labelText: "Check Out Date",
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
                      checkIn =
                          formattedDate; //set output date to TextField value.
                    });
                  } else {
                    print("Date is not selected");
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
