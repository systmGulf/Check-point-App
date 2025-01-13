import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hr_management_system_package/core/core.dart';
import 'package:hr_management_system_package/supervisor/data/models/plan_model/get_plan_by_id_model.dart';

import '../../../../../../core/enums/attendance_type_enum.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../controller/attendence/attendence_cubit.dart';

class CustomerMapScreen extends StatefulWidget {
  final AttendanceTypeEnum attendanceType;

  const CustomerMapScreen({super.key, required this.attendanceType});

  @override
  State<StatefulWidget> createState() => _CustomerMapScreenState();
}

class _CustomerMapScreenState extends State<CustomerMapScreen> {
  GoogleMapController? googleMapController;
  int currentCustomerIndex = 0;
  bool isNavigating = false;
  Set<Marker> markers = {};
  Set<Polygon> customerPlongons = {};
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
              .where((element) => element.customer!.customerType == "Customer")
              .toList();

          if (customers.isNotEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Stack(
                children: [
                  GoogleMap(
                
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    onMapCreated: (GoogleMapController controller) async {
                      googleMapController = controller;
  
                      LocationService.getRealTimeLocation((locationData) {
                        if (!mounted) return;
                        LatLng currentLocation = LatLng(
                          locationData.latitude!,
                          locationData.longitude!,
                        );
                        markers.addAll(customers.map((customer) {
                          return Marker(
                            markerId: MarkerId(customer.id.toString()),
                            position: LatLng(
                              customer.customer!.coordinates![0].latitude!,
                              customer.customer!.coordinates![0].longitude!,
                            ),
                          );
                        }).toSet());

                       

                        context.read<AttendanceCubit>().customerId =
                            customers[currentCustomerIndex].customer!.id!;

                        googleMapController!.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(
                                customers[currentCustomerIndex]
                                    .customer!
                                    .coordinates![0]
                                    .latitude!,
                                customers[currentCustomerIndex]
                                    .customer!
                                    .coordinates![0]
                                    .longitude!,
                              ),
                              zoom: 16.5,
                            ),
                          ),
                        );

                        setState(() {});
                        context
                            .read<AttendanceCubit>()
                            .checkAssessableAreaForCircle(
                                currentLocation,
                                LatLng(
                                  customers[currentCustomerIndex]
                                      .customer!
                                      .coordinates![0]
                                      .latitude!,
                                  customers[currentCustomerIndex]
                                      .customer!
                                      .coordinates![0]
                                      .longitude!,
                                ),
                                250,
                                widget.attendanceType);
                      });
                    },
                    markers: markers,
                        polygons: {
                          Polygon(
                            polygonId: PolygonId("1"),
                            points: customers
                                .map((customer) => LatLng(
                                      customer.customer!.coordinates![0]
                                          .latitude!,
                                      customer.customer!.coordinates![0]
                                          .longitude!,
                                    ))
                                .toList(),
                            strokeWidth: 1,
                            fillColor: Colors.blue.withOpacity(0.5),
                          )
                        }.toSet(),
                        
                    circles: customers.map((customer) {
                      return Circle(
                        fillColor: Colors.blue.withOpacity(0.5),
                        strokeWidth: 1,
                        circleId: CircleId(customer.id.toString()),
                        center: LatLng(
                          customer.customer!.coordinates![0].latitude!,
                          customer.customer!.coordinates![0].longitude!,
                        ),
                        radius: 250,
                      );
                    }).toSet(),
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(0, 0),
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
                                  currentCustomerIndex =
                                      customers.indexOf(customer);
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
                                      zoom: 10.5,
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
                                        color: currentCustomerIndex ==
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
                                          Icons.person,
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
            return Center(
              child: Text(
                'You Do Not Have Customer Plans'.tr(context: context),
              ),
            );
          }
        } else if (state is GetPlanByIdError) {
          return Center(child: Text(state.error));
        } else {
          return Center(
              child: CircularProgressIndicator(
            color: ColorsManger.primaryColor,
            strokeCap: StrokeCap.round,
            strokeWidth: 3,
          ));
        }
      },
    );
  }

  @override
  void dispose() {
    googleMapController?.dispose();
    super.dispose();
  }
}
