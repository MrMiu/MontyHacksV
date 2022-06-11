import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import "package:http/http.dart" as http;

import '../models/county.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late MapShapeSource _dataSource;
  late MapZoomPanBehavior _zoomPanBehavior;
  late int selectedIndex;

  late List<County> counties;

  @override
  void initState() {
    counties = [
      County(name: 'Alameda', color: Colors.red),
      County(name: 'Alpine', color: Colors.green),
      County(name: 'Amador', color: Colors.blue),
      County(name: 'Butte', color: Colors.yellow),
      County(name: 'Calaveras', color: Colors.orange),
      County(name: 'Colusa', color: Colors.purple),
      County(name: 'Contra Costa', color: Colors.pink),
      County(name: 'Del Norte', color: Colors.teal),
      County(name: 'El Dorado', color: Colors.lime),
      County(name: 'Fresno', color: Colors.lightGreen),
      County(name: 'Glenn', color: Colors.lightBlue),
      County(name: 'Humboldt', color: Colors.lightGreen),
      County(name: 'Imperial', color: Colors.lightBlue),
      County(name: 'Inyo', color: Colors.lightGreen),
      County(name: 'Kern', color: Colors.lightBlue),
      County(name: 'Kings', color: Colors.lightGreen),
      County(name: 'Lake', color: Colors.lightBlue),
      County(name: 'Lassen', color: Colors.lightGreen),
      County(name: 'Los Angeles', color: Colors.lightBlue),
      County(name: 'Madera', color: Colors.lightGreen),
      County(name: 'Marin', color: Colors.lightBlue),
      County(name: 'Mariposa', color: Colors.lightGreen),
      County(name: 'Mendocino', color: Colors.lightBlue),
      County(name: 'Merced', color: Colors.lightGreen),
      County(name: 'Modoc', color: Colors.lightBlue),
      County(name: 'Mono', color: Colors.lightGreen),
      County(name: 'Monterey', color: Colors.lightBlue),
      County(name: 'Napa', color: Colors.lightGreen),
      County(name: 'Nevada', color: Colors.lightBlue),
      County(name: 'Orange', color: Colors.lightGreen),
      County(name: 'Placer', color: Colors.lightBlue),
      County(name: 'Plumas', color: Colors.lightGreen),
      County(name: 'Riverside', color: Colors.lightBlue),
      County(name: 'Sacramento', color: Colors.lightGreen),
      County(name: 'San Benito', color: Colors.lightBlue),
      County(name: 'San Bernardino', color: Colors.lightGreen),
      County(name: 'San Diego', color: Colors.lightBlue),
      County(name: 'San Francisco', color: Colors.lightGreen),
      County(name: 'San Joaquin', color: Colors.lightBlue),
      County(name: 'San Luis Obispo', color: Colors.lightGreen),
      County(name: 'San Mateo', color: Colors.lightBlue),
      County(name: 'Santa Barbara', color: Colors.lightGreen),
      County(name: 'Santa Clara', color: Colors.lightBlue),
      County(name: 'Santa Cruz', color: Colors.lightGreen),
      County(name: 'Shasta', color: Colors.lightBlue),
      County(name: 'Sierra', color: Colors.lightGreen),
      County(name: 'Siskiyou', color: Colors.lightBlue),
      County(name: 'Solano', color: Colors.lightGreen),
      County(name: 'Sonoma', color: Colors.lightBlue),
      County(name: 'Stanislaus', color: Colors.lightGreen),
      County(name: 'Sutter', color: Colors.lightBlue),
      County(name: 'Tehama', color: Colors.lightGreen),
      County(name: 'Trinity', color: Colors.lightBlue),
      County(name: 'Tulare', color: Colors.lightGreen),
      County(name: 'Tuolumne', color: Colors.lightBlue),
      County(name: 'Ventura', color: Colors.lightGreen),
      County(name: 'Yolo', color: Colors.lightBlue),
      County(name: 'Yuba', color: Colors.lightGreen),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SfMaps(layers: [
        MapTileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          initialFocalLatLng: const MapLatLng(36.7783, -119.4179),
          initialZoomLevel: 6,
          zoomPanBehavior: _zoomPanBehavior,
          sublayers: [
            MapShapeSublayer(
              source: _dataSource,
              color: Colors.red.withOpacity(0.3),
              strokeWidth: 0,
              selectedIndex: selectedIndex,
              onSelectionChanged: (int index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              selectionSettings: const MapSelectionSettings(color: Colors.white),
            ),
          ],
        ),
      ]),
    );
  }
}
