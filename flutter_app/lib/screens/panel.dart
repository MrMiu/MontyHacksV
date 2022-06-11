import 'package:app/services/api.dart';
import 'package:flutter/material.dart';

class Panel extends StatefulWidget {
  String countyName;
  double? longitude;
  double? latitude;
  Panel({Key? key, required this.countyName}) : super(key: key);
  @override
  State<Panel> createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  Api api = Api();
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        child: FutureBuilder(
            future: api.fireApi(longitude: "${widget.longitude ?? 0}", latitude: "${widget.latitude ?? 0}"),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return const CircularProgressIndicator.adaptive();
              }
              Map<String, dynamic>?
               data = snapshot.data;
              return Column(
                children: [
                  
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Spacer(),
                                Column(
                                  children: const [
                                     Text("Fire Prediction"),
                                     Text("74%", style: TextStyle(fontSize: 32))
                                  ],
                                ),
                                const Spacer(),
                                Column(children: const [Divider(thickness: 2,),],),
                                const Spacer(),
                                Column(
                                  children: const [
                                     Text("Smoke Prediction"), Text("32%", style: TextStyle(fontSize: 32))
                                  ],
                                ),
                                const Spacer(),
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(child: Text("${widget.countyName} County", style: const TextStyle(fontSize: 28)))
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          const Text("Soil Temperature"),
                          // Text("${data['Soil Temperature']}"),
                          const Text("jshfdsf")
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Wind Speed"),
                          // Text("${data['Wind Speed']}"),
                          const Text("jshfdsf")
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Dew Point"),
                          // Text("${data['Dew Point']}"),
                          const Text("jshfdsf")
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Rel Humidity"),
                          // Text("${data['Rel Humidity']}"),
                          const Text("jshfdsf")
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Temperature"),
                          // Text("${data['Temperature']}"),
                          const Text("jshfdsf")
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Precipitation"),
                          // Text("${data['Precipitation']}"),
                          const Text("jshfdsf")
                        ],
                      )
                    ],
                  )
                ],
              );
                
              
            }
            )
            );
  }
}
