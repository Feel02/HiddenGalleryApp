import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class PhotoSelect extends StatefulWidget{
  const PhotoSelect({super.key});


  @override
  State<PhotoSelect> createState() {
    return _PhotoSelectState();
  }
}

class _PhotoSelectState extends State<PhotoSelect>{

  final ref = FirebaseDatabase.instance.ref("photoLinks");
  final url = Uri.https('calculator-9e83e-default-rtdb.firebaseio.com','photolinks.json');

  List<String> listImages = [];
  Widget? content; 

  late final path;

  Future selectFile() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 100);
    final pickedImageFile = File(pickedImage!.path);
    final storageRef = FirebaseStorage.instance.ref().child("user_images").child(pickedImage.name);
    await storageRef.putFile(pickedImageFile);
    String temp = await storageRef.getDownloadURL();
    await http.post(url,
      headers: {
        'Content-type' : 'application/json',
      },
      body:json.encode({
        "link" : temp ,
      },),
    );
    loadFile();
  }

  void loadFile() async {
    setState(() {
      content = const Center(child: CircularProgressIndicator(),); 
    });
    
    listImages = [];
    final response = await http.get(url);
    Map<String,dynamic> listData;

    try{
      listData  = json.decode(response.body);
    } catch (_) {
      listData = {} ;
    }
    
    for(final item in listData.entries){
      listImages.add(item.value.values.first.toString());
    }
    showFile();
  }

  void showFile(){
    setState(() {
      Widget temp;
      if(listImages.isNotEmpty){
        temp = 
          Center(
            child: 
              Scaffold(
                body: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  crossAxisCount: 3,
                ),
                itemCount: listImages.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => Scaffold(
                            appBar: AppBar(
                              title: const Text("Hidden Gallery"),
                              actions: [
                                IconButton(onPressed: (){
                                   downloadPicture(listImages[index]);    
                                }, icon: const Icon(Icons.download))
                              ],
                            ),
                            body: 
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: 
                                      Container(
                                        decoration: 
                                          BoxDecoration(
                                            image: DecorationImage(image: NetworkImage(listImages[index]),fit: BoxFit.contain,),
                                          ),
                                      ),
                                  ),
                                  //ElevatedButton(onPressed: (){}, child: Text("Download",style: TextStyle(fontSize: 25),))
                                ],
                              )
                              
                          ),
                        )
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(listImages[index]),
                        ),
                      ),
                    ),
                  );
                },
                ),    
            ),
          );
      }
      else{
        temp = const Center(child: Text("No item(s) found. What about \n adding the first one?",style: TextStyle(fontSize: 24),));
      }
      content = temp;
    });
  }

  void downloadPicture(String download) async {
    var rng = Random();
    var name = rng.nextInt(100000);

    await FileDownloader.downloadFile(

    url: download,
    name: name.toString(),
    onDownloadCompleted: (path) {
        final File file = File(path);
        print(file);
    });
  }

  @override
  void initState(){
    loadFile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hidden Gallery'),
        actions: [
          IconButton(onPressed: selectFile, icon: Icon(Icons.add,color: Colors.red[400],)),
        ],
      ),
      body: content,
        
    );
  }

}