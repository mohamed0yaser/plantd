import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:simple_progress_bar/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:plantd/main.dart';
import 'package:image_picker/image_picker.dart';


class Res extends StatefulWidget {

  @override
  _ResState createState() => _ResState();
}

class _ResState extends State<Res> {
  late File img;
  late File _image;
  late double _imageHeight;
  late double _imageWidth;

  late List _recognitions;
  void initState(){
    super.initState();
  }


  Future Recognize(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.05,
      imageMean: 0,
      imageStd: 255,
    );
    setState(() {
      _recognitions = recognitions!;
    });
  }
  Future<Null> getImage({required ImageSource source}) async {
    // ignore: deprecated_member_use
    final ImagePicker image = (await getImage(source: ImageSource.gallery)) as ImagePicker;
    Recognize(image as File);
    Image img = new Image.file(image as File);
    Completer<ImageInfo> completer = Completer();


    img.image
        .resolve(new ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info);
    }));
    ImageInfo imageInfo = await completer.future;
    setState(() {
      this._image = image as File;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(child: Container(height: 300,width: double.infinity, child: Image.file(img,width: double.infinity))),
const SizedBox(height: 25),
            Container(

              child: const Text('Results:',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold
              ),),
            ),
              const SizedBox(height: 25),
               ProgressBar(
                padding: 5,
                barColor: const Color(0XFF6B2737),
                barHeight: 50,
                barWidth: MediaQuery.of(context).size.width,
                numerator: 6,
                denominator: 8,
                title: 'Prediction',
                showRemainder: false,
                dialogTextStyle:  const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                titleStyle:  TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0XFF3C6E71)),
                boarderColor: Colors.grey,
              )
              ,const SizedBox(height: 25),
              new ProgressBar(
                padding: 5,
                barColor: const Color(0XFFFFA187),
                barHeight: 15,
                barWidth: MediaQuery.of(context).size.width,
                numerator: 23,
                denominator: 25,
                title: 'Confidence',
                dialogTextStyle: new TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                titleStyle: new TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0XFF3C6E71)),
                boarderColor: Colors.grey,
              )
             ]),
      ),
    );
  }
  
}
