
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hive_crud/Blocs/text_provider.dart';
import 'package:hive_crud/Controllers/CameraController.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class TakeNyugtaPicture extends StatefulWidget {
  const TakeNyugtaPicture({Key? key, required this.camera}) : super(key: key);

  final CameraDescription camera;

  @override
  _TakeNyugtaPictureState createState() => _TakeNyugtaPictureState();
}

class _TakeNyugtaPictureState extends State<TakeNyugtaPicture> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late CameraManager cameraManager;

  void initState(){
    super.initState();

    // cameraManager = CameraManager(camera: widget.camera);

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium
    );

    _initializeControllerFuture = _controller.initialize();

    @override
    void dispose(){
      _controller.dispose();
      super.dispose();
    }

  }


  @override
  Widget build(BuildContext context) {
    final textProvider = Provider.of<TextProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Kamera'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return CameraPreview(_controller);
          }else{
            return Center(child: CircularProgressIndicator(),);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.camera_alt),
        onPressed: ()async{
          try{
            await _initializeControllerFuture;

            final path = join(
                (await getApplicationDocumentsDirectory()).path,
              'nyugtaPicture.png',
            );

            // final path = await getApplicationDocumentsDirectory() as String;
            final file = File(path);
            if(file.existsSync()){
              file.deleteSync();
            }
            final appdir = await getApplicationDocumentsDirectory();
            final picture = await _controller.takePicture();
            String picpath = picture.path;
            RegExp exp = RegExp('\/((?:.(?!\/))+\$)');
            String? filename = exp.firstMatch(picpath)!.group(1);
            final pictureFile = File(picture.path);
            picture.saveTo(file.path);
            await pictureFile.copy(file.path);
            textProvider.getPath(picture.path.split('/').last);
            print(picture.path);
            Navigator.pop(context,pictureFile);
          }catch(e){
            print(e);
          }
        },
      ),
    );
  }
}
