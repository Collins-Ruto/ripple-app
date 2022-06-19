import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:typed_data';

class ImageView extends StatefulWidget {
  const ImageView({Key? key, required this.imgUrl,}) : super(key: key);

  final String imgUrl;

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {

  late String imgUrl;
  var filePath;
  @override
  void initState() {
    imgUrl = widget.imgUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx > 0) {

          }
          if (details.delta.dx < 0) {

          }
        },
        child: Stack(
          children: [Container(
            height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.network(imgUrl, fit: BoxFit.cover,)),
          GestureDetector(
            onTap: () {
              _save();
            },
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    margin: EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white30, width: 1),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0x36FFFFFF  ),
                          Color(0x0FFFFFFF)
                        ]
                      )
                    ),
                    child: const Text("Set Wallpaper", style: TextStyle(fontSize: 20, color: Colors.white70),),
                  ),
                  const Text("cancel", style: TextStyle(color: Colors.white, fontSize: 18),)
                ],
              ),
            ),
          )],
        ),
      ),
    );
  }
  _save() async {
    if (Platform.isAndroid) {
      await _askPermission();
    }
    var response = await Dio().get(
        widget.imgUrl,
        options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: "hello");
    print(result);
    Navigator.pop(context);
  }

  _askPermission() async{
    if (Platform.isIOS) {
      Map<Permission, PermissionStatus> statuses =
      (await Permission.photos.request()) as Map<Permission, PermissionStatus>;
    } else {
      PermissionStatus permission = await Permission.storage.status;
    }
  }
}
