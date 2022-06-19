import 'package:flutter/material.dart';

import '../home/image_view.dart';
import '../models/wallpaper_model.dart';

class BigText extends StatelessWidget {
  final Color? color;
  final String text;
  final double size;

  const BigText({Key? key, this.color = const Color(0xFF332d2b), required this.text, this.size = 15}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(left: -10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              color: color,
              fontFamily: 'Roboto',
              fontSize: size
            ),
          ),
        ],
      ),
    );
  }
}

Widget wallpapersList({required List<WallpaperModel> wallpapers, context}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: GridView.count(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 0.6,
      mainAxisSpacing: 6.0,
      crossAxisSpacing: 6.0,
      children: wallpapers.map((wallpaper){
        return GridTile(
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ImageView(imgUrl: wallpaper.original,)));
              },
              child: Hero(
                tag: wallpaper.portrait,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                    child: Image.network(wallpaper.portrait, fit: BoxFit.cover,)),
              ),
            ),);
      }).toList(),
    ),
  );
}