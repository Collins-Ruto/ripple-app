import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ripple/home/main_page.dart';

import '../data/data.dart';
import '../models/wallpaper_model.dart';
import '../widgets/widgets.dart';

class Search extends StatefulWidget {
  const Search({Key? key, this.searchQuery = ''}) : super(key: key);

  final String searchQuery;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  List<WallpaperModel> wallpapers = [];
  TextEditingController searchController = TextEditingController();

  WallpaperModel wallModel = WallpaperModel();

  getSearchWallpapers(String query) async {
    var url = Uri.parse(  "https://api.pexels.com/v1/search?query=$query&per_page=25"
    );
    var response = await http.get(url,
        headers: { "Authorization" : apiKey }
    );

    Map<String, dynamic> imageData = jsonDecode(response.body);

    imageData["photos"].forEach((element){
      wallModel.alt = element["alt"];
      wallModel.large2x = element["src"]["large2x"];
      wallModel.medium = element["src"]["medium"];
      wallModel.large = element["src"]["large"];
      wallModel.original = element["src"]["original"];
      wallModel.landscape = element["src"]["landscape"];
      wallpapers.add(wallModel);
      wallModel = WallpaperModel();
    });

    setState(() {});
  }

  @override
  void initState() {
    getSearchWallpapers(widget.searchQuery);
    super.initState();
    searchController.text = widget.searchQuery;
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
        title: const BigText(text: 'Ripple', color: Color(0xFF89dad0), size: 27,),
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
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xffc8d0e2),
                  borderRadius: BorderRadius.circular(10),
                ),
                  padding: const EdgeInsets.symmetric(horizontal: 8,),
                  margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                      child: TextField( style: const TextStyle(
                        fontSize: 22,
                      ),
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
                              builder: (context) => Search(searchQuery: searchController.text,)));
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
              wallpapersList(wallpapers: wallpapers, context: context)
            ],
          ),
        ),
      ),
    );
  }
}
