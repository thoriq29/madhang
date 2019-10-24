import 'package:flutter/material.dart';
import 'package:resep_makanan/entity/meal.dart';
import 'package:resep_makanan/widgets/foods.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'details.dart';

class Food extends StatefulWidget {
  final String area;
  final String category;

  Food({
    Key key,
    @required this.area,
    @required this.category,

  }): super(key: key);

  @override
  _FoodState createState() => _FoodState();
}

class _FoodState extends State<Food> {
  List<Meals> foods;

  @override
  void initState() {
    super.initState();
    getFoodByArea();
  }


  Future<List<Meals>> getFoodByArea() async {
    String link;
    if(widget.area != "") {
      link = "https://www.themealdb.com/api/json/v1/1/filter.php?a="+widget.area;
    } else {
      link = "https://www.themealdb.com/api/json/v1/1/filter.php?c="+widget.category;
    }

    var res = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        var rest = data["meals"] as List;
        setState(() {
          foods = rest.map<Meals>((json) => Meals.fromJson(json)).toList();  
        });
      }
    return foods;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(widget.area != "" ? widget.area + " Foods": widget.category + " Foods"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios
          ),
          onPressed: ()=>Navigator.pop(context),
        ),
      ),

      body: foods == null?
      Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)
            )
      ): Padding(
        padding: EdgeInsets.fromLTRB(10.0,0,10.0,0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            GridView.builder(
              primary: false,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: foods == null ? 0 :foods.length,
              gridDelegate:
                new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait?2:3,
                  childAspectRatio:MediaQuery.of(context).orientation == Orientation.portrait?0.70:0.90 ,
              ),
              itemBuilder: (BuildContext context, int index) {
                Meals meals = foods[index];                
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
                  child: TrendingItem(
                    img: meals.strMealThumb,
                    title: meals.strMeal.length > 18? meals.strMeal.substring(0, 18) + "...": meals.strMeal,
                    desc: widget.area != "" ? widget.area : widget.category,
                    id: meals.idMeal.toString(),
                  )
                );
              },
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
