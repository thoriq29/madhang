import 'package:flutter/material.dart';
import 'package:resep_makanan/pages/details.dart';
import 'package:resep_makanan/pages/foods.dart';
import 'package:resep_makanan/entity/category.dart';
import 'package:resep_makanan/entity/meal.dart';
import 'package:resep_makanan/utils/const.dart';
import 'package:resep_makanan/widgets/slide_food.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home>{  
  List<Meals> randomFood;
  List<Categories> categories;

  var areas = [
    "American","British", "Canadian","Chinese", "Dutch", "Egyptian",
    "French", "Greek", "Indian", "Irish",  "Italian", "Jamaican", "Japanese",
    "Kenyan", "Malaysian", "Mexican", "Moroccan", "Russian", "Spanish", "Thai",
    "Tunisian","Turkish","Vietnamese"
  ];

  String area;

  Random rnd = new Random();

  @override
  void initState() {
    super.initState();
    setArea();
  }

  void setArea() {
    var selected = areas[rnd.nextInt(areas.length)];
    getRandomFoods(selected);
    getAllCategories();
    setState(() {
      area = selected;
    });
  }

  Future<List<Meals>> getRandomFoods(String area) async {
    String link = "https://www.themealdb.com/api/json/v1/1/filter.php?a="+area;
    var res = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        var rest = data["meals"] as List;
        setState(() {
          randomFood = rest.map<Meals>((json) => Meals.fromJson(json)).toList();  
        });
      }
    return randomFood;
  }

  Future<List<Categories>> getAllCategories() async {
    String link = "https://www.themealdb.com/api/json/v1/1/categories.php";
    var res = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        var rest = data["categories"] as List;
        setState(() {
          categories = rest.map<Categories>((json) => Categories.fromJson(json)).toList();  
        });
      }
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.appName),
        elevation: 0.0,
      ),
      body: randomFood == null?
        Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)
            )
        ): Padding(
        padding: EdgeInsets.fromLTRB(10.0,0,10.0,0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  area + " Foods",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                FlatButton(
                  child: Text(
                    randomFood != null?"See all "+ randomFood.length.toString(): "See all 0",
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context){
                          return Food(
                            area: area,
                            category: "",
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            randomFood != null?
            Container(
              height: MediaQuery.of(context).size.height/2.4,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                primary: false,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: randomFood == null ? 0 :randomFood.length,
                itemBuilder: (BuildContext context, int index) {
                  Meals meals = randomFood[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context){
                            return Detail(
                              id: meals.idMeal,
                              name: meals.strMeal,
                            );
                          },
                        ),
                      );
                    },
                    child:  Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: SlideItem(
                        img: meals.strMealThumb,
                        title: meals.strMeal.length > 20? meals.strMeal.substring(0, 20) + "...": meals.strMeal,
                        desc: meals.strMeal + " from " + area,
                        id: meals.idMeal.toString(),
                      ),
                    ),
                  );
                },
              ),
            ):Container(
                height: MediaQuery.of(context).size.height/3.7,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Image.network(
                    "https://ahegawcyen.cloudimg.io/cdn/n/n/https://cdn.halalster.com.au/assets/images/placeholder.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Categories",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Container(
              height: MediaQuery.of(context).size.height/6,
              child: ListView.builder(
                primary: false,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: categories == null ? 0:categories.length,
                itemBuilder: (BuildContext context, int index) {
                  Categories cat = categories[index];
                  return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context){
                              return Food(
                                category: cat.strCategory,
                                area: "",
                              );
                            },
                          ),
                        );
                      },
                      child: Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Stack(
                          children: <Widget>[
                            Image.network(
                              cat.strCategoryThumb,
                              height: MediaQuery.of(context).size.height/6,
                              width: MediaQuery.of(context).size.height/6,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  // Add one stop for each color. Stops should increase from 0 to 1
                                  stops: [0.2, 0.7],
                                  colors: [
                                    Color.fromARGB(100, 0, 0, 0),
                                    Color.fromARGB(100, 0, 0, 0),
                                  ],
                                  // stops: [0.0, 0.1],
                                ),
                              ),
                              height: MediaQuery.of(context).size.height/6,
                              width: MediaQuery.of(context).size.height/6,
                            ),
                            Center(
                              child: Container(
                                height: MediaQuery.of(context).size.height/6,
                                width: MediaQuery.of(context).size.height/6,
                                padding: EdgeInsets.all(1),
                                constraints: BoxConstraints(
                                  minWidth: 20,
                                  minHeight: 20,
                                ),
                                child: Center(
                                  child: Text(
                                    cat.strCategory,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
  @override
  bool get wantKeepAlive => true;


}
