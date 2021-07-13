import 'dart:math';

import 'package:flutter/material.dart';

class Box {
  String name;
  int weight;
  int value;

  Box({@required this.name, @required this.weight, @required this.value});

  String toString(){
    return "\nBox{name: ${this.name}, weight: ${this.weight}, value: ${this.value}}";
  }

}

class Knapsack{

  List<Box> boxes;
  int weightLimit;

  Knapsack({@required this.boxes, @required this.weightLimit});

  String solve(){
    int noOfBoxes = boxes.length;
    // we use a 2D matrix to save the max value at each nth item
    List<List<int>> table = List.generate(noOfBoxes + 1, (i) =>  List.filled(weightLimit + 1, 0), growable: false);

    print("here1");
    // initialize first row to 0
    for (int i = 0; i <= weightLimit; i++){
      table[0][i] = 0;
    }

    print("here2");
    // we iterate on items
    for (int i = 1; i <= noOfBoxes; i++) {
      // we iterate on each weight limit
      for (int j = 0; j <= weightLimit; j++) {
        print("insert in matrix[$i][$j]");
        if (boxes[i - 1].weight > j){
          table[i][j] = table[i-1][j];
        }
        else{
          // we save the max of both value in the matrix
          table[i][j] = max(table[i-1][j - boxes[i-1].weight]
              + boxes[i-1].value, table[i-1][j]);
        }
      }
    }


    int highestValue = table[noOfBoxes][weightLimit];
    int w = weightLimit;
    List<Box> selectedBoxes = [];

    for (int i = noOfBoxes; i > 0  &&  highestValue > 0; i--) {
      if (highestValue != table[i-1][w]) {
        selectedBoxes.add(boxes[i-1]);
        // we remove items value and weight
        highestValue -= boxes[i-1].value;
        w -= boxes[i-1].weight;
      }
    }

    return "Boxes: ${selectedBoxes.toString()} --- max weight: ${table[noOfBoxes][weightLimit]}";

  }
}

// void main(){
//   List<Box> boxes = [
//     Box(name: "box1", weight: 2, value: 1),
//     Box(name: "box2", weight: 3, value: 2),
//     Box(name: "box3", weight: 4, value: 5),
//     Box(name: "box4", weight: 5, value: 6),
// //                     Box(name: "box5", weight: 4, value: 10),
//   ];
//
//   Knapsack knapsack = Knapsack(boxes: boxes, weightLimit: 8);
//   knapsack.solve();
// }