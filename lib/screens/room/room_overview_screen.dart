import 'package:flutter/material.dart';
import 'package:roomfy_proj/screens/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/widgets/rooms_grid_view.dart';
import '../../providers/room.dart';
class RoomView extends StatefulWidget {
  const RoomView({Key? key}) : super(key: key);
  static const routeName = '/room-view';
  @override
  _RoomViewState createState() => _RoomViewState();
}

class _RoomViewState extends State<RoomView> {
  var _isInit = true;
  var _isLoading = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Rooms>(context).fetchAndSetRoom().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rooms'),
        actions: const [],
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : const RoomsGrid(),
    );
  }
}
