import 'package:employee_mangement/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

import '../../../../../../core/styles/styles.dart';

class CompanyBranchDetailsScreen extends StatelessWidget {
  const CompanyBranchDetailsScreen({
    super.key,
    required this.name,
    required this.location,
    required this.description,
    required this.points,
  });

  final String name;
  final String location;
  final String description;
  final List<GetBranchesCoordinates> points;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name, style: AppStylesManger.font18BoldBlack),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: GoogleMap(
              polygons: {
                Polygon(
                  polygonId: const PolygonId('1'),
                  points: points
                      .map((e) => LatLng(e.latitude!, e.longitude!))
                      .toList(),
                  strokeWidth: 2,
                  fillColor: ColorsManger.primaryColor.withOpacity(0.5),
                ),
              },
              initialCameraPosition: CameraPosition(
                  target: LatLng(points[0].latitude!, points[0].longitude!),
                  zoom: 17),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          color: ColorsManger.primaryColor, size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
