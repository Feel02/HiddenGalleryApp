import 'package:flutter/material.dart';
import 'package:w1/calculator.dart';

class Keypad extends StatefulWidget{
  const Keypad({super.key});

  @override
  State<Keypad> createState() => _KeypadState();
}

class _KeypadState extends State<Keypad> {
  String inputs = "";                                                           //calculator's main input holder string

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;                         //height of the device
    height -= height*0.745842;                                                  //programs widgets' size
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(height: height/2,),
        SingleChildScrollView(                                                  //horizontal scrollable input area
          //for horizontal scrolling
          scrollDirection: Axis.horizontal,
          child: Text(inputs, style: const TextStyle(fontSize: 40,),),
        ),
        SizedBox(height: height/2),
        Expanded(                                                               //main grid for the buttonsdd
          child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(15),
            crossAxisSpacing: 20,
            mainAxisSpacing: 8,
            crossAxisCount: 4,
            children: [
              TextButton(onPressed: (){setState(() {inputs+="(";});}, child: const Text("(",style: TextStyle(fontSize: 40),),),
              TextButton(onPressed: (){setState(() {inputs+=")";});}, child: const Text(")",style: TextStyle(fontSize: 40),),),
              TextButton(onPressed: (){setState(() {inputs+="%";});}, child: const Text("%",style: TextStyle(fontSize: 40),),),
              TextButton(
                onPressed: (){ setState(() {
                    if (inputs.isNotEmpty) { inputs = inputs.substring(0, inputs.length - 1); } },);}, 
                onLongPress:(){ setState(() {
                    inputs = ""; },);},
                child: const Text("<-",style: TextStyle(fontSize: 40),),),
              TextButton(onPressed: (){setState(() {inputs+="7";});}, child: const Text("7",style: TextStyle(fontSize: 50),),),
              TextButton(onPressed: (){setState(() {inputs+="8";});}, child: const Text("8",style: TextStyle(fontSize: 50),),),
              TextButton(onPressed: (){setState(() {inputs+="9";});}, child: const Text("9",style: TextStyle(fontSize: 50),),),
              TextButton(onPressed: (){setState(() {inputs+="/";});}, child: const Text("/",style: TextStyle(fontSize: 40),),),
              TextButton(onPressed: (){setState(() {inputs+="4";});}, child: const Text("4",style: TextStyle(fontSize: 50),),),
              TextButton(onPressed: (){setState(() {inputs+="5";});}, child: const Text("5",style: TextStyle(fontSize: 50),),),
              TextButton(onPressed: (){setState(() {inputs+="6";});}, child: const Text("6",style: TextStyle(fontSize: 50),),),
              TextButton(onPressed: (){setState(() {inputs+="X";});}, child: const Text("x",style: TextStyle(fontSize: 40),),),
              TextButton(onPressed: (){setState(() {inputs+="1";});}, child: const Text("1",style: TextStyle(fontSize: 50),),),
              TextButton(onPressed: (){setState(() {inputs+="2";});}, child: const Text("2",style: TextStyle(fontSize: 50),),),
              TextButton(onPressed: (){setState(() {inputs+="3";});}, child: const Text("3",style: TextStyle(fontSize: 50),),),
              TextButton(onPressed: (){setState(() {inputs+="-";});}, child: const Text("-",style: TextStyle(fontSize: 40),),),
              TextButton(onPressed: (){setState(() {inputs+=".";});}, child: const Text(".",style: TextStyle(fontSize: 40),),),
              TextButton(onPressed: (){setState(() {inputs+="0";});}, child: const Text("0",style: TextStyle(fontSize: 50),),),
              TextButton(onPressed: (){setState(() {inputs = calculate(inputs,context);});}, child: const Text("=",style: TextStyle(fontSize: 50),),),
              TextButton(onPressed: (){setState(() {inputs+="+";});}, child: const Text("+",style: TextStyle(fontSize: 50),),),
            ],
          ),
        ),
      ],
    );
  }
}