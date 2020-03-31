import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {

  final Function(File) onImageSelected;

  ImageSourceSheet({this.onImageSelected});

  void imageSelected(File image) async {
    if(image != null){
      File croppedImage = await ImageCropper.cropImage(
          sourcePath: image.path,
      );
      onImageSelected(croppedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: (){},
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FlatButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Câmera", style: TextStyle(color: Colors.purple[800], fontSize: 20),),
                SizedBox(width: 10,),
                Icon(Icons.camera, color: Colors.purple[800], size: 35,)
              ],
            ),
            onPressed: () async {
              File image = await ImagePicker.pickImage(source: ImageSource.camera);
              imageSelected(image);
            },
          ),
          FlatButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Galeria", style: TextStyle(color: Colors.purple[800], fontSize: 20)),
                SizedBox(width: 10,),
                Icon(Icons.image, color: Colors.purple[800], size: 35,)
              ],
            ),
            onPressed: () async {
              File image = await ImagePicker.pickImage(source: ImageSource.gallery);
              imageSelected(image);
            },
          )
        ],
      ),
    );
  }
}
