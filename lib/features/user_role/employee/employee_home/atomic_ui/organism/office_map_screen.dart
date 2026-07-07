import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hr_management_system_package/core/core.dart';
import 'package:employee_mangement/core/widgets/app_top_snack_bar.dart';

import '../../../../../../core/common/animate_camera_postion.dart';
import '../../../../../../core/enums/attendance_type_enum.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/build_snake_bar.dart';
import '../../controller/attendence/attendence_cubit.dart';

class OfficeMapScreen extends StatefulWidget {
  const OfficeMapScreen({required this.attendanceType, super.key});
  final AttendanceTypeEnum attendanceType;

  @override
  _OfficeMapScreenState createState() => _OfficeMapScreenState();
}

class _OfficeMapScreenState extends State<OfficeMapScreen> {
  static Set<Polyline> polylines = {};
  GoogleMapController? googleMapController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceCubit, AttendanceState>(
      buildWhen: (previous, current) =>
          current is GetUserBranchDone ||
          current is GetUserBranchError ||
          current is GetUserBranchLoading,
      builder: (context, state) {
        if (state is GetUserBranchDone) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: GoogleMap(
              myLocationEnabled: true,
              padding: const EdgeInsets.all(20),
              polylines: polylines,
              onMapCreated: (GoogleMapController controller) async {
                googleMapController = controller;
                final hasPermission = await LocationService.getLocationData();

                if (!context.mounted) return;

                if (!hasPermission) {
                  context.pop();
                  buildSnackBar(
                    context,
                    customSnackBar: CustomSnackBar.error(
                      message:
                          'Location Permission Denied'.tr(context: context),
                    ),
                  );
                  return;
                }

                LocationService.getRealTimeLocation((locationData) {
                  if (!context.mounted) return;

                  animateCameraPosition(locationData, googleMapController);
                  BlocProvider.of<AttendanceCubit>(context).checkAssessableArea(
                    LatLng(
                      locationData.latitude!,
                      locationData.longitude!,
                    ),
                    state.departmentModel.coordinates!
                        .map((e) => LatLng(e.latitude!, e.longitude!))
                        .toList(),
                    widget.attendanceType,
                  );
                });
              },
              polygons: {
                Polygon(
                  polygonId: const PolygonId('1'),
                  points: state.departmentModel.coordinates!
                      .map((e) => LatLng(e.latitude!, e.longitude!))
                      .toList(),
                  fillColor: Colors.lightBlue.withValues(alpha: 0.3),
                  strokeWidth: 1,
                ),
              },
              initialCameraPosition: CameraPosition(
                target: BlocProvider.of<AttendanceCubit>(context)
                    .initialCameraPosition,
                zoom: 5,
              ),
            ),
          );
        } else if (state is GetUserBranchError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error,
                  color: Colors.red,
                ),
                verticalSpace(10),
                Text(
                  state.error,
                  style: AppStylesManger.font14RedularRed,
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: const CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
