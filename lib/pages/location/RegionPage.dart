import 'package:flutter/material.dart';

class RegionPage extends StatelessWidget {
  final String regionId;

  const RegionPage({Key? key, required this.regionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Region $regionId"),
      ),
      body: Center(
        child: Text(
          "Thông tin chi tiết Region: $regionId",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
