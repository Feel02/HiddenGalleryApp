import 'package:flutter/material.dart';
import 'package:w1/photoselect.dart';

bool isEndsWithZero = false;                                                  //checks if the calculated number ends with 0 like 50.0

String calculate(String infixExpression,BuildContext context) {

  if(infixExpression == "112233"){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const PhotoSelect()),);
    return "";
  }

  String postfixExpression = convertToPostfix(infixExpression);
  double calculatedValue = evaluatePostfix(postfixExpression);
  if(isEndsWithZero){                                                         //if its ends with 0
    return calculatedValue.toInt().toString();                                //just return the number as an int.toString  
  }
  else{                                                                       //else, check if the floating numbers longer than 4 digit
    if(calculatedValue.toString().length - calculatedValue.toInt().toString().length > 4){
      return calculatedValue.toStringAsPrecision(calculatedValue.toInt().toString().length+4).replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
    }                                                                         //if so return the input as a (number.XXXX) like 5.3212.toString
    return calculatedValue.toString();                                        //else directly return the number.toString
  }
}

String convertToPostfix(String infixExpression) {
  String postfixExpression = "";
  List<String> stack = [];
  
  Map<String, int> precedence = {
    '+': 1,
    '-': 1,
    'X': 2,
    '/': 2,
    '%': 2,
  };

  for (int i = 0;i<infixExpression.length;i++) {                              //iterate every char in the string one at a time
    var token = infixExpression[i];
    if (isNumber(token)){                                                     //if it's a number check if it's only 1 digit or there is more digit or .
      postfixExpression += token;                                             //while so put the following digits or . to next to each other   
      while(i+1 != infixExpression.length && (isNumber(infixExpression[i+1]) || infixExpression[i+1] == '.')){
        postfixExpression += infixExpression[i+1];
        i++;
      }
      postfixExpression += ' ';                                               //lastly put space to postfix
    }
    else if (token == '.'){                                                   //if it's a dot check if it's only has following 1 digit or there is more digit
      postfixExpression += token;                                             //while so put the following digits to next to each other   
      while(i+1 != infixExpression.length && isNumber(infixExpression[i+1])){
        postfixExpression += infixExpression[i+1];
        i++;
      }
      postfixExpression += ' ';                                               //lastly put space to postfix
    }  
    else if (token == '(') {                                                  //if it's a left parentheses add to the stack
      stack.add(token);
    } 
    else if (token == ')') {                                                  //if it's a right parentheses 
      while (stack.isNotEmpty && stack.last != '(') {                         //while the stack isn't empty add the last element to the postfix
        postfixExpression += '${stack.removeLast()} ';
      }
      if (stack.isNotEmpty && stack.last == '(') {                            //and discard the left parentheses from the stack either 
        stack.removeLast(); 
      }
    } 
    else if (isOperator(token)) {                                             //if it's a token check for the predence then put it in to the postfix
      while (stack.isNotEmpty && stack.last != '(' && precedence[stack.last]! >= precedence[token]!) {
        postfixExpression += '${stack.removeLast()} ';
      }
      stack.add(token);
    }
  }

  while (stack.isNotEmpty) {                                                  //while the stack isn't empty add everyting to postfix
    postfixExpression += '${stack.removeLast()} ';  
  }

  return postfixExpression.trim();
}

double evaluatePostfix(String postfixExpression) {
  List<double> stack = [];

  for (int i = 0;i<postfixExpression.length;i++) {                            //iterate every char in the postfix string
    if (isNumber(postfixExpression[i])) {                                     //if it's a number check if it's only 1 digit or there is more digit or .
      String temp = "";                                                       //while so put the following digits or . to next to each other 
      temp += postfixExpression[i];
      while(i+1 != postfixExpression.length && (isNumber(postfixExpression[i+1]) || postfixExpression[i+1] == '.')){
        temp += postfixExpression[i+1];
        i++;
      }
      stack.add(double.parse(temp));                                          //add the double value to stack
    } 
    else if (isOperator(postfixExpression[i])) {                              //if it's operator do the calculation
      double operand2 = stack.removeLast();                                   //and add the result to the stack again
      double operand1 = stack.removeLast();
      double result = performOperation(postfixExpression[i], operand1, operand2);
      stack.add(result);
    }
    else if(postfixExpression[i] == '.'){                                     //if it's a dot check if it's only 1 digit or there is more digit
      String temp = "0";                                                      //while so put the following digits to next to each other 
      temp += postfixExpression[i];
      while(i+1 != postfixExpression.length && isNumber(postfixExpression[i+1])){
        temp += postfixExpression[i+1];
        i++;
      }
      stack.add(double.parse(temp));                                          //add the double value to stack
    }
  }
  double calculatedValue = stack.first;                                       //this part for checking if the number ends with 0 or not
  if(calculatedValue.toString() == calculatedValue.toInt().toStringAsPrecision(calculatedValue.toInt().toString().length+1)){
    isEndsWithZero = true;                                                    //if the number is equal to the number's integer form with add .0 at the end 
  }                                                                           //it means number ends with 0
  else{
    isEndsWithZero = false;                                                   //else it is not
  }
  return calculatedValue;
}

bool isNumber(String token) {
  return double.tryParse(token) != null;
}

bool isOperator(String token) {
  return token == '+' || token == '-' || token == 'X' || token == '/' || token == '%';
}

double performOperation(String operator, double operand1, double operand2) {
  switch (operator) {
    case '+':
      return operand1 + operand2;
    case '-':
      return operand1 - operand2;
    case 'X':
      return operand1 * operand2;
    case '/':
      return operand1 / operand2;
    case '%':
      return operand1 % operand2;
    default:
      throw ArgumentError('Invalid operator: $operator');
  }
}
