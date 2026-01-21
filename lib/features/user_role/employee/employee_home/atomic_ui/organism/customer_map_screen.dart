import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hr_management_system_package/core/core.dart';
import 'package:lottie/lottie.dart' show Lottie;

import '../../../../../../core/enums/attendance_type_enum.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../controller/attendence/attendence_cubit.dart';

class CustomerMapScreen extends StatefulWidget {
  final AttendanceTypeEnum attendanceType;
  final ValueChanged oncustomerChanged;

  const CustomerMapScreen({
    super.key,
    required this.attendanceType,
    required this.oncustomerChanged,
  });

  @override
  State<CustomerMapScreen> createState() => _CustomerMapScreenState();
}

class _CustomerMapScreenState extends State<CustomerMapScreen> {
  GoogleMapController? googleMapController;
  int currentCustomerIndex = 0;

  Set<Marker> markers = {};
  bool isServiceRunning = false;

  @override
  @override
  void initState() {
    super.initState();
    final service = FlutterBackgroundService();

    service.on('service_status').listen((event) {
      if (!mounted || event == null) return;
      setState(() {
        isServiceRunning = event['running'] ?? false;
      });
    });

    service.invoke('get_status');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceCubit, AttendanceState>(
      buildWhen: (previous, current) =>
          current is GetCustomerAreaDone ||
          current is GetPlanByIdIdDone ||
          current is GetCustomerAreaLoading,
      builder: (context, state) {
        if (state is GetCustomerAreaDone) {
          final today = DateTime.now();

          final customers = state.customerArea.value!.data!
              .where((e) =>
                  e.customer!.customerType == "Customer" &&
                  e.plan?.planDate != null &&
                  DateUtils.isSameDay(e.plan!.planDate!, today))
              .toList();

          if (customers.isEmpty) {
            return Center(
              child: Column(
                children: [
                  Lottie.asset(
                    'assets/animated_images/empty.json',
                    repeat: false,
                    height: 150.h,
                    width: 150.w,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    'You Do Not Have Customer Plans Today'.tr(context: context),
                  ),
                ],
              ),
            );
          }

          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Stack(
              children: [
                /// 🗺 MAP
                GoogleMap(
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  onMapCreated: (controller) {
                    googleMapController = controller;

                    LocationService.getRealTimeLocation((locationData) {
                      if (!mounted) return;

                      final currentLocation = LatLng(
                        locationData.latitude!,
                        locationData.longitude!,
                      );

                      markers
                        ..clear()
                        ..addAll(customers.map((c) => Marker(
                              markerId: MarkerId(c.id.toString()),
                              position: LatLng(
                                c.customer!.coordinates![0].latitude!,
                                c.customer!.coordinates![0].longitude!,
                              ),
                            )));

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
                            widget.attendanceType,
                          );
                    });
                  },
                  markers: markers,
                  circles: customers
                      .map(
                        (c) => Circle(
                          circleId: CircleId(c.id.toString()),
                          center: LatLng(
                            c.customer!.coordinates![0].latitude!,
                            c.customer!.coordinates![0].longitude!,
                          ),
                          radius: 250,
                          strokeWidth: 1,
                          fillColor: Colors.blue.withValues(alpha: 0.5),
                        ),
                      )
                      .toSet(),
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(0, 0),
                    zoom: 5,
                  ),
                ),

                Positioned(
                  top: 55.h,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: customers.map((customer) {
                          final index = customers.indexOf(customer);
                          return InkWell(
                            onTap: () {
                              setState(() {
                                currentCustomerIndex = index;
                                widget.oncustomerChanged(customers[index]);
                              });

                              googleMapController!.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: LatLng(
                                      customer
                                          .customer!.coordinates![0].latitude!,
                                      customer
                                          .customer!.coordinates![0].longitude!,
                                    ),
                                    zoom: 16.5,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              width: MediaQuery.sizeOf(context).width * 0.7,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: currentCustomerIndex == index
                                      ? ColorsManger.primaryColor
                                      : Colors.white,
                                ),
                              ),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: Colors.black,
                                  child:
                                      Icon(Icons.person, color: Colors.white),
                                ),
                                title: Text(
                                  customer.customer!.name!,
                                  style: AppStylesManger.font14RegularBlack
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  customer.customer!.workesAs!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: MaterialButton(
                      color: isServiceRunning ? Colors.red : Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onPressed: () async {
                        final service = FlutterBackgroundService();

                        if (isServiceRunning) {
                          service.invoke('stop');
                          setState(() => isServiceRunning = false);
                        } else {
                          await service.startService();
                          service.invoke('setAsForeground');
                          setState(() => isServiceRunning = true);
                        }
                      },
                      child: Text(
                        isServiceRunning ? 'إيقاف التتبع' : 'تشغيل التتبع',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is GetPlanByIdError) {
          return Center(child: Text(state.error));
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  void dispose() {
    googleMapController?.dispose();
    super.dispose();
  }
}
