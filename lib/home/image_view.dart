import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ImageView extends StatefulWidget {
  const ImageView({Key? key, required this.imgUrl, required this.imgOriginal,}) : super(key: key);

  final String imgUrl;
  final String imgOriginal;

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {

  late String imgUrl;
  bool  isDownload = false;
  bool isDone = false;
  bool hasDownload = false;
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
            color: Colors.black54,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: CachedNetworkImage(
                    fit: BoxFit.cover,
                  // placeholder: (context, url) => Image.network(imgUrl),
                  progressIndicatorBuilder: (context, url, progress) => Center(
                    child: CircularProgressIndicator(color: const Color(0xDEE6FDFD),
                      value: progress.progress,
                    ),
                  ),
                  imageUrl: widget.imgOriginal
                )),
          ),
              // child: Image.network(widget.imgUrl, fit: BoxFit.cover,)),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    _save();
                    isDownload = true;
                    setState(() {});
                    hasDownload? Navigator.pop(context) :setWallpaperFromFile();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    margin: const EdgeInsets.only(bottom: 8),
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
                    child: Text(
                      isDownload ? !isDone  ? "downloading...": "success": hasDownload? "Back Home" :"Set Wallpaper",
                      style: const TextStyle(fontSize: 20, color: Colors.white70),),
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text("cancel", style: TextStyle(color: Colors.white, fontSize: 18),))
              ],
            ),
          ),],
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

  Future<void> setWallpaperFromFile() async {
    String result;
    var file = await DefaultCacheManager().getSingleFile(
      widget.imgUrl
    );
    try {
      File cachedimage = await DefaultCacheManager().getSingleFile(widget.imgOriginal);  //image file

      int location = WallpaperManagerFlutter.HOME_SCREEN;  //Choose screen type

      WallpaperManagerFlutter().setwallpaperfromFile(cachedimage, location);
      isDone = true;
      setState((){});
      Timer(const Duration(seconds: 1), () {
        isDownload = false;
        hasDownload = true;
        setState((){});
      });

    } on PlatformException {
      result = 'Failed to get wallpaper.';
    }
    if (!mounted) return;
  }
}

// class ImgView extends StatefulWidget {
//   final String imgOriginal;
//   final String imgUrl;
//
//   const ImgView({Key? key, required this.imgOriginal, required this.imgUrl}) : super(key: key);
//
//   @override
//   State<ImgView> createState() => _ImgViewState();
// }
//
// class _ImgViewState extends State<ImgView> {
//   @override
//   Widget build(BuildContext context) {
//     bool isImg = false;
//     File cachedimage = DefaultCacheManager().getSingleFile(widget.imgUrl);
//
//     Future<File> getImage() async {
//       File cachedimage = await DefaultCacheManager().getSingleFile(widget.imgOriginal);
//       isImg = true;
//       setState(() {});
//       return cachedimage;
//     }
//
//     return !isImg ? Image.network(widget.imgUrl, fit: BoxFit.cover,) : Image.file(cachedimage);
//   }
// }