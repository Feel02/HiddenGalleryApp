import 'package:flutter/material.dart';
import 'package:w1/keypad.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

var kColorScheme = ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 27, 238, 210));                                    //light mode colorscheme
var kDarkColorScheme = ColorScheme.fromSeed(seedColor: const Color.fromARGB(214, 16, 195, 171),brightness: Brightness.dark);    //dark mode color scheme

void main() async{
  WidgetsFlutterBinding.ensureInitialized();    
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      darkTheme: ThemeData.dark().copyWith( //themedata.dark()                               //the dark mode theme
        colorScheme: kDarkColorScheme,
        cardTheme: const CardTheme().copyWith(
            color: kDarkColorScheme.primaryContainer,
            margin: const EdgeInsets.fromLTRB(16,8,16,0)
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primaryContainer
          ),
        ),
      ),
      theme:ThemeData().copyWith(                                                           //the light mode theme
        colorScheme: kColorScheme,
        scaffoldBackgroundColor: kColorScheme.secondaryContainer,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.inversePrimary,
          foregroundColor: kColorScheme.inverseSurface,
        ),
        cardTheme: const CardTheme().copyWith(
          color: kColorScheme.primaryContainer,
          margin: const EdgeInsets.fromLTRB(16,8,16,0)
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer
          ),
        ),
      ),
      themeMode: ThemeMode.system, // default                                             //use the system's mode for choosing between the dark and light mode
      home: 
        Scaffold(
          appBar: AppBar(
            title: const Text("Calculator", style: TextStyle(fontSize: 20)),
          ),
          body: 
            const Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 10,),
                Expanded(child:Keypad()),
            ]
          ),
    ),
  ),
  );
}