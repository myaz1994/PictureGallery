# Picture Gallery App

A Picture Gallery App developed for Consider-IT recruiting purposes

## General Information

The main features of this app are:
- Build an image gallery that shows the pictures taken with the phone (Library used: https://pub.dev/packages/photo_gallery)
- Show image thumbnails in a staggered grid view. (Library used: https://pub.dev/packages/flutter_staggered_grid_view)
- When an image is clicked, the full image is presented in a detail view using a Modal Bottom Sheet. (Library used: https://pub.dev/packages/photo_gallery)

Developed with: Flutter / Dart

Developed by: El Houssaine Myaz

## How to implement and test?

1. In the desired directory, clone the repository:
> git clone https://github.com/myaz1994/PictureGallery.git


2. Download and upgrade needed packages:
> flutter pub get
> flutter pub upgrade


3. Run the app on your mobile device:
> flutter run


4. When the app is launched, give the app the permission to access your photos:

![Alt text](assets/images/screen1.jpg?raw=true "Access permission")


5. Once the permissions are set, the gallery is shown in a staggered view (Screenshot blurred for privacy reasons):

![Alt text](assets/images/screen2.jpg?raw=true "Gallery")


6. After clicking on a picture, it appears in a Modal bottom sheet on the same page for a full image view:

![Alt text](assets/images/screen3.jpg?raw=true "Image View")



## Change log

> ## v0.0.4 (24/06/2021) 
>
> #### News:
> 
> - Minor changes.
> - Updated README.md.

> ## v0.0.3 (24/06/2021) 
>
> #### New Features:
> 
> - Added Image View to show the full image (Library used: https://pub.dev/packages/photo_gallery).
> - The Image View is opened on the same page using a Modal Bottom Sheet with a Fade In Effect and a close button at the top.


> ## v0.0.2 (23/06/2021)
> 
> #### Design:
> 
> - Changed AppBar to a container box with a centered page title and circular borders and grandient blue colors.
> - Changed the background of the App to light blue.
> - Pictures are shown in a Staggered Grid View with circular borders after fading effects (Library used: https://pub.dev/packages/flutter_staggered_grid_view).
> - While loading pictures, empty boxes are shown with circular borders and blue gradient colors.


> ## v0.0.1 (23/06/2021)
> 
> #### Icon configuration:
> 
> - Set app Icon with Consider-IT Logo.
> - Set app name.
> 
> #### New Features:
> 
> - Build a gallery that shows the pictures taken with the phone and show it in a grid view (Library used: https://pub.dev/packages/photo_gallery).
