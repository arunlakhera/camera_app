import 'dart:io';

import 'package:camera_app/SecondScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  File image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Photo Editor'),
        actions: [
          IconButton(
              icon: Icon(Icons.check),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return SecondScreen(imageData: image);
                }));
              },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        heroTag: 'takephototag',
        child: Icon(Icons.camera),
        onPressed: (){
          takeImage(context);
        },
      ),
      body: SafeArea(
        child: image == null ? displayNoPhoto() :
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.file(
            image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  displayNoPhoto() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo, size: 200, color: Colors.white70,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Select Photo',
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                  fontWeight: FontWeight.w400
              ),
            ),
          ),
        ],
      ),
    );
  }

  takeImage(BuildContext mContext) {
    return Alert(
      context: context,
      type: AlertType.none,
      title: 'Select Photo',
      //desc: 'Please allow access to Photos Gallery from Phone settings',
      style: AlertStyle(
        backgroundColor: Color(0xFFE6E6EA),
      ),
      content: Column(
        children: [
          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width / 2,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: FlatButton.icon(
              onPressed: captureImageWithCamera,
              icon: Icon(Icons.camera_alt, color: Colors.white,),
              label: Text('Using Camera', style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width / 2,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: FlatButton.icon(
              onPressed: pickImageFromGallery,
              icon: Icon(Icons.photo, color: Colors.white,),
              label: Text('From Gallery', style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ),
        ],
      ),
      buttons: [
        // DialogButton(
        //   width: MediaQuery.of(context).size.width / 2,
        //   color: Colors.red.shade900,
        //   child: Text(
        //     'Cancel',
        //     style: TextStyle(color: Colors.white, fontSize: 16),
        //   ),
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        // ),
      ],
    ).show();
  }

  captureImageWithCamera() async {

    Navigator.pop(context);

    //Check fir Camera Permission
    var cameraPermission = await getCameraPermissions();
    var storagePermission = await getStoragePermissions();

    //var microphonePermission = await getMicrophonePermissions();
    //var notificationPermission = await getNotificationPermissions();

    if((cameraPermission.isDenied || cameraPermission.isRestricted || cameraPermission.isPermanentlyDenied) &&
        (storagePermission.isDenied || storagePermission.isRestricted || storagePermission.isPermanentlyDenied)){
      showAlert(
        mContext: context,
        alertType: AlertType.info,
        title: 'Access!',
        description: 'Please allow access to Camera from Phone settings',
        btnText: 'Ok',
      );
    }else{
      try{
        final pickedFile = await picker.getImage(
          source: ImageSource.camera,
          // maxWidth: 680,
          // maxHeight: 970,
          imageQuality: 30,
        ).catchError((err){
          print('Error while getting image from gallery');
        });
        setState(() {
          this.image = File(pickedFile.path);
        });
      }catch(err){
        print("CAMERA---->" + err);
      }
    }
  }

  pickImageFromGallery() async {

    Navigator.pop(context);

    var photosPermission = await getPhotosPermissions();
    var storagePermission = await getStoragePermissions();
    var mediaPermission = await getMediaPermissions();

    if((photosPermission.isDenied || photosPermission.isRestricted || photosPermission.isPermanentlyDenied) &&
        (storagePermission.isDenied || storagePermission.isRestricted || storagePermission.isPermanentlyDenied) &&
        (mediaPermission.isDenied || mediaPermission.isRestricted || mediaPermission.isPermanentlyDenied)
    ){

      showAlert(
        mContext: context,
        alertType: AlertType.info,
        title: 'Access!',
        description: 'Please allow access to Photos Gallery from Phone settings',
        btnText: 'Ok',
      );
    }else{
      final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        // maxWidth: 680,
        // maxHeight: 970,
        imageQuality: 30,
      );
      setState(() {
        this.image = File(pickedFile.path);
      });
    }
  }

  Future<PermissionStatus> getCameraPermissions() async{

    var status = await Permission.camera.status;
    if (status.isUndetermined || status.isDenied) {
      await Permission.camera.request();

    }

    return await Permission.camera.status;

  }

  Future<PermissionStatus> getStoragePermissions() async{

    var status = await Permission.storage.status;
    if (status.isUndetermined || status.isDenied) {
      await Permission.storage.request();
    }

    return await Permission.storage.status;

  }

  Future<PermissionStatus> getPhotosPermissions() async{

    var status = await Permission.photos.status;
    if (status.isUndetermined || status.isDenied) {
      Permission.photos.request();
    }

    return await Permission.microphone.status;

  }

  Future<PermissionStatus> getMediaPermissions() async{

    var status = await Permission.accessMediaLocation.status;
    if (status.isUndetermined || status.isDenied) {
      Permission.accessMediaLocation.request();
    }
    return await Permission.accessMediaLocation.status;

  }

  showAlert({mContext, alertType, title, description, btnText,}){
    return Alert(
      context: mContext,
      type: alertType,
      title: title,
      desc: description,
      style: AlertStyle(
          backgroundColor: Color(0xFFE6E6EA),
      ),
      buttons: [
        DialogButton(
          child: Text(
            btnText,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.of(mContext).pop();
          },
          width: 120,
        )
      ],
    ).show();
  }
}
