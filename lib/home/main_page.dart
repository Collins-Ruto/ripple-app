import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ripple/data/data.dart';
import 'package:ripple/home/search.dart';
import 'package:ripple/models/wallpaper_model.dart';
import 'package:ripple/widgets/widgets.dart';
import 'package:http/http.dart' as http;

import '../models/categories_model.dart';

bool isPhone = Platform.isAndroid || Platform.isIOS ? true : false;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<CategoriesModel> categories = [];
  List<WallpaperModel> wallpapers = [];

  TextEditingController searchController = TextEditingController();

  WallpaperModel wallModel = WallpaperModel();

  getWallpapers() async {
    var url = Uri.parse("https://api.pexels.com/v1/curated?page=2&per_page=30");
    var response = await http.get(url,
      headers: { "Authorization" : apiKey }
    );

    Map<String, dynamic> imageData = jsonDecode(response.body);

    imageData["photos"].forEach((element){
      wallModel.alt = element["alt"];
      wallModel.large2x = element["src"]["large2x"];
      wallModel.medium = element["src"]["medium"];
      wallModel.original = element["src"]["original"];
      wallModel.large = element["src"]["large"];
      wallModel.landscape = element["src"]["landscape"];
      wallpapers.add(wallModel);
      wallModel = WallpaperModel();
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
      appBar: AppBar(
        toolbarHeight: 50.0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black54,
        flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[Colors.black54, Colors.blueGrey]))),
        title:
        Container(
          margin: const EdgeInsets.only(top: 15, bottom: 15,),
          // padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              Container(
                  margin: const EdgeInsets.only(right: 25),
                  child: const BigText(text: 'Ripple', color: Color(0xFF89dad0), size: 30,)),
              Container(
                  child: (
                      Expanded(
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: searchController,
                          decoration:  const InputDecoration(
                            hintStyle: TextStyle(color: Colors.white),
                              hintText: 'search',
                              border: InputBorder.none
                          ),
                        ),
                      )
                  )),
              Center(
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Search(
                          searchQuery: searchController.text,)));
                  },
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(Icons.search, color: Colors.white,),
                  ),
                ),
              )
            ],
          ),
        ),),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black87,
          child: Column(
            children: [
              const SizedBox(height: 16,),
              Container(
                height: isPhone? 80: 90,
                padding: const EdgeInsets.symmetric(horizontal:8),
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
              wallpapersList(wallpapers: wallpapers, context: context)
            ],
          ),
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
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Search(
              searchQuery: title,)));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 4),
        child: Stack( children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                  child: isPhone? Image.network(imgUrl, height: 50, width: 100, fit: BoxFit.cover,)
                      :Image.network(imgUrl, height: 75, width: 150, fit: BoxFit.cover,)),

          Container(
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8),
            ),
            height: isPhone? 50 : 75, width: isPhone? 100: 150,
            alignment: Alignment.center,
            child: Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: isPhone? 15 : 20),),
          )
        ],
        ),
      ),
    );
  }


}

