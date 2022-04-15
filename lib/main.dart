import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/constraints.dart';
import 'package:roomfy_proj/providers/auth.dart';
import 'package:roomfy_proj/providers/booking.dart';
import 'package:roomfy_proj/providers/room.dart';
import 'package:roomfy_proj/providers/tenant.dart';
import 'package:roomfy_proj/providers/user.dart';
import 'package:roomfy_proj/screens/auth_screen.dart';
import 'package:roomfy_proj/screens/my_adverts.dart';
import 'package:roomfy_proj/screens/post_ad.dart';
import 'package:roomfy_proj/screens/room/room_booking_screen.dart';
import 'package:roomfy_proj/screens/main_view_screen.dart';
import 'package:roomfy_proj/screens/room/post_room_ad.dart';
import 'package:roomfy_proj/screens/room/room_detail_screen.dart';
import 'package:roomfy_proj/screens/room/room_overview_screen.dart';
import 'package:roomfy_proj/screens/room/update_room_photo.dart';
import 'package:roomfy_proj/screens/room/user_room_detail_screen.dart';
import 'package:roomfy_proj/screens/tenant/post_tenant_ad.dart';
import 'package:roomfy_proj/screens/tenant/tenant_detail_screen.dart';
import 'package:roomfy_proj/screens/tenant/tenant_overview_screen.dart';
import 'package:roomfy_proj/screens/room/user_room_screen.dart';
import 'package:roomfy_proj/screens/tenant/user_tenant_detail_screen.dart';
import 'package:roomfy_proj/screens/tenant/user_tenant_screen.dart';
import 'package:roomfy_proj/screens/user/create_profile.dart';
import 'package:roomfy_proj/screens/user/user_profile_overview.dart';
import 'package:roomfy_proj/screens/user/user_profile_overview.dart';
import 'screens/room/user_room_booking_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, Users>(
          create: (context) => Users('', '', []),
          update: (BuildContext context, auth, previousUser) => Users(
            auth.token.toString(),
            auth.userId.toString(),
            previousUser == null ? [] : previousUser.users,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Rooms>(
          create: (context) => Rooms('', '', []),
          update: (BuildContext context, auth, previousRoom) => Rooms(
            auth.token.toString(),
            auth.userId.toString(),
            previousRoom == null ? [] : previousRoom.rooms,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Tenants>(
          create: (context) => Tenants('', '', []),
          update: (BuildContext context, auth, previousTenant) => Tenants(
            auth.token.toString(),
            auth.userId.toString(),
            previousTenant == null ? [] : previousTenant.tenants,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Bookings>(
          create: (context) => Bookings('', '', []),
          update: (BuildContext context, auth, previousBookings) => Bookings(
            auth.token.toString(),
            auth.userId.toString(),
            previousBookings == null ? [] : previousBookings.getBooking,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Roomfy',
          theme: ThemeData(
            primaryColor: KPrimaryColor,
            accentColor: KPrimaryAccentColor,
            buttonColor: KPrimaryAccentColor,
            appBarTheme: const AppBarTheme(color: KPrimaryColor),
          ),
          home: auth.isAuth ? const MainView() : const AuthScreen(),
          routes: {
            TenantView.routeName: (ctx) => const TenantView(),
            RoomView.routeName: (ctx) => const RoomView(),
            RoomDetailScreen.routeName: (ctx) => const RoomDetailScreen(),
            UserRoomScreen.routeName: (ctx) => const UserRoomScreen(),
            TenantDetailScreen.routeName: (ctx) => const TenantDetailScreen(),
            UserTenantScreen.routeName: (ctx) => const UserTenantScreen(),
            UserRoomBookingScreen.routeName: (ctx) =>
                const UserRoomBookingScreen(),
            BookingScreen.routeName: (ctx) => const BookingScreen(),
            MyAdverts.routeName: (ctx) => const MyAdverts(),
            PostAd.routeName: (ctx) => const PostAd(),
            PostRoomAd.routeName: (ctx) => const PostRoomAd(),
            PostTenantAd.routeName: (ctx) => const PostTenantAd(),
            UserRoomDetailScreen.routeName: (ctx) =>
                const UserRoomDetailScreen(),
            UpdateRoomImage.routeName: (ctx) => const UpdateRoomImage(),
            UserProfileOverview.routeName: (ctx) => const UserProfileOverview(),
            CreateProfile.routeName: (ctx) => const CreateProfile(),
            UserTenantDetailScreen.routeName: (ctx) =>
                const UserTenantDetailScreen(),
          },
        ),
      ),
    );
  }
}
