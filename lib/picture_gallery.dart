import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:transparent_image/transparent_image.dart';

class PictureGallery extends StatefulWidget {

  @override
  GalleryState createState() => GalleryState();
}

class GalleryState extends State<PictureGallery> {

  /// Initiation of variables.
  /// listOfAlbums: used to store all the albums that exist in the phone gallery in a list.
  /// cameraAlbum: used to retrieve the Camera album among the albums stored in listOfAlbums.
  /// pictures: used to store all the pictures retrieved from the Camera album in the list.
  List<Album> listOfAlbums;
  Album cameraAlbum;
  List<Medium> pictures;

  // The method to execute at page launch:
  @override
  void initState() {
    super.initState();
    getData();
  }

  /// The method to prompt for permission in order to access to the gallery:
  /// Permissions for Android are set in AndroidManifest
  /// Permissions for iOS are set in Info.plist
  Future<bool> promptPermissionSetting() async {
    if (Platform.isIOS &&
        await Permission.storage
            .request()
            .isGranted &&
        await Permission.photos
            .request()
            .isGranted ||
        Platform.isAndroid && await Permission.storage
            .request()
            .isGranted) {
      return true;
    }
    return false;
  }

  // The method to retrieve all the albums that exist in the gallery:
  Future<void> getAlbums() async {
    if (await promptPermissionSetting()) {
      List<Album> albums =
      await PhotoGallery.listAlbums(mediumType: MediumType.image);
      setState(() {
        listOfAlbums = albums;
      });
    }
  }

  // The method to retrieve only the album that contains picturess taken by the phone (Camera Album) and stores is in the CameraAlbum variable:
  Future<void> retrieveCameraAlbum() async {
    for (int i = 0; i < listOfAlbums.length; i++) {
      if (listOfAlbums[i].name == "Camera") {
        setState(() {
          cameraAlbum = listOfAlbums[i];
        });
      }
    }
  }

  // The method that retrieves all the picturess in the Camera Album retrieved thanks to the retrieveCameraAlbum Method:
  void getPictures() async {
    MediaPage picturesPage = await cameraAlbum.listMedia();
    setState(() {
      pictures = picturesPage.items;
    });
  }

  /// The method that calls and executes the previous methods.
  /// This method is called in the initState method.
  /// The reason why the methods weren't directly called in the initState method is because "await" can't be used there.
  /// "await" is necessary in order to execute the methods one after the other.
  /// "photo_gallery" plugin is used to retrieve albums and pictures.
  void getData() async {
    await getAlbums();
    await retrieveCameraAlbum();
    await getPictures();
  }

  //Widget to show the gallery:
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      // Group all content in a scaffold:
      home: Scaffold(

        // Show an Appbar at the top of the screen:
        appBar: AppBar(
          title: Text("Picture Gallery"),
        ),

        //Show the pictures in a GridView (Staggered View will be configured later)
        body: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 1.0,
          crossAxisSpacing: 1.0,
          children: <Widget>[
            ...?pictures?.map(
                  (medium) => GestureDetector(
                child: Container(
                  color: Colors.grey[300],
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    placeholder: MemoryImage(kTransparentImage),
                    image: ThumbnailProvider(
                      mediumId: medium.id,
                      mediumType: medium.mediumType,
                      highQuality: true,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
