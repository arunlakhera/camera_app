import 'dart:io';
import 'dart:typed_data';

import 'package:camera_app/ThirdScreen.dart';
import 'package:camera_app/filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

class SecondScreen extends StatefulWidget {
  File imageData;

  SecondScreen({Key key, this.imageData}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final List<List<double>> filters = [
    Original,
    Sepium,
    Sepia,
    Retro,
    Reverse,
    Milky,
    Winter,
    Purple,
    Yellow
  ];
  bool filtersFlag = true;
  bool stickersFlag = false;
  bool sizeFlag = false;

  final GlobalKey _globalKey = GlobalKey();
  int selectedIndex = 0;
  double top = 0.0;
  double left = 0.0;

  // Photo Dimension Variable
  BoxFit photoDimension = BoxFit.fill;
  Color photoDimensionColor = Colors.grey.shade100;//Colors.white.withOpacity(0.5);
  Color photoDimensionColorSelected = Colors.greenAccent;//.withOpacity(0.8);
  bool photoHeightFlag = false;
  bool photoWidthFlag = false;
  bool photoZoomFlag = false;
  bool photoRotateLeftFlag = true;
  bool photoRotateRightFlag = false;
  int rotatePhotoDegree = 0;
  bool noDimensionFlag = false;
  bool fitScreenFlag = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> convertWidgetToImage() async {
    RenderRepaintBoundary repaintBoundary =
        _globalKey.currentContext.findRenderObject();
    ui.Image boxImage = await repaintBoundary.toImage(pixelRatio: 3);
    ByteData byteData =
        await boxImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List uint8list = byteData.buffer.asUint8List();

    Navigator.of(_globalKey.currentContext)
        .push(MaterialPageRoute(builder: (context) {
      return ThirdScreen(
        imageData: uint8list,
      );
    }));
  }

  showDots({double ri, double le, double to, double bo}) {
    return Positioned(
      top: to,
      bottom: bo,
      right: ri,
      left: le,
      child: Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.5),
            shape: BoxShape.circle,
            gradient: LinearGradient(
                colors: [
                  Colors.red.shade300,
                  Colors.red.shade400,
                  Colors.red.shade500,
                  Colors.red.shade600,
                ]
            )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Post'),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                convertWidgetToImage();
              })
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                RepaintBoundary(
                  key: _globalKey,
                  child: Container(
                    width: size.width,
                    height: size.height * 0.5,
                    alignment: Alignment.center,
                    child: Stack(
                      children: [

                        ColorFiltered(
                          colorFilter:
                              ColorFilter.matrix(filters[selectedIndex]),
                          child: RotatedBox(
                            quarterTurns: rotatePhotoDegree,
                            child: Image.file(
                              widget.imageData,
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              fit: photoDimension,
                            ),
                          ),
                        ),
                        showSticker(),
                        // Opacity(
                        //   opacity: 0.5,
                        //   child: Image.asset(
                        //       'assets/images/filter1.png',
                        //       fit: BoxFit.fill,
                        //       height: MediaQuery.of(context).size.height,
                        //       width: MediaQuery.of(context).size.width,
                        //   ),
                        // ),
                        showDots(to: 350,bo: 40, ri: 0, le: 40),
                        showDots(to: 330,bo: 55, ri: 10, le: 75),
                        showDots(to: 310,bo: 70, ri: 20, le: 100),
                        showDots(to: 290,bo: 95, ri: 30, le: 175),
                        showDots(to: 250,bo: 100, ri: 0, le: 240),
                        showDots(to: 230,bo: 65, ri: 0, le: 275),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                InkWell(
                  highlightColor: Colors.black,
                  onTap: () {
                    setState(() {
                      filtersFlag = true;
                      stickersFlag = false;
                      sizeFlag = false;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 5),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: filtersFlag ? Colors.deepOrange : Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Filters',
                      style: TextStyle(
                          fontSize: filtersFlag ? 16 : 14,
                          color: filtersFlag
                              ? Colors.white
                              : Colors.grey.shade500,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  highlightColor: Colors.black,
                  onTap: () {
                    setState(() {
                      stickersFlag = true;
                      filtersFlag = false;
                      sizeFlag = false;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: stickersFlag ? Colors.deepOrange : Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Text(
                      'Stickers',
                      style: TextStyle(
                          fontSize: stickersFlag ? 16 : 14,
                          color: stickersFlag
                              ? Colors.white
                              : Colors.grey.shade500,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  highlightColor: Colors.black,
                  onTap: () {
                    setState(() {
                      stickersFlag = false;
                      filtersFlag = false;
                      sizeFlag = true;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: sizeFlag ? Colors.deepOrange : Colors.grey.shade700,//Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Size',
                      style: TextStyle(
                          fontSize: sizeFlag ? 18 : 14,
                          color: sizeFlag
                              ? Colors.white
                              : Colors.grey.shade500,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Visibility(
              visible: filtersFlag,
              child: Container(
                width: double.infinity,
                height: size.height / 3,
                padding: EdgeInsets.only(left: 5, right: 5),
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  children: List.generate(filters.length, (index) {
                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: ColorFiltered(
                          colorFilter: ColorFilter.matrix(filters[index]),
                          child: Image.file(widget.imageData, width: size.width, fit: BoxFit.fill,),//Image.memory(widget.imageData, width: size.width, fit: BoxFit.fill,)
                      ),
                    );
                  }),
                ),
                // child: ListView.builder(
                //   scrollDirection: Axis.horizontal,
                //   itemCount: filters.length,
                //   itemBuilder: (context, index) {
                //     return GestureDetector(
                //       onTap: () {
                //         setState(() {
                //           selectedIndex = index;
                //         });
                //       },
                //       child: Card(
                //         color: selectedIndex == index
                //             ? Colors.deepOrange
                //             : Colors.white,
                //         child: Container(
                //           width: selectedIndex == index ? 100 : 80,
                //           margin: EdgeInsets.all(3),
                //           decoration: BoxDecoration(
                //             color: Colors.blue,
                //             borderRadius: BorderRadius.circular(10),
                //           ),
                //           child: ColorFiltered(
                //             colorFilter: ColorFilter.matrix(filters[index]),
                //             child: Image.file(
                //               widget.imageData,
                //               width: size.width,
                //               fit: BoxFit.fill,
                //             ), //Image.memory(widget.imageData, width: size.width, fit: BoxFit.fill,)
                //           ),
                //         ),
                //       ),
                //     );
                //   },
                // ),
              ),
            ),
            Visibility(
                visible: stickersFlag,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          double top = 100.0;
                          double left = 100.0;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          'Hello Yeah!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ),
            Visibility(
                visible: sizeFlag,
                child: loadPhotoDimensionButtons(size)
            ),
          ],
        ),
      ),
    );
  }

  showSticker() {
    return Visibility(
      visible: stickersFlag,
      child: Draggable(
        child: Container(
          padding: EdgeInsets.only(top: top, left: left),
          child: dragItem(),
        ),
        feedback: Container(
          padding: EdgeInsets.only(top: top, left: left),
          child: dragItem(),
        ),
        childWhenDragging: Container(
          padding: EdgeInsets.only(top: top, left: left),
          child: dragItem(),
        ),
        onDragCompleted: () {},
        onDragEnd: (drag) {
          setState(() {
            top = (top + drag.offset.dy < 0 ||
                    top + drag.offset.dy >
                        MediaQuery.of(context).size.height * 0.7)
                ? 0
                : top + drag.offset.dy;
            left = (left + drag.offset.dx < 0 ||
                    left + drag.offset.dx > MediaQuery.of(context).size.width)
                ? 0
                : left + drag.offset.dx;
          });
        },
      ),
    );
  }

  dragItem() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(20)),
      child: Text(
        'Hello Yo!',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  loadPhotoDimensionButtons(size) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        height: size.height / 10 ,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                setState(() {
                  noDimensionFlag = true;
                  rotatePhotoDegree = 0;
                  photoHeightFlag = false;
                  photoWidthFlag = false;
                  photoZoomFlag = false;
                  photoRotateLeftFlag = false;
                  photoRotateRightFlag = false;
                  photoDimension = BoxFit.fill;
                  fitScreenFlag = false;
                });
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: noDimensionFlag
                      ? photoDimensionColorSelected
                      : photoDimensionColor,
                ),
                child: Text('None', style: TextStyle(fontSize: 10, color: noDimensionFlag ? Colors.white : Colors.black)),
              ),
            ),
            SizedBox(width: 10),

            GestureDetector(
              onTap: (){
                setState(() {
                  photoDimension = BoxFit.fitHeight;
                  noDimensionFlag = false;
                  photoHeightFlag = true;
                  photoWidthFlag = false;
                  photoZoomFlag = false;
                  photoRotateLeftFlag = false;
                  photoRotateRightFlag = false;
                  fitScreenFlag = false;
                });
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: photoHeightFlag
                      ? photoDimensionColorSelected
                      : photoDimensionColor,
                ),
                child: Icon(
                  Icons.height,
                  color: photoHeightFlag ? Colors.white : Colors.black,
                  size: photoHeightFlag ? 25 : 15,
                ),
              ),
            ),

            SizedBox(width: 10),

            GestureDetector(
              onTap: (){
                setState(() {
                  photoDimension = BoxFit.fitWidth;
                  noDimensionFlag = false;
                  photoHeightFlag = false;
                  photoWidthFlag = true;
                  photoZoomFlag = false;
                  photoRotateLeftFlag = false;
                  photoRotateRightFlag = false;
                  fitScreenFlag = false;
                });
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: photoWidthFlag
                      ? photoDimensionColorSelected
                      : photoDimensionColor,
                ),
                child: Icon(
                  Icons.code,
                  color: photoWidthFlag ? Colors.white : Colors.black,
                  size: photoWidthFlag ? 25 : 15,
                ),
              ),
            ),

            SizedBox(width: 10),

            GestureDetector(
              onTap: (){
                setState(() {
                  photoDimension = BoxFit.cover;
                  noDimensionFlag = false;
                  photoHeightFlag = false;
                  photoWidthFlag = false;
                  photoZoomFlag = true;
                  photoRotateLeftFlag = false;
                  photoRotateRightFlag = false;
                  fitScreenFlag = false;
                });
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: photoZoomFlag
                      ? photoDimensionColorSelected
                      : photoDimensionColor,
                ),
                child: Icon(
                  Icons.zoom_out_map,
                  color: photoZoomFlag ? Colors.white : Colors.black,
                  size: photoZoomFlag ? 25 : 15,
                ),
              ),
            ),

            SizedBox(width: 10),

            GestureDetector(
              onTap: (){
                setState(() {
                  noDimensionFlag = false;
                  photoHeightFlag = false;
                  photoWidthFlag = false;
                  photoZoomFlag = false;
                  photoRotateLeftFlag = false;
                  photoRotateRightFlag = false;
                  fitScreenFlag = true;
                  photoDimension = BoxFit.fill;
                });
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: fitScreenFlag
                      ? photoDimensionColorSelected
                      : photoDimensionColor,
                ),
                child: Icon(
                  Icons.fit_screen,
                  color: fitScreenFlag ? Colors.white : Colors.black,
                  size: fitScreenFlag ? 25 : 15,
                ),
              ),
            ),

            SizedBox(width: 10),

            GestureDetector(
              onTap: (){
                setState(() {
                  rotatePhotoDegree = rotatePhotoDegree - 45;
                  noDimensionFlag = false;
                  photoHeightFlag = false;
                  photoWidthFlag = false;
                  photoZoomFlag = false;
                  photoRotateLeftFlag = true;
                  photoRotateRightFlag = false;
                  fitScreenFlag = false;
                });
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: photoRotateLeftFlag
                      ? photoDimensionColorSelected
                      : photoDimensionColor,
                ),
                child: Icon(
                  Icons.rotate_left,
                  color: photoRotateLeftFlag ? Colors.white : Colors.black,
                  size: photoRotateLeftFlag ? 25 : 15,
                ),
              ),
            ),

            SizedBox(width: 10),

            GestureDetector(
              onTap: (){
                setState(() {
                  rotatePhotoDegree = rotatePhotoDegree + 45;
                  noDimensionFlag = false;
                  photoHeightFlag = false;
                  photoWidthFlag = false;
                  photoZoomFlag = false;
                  photoRotateLeftFlag = false;
                  photoRotateRightFlag = true;
                  fitScreenFlag = false;
                });
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: photoRotateRightFlag
                      ? photoDimensionColorSelected
                      : photoDimensionColor,
                ),
                child: Icon(
                  Icons.rotate_right,
                  color: photoRotateRightFlag ? Colors.white : Colors.black,
                  size: photoRotateRightFlag ? 25 : 15,
                ),
              ),
            ),

            SizedBox(width: 10),

          ],
        ),
      ),
    );
  }
}

class DragItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(
      IconData(57744, fontFamily: 'MaterialIcons'),
      size: 50,
      color: Colors.orange,
    );
  }
}
