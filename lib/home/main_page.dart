import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ripple/data/data.dart';
import 'package:ripple/models/wallpaper_model.dart';
import 'package:ripple/widgets/widgets.dart';
import 'package:http/http.dart' as http;

import '../models/categories_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<CategoriesModel> categories = [];
  List<WallpaperModel> wallpapers = [];

  WallpaperModel wallModel = WallpaperModel();

  getWallpapers() async {
    var url = Uri.parse("https://api.pexels.com/v1/curated");
    var response = await http.get(url,
      headers: { "Authorization" : apiKey }
    );

    Map<String, dynamic> image_data = jsonDecode(response.body);

    image_data["photos"].forEach((element){
      print(element);
      wallModel.id = element["id"];
      wallModel.photographer = element["photographer"];
      wallModel.portrait = element["src"]["portrait"];
      wallModel.original = element["src"]["original"];
      wallpapers.add(wallModel);
      wallModel = WallpaperModel();
      print("id is" + wallModel.id.toString());
    });

    setState(() {});
  }

  @override
  void initState() {
    getWallpapers();
    categories = getCategories();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 45, bottom: 15),
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BigText(text: 'Ripple', color: Color(0xFF89dad0), size: 30,),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xfff5f8fd),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                  children: <Widget> [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: 'search',
                            border: InputBorder.none
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 45,
                        height: 45,
                        child: Icon(Icons.search, color: Colors.black,),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          // color: Color(0xFF89dad0),
                        ),
                      ),
                    )
                  ]),
            ),
            SizedBox(height: 16,),
            Container(
              height: 80,
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                  itemBuilder: (context, index){
                  return CategoriesTile(
                    title: categories[index].category_name,
                    imgUrl: categories[index].img_url,
                  );
                  }),
            ),
            SizedBox(height: 16,),
            WallpapersList(wallpapers: wallpapers, context: context)
          ],
        ),
      ),
    ) ;
  }
}

class CategoriesTile extends StatelessWidget {
  final String imgUrl, title;
  const CategoriesTile({Key? key,  this.imgUrl = 'https://imgs.search.brave.com/nfH77DB-hIoNxoRC-kTqgPMANYrCa1umZjn5mFHZ4Ao/rs:fit:666:225:1/g:ce/aHR0cHM6Ly90c2Ux/Lm1tLmJpbmcubmV0/L3RoP2lkPU9JUC5q/eWRqaXlDMVJVVVgw/X1dMZEh4WF9BSGFG/UiZwaWQ9QXBp', this.title = 'Category'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 4),
      child: Stack( children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
            child: Image.network(imgUrl, height: 50, width: 100, fit: BoxFit.cover,)),
        Container(
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(8),
          ),
          height: 50, width: 100,
          alignment: Alignment.center,
          child: Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),),
        )
      ],
      ),
    );
  }
}

