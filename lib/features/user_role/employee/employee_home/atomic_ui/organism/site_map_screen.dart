import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/models/customers_model/get_customer_model.dart';
import 'package:hr_management_system_package/core/core.dart';
import 'package:lottie/lottie.dart';
import 'package:location/location.dart';

import '../../../../../../core/enums/attendance_type_enum.dart';
import '../../../../../../core/enums/customer_type.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../controller/attendence/attendence_cubit.dart';

class SiteMapScreen extends StatefulWidget {
  const SiteMapScreen({super.key, required this.attendanceType});
  final AttendanceTypeEnum attendanceType;

  @override
  State<SiteMapScreen> createState() => _SiteMapScreenState();
}

class _SiteMapScreenState extends State<SiteMapScreen> {
  GoogleMapController? googleMapController;
  StreamSubscription<LocationData>? locationSubscription;

  @override
  void dispose() {
    locationSubscription?.cancel();
    googleMapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceCubit, AttendanceState>(
      buildWhen: (previous, current) =>
          current is GetAttendanceTargetsLoading ||
          current is GetAttendanceTargetsDone ||
          current is GetAttendanceTargetsError ||
          current is AttendanceTargetSelected,
      builder: (context, state) {
        final cubit = context.read<AttendanceCubit>();
        if (state is GetAttendanceTargetsError) {
          return Center(child: Text(state.error));
        }

        final targets = state is GetAttendanceTargetsDone
            ? state.targets
            : cubit.attendanceTargets;
        final currentType = state is GetAttendanceTargetsDone
            ? state.customerType
            : cubit.selectedAttendanceTargetType;

        if (currentType != CustomerType.Site) {
          return Center(
            child: CircularProgressIndicator(
              color: ColorsManger.primaryColor,
            ),
          );
        }

        if (targets.isEmpty) {
          return _EmptyTargets(message: 'No sites found'.tr());
        }

        final selectedTarget =
            _resolveSelectedTarget(cubit: cubit, targets: targets);

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Stack(
            children: [
              GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                polygons: targets
                    .where((target) =>
                        target.coordinates != null &&
                        target.coordinates!.isNotEmpty)
                    .map(
                      (target) => Polygon(
                        polygonId:
                            PolygonId(target.id ?? target.name ?? 'site'),
                        points: target.coordinates!
                            .map(
                              (coordinate) => LatLng(
                                coordinate.latitude ?? 0,
                                coordinate.longitude ?? 0,
                              ),
                            )
                            .toList(),
                        fillColor: (target.id == selectedTarget?.id
                                ? Colors.blue
                                : Colors.grey)
                            .withValues(alpha: 0.25),
                        strokeColor: target.id == selectedTarget?.id
                            ? Colors.blue
                            : Colors.grey,
                        strokeWidth: 2,
                      ),
                    )
                    .toSet(),
                initialCameraPosition: CameraPosition(
                  target: _targetLatLng(selectedTarget) ??
                      cubit.initialCameraPosition,
                  zoom: 15,
                ),
                onMapCreated: (controller) async {
                  googleMapController = controller;
                  final hasPermission = await LocationService.getLocationData();
                  if (!mounted || !hasPermission) return;

                  if (selectedTarget != null) {
                    await cubit.setSelectedAttendanceTarget(
                      target: selectedTarget,
                      attendanceType: widget.attendanceType,
                    );
                    _animateToTarget(selectedTarget);
                  }

                  locationSubscription?.cancel();
                  locationSubscription =
                      LocationService.getRealTimeLocation((locationData) {
                    final latitude = locationData.latitude;
                    final longitude = locationData.longitude;
                    if (!mounted || latitude == null || longitude == null) {
                      return;
                    }

                    cubit.updateCurrentLocation(
                      location: LatLng(latitude, longitude),
                      attendanceType: widget.attendanceType,
                    );
                  });
                },
              ),
              Positioned(
                top: 55.h,
                left: 16.w,
                right: 16.w,
                child: _TargetDropdown(
                  value: selectedTarget,
                  items: targets,
                  hint: 'Select site'.tr(),
                  onChanged: (target) async {
                    if (target == null) return;
                    await cubit.setSelectedAttendanceTarget(
                      target: target,
                      attendanceType: widget.attendanceType,
                    );
                    _animateToTarget(target);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  CustomerData? _resolveSelectedTarget({
    required AttendanceCubit cubit,
    required List<CustomerData> targets,
  }) {
    final selectedId = cubit.selectedAttendanceTarget?.id;
    for (final target in targets) {
      if (target.id == selectedId) {
        return target;
      }
    }
    return targets.isEmpty ? null : targets.first;
  }

  LatLng? _targetLatLng(CustomerData? target) {
    final coordinates = target?.coordinates;
    if (coordinates == null || coordinates.isEmpty) return null;
    return LatLng(
      coordinates.first.latitude ?? 0,
      coordinates.first.longitude ?? 0,
    );
  }

  void _animateToTarget(CustomerData target) {
    final points = target.coordinates;
    if (googleMapController == null || points == null || points.isEmpty) {
      return;
    }
    googleMapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            points.first.latitude ?? 0,
            points.first.longitude ?? 0,
          ),
          zoom: 16,
        ),
      ),
    );
  }
}

class _TargetDropdown extends StatelessWidget {
  const _TargetDropdown({
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
  });

  final CustomerData? value;
  final List<CustomerData> items;
  final String hint;
  final ValueChanged<CustomerData?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<CustomerData>(
      value: value,
      menuMaxHeight: 260.h,
      borderRadius: BorderRadius.circular(18.r),
      dropdownColor: Colors.white,
      elevation: 3,
      icon: Container(
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FB),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: ColorsManger.primaryColor,
          size: 20.sp,
        ),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppStylesManger.font14RegularBlack.copyWith(
          color: Colors.black45,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: const BorderSide(
            color: Color(0xFFE4E7EC),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: BorderSide(
            color: ColorsManger.primaryColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: const BorderSide(
            color: Color(0xFFE4E7EC),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: BorderSide(
            color: ColorsManger.primaryColor,
          ),
        ),
      ),
      style: AppStylesManger.font14RegularBlack,
      items: items
          .map(
            (target) => DropdownMenuItem<CustomerData>(
              value: target,
              child: Text(
                target.name ?? '',
                overflow: TextOverflow.ellipsis,
                style: AppStylesManger.font14RegularBlack,
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _EmptyTargets extends StatelessWidget {
  const _EmptyTargets({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset(
            'assets/animated_images/empty.json',
            height: 100.h,
            width: 100.w,
            fit: BoxFit.cover,
          ),
          Text(
            message,
            style: AppStylesManger.font15BoldRed.copyWith(
              color: ColorsManger.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
