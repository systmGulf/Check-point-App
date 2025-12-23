import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/app_spaces.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/widgets/custom_app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

import '../../../../../../core/styles/styles.dart';
import '../../controllers/branch_cubit/branch_cubit.dart';

class CompanyBranchDetailsScreen extends StatefulWidget {
  const CompanyBranchDetailsScreen({
    super.key,
    required this.name,
    required this.location,
    required this.description,
    required this.points,
    required this.branchId, required this.contextt,
  });

  final String name;
  final String location;
  final String description;
  final List<GetBranchesCoordinates> points;
  final int branchId;
  final BuildContext contextt;

  @override
  State<CompanyBranchDetailsScreen> createState() =>
      _CompanyBranchDetailsScreenState();
}

class _CompanyBranchDetailsScreenState
    extends State<CompanyBranchDetailsScreen> {
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    final List<LatLng> polygonPoints =
        widget.points.map((e) => LatLng(e.latitude!, e.longitude!)).toList();

    return BlocProvider.value(
      value: widget.contextt.read<BranchCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.name, style: AppStylesManger.font18BoldBlack),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: GoogleMap(
                onMapCreated: (controller) {
                  _mapController = controller;
                  _fitPolygon(polygonPoints);
                },
                initialCameraPosition: CameraPosition(
                  target: polygonPoints.first,
                  zoom: 14,
                ),
                polygons: {
                  Polygon(
                    polygonId: const PolygonId('branch_polygon'),
                    points: polygonPoints,
                    strokeWidth: 2,
                    strokeColor: ColorsManger.primaryColor,
                    fillColor: ColorsManger.primaryColor.withOpacity(0.4),
                  ),
                },
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
                        Icon(
                          Icons.location_on,
                          color: ColorsManger.primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.location,
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
                      widget.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    Spacer(),
                    CustomAppButton(
                      textButton: "Delete this branch".tr(context: context),
                      buttonColor: ColorsManger.primaryColor,
                      onPressed: () {
                        BlocProvider.of<BranchCubit>(widget.contextt)
                            .deleteBranch(
                              widget.branchId,
                            )
                            .then((_) {
                          Navigator.of(context).pop();
                            });
                      },
                    ),
                    verticalSpace(20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _fitPolygon(List<LatLng> points) {
    if (points.isEmpty || _mapController == null) return;

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    final LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng), // Down Left
      northeast: LatLng(maxLat, maxLng), // Top Right
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 60),
      );
    });
  }
}
