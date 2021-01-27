import 'dart:io';
import 'dart:typed_data';
import 'dart:async';

import 'package:camera_app/Post/CreatePostPage.dart';
import 'package:camera_app/SecondScreen.dart';
import 'package:camera_app/filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as imageLib;
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path/path.dart';
import 'dart:ui' as ui;

void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false, home: new MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  final GlobalKey _globalKey = GlobalKey();
  final GlobalKey _scaffoldKey = GlobalKey();
  Asset selectedAsset;

  @override
  void initState() {
    super.initState();
  }

  Future<void> convertWidgetToImage() async {
    RenderRepaintBoundary repaintBoundary = _globalKey.currentContext.findRenderObject();
    ui.Image boxImage = await repaintBoundary.toImage(pixelRatio: 1);
    ByteData byteData = await boxImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List uint8list = byteData.buffer.asUint8List();

    // Navigator.of(_globalKey.currentContext).push(MaterialPageRoute(builder: (context){
    //   return SecondScreen(imageData: uint8list,);
    // }));
  }

  Widget buildGridView() {

    if(images.length > 0){
      Asset asset = images[0];
      selectedAsset = asset;
      return AssetThumb(
        asset: asset,
        height: 700,
        width: 500,
      );

    }else{
      displayNoPhoto();
    }
  }

  displayNoPhoto(){
    return Container(
      width: double.infinity,
        color: Colors.grey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo, size: 200,),
            Text('Select Photo', style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.w400, fontSize: 25),)
          ],
        ),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Pikchilly",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: new AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Photo Editor'),
          actions: [
            IconButton(icon: Icon(Icons.check), onPressed: (){convertWidgetToImage();})
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera),
          onPressed: (){createPost(context);},//loadAssets,
        ),
        body: SafeArea(
          child: images.isEmpty ? displayNoPhoto() : Column(
            children: [
              RepaintBoundary(
                key: _globalKey,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: size.width,
                    maxHeight: size.height,
                  ),
                  child: buildGridView(),
                  //child: buildGridView(),
                ),
              ),

            ],
          ),
        ),
    );
  }

  void createPost(mContext) {
    Navigator.of(mContext).push(MaterialPageRoute(builder: (context){
      return CreatePostPage();
    }));
  }
}