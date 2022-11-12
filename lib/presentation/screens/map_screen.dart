import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_maps_app/core/utils/color_manager.dart';
import 'package:flutter_maps_app/network/location_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import '../widgets/my_drawer.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {






  static Position? position;
  final Completer<GoogleMapController> _mapController = Completer();
  FloatingSearchBarController controller = FloatingSearchBarController();





  static final CameraPosition _myCurrentCameraPosition = CameraPosition(
      target: LatLng(position!.latitude, position!.longitude),
      zoom: 17,
  );


  // passing data from LocationHelper class to here in this methode..
  Future<void> getMyCurrentLocation()async
  {
    position = await LocationHelper.getMyCurrentLocation().whenComplete(() {
      setState(() {});
    });
  }


  Widget buildMap()
  {
    return GoogleMap(
        initialCameraPosition: _myCurrentCameraPosition,
      mapType: MapType.normal,
      myLocationEnabled: true,
      //zoom in and zoom out buttons on Map ( + , - )
      zoomControlsEnabled: false,
      // btn that getting myInitial location .. from google map ..
      myLocationButtonEnabled: false,

      onMapCreated: (GoogleMapController controller){
         _mapController.complete(controller);
      },

    );
  }


 Future<void> _goToMyCurrentLocation()async{
    final GoogleMapController controller = await _mapController.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(_myCurrentCameraPosition));
 }



 Widget buildFloatingSearchBar()
 {
   final isPortrait =
       MediaQuery.of(context).orientation == Orientation.portrait;
   return FloatingSearchBar(
     controller: controller,
     elevation: 6,
     hintStyle: const TextStyle(fontSize: 18),
     queryStyle: const TextStyle(fontSize: 18),
     hint: ' Find a place..',
     border: const BorderSide(style: BorderStyle.none),
     margins: const EdgeInsets.fromLTRB(20, 70, 20, 0),
     padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
     height: 52,
     iconColor: ColorManager.blue,
     scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
     transitionDuration: const Duration(milliseconds: 600),
     transitionCurve: Curves.easeInOut,
     physics: const BouncingScrollPhysics(),
     openAxisAlignment: 0.0,
     width: isPortrait ? 600 : 500,
     debounceDelay: const Duration(milliseconds: 500),
     onQueryChanged: (query){

     },
     onFocusChanged: (_){

     },
     transition: CircularFloatingSearchBarTransition(),
     actions: [
       FloatingSearchBarAction(
         showIfOpened: false,
         child: CircularButton(
             icon: Icon(Icons.place, color: ColorManager.black.withOpacity(0.6)),
             onPressed: () {

             }),
       ),
     ],
     builder: ( context,  transition) {
       return ClipRRect(
         borderRadius: BorderRadius.circular(8),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.start,
           mainAxisSize: MainAxisSize.min,
           children: [

           ],
         ),
       );
     },
   );

 }



  @override
  void initState() {
    getMyCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: MyDrawer(),
        body:  Stack(
          fit: StackFit.expand,
          children: [
            position != null ? buildMap() :
                Center(
                  child: Container(
                    child:const CircularProgressIndicator(color: ColorManager.blue,),),),
            buildFloatingSearchBar(),
          ],
        ),
        floatingActionButton: Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 8, 20),
          child: FloatingActionButton(
            backgroundColor: ColorManager.blue,
              onPressed: _goToMyCurrentLocation,
            child: const Icon(Icons.place,color: ColorManager.white,),
          ),
        ),
      ),
    );
  }

}
