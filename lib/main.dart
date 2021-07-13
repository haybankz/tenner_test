import 'package:flutter/material.dart';
import 'package:tenner_test/knapsack.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<MyHomePage>{

  TextEditingController wController = TextEditingController();
  TextEditingController vController = TextEditingController();
  TextEditingController weightLimitController = TextEditingController();
  final _formKey  = GlobalKey<FormState>();
  String answer = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Knapsack Dart"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
             TextFormField(
              controller: wController,
              decoration: InputDecoration.collapsed(hintText: "Comma separated weights"),
               validator: (value){
                if(value.isEmpty) return "Enter box weights separated by commas";
                if(value.replaceAll(" ", "").split(",").length != vController.text.replaceAll(" ", "").split(",").length){
                  return "No of weights must be same with number of values";
                }
                return null;
               },
            ),

            TextFormField(
              controller: vController,
              decoration: InputDecoration.collapsed(hintText: "Comma separated values"),
              validator: (value){
                if(value.isEmpty) return "Enter box value separated by commas";
                if(value.replaceAll(" ", "").split(",").length != wController.text.replaceAll(" ", "").split(",").length){
                  return "No of values must be same with number of weights";
                }
                return null;
              },
            ),

            TextFormField(
              controller: weightLimitController,
              decoration: InputDecoration.collapsed(hintText: "Box weight limit"),
              validator: (value){
                if(value.isEmpty) return "Enter box weight limit";
                return null;
              },
            ),
            RaisedButton(onPressed: (){
              if(_formKey.currentState.validate()){
                var weights = wController.text.replaceAll(" ", "").split(",").map((e) => int.parse(e)).toList();
                var values = vController.text.replaceAll(" ", "").split(",").map((e) => int.parse(e)).toList();
                List<Box> boxes = [];
                for(int i = 0; i < weights.length; i++){
                  boxes.add(Box(name: "Box $i", weight: weights[i], value: values[i]));
                }

                Knapsack knapsack = Knapsack(boxes: boxes, weightLimit: int.parse(weightLimitController.text.trim()));
                var ans = knapsack.solve();
                setState(() {
                  answer = ans;
                });
              }
            }),

            Text(answer),

          ],
        ),
      ),
    );
  }
}
