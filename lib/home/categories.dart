import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ripple/home/search.dart';
import 'dart:convert';

import '../data/data.dart';
import '../models/wallpaper_model.dart';
import '../widgets/widgets.dart';
import 'main_page.dart';


class Categories extends StatefulWidget {
  const Categories({Key? key, required this.category}) : super(key: key);

  final String category;

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  List<WallpaperModel> wallpapers = [];
  WallpaperModel wallModel = WallpaperModel();
  TextEditingController searchController = TextEditingController();

  getSearchWallpapers(String query) async {
    var url = Uri.parse(  "https://api.pexels.com/v1/search?query=$query&per_page=15"
    );
    var response = await http.get(url,
        headers: { "Authorization" : apiKey }
    );

    Map<String, dynamic> imageData = jsonDecode(response.body);

    imageData["photos"].forEach((element){
      wallModel.id = element["id"];
      wallModel.photographer = element["photographer"];
      wallModel.portrait = element["src"]["medium"];
      wallModel.original = element["src"]["original"];
      wallpapers.add(wallModel);
      wallModel = WallpaperModel();
    });

    setState(() {});
  }

  @override
  void initState() {
    getSearchWallpapers(widget.category);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: Colors.black54,
        flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[Colors.black54, Colors.blueGrey]))),
        title: const BigText(text: 'Ripple', color: Color(0xFF89dad0), size: 25,),
        actions: [IconButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => const HomePage()));
        } , icon: const Icon(Icons.home) )],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black87,
          child: Column(
            children: [
              Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xffc8d0e2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: const InputDecoration(
                              hintText: 'search',
                              border: InputBorder.none
                          ),
                        ),
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => Search(
                                  searchQuery: searchController.text,)));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: const Icon(Icons.search, color: Colors.black,),
                          ),
                        ),
                      ),
                    ],
                  )),
              WallpapersList(wallpapers: wallpapers, context: context)
            ],
          ),
        ),
      ),
    );
  }
}
