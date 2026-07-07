import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../controllers/branch_cubit/branch_cubit.dart';
import '../../controllers/customer_cubit/customer_cubit.dart';

class SelectLocationOfSiteBottomSheet extends StatefulWidget {
  const SelectLocationOfSiteBottomSheet({super.key});

  @override
  State<SelectLocationOfSiteBottomSheet> createState() =>
      _SelectLocationOfSiteBottomSheetState();
}

class _SelectLocationOfSiteBottomSheetState
    extends State<SelectLocationOfSiteBottomSheet> {
  Set<Marker> markers = {};
  List<LatLng> points = [];
  Set<Polygon> polygons = {};
  List<Placemark> address = [];
  @override
  @override
  void initState() {
    super.initState();
    markers = {};
    points = [];
    polygons = {};
    address = [];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          GoogleMap(
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 150.h),
              markers: markers,
              polygons: polygons,
              onMapCreated: (GoogleMapController controller) {},
              onTap: _onMapTap,
              initialCameraPosition: const CameraPosition(
                  target: LatLng(30.056996415506003, 31.34547305832398),
                  zoom: 8)),
          Padding(
            padding: const EdgeInsets.all(40),
            child: Align(
                alignment: AlignmentDirectional.topStart,
                child: Text('Pick Location'.tr(context: context),
                    style: AppStylesManger.font15BoldBlack)),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 55.h,
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(Colors.green),
                              ),
                              onPressed: _drawPolygon,
                              child: Text('set'.tr(context: context),
                                  style: AppStylesManger.font14regularWhite
                                      .copyWith(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                        horizontalSpace(20),
                        Expanded(
                          child: SizedBox(
                            height: 55.h,
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(Colors.red),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                points.clear();
                                markers.clear();
                                polygons.clear();
                              },
                              child: Text('cancel'.tr(context: context),
                                  style: AppStylesManger.font14regularWhite
                                      .copyWith(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    address.isEmpty
                        ? const Text('')
                        : Text(
                            ' ${address[0].name} ${address[0].subAdministrativeArea} ${address[0].administrativeArea} ${address[0].country}'),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 55.h,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            ColorsManger.primaryColor,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Done'.tr(context: context),
                            style: AppStylesManger.font14regularWhite
                                .copyWith(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapTap(LatLng point) async {
    setState(() {
      points.add(point);
      markers.add(
        Marker(
          markerId: MarkerId(point.toString()),
          position: point,
        ),
      );
      BlocProvider.of<CustomerCubit>(context).customersLocation.add(
            CustomerLocation(
                latitude: point.latitude, longitude: point.longitude),
          );
    });
  }

  void _drawPolygon() async {
    setState(() {
      polygons.add(Polygon(
        polygonId: const PolygonId('poly'),
        points: points,
        strokeWidth: 2,
        strokeColor: Colors.blue,
        fillColor: Colors.blue.withValues(alpha: 0.3),
      ));
    });
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          points[0].latitude, points[0].longitude);
      setState(() {
        address = placemarks;
        BlocProvider.of<BranchCubit>(context).locationController.text =
            ' ${address[0].name} ${address[0].subAdministrativeArea} ${address[0].administrativeArea} ${address[0].country}';
      });
    } catch (_) {}
  }
}
