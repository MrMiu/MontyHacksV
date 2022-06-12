import 'dart:convert';
import 'dart:math';

import 'package:app/screens/panel.dart';
import 'package:app/services/api.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import "package:http/http.dart" as http;

import '../models/county.dart';
import '../services/location_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late MapShapeSource _dataSource;
  late MapZoomPanBehavior _zoomPanBehavior;
  late int selectedIndex;

  PanelController _pc = PanelController();

  late List<County> counties;
  Api api = Api();

  @override
  void initState() {
    counties = [
      County(name: 'Alameda', latitude: 37.6017, longitude: -121.7195),
      County(name: 'Alpine', latitude: 38.5941, longitude: -119.8815),
      County(name: 'Amador', latitude: 38.8981, longitude: -120.8981),
      County(name: 'Butte', latitude: 39.5, longitude: 121.5543),
      County(name: 'Calaveras', latitude: 38.1960, longitude: -120.6805),
      County(name: 'Colusa', latitude: 39.1041, longitude: -122.2654),
      County(name: 'Contra Costa', latitude: 37.8534, longitude: -121.9018),
      County(name: 'Del Norte', latitude: 41.7076, longitude: -123.9660),
      County(name: 'El Dorado', latitude: 33.2075, longitude: -92.6656),
      County(name: 'Fresno', latitude: 36.9859, longitude: -119.2321),
      County(name: 'Glenn', latitude: 39.6438, longitude: -122.4467),
      County(name: 'Humboldt', latitude: 40.7450, longitude: -123.8695),
      County(name: 'Imperial', latitude: 33.0114, longitude: -115.4734),
      County(name: 'Inyo', latitude: 36.3092, longitude: -117.5496),
      County(name: 'Kern', latitude: 35.4937, longitude: 118.8597),
      County(name: 'Kings', latitude: 36.0988, longitude: -119.8815),
      County(name: 'Lake', latitude: 39.0840, longitude: -122.8084),
      County(name: 'Lassen', latitude: 40.5394, longitude: -120.7120),
      County(name: 'Los Angeles', latitude: 34.0522, longitude: -118.2437),
      County(name: 'Madera', latitude: 34.0522, longitude: -118.2437),
      County(name: 'Marin', latitude: 38.0834, longitude: -122.7633),
      County(name: 'Mariposa', latitude: 37.4894, longitude: -119.9679),
      County(name: 'Mendocino', latitude: 39.5500, longitude: -123.4384),
      County(name: 'Merced', latitude: 37.2010, longitude: -120.7120),
      County(name: 'Modoc', latitude: 41.4565, longitude: -120.6294),
      County(name: 'Mono', latitude: 37.9219, longitude: -118.9529),
      County(name: 'Monterey', latitude: 37.9219, longitude: -118.9529),
      County(name: 'Napa', latitude: 38.5025, longitude: -122.2654),
      County(name: 'Nevada', latitude: 39.1347, longitude: -121.1710),
      County(name: 'Orange', latitude: 33.7175, longitude: -117.8311),
      County(name: 'Placer', latitude: 39.0916, longitude: -120.8039),
      County(name: 'Plumas', latitude: 39.9927, longitude: -120.8039),
      County(name: 'Riverside', latitude: 33.9533, longitude: -117.3961),
      County(name: 'Sacramento', latitude: 38.4747, longitude: -121.3542),
      County(name: 'San Benito', latitude: 36.5761, longitude: -120.9876),
      County(name: 'San Bernardino', latitude: 34.9592, longitude: -116.4194),
      County(name: 'San Diego', latitude: 32.7157, longitude: -117.1611),
      County(name: 'San Francisco', latitude: 37.7749, longitude: -122.4194),
      County(name: 'San Joaquin', latitude: 37.9176, longitude: -121.1710),
      County(name: 'San Luis Obispo', latitude: 35.3102, longitude: -120.4358),
      County(name: 'San Mateo', latitude: 37.4337, longitude: -122.4014),
      County(name: 'Santa Barbara', latitude: 34.4208, longitude: -119.6982),
      County(name: 'Santa Clara', latitude: 37.3337, longitude: -121.8907),
      County(name: 'Santa Cruz', latitude: 37.0454, longitude: -121.9580),
      County(name: 'Shasta', latitude: 40.7909, longitude: -121.8474),
      County(name: 'Sierra', latitude: 39.5533, longitude: -120.2513),
      County(name: 'Siskiyou', latitude: 41.7743, longitude: -122.5770),
      County(name: 'Solano', latitude: 38.3105, longitude: -121.9018),
      County(name: 'Sonoma', latitude: 38.5780, longitude: -122.9888),
      County(name: 'Stanislaus', latitude: 37.5091, longitude: -120.9876),
      County(name: 'Sutter', latitude: 39.0220, longitude: -121.6739),
      County(name: 'Tehama', latitude: 40.0982, longitude: -122.1746),
      County(name: 'Trinity', latitude: 40.6329, longitude: -123.0623),
      County(name: 'Tulare', latitude: 36.1342, longitude: -118.8597),
      County(name: 'Tuolumne', latitude: 38.0297, longitude: -119.9741),
      County(name: 'Ventura', latitude: 34.3705, longitude: -119.1391),
      County(name: 'Yolo', latitude: 38.7646, longitude: -121.9018),
      County(name: 'Yuba', latitude: 39.2547, longitude: -121.3999),
    ];
    
    for(int i = 0; i < counties.length; i++){
      api.flaskFireApi(latitude: "${counties[selectedIndex].latitude}", longitude: "${counties[selectedIndex].longitude}").then((value){
        double opacity = value["data"];
        County county = County(name: counties[i].name, latitude: counties[i].latitude, longitude: counties[i].longitude, color: Colors.red.withOpacity(opacity), fire: opacity);
        counties[i] = county;
      });
    }
    

    selectedIndex = -1;
    _dataSource = MapShapeSource.asset(
      'assets/geojson/california_counties.geojson',
      shapeDataField: 'CountyName',
      dataCount: counties.length,
      primaryValueMapper: (int index) => counties[index].name,
      shapeColorValueMapper: (int index) => counties[index].color,
    );
    super.initState();
    _zoomPanBehavior = MapZoomPanBehavior();
  }

  @override
  Widget build(BuildContext context) {
    // for(int i =0; i<counties.length; i++){
    //   print(counties[i].name);
    // }
    print(selectedIndex);
    return Scaffold(
      body: SlidingUpPanel(
        body: FutureBuilder<LocationData?>(
            future: currentLocation(),
            builder: (BuildContext context, AsyncSnapshot<dynamic?> snapshot) {
              if (snapshot.hasData) {
                final LocationData currentLocation = snapshot.data;
                return SfMaps(layers: [
                  MapTileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    initialFocalLatLng: const MapLatLng(36.7783, -119.4179),
                    initialZoomLevel: 6,
                    zoomPanBehavior: _zoomPanBehavior,
                    initialMarkersCount: 1,
                    markerBuilder: (BuildContext context, int index) {
                      return MapMarker(
                        latitude: currentLocation.latitude!,
                        longitude: currentLocation.longitude!,
                        size: const Size(20, 20),
                        child: Icon(
                          Icons.circle,
                          color: Colors.blue[800],
                        ),
                      );
                    },
                    sublayers: [
                      MapShapeSublayer(
                        source: _dataSource,
                        color: Colors.red.withOpacity(0.3),
                        strokeWidth: 0,
                        selectedIndex: selectedIndex,
                        onSelectionChanged: (int index) {
                          _pc.open();
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        selectionSettings: MapSelectionSettings(
                            strokeColor: Colors.white,
                            strokeWidth: 2,
                            color: selectedIndex == -1 ? Colors.transparent : counties[selectedIndex].color),
                      ),
                    ],
                  ),
                ]);
              }
              return const CircularProgressIndicator.adaptive();
            }),
        maxHeight: 300,
        minHeight: 50,
        onPanelClosed: () {
          setState(() {
            selectedIndex = -1;
          });
        },
        collapsed: Container(
            decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        )),
        panel: Padding(
          padding: const EdgeInsets.all(8.0),
          child: selectedIndex == -1
              ? Row(children: const [Text("Select a county")])
              : Panel(
                fire: counties[selectedIndex].fire!,
                  countyName: counties[selectedIndex].name,
                ),
        ),
        controller: _pc,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
    );
  }
}
