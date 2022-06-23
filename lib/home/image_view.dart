import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:dio/dio.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import '../models/wallpaper_model.dart';
import 'package:path_provider/path_provider.dart';
FocusNode focusNode = FocusNode();

final List<String> downloaded = [];
bool isPhone = Platform.isAndroid || Platform.isIOS ? true : false;

class ImageView extends StatefulWidget {
  ImageView({Key? key, required this.imgUrl, required this.imgOriginal, required this.wallpapers, required this.wall}) : super(key: key);

  final String imgUrl;
  final String imgOriginal;
  final List<WallpaperModel> wallpapers;
  final WallpaperModel wall;

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {

  late String imgUrl;
  bool  isDownloading = false;
  bool isDone = false;
  bool hasDownload = false;
  int initial = 1;
  int fake = 1;

  final controller=SwiperController();

  dynamic filePath;
  @override
  void initState() {
    controller.move(7);
    imgUrl = widget.imgUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(focusNode);
    return Scaffold(
      body: Swiper(
        controller: SwiperController(),
        itemBuilder: (BuildContext context, int index) {
          if (index != widget.wallpapers.indexOf(widget.wall) || initial == 1) {
          index += widget.wallpapers.indexOf(widget.wall);
          initial = 2;
          }
          if (index >= widget.wallpapers.length && index > 0) {
            index = widget.wallpapers.length - index;
          }
          if (index < 0) {
            index = index * -1;
          }
          if (fake != index) {
            hasDownload = false;
            fake = index;
          }
          print("idex: $index");
          print(downloaded);
          print(widget.wallpapers[index].medium);
          if (downloaded.contains(widget.wallpapers[index].original)){
            hasDownload = true;
          }
          return RawKeyboardListener(
            autofocus: true,
            focusNode: focusNode,
            onKey: (RawKeyEvent event) {
              if (event.data.logicalKey == LogicalKeyboardKey.arrowRight) {
                index += 1;
                print("ringht key");
                setState(() {});
              }
              if (event.data.logicalKey == LogicalKeyboardKey.arrowLeft) {
                index -= 1;
                setState(() {});
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
                    progressIndicatorBuilder: (context, url, progress) => Center(
                      child: CircularProgressIndicator(color: const Color(0xDEE6FDFD),
                        value: progress.progress,
                      ),
                    ),
                    imageUrl: widget.wallpapers[index].large2x,
                  )),
            ),
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
                      _save(widget.wallpapers[index].alt);
                      isDownloading = true;
                      setState(() {});
                      paths(widget.wallpapers[index].original, widget.wallpapers[index].alt);
                      hasDownload? Navigator.pop(context) :setWallpaperFromFile(widget.wallpapers[index].large2x);
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
                        isDownloading ? !isDone  ? "downloading...": "success": hasDownload? "Back Home" :"Set Wallpaper",
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
          );}, itemCount: widget.wallpapers.length,
      ),
    );
  }

  void paths(String url, String alt) async {
    if (Platform.isAndroid || Platform.isIOS) {return;}
    Directory docDir = await getApplicationDocumentsDirectory();
    String folderName = "ripple";
    final Directory docDirFolder = Directory('${docDir.path}/$folderName/');
    if (!await docDirFolder.exists()) {
      final Directory newFolder = await docDirFolder.create(recursive: true);
      print(newFolder.path);
    }

    String fullPath = "${docDirFolder.path}${alt}_img.jpeg";
    try {
      Response response = await Dio().get(
        url,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      print(response.headers);
      File file = File(fullPath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      isDone = true;
      setState((){});
      Timer(const Duration(seconds: 1), () {
        isDownloading = false;
        hasDownload = true;
        downloaded.add(url);
        setState((){});
      });
    } catch (e) {
      print(e);
    }
    print('full path $fullPath');
  }

  _save(String alt) async {
    if (!Platform.isAndroid || !Platform.isIOS) {return;}
    if (Platform.isAndroid) {
      await _askPermission();
    }
    var response = await Dio().get(
        widget.imgUrl,
        options: Options(responseType: ResponseType.bytes));
    await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: alt);
  }

  _askPermission() async{
    if (Platform.isIOS) {
      // Map<Permission, PermissionStatus> statuses =
      (await Permission.photos.request()) as Map<Permission, PermissionStatus>;
    } else {
      await Permission.storage.status;
    }
  }

  Future<void> setWallpaperFromFile(String url) async {
    if (!Platform.isAndroid || !Platform.isIOS) {return;}
    try {
      File cachedimage = await DefaultCacheManager().getSingleFile(url);  //image file
      int location = WallpaperManagerFlutter.HOME_SCREEN;  //Choose screen type
      WallpaperManagerFlutter().setwallpaperfromFile(cachedimage, location);

      isDone = true;
      setState((){});
      Timer(const Duration(seconds: 1), () {
        isDownloading = false;
        hasDownload = true;
        setState((){});
      });

    } on PlatformException {
      'Failed to get wallpaper.';
    }
    if (!mounted) return;
  }
}
