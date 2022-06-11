import 'dart:convert';

import 'package:app/screens/panel.dart';
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

  PanelController _pc = new PanelController();

  late List<County> counties;

  @override
  void initState() {
    counties = [
      County(name: 'Alameda', color: Colors.red.withOpacity(0.3), latitude: 37.6017, longitude: -121.7195),
      County(name: 'Alpine', color: Colors.green, latitude: 38.5941, longitude: -119.8815),
      County(name: 'Amador', color: Colors.blue, latitude: 38.8981, longitude: -120.8981),
      County(name: 'Butte', color: Colors.yellow, latitude: 39.5, longitude: 121.5543),
      County(name: 'Calaveras', color: Colors.orange, latitude: 38.1960, longitude: -120.6805),
      County(name: 'Colusa', color: Colors.purple, latitude: 39.1041, longitude: -122.2654),
      County(name: 'Contra Costa', color: Colors.pink, latitude: 37.8534, longitude: -121.9018),
      County(name: 'Del Norte', color: Colors.teal, latitude: 41.7076, longitude: -123.9660),
      County(name: 'El Dorado', color: Colors.lime, latitude: 33.2075, longitude: -92.6656),
      County(name: 'Fresno', color: Colors.lightGreen, latitude: 36.9859, longitude: -119.2321),
      County(name: 'Glenn', color: Colors.lightBlue, latitude: 39.6438, longitude: -122.4467),
      County(name: 'Humboldt', color: Colors.lightGreen, latitude: 40.7450, longitude: -123.8695),
      County(name: 'Imperial', color: Colors.lightBlue, latitude: 33.0114, longitude: -115.4734),
      County(name: 'Inyo', color: Colors.lightGreen, latitude: 36.3092, longitude: -117.5496),
      County(name: 'Kern', color: Colors.lightBlue, latitude: 35.4937, longitude: 118.8597),

      County(name: 'Kings', color: Colors.lightGreen, latitude: 36.0988, longitude: -119.8815),
      County(name: 'Lake', color: Colors.lightBlue, latitude: 39.0840, longitude: -122.8084),
      County(name: 'Lassen', color: Colors.lightGreen, latitude: 40.5394, longitude: -120.7120),
      County(name: 'Los Angeles', color: Colors.lightBlue, latitude: 34.0522, longitude: -118.2437),
      County(name: 'Madera', color: Colors.lightGreen, latitude: 34.0522, longitude: -118.2437),
      County(name: 'Marin', color: Colors.lightBlue, latitude: 38.0834, longitude: -122.7633),
      County(name: 'Mariposa', color: Colors.lightGreen, latitude: 37.4894, longitude: -119.9679),
      County(name: 'Mendocino', color: Colors.lightBlue, latitude: 39.5500, longitude: -123.4384),
      County(name: 'Merced', color: Colors.lightGreen, latitude: 37.2010, longitude: -120.7120),
      County(name: 'Modoc', color: Colors.lightBlue, latitude: 41.4565, longitude: -120.6294),
      County(name: 'Mono', color: Colors.lightGreen, latitude: 37.9219, longitude: -118.9529),
      County(name: 'Monterey', color: Colors.lightBlue, latitude: 37.9219, longitude: -118.9529),
      County(name: 'Napa', color: Colors.lightGreen, latitude: 38.5025, longitude: -122.2654),
      County(name: 'Nevada', color: Colors.lightBlue, latitude: 39.1347, longitude: -121.1710),
      County(name: 'Orange', color: Colors.lightGreen, latitude: 33.7175, longitude: -117.8311),
      County(name: 'Placer', color: Colors.lightBlue, latitude: 39.0916, longitude: -120.8039),
      County(name: 'Plumas', color: Colors.lightGreen, latitude: 39.9927, longitude: -120.8039),
      County(name: 'Riverside', color: Colors.lightBlue, latitude: 33.9533, longitude: -117.3961),
      County(name: 'Sacramento', color: Colors.lightGreen, latitude: 38.4747, longitude: -121.3542),
      County(name: 'San Benito', color: Colors.lightBlue, latitude: 36.5761, longitude: -120.9876),
      County(name: 'San Bernardino', color: Colors.lightGreen, latitude: 34.9592, longitude: -116.4194),
      County(name: 'San Diego', color: Colors.lightBlue, latitude: 32.7157, longitude: -117.1611),
      County(name: 'San Francisco', color: Colors.lightGreen, latitude: 37.7749, longitude: -122.4194),
      County(name: 'San Joaquin', color: Colors.lightBlue, latitude: 37.9176, longitude: -121.1710),
      County(name: 'San Luis Obispo', color: Colors.lightGreen, latitude: 35.3102, longitude: -120.4358),
      County(name: 'San Mateo', color: Colors.lightBlue, latitude: 37.4337, longitude: -122.4014),
      County(name: 'Santa Barbara', color: Colors.lightGreen, latitude: 34.4208, longitude: -119.6982),
      County(name: 'Santa Clara', color: Colors.lightBlue, latitude: 37.3337, longitude: -121.8907),
      County(name: 'Santa Cruz', color: Colors.lightGreen, latitude: 37.0454, longitude: -121.9580),
      County(name: 'Shasta', color: Colors.lightBlue, latitude: 40.7909, longitude: -121.8474),
      County(name: 'Sierra', color: Colors.lightGreen, latitude: 39.5533, longitude: -120.2513),
      County(name: 'Siskiyou', color: Colors.lightBlue, latitude: 41.7743, longitude: -122.5770),
      County(name: 'Solano', color: Colors.lightGreen, latitude: 38.3105, longitude: -121.9018),
      County(name: 'Sonoma', color: Colors.lightBlue, latitude: 38.5780, longitude: -122.9888),
      County(name: 'Stanislaus', color: Colors.lightGreen, latitude: 37.5091, longitude: -120.9876),
      County(name: 'Sutter', color: Colors.lightBlue, latitude: 39.0220, longitude: -121.6739),
      County(name: 'Tehama', color: Colors.lightGreen, latitude:40.0982, longitude: -122.1746),
      County(name: 'Trinity', color: Colors.lightBlue, latitude:40.6329, longitude: -123.0623),
      County(name: 'Tulare', color: Colors.lightGreen, latitude:36.1342, longitude: -118.8597),
      County(name: 'Tuolumne', color: Colors.lightBlue, latitude:38.0297, longitude: -119.9741),
      County(name: 'Ventura', color: Colors.lightGreen, latitude:34.3705, longitude: -119.1391),
      County(name: 'Yolo', color: Colors.lightBlue, latitude:38.7646, longitude: -121.9018),
      County(name: 'Yuba', color: Colors.lightGreen, latitude:39.2547, longitude: -121.3999),
    ];

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
    print(selectedIndex);
    return Scaffold(
      body: SlidingUpPanel(
        controller: _pc,
        header: Row(
          children: [
            const Divider()
          ],
        ),
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
                        selectionSettings: const MapSelectionSettings(color: Colors.white),
                      ),
                    ],
                  ),
                ]);
              }
              return const CircularProgressIndicator.adaptive();
            }),
        collapsed: Container(
            decoration: const BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        )),
        panel: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Panel(countyName: selectedIndex == -1 ? "Select a county" : counties[selectedIndex].name,),
          ),
        ),
      ),
    );
  }
}
