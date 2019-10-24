import 'package:flutter/material.dart';
import 'package:resep_makanan/entity/mealDetail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Detail extends StatefulWidget {
  final String id;
  final String name;

  Detail({
    Key key,
    @required this.id,
    @required this.name

  }): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DetailState();
  }
}

class _DetailState extends State<Detail> {
  List<Meals> food;
  
  @override
  void initState() {
    super.initState();
    getFoodById();
  }

  Future<List<Meals>> getFoodById() async {
    String link;
    link = "https://www.themealdb.com/api/json/v1/1/lookup.php?i="+widget.id;
    var res = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        var rest = data["meals"] as List;
        print(rest);
        setState(() {print(food);
          food = rest.map<Meals>((json) => Meals.fromJson(json)).toList();  
        });
      }
      print(food[0].strInstructions);
    return food;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        elevation: 0.0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios
          ),
          onPressed: ()=>Navigator.pop(context),
        ),
      ),
      body: food == null ? 
        Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)
            )
        ): Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width / 1,
          child: ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height/3.7,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: Image.network(
                        food != null? food[0].strMealThumb:
                        "https://ahegawcyen.cloudimg.io/cdn/n/n/https://cdn.halalster.com.au/assets/images/placeholder.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 7.0),

              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    food != null? food[0].strMeal: "",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),

              SizedBox(height: 7.0),

              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    food != null? food[0].strCategory : "",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Instructions :",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    food != null? food[0].strInstructions : "",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ),
    );
  }
}