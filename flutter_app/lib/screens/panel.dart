import 'package:app/services/api.dart';
import 'package:flutter/material.dart';

class Panel extends StatefulWidget {
  String countyName;
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
            future: api.fireApi(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [],
                          ),
                        ),
                        Expanded(child: Text("${widget.countyName} County", style: const TextStyle(fontSize: 30)))
                      ],
                    )
                  ],
                );
              }
              return const CircularProgressIndicator.adaptive();
            }));
  }
}
