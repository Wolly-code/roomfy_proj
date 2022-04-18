import 'package:carousel_slider/carousel_slider.dart';
import 'package:esewa_pnp/esewa.dart';
import 'package:esewa_pnp/esewa_pnp.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/booking.dart';
import 'package:roomfy_proj/providers/user.dart';
import 'package:roomfy_proj/screens/room/room_detail_screen.dart';
import '../user/user_profile.dart';
import '../../providers/room.dart';

class UserRoomBookingDetail extends StatefulWidget {
  const UserRoomBookingDetail({Key? key}) : super(key: key);
  static const routeName = '/User-Room-Booking-Detail';

  @override
  State<UserRoomBookingDetail> createState() => _UserRoomBookingDetailState();
}

class _UserRoomBookingDetailState extends State<UserRoomBookingDetail> {
  final _form = GlobalKey<FormState>();
  bool _isinnit = true;
  Room? roomData;
  User? userData;
  Booking? bookingData;
  bool _customTileExpanded = false;
  double? amount;

  @override
  void didChangeDependencies() {
    if (_isinnit) {
      final bookingId = ModalRoute.of(context)!.settings.arguments as String;
      final bookingDatas = Provider.of<Bookings>(context).findByID(bookingId);
      final roomDatas = Provider.of<Rooms>(context).findByID(bookingDatas.room);
      final userDatas = Provider.of<Users>(context).findByID(bookingDatas.user);
      roomData = roomDatas;
      userData = userDatas;
      bookingData = bookingDatas;
    }
    super.didChangeDependencies();
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: Colors.grey[300],
    minimumSize: const Size(88, 36),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    ESewaConfiguration _configuration = ESewaConfiguration(
        clientID: "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R",
        secretKey: "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==",
        environment: ESewaConfiguration.ENVIRONMENT_TEST //ENVIRONMENT_LIVE
        );
    ESewaPnp _eSewaPnp = ESewaPnp(configuration: _configuration);
    int totalAmount = roomData!.price * bookingData!.duration;
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking #${bookingData!.id}'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(height: 250.0),
              items: [
                roomData!.photo1,
                roomData!.photo2,
              ].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: const BoxDecoration(color: Colors.amber),
                      child: Image.network(
                        i,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(
              height: 15,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Booked By:',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(userData!.profile, scale: 10),
                  ),
                  title: Text(userData!.firstName + " " + userData!.lastName),
                  subtitle: Text(userData!.userId),
                  trailing: Icon(
                    _customTileExpanded
                        ? Icons.arrow_drop_down_circle
                        : Icons.arrow_drop_down,
                  ),
                  children: <Widget>[
                    ElevatedButton(
                      style: raisedButtonStyle,
                      onPressed: () {
                        Navigator.of(context).pushNamed(UserProfile.routeName,
                            arguments: bookingData!.user);
                      },
                      child: const Text('View User'),
                    )
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded = expanded);
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Room Detail:',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(roomData!.photo1, scale: 10),
                  ),
                  title: Text(roomData!.title),
                  subtitle: Text(roomData!.description),
                  trailing: Icon(
                    _customTileExpanded
                        ? Icons.arrow_drop_down_circle
                        : Icons.arrow_drop_down,
                  ),
                  children: <Widget>[
                    ElevatedButton(
                      style: raisedButtonStyle,
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            RoomDetailScreen.routeName,
                            arguments: roomData!.id);
                      },
                      child: const Text('View Room'),
                    )
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded = expanded);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text('Booking Date'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [Text('From'), Text('To')],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('yyyy-MM-dd').format(
                                    DateTime.parse(bookingData!.checkIn)),
                                style: const TextStyle(fontSize: 20),
                              ),
                              const Icon(Icons.arrow_forward),
                              Text(
                                DateFormat('yyyy-MM-dd').format(
                                    DateTime.parse(bookingData!.checkOut)),
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child:
                                Text('Duration: ${bookingData!.duration} Days'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Text(
                    'Your total amount is NRS ${roomData!.price * bookingData!.duration}/-',style: TextStyle(fontSize: 20),),
                Center(
                  child: ESewaPaymentButton(
                    _eSewaPnp,
                    amount: (totalAmount) > 1000 ? 999 : totalAmount.toDouble(),
                    callBackURL: "https://example.com",
                    productId: roomData!.id,
                    productName: roomData!.title,
                    onSuccess: (ESewaResult result) async {
                      final paymentDetail = result;
                      await Provider.of<Bookings>(context, listen: false)
                          .postPaymentDetails(
                              paymentDetail.productId,
                              roomData!.securityDeposit.toDouble(),
                              userData!.userId,
                              roomData!.id,
                              'Rent Payment');
                    },
                    onFailure: (ESewaPaymentException e) {},
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
