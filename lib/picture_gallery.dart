import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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

  // Initiation of staggeredTiles variable used to store a list of tiles configurations:
  List<StaggeredTile> staggeredTiles = [];

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
            await Permission.storage.request().isGranted &&
            await Permission.photos.request().isGranted ||
        Platform.isAndroid && await Permission.storage.request().isGranted) {
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

  //The method to fill the staggeredTiles list:
  void configureStaggeredView() async {
    for (int i = 0; i < pictures.length; i++) {
      if (i % 2 == 0) {
        staggeredTiles.add(StaggeredTile.count(2, 2));
      } else {
        staggeredTiles.add(StaggeredTile.count(2, 1));
      }
    }
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
    await configureStaggeredView();
  }

  // Widget to show the gallery:
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Group all content in a scaffold with a light blue background color:
      home: Scaffold(
        backgroundColor: Colors.blue[100],
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Page header to show page title "Picture Gallery" in a Container
              Container(
                height: 80,

                // Decorate the container box by defining circular borders and gradient blue colors:
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30)),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: [0.1, 0.4, 0.7, 0.9],
                    colors: [
                      Colors.blue[300],
                      Colors.blue[400],
                      Colors.blue[500],
                      Colors.blue[600],
                    ],
                  ),
                ),

                // Show a text "Picture Gallery" at the center of the container:
                child: Center(
                  child: Text(
                    'Picture Gallery',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),

                  // Show images in a Stagerred Grid View:
                  child: StaggeredGridView.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    staggeredTiles: staggeredTiles,
                    children: <Widget>[
                      ...?pictures?.map(
                        (medium) => GestureDetector(
                          // Call the Modal Bottom Sheet to show the picture in full view:
                          onTap: () => showImageView(medium),
                          child: Container(
                            // Show a decorated box with circular borders and gradient blue colors while loading pictures:
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18.0),
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                stops: [0.1, 0.4, 0.7, 0.9],
                                colors: [
                                  Colors.blue[300],
                                  Colors.blue[400],
                                  Colors.blue[500],
                                  Colors.blue[600],
                                ],
                              ),
                            ),

                            // Show pictures after a fading effect while keeping the circular borders:
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18.0),
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
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to show Image view in a Modal Bottom Sheet:
  Future<void> showImageView(Medium medium) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          // Used an OrientationBuilder in order to control how the image view is shown in both Portrait and Landscape modes:
          return new OrientationBuilder(builder: (context, orientation) {
            return Padding(
                padding: const EdgeInsets.only(
                    top: 30.0, right: 10.0, left: 10.0, bottom: 10.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Show a "close" button at the top of the image view to close it:
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              shape: StadiumBorder(),
                              textStyle: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                          child: Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 25.0,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      SizedBox(
                        height: 10,
                      ),

                      // Show the picture in Image view with a fade in effect (Portrait orientation view):
                      orientation == Orientation.portrait
                          ? Container(
                              alignment: Alignment.center,
                              child: medium.mediumType == MediumType.image
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(18.0),
                                      child: FadeInImage(
                                        fit: BoxFit.fill,
                                        placeholder:
                                            MemoryImage(kTransparentImage),
                                        image:
                                            PhotoProvider(mediumId: medium.id),
                                      ))
                                  : Text(
                                      'Unsupported format',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                            )
                          :

                          // Show the picture in Image view with a fade in effect (Landscape orientation view to avoid bottom pixel overflow):
                          Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * 0.75,
                              child: medium.mediumType == MediumType.image
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(18.0),
                                      child: FadeInImage(
                                        fit: BoxFit.fill,
                                        placeholder:
                                            MemoryImage(kTransparentImage),
                                        image:
                                            PhotoProvider(mediumId: medium.id),
                                      ))
                                  : Text(
                                      'Unsupported format',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                            ),
                    ]));
          });
        });
  }
}
