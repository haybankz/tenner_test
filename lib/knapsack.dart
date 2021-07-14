import 'dart:math';

import 'package:flutter/material.dart';

class Box {
  String name;
  int weight;
  int value;

  Box({@required this.name, @required this.weight, @required this.value});

  String toString() {
    return "\nBox{name: ${this.name}, weight: ${this.weight}, value: ${this.value}}";
  }
}

class Knapsack {
  List<Box> boxes;
  int weightLimit;

  Knapsack({@required this.boxes, @required this.weightLimit});

  String solve() {

    printTime();
    //calculate the sum of the weight of all the boxes
    int totalWeight = boxes.fold(0, (sum, b) => sum + b.weight);

    // if the weight capacity is more than or equal to the total weight of the boxes,
    //that's not a knapsack problem as the bag can contain all the boxes
    //so return the list of boxes and total value of the boxes as the optimized solution
    if (weightLimit >= totalWeight) {
      int totalValue = boxes.fold(0, (sum, element) => sum + element.value);
      printTime();
      return "Boxes: ${boxes.toString()} --- max weight: $totalValue";
    }

    //arrange boxes in ascending order of their weight
    boxes.sort((a, b) => a.weight.compareTo(b.weight));

    //get number of boxes
    int noOfBoxes = boxes.length;

    // we use a 2D matrix to store the max value at each nth item
    //the matrix dimension will be [noOfBoxes][weight]
    List<List<int>> table = List.generate(
        noOfBoxes + 1, (i) => List.filled(weightLimit + 1, 0),
        growable: false);

    //first row is assuming that there are no boxes at all,
    //so there is nothing to put in the bag, so value for all the cells in that row will be zero
    // initialize first row to 0
    for (int i = 0; i <= weightLimit; i++) {
      table[0][i] = 0;
    }

    // we iterate on items
    for (int i = 1; i <= noOfBoxes; i++) {
      // we iterate on each weight limit
      for (int j = 0; j <= weightLimit; j++) {
        //if the value in the cell directly above is greater than the weight, choose the above value
        //as we can agree that the one with the greater value is the optimized solution
        //get the
        if (boxes[i - 1].weight > j) {
          table[i][j] = table[i - 1][j];
        } else {
          // we save the max of both value in the matrix
          table[i][j] = max(
              table[i - 1][j - boxes[i - 1].weight] + boxes[i - 1].value,
              table[i - 1][j]);
        }
      }
    }

    int highestValue = table[noOfBoxes][weightLimit];
    int w = weightLimit;
    List<Box> selectedBoxes = [];

    for (int i = noOfBoxes; i > 0 && highestValue > 0; i--) {
      if (highestValue != table[i - 1][w]) {
        selectedBoxes.add(boxes[i - 1]);
        // we remove items value and weight
        highestValue -= boxes[i - 1].value;
        w -= boxes[i - 1].weight;
      }
    }

    printTime();
    return "Boxes: ${selectedBoxes.toString()} --- max weight: ${table[noOfBoxes][weightLimit]}";
  }
}

//this does not show the boxes, just calculates the optimal value
class Knapsack2 {
  List<Box> boxes;
  int weightLimit;

  Knapsack2({@required this.boxes, @required this.weightLimit});

  // Returns the maximum value that can be put in a bag of
  // capacity weightLimit
  int knapSack(int weightLimit, List<int> weights, List<int> values, int row) {
    if (row == 0 || weightLimit == 0) return 0;

    // If weight of the nth item is greater than bag capacity weightLimit,
    // then this item cannot be included in the optimal solution
    if (weights[row - 1] > weightLimit) {
      // print(weights[row-1]);
      return knapSack(weightLimit, weights, values, row - 1);
    } else {
      // Return the maximum of two cases:
      // (1) nth item included
      // (2) not included
      return max(
        knapSack(weightLimit, weights, values, row - 1),
        values[row - 1] +
            knapSack(weightLimit - weights[row - 1], weights, values, row - 1),
      );
    }
  }

  String solve() {
    printTime();


    int totalValue = boxes.fold(0, (sum, e) => sum + e.weight);
    if(totalValue  <= weightLimit){
      return "$totalValue";
    }
    List<int> weights = boxes.map((e) => e.weight).toList();
    List<int> values = boxes.map((e) => e.value).toList();

    var str = "${knapSack(weightLimit, weights, values, boxes.length)}";
    printTime();
    return str;
  }
}


printTime(){
  print(DateTime.now().toIso8601String());
}
