import 'package:flutter/material.dart';

import '../models/wallpaper_model.dart';

class BigText extends StatelessWidget {
  final Color? color;
  final String text;
  final double size;

  const BigText({Key? key, this.color = const Color(0xFF332d2b), required this.text, this.size = 20}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontFamily: 'Roboto',
        fontSize: size
      ),
    );
  }
}

Widget WallpapersList({required List<WallpaperModel> wallpapers, context}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 0.6,
      mainAxisSpacing: 6.0,
      crossAxisSpacing: 6.0,
      children: wallpapers.map((wallpaper){
        return GridTile(
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                  child: Image.network(wallpaper.portrait, fit: BoxFit.cover,)),
        ),);
      }).toList(),
    ),
  );
}