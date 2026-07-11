import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/app_spaces.dart';
import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:employee_mangement/core/widgets/build_custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../contoller/Supervisor_get_employee_attendance/supervisor_get_employee_attendance_cubit.dart';

class EmployeeTrackingDiagramMap extends StatelessWidget {
  const EmployeeTrackingDiagramMap({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupervisorGetEmployeeAttendanceCubit,
        SupervisorGetEmployeeAttendanceState>(
      buildWhen: (previous, current) =>
          current is GetEmployeeTrackingSummaryLoading ||
          current is GetEmployeeTrackingSummaryFailure ||
          current is GetEmployeeTrackingSummarySuccess,
      builder: (context, state) {
        if (state is GetEmployeeTrackingSummaryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetEmployeeTrackingSummaryFailure) {
          return Center(child: Text(state.errorMessage));
        } else if (state is GetEmployeeTrackingSummarySuccess) {
          if (state.employeeTrackingSummary.value!.data!.isEmpty) {
            return SafeArea(
              child: Column(
                children: [
                  verticalSpace(30),
                  buildCustomAppBar(context, ''),
                  verticalSpace(MediaQuery.sizeOf(context).height * 0.4),
                  Center(
                    child: Text(
                      'No tracking data available'.tr(),
                      style: AppStylesManger.font15BoldrBlue,
                    ),
                  ),
                ],
              ),
            );
          }

          List<LatLng> points = state
              .employeeTrackingSummary.value!.data!.first.coordinates!
              .map((e) => LatLng(e.latitude!, e.longitude!))
              .toList();

          if (points.isEmpty) {
            return SafeArea(
              child: Column(
                children: [
                  verticalSpace(30),
                  buildCustomAppBar(context, ''),
                  verticalSpace(MediaQuery.sizeOf(context).height * 0.4),
                  Center(
                    child: Text(
                      'No tracking data available'.tr(),
                      style: AppStylesManger.font15BoldrBlue,
                    ),
                  ),
                ],
              ),
            );
          }

          if (points.length == 1) {
            points.add(LatLng(points.first.latitude + 0.0001,
                points.first.longitude + 0.0001));
          }

          double minLat =
              points.map((p) => p.latitude).reduce((a, b) => a < b ? a : b);
          double maxLat =
              points.map((p) => p.latitude).reduce((a, b) => a > b ? a : b);
          double minLng =
              points.map((p) => p.longitude).reduce((a, b) => a < b ? a : b);
          double maxLng =
              points.map((p) => p.longitude).reduce((a, b) => a > b ? a : b);

          LatLngBounds bounds = LatLngBounds(
            southwest: LatLng(minLat, minLng),
            northeast: LatLng(maxLat, maxLng),
          );

          return SafeArea(
            child: Scaffold(
              body: SafeArea(
                child: Stack(
                  children: [
                    GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: points.first,
                        zoom: 15,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('start'),
                          position: points.first,
                          infoWindow: const InfoWindow(title: "Start"),
                        ),
                        Marker(
                          markerId: const MarkerId('end'),
                          position: points.last,
                          infoWindow: const InfoWindow(title: "End"),
                        ),
                      },
                      polylines: {
                        Polyline(
                          polylineId: const PolylineId('route'),
                          points: points,
                          color: ColorsManger.primaryColor,
                          width: 5,
                        ),
                      },
                      onMapCreated: (GoogleMapController controller) {
                        Future.delayed(const Duration(milliseconds: 300), () {
                          controller.animateCamera(
                              CameraUpdate.newLatLngBounds(bounds, 50));
                        });
                      },
                    ),
                    IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_outlined,
                          size: 40,
                        ))
                  ],
                ),
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
