import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import "package:http/http.dart" as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late MapShapeSource _dataSource;
  late MapZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    _dataSource = const MapShapeSource.asset(
      'assets/geojson/california_counties.geojson',
      shapeDataField: 'CountyName',
    );
    super.initState();
    _zoomPanBehavior = MapZoomPanBehavior();
  }

  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
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
              strokeColor: Colors.black,
              selectedIndex: selectedIndex,
              onSelectionChanged: (int index) {
                setState(() {
                  selectedIndex = index;
                });
                print(selectedIndex);
              
              },
              selectionSettings: const MapSelectionSettings(
                color: Colors.white
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
