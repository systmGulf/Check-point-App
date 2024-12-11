import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hr_management_system_package/core/core.dart';
import 'package:hr_management_system_package/supervisor/data/models/plan_model/get_plan_by_id_model.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

import '../../../../../../core/common/animate_camera_postion.dart';
import '../../../../../../core/enums/attendance_type_enum.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/build_snake_bar.dart';
import '../../controller/attendence/attendence_cubit.dart';

class SiteMapScreen extends StatefulWidget {
  const SiteMapScreen({super.key, required this.attendanceType});
  final AttendanceTypeEnum attendanceType;

  @override
  State<SiteMapScreen> createState() => _SiteMapScreenState();
}

int currentSite = 0;

class _SiteMapScreenState extends State<SiteMapScreen> {
  static Set<Polyline> polylines = {};
  GoogleMapController? googleMapController;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceCubit, AttendanceState>(
      buildWhen: (previous, current) =>
          current is GetPlanByIdLoading ||
          current is GetPlanByIdIdDone ||
          current is GetPlanByIdError,
      builder: (context, state) {
        if (state is GetPlanByIdIdDone) {
          List<CustomerPlans> customers = state.plansById.customerPlans!
              .where((element) => element.customer!.customerType == "Site")
              .toList();
          if (customers.isNotEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Stack(
                children: [
                  GoogleMap(
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    padding: const EdgeInsets.all(20),
                    polylines: polylines,
                    onMapCreated: (GoogleMapController controller) async {
                      googleMapController = controller;
                      var hasPermission =
                          await LocationService.getLocationData();

                      if (!context.mounted) return;

                      if (!hasPermission) {
                        context.pop();
                        buildSnackBar(
                          context,
                          customSnackBar: CustomSnackBar.error(
                            message: "Location Permission Denied"
                                .tr(context: context),
                          ),
                        );
                        return;
                      }

                      LocationService.getRealTimeLocation((locationData) {
                        if (!context.mounted) return;

                        animateCameraPosition(
                            locationData, googleMapController);
                        context.read<AttendanceCubit>().customerId =
                            customers[currentSite].customer!.id!;

                        BlocProvider.of<AttendanceCubit>(context)
                            .checkAssessableArea(
                          LatLng(
                            locationData.latitude!,
                            locationData.longitude!,
                          ),
                          customers[currentSite]
                              .customer!
                              .coordinates!
                              .map((e) => LatLng(e.latitude!, e.longitude!))
                              .toList(),
                          widget.attendanceType,
                        );
                      });
                    },
                    polygons: customers
                        .map((e) => Polygon(
                              polygonId: PolygonId(e.customer!.id.toString()),
                              points: e.customer!.coordinates!
                                  .map((e) => LatLng(e.latitude!, e.longitude!))
                                  .toList(),
                              fillColor: Colors.blue.withOpacity(0.5),
                              strokeColor: Colors.blue,
                            ))
                        .toSet(),
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: BlocProvider.of<AttendanceCubit>(context)
                          .initialCameraPosition,
                      zoom: 5,
                    ),
                  ),
                  Positioned(
                      top: 55.0.h,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              children: customers.map((customer) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  currentSite = customers.indexOf(customer);
                                });
                                googleMapController!.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                    CameraPosition(
                                      target: LatLng(
                                        customer.customer!.coordinates![0]
                                            .latitude!,
                                        customer.customer!.coordinates![0]
                                            .longitude!,
                                      ),
                                      zoom: 15.5,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      border: Border.all(
                                        color: currentSite ==
                                                customers.indexOf(customer)
                                            ? ColorsManger.primaryColor
                                            : Colors.white,
                                      )),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.7,
                                    child: ListTile(
                                      trailing: Container(
                                        height: 22.h,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: ShapeDecoration(
                                          color: customer.visited!
                                              ? Color(0xFFD9F7D9)
                                              : Color(0xFFFFE4F2),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Center(
                                              child: Text(
                                                customer.visited!
                                                    ? 'Visited'
                                                    : 'Not Visited',
                                                style: TextStyle(
                                                  color: customer.visited!
                                                      ? Colors.green
                                                      : Color(0xFFFF7D53),
                                                  fontSize: 11,
                                                  fontFamily: 'DM Sans',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      leading: CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.black,
                                        child: Icon(
                                          Icons.location_city,
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Text(
                                        customer.customer!.name!,
                                        style: AppStylesManger
                                            .font14RegularBlack
                                            .copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        customer.customer!.workesAs!,
                                        style: AppStylesManger
                                            .font14RegularBlack
                                            .copyWith(color: Colors.grey),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  )),
                            );
                          }).toList()),
                        ),
                      )),
                ],
              ),
            );
          } else {
            return Container(
              color: Colors.white,
              child: Center(
                child: Text(
                  'You Do Not Have Site Plans'.tr(context: context),
                  style: AppStylesManger.font15BoldRed.copyWith(
                    color: ColorsManger.primaryColor,
                  ),
                ),
              ),
            );
          }
        } else if (state is GetUserBranchError) {
          return Text(state.error);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
