import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_exif_plugin/tags.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_exif_plugin/flutter_exif_plugin.dart' as dd;

class ImageToGps extends StatefulWidget {
  ImageToGps({Key? key}) : super(key: key);

  @override
  State<ImageToGps> createState() => _ImageToGpsState();
}

class _ImageToGpsState extends State<ImageToGps> {
  File? _image;

  Future getImage() async {
    final _image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_image == null) return;

    final imageTemp = File(_image.path);
    setState(() {
      this._image = imageTemp;
    });
    getGpsData();
  }

  getGpsData() async {
    Position position = await _determinedPosition();

    // final exif = dd.FlutterExif.fromBytes(await _image!.readAsBytes());
    // print(exif.getLatLong().toString());
    // await exif.setLatLong(position.latitude, position.longitude);
    // await exif.saveAttributes();
    // final modifiedImage = await exif.imageData;
    // var imageName = "imgName..";
    // File imageFile = new File("/$imageName.jpg");
    // imageFile.writeAsBytes(
    //   List.from(modifiedImage!),
    // );
    // print(imageFile.readAsString());

    final pathToImage = _image!.path;

    final exif = dd.FlutterExif.fromPath(pathToImage);
    print("first:${exif}");
    exif.setAttribute(TAG_GPS_LATITUDE, position.latitude.toString());
    exif.setAttribute(TAG_GPS_LONGITUDE, position.longitude.toString());
    // exif.rotate(20);
// apply attributes
    exif.saveAttributes();

    print(exif.getLatLong());
  }

  Future<Position> _determinedPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('location service disabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("gps data to image")),
        body: Column(
          children: [
            _image != null
                ? Image.file(
                    _image!,
                    width: 250,
                    height: 250,
                  )
                : Image.network(
                    'https://images.touchscreenlaptop.biz/l-m/new-14-touchscreen-laptop-8gb-ram-amd-v-1945122527.jpg'),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: getImage, child: Text("Gallery")),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: () {}, child: Text("camera"))
          ],
        ));
  }
}
