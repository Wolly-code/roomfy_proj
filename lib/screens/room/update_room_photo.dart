import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/room.dart';

class UpdateRoomImage extends StatefulWidget {
  const UpdateRoomImage({Key? key}) : super(key: key);
  static const routeName = '/Update-Room-Image';

  @override
  State<UpdateRoomImage> createState() => _UpdateRoomImageState();
}

class _UpdateRoomImageState extends State<UpdateRoomImage> {
  final _form = GlobalKey<FormState>();
  Room? room;
  bool _innit = true;
  File? _photo1Stored;
  File? _photo2Stored;
  String? photo1;
  String? photo2;

  Future<void> _photo1(int id) async {
    final picker = ImagePicker();
    final XFile? imageFile =
        await picker.pickImage(source: ImageSource.gallery, maxWidth: 600);
    if (imageFile == null) {
      return;
    }
    final File? saveFile = File(imageFile.path);
    setState(() {
      if (id == 0) {
        _photo1Stored = saveFile;
      } else {
        _photo2Stored = saveFile;
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (_innit) {
      try {
        final String? roomID =
            ModalRoute.of(context)!.settings.arguments as String;
        final temp = Provider.of<Rooms>(context).findByID(roomID!);
        room = temp;
        photo1 = temp.photo1;
        photo2 = temp.photo2;
      } catch (error) {
        rethrow;
      }
    }
    _innit = false;
    super.didChangeDependencies();
  }

  Future<void> _savePhoto() async {
    try {
      await Provider.of<Rooms>(context, listen: false)
          .updateRoomPhoto(_photo1Stored!, _photo2Stored!, room!.id);
      await Provider.of<Rooms>(context, listen: false).fetchAndSetRoom();
      const snackBar = SnackBar(
        duration: Duration(seconds: 2),
        content: Text("Room Photo updated Successfully"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
    } catch (error) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Photos'),
        centerTitle: true,
        actions: [
          TextButton(onPressed: _savePhoto, child: const Text('Upload Image'))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                'Your Current Images',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          const Divider(),
          CarouselSlider(
            options: CarouselOptions(height: 300.0),
            items: [
              photo1,
              photo2,
            ].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: const BoxDecoration(color: Colors.amber),
                    child: Image.network(
                      i!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  );
                },
              );
            }).toList(),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                  ),
                  child: _photo1Stored != null
                      ? GestureDetector(
                          onTap: () async {
                            _photo1(0);
                          },
                          child: Image.file(
                            _photo1Stored!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                      : Container(
                          height: 100,
                          width: 100,
                          child: IconButton(
                            onPressed: () async {
                              _photo1(0);
                            },
                            icon: const Icon(Icons.add),
                          ),
                          decoration: BoxDecoration(border: Border.all()),
                        ),
                  alignment: Alignment.center,
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                  ),
                  child: _photo2Stored != null
                      ? GestureDetector(
                          onTap: () async {
                            _photo1(1);
                          },
                          child: Image.file(
                            _photo2Stored!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                      : Container(
                          height: 100,
                          width: 100,
                          child: IconButton(
                            onPressed: () async {
                              setState(() {
                                _photo1(1);
                              });
                            },
                            icon: const Icon(Icons.add),
                          ),
                          decoration: BoxDecoration(border: Border.all()),
                        ),
                  alignment: Alignment.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
