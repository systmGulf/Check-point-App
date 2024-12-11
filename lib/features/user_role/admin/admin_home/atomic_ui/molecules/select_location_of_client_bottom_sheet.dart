import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hr_management_system_package/admin/data/models/customers/add_customer_request_body.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../controllers/customer_cubit/customer_cubit.dart';

class SelectLocationOfClientBottomSheet extends StatefulWidget {
  const SelectLocationOfClientBottomSheet({
    super.key,
  });

  @override
  State<SelectLocationOfClientBottomSheet> createState() =>
      _SelectLocationOfClientBottomSheetState();
}

class _SelectLocationOfClientBottomSheetState
    extends State<SelectLocationOfClientBottomSheet> {
  Set<Marker> markers = {};
  @override
  void initState() {
    super.initState();
    markers = {};
    context.read<CustomerCubit>().customersLocation.clear();
  }

  double radius = 100;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Center(
          child: Stack(children: [
        GoogleMap(
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            markers: markers,
            circles: context
                .read<CustomerCubit>()
                .customersLocation
                .map((e) => Circle(
                      circleId: const CircleId('1'),
                      center: LatLng(e.latitude, e.longitude),
                      fillColor: Colors.blue.withOpacity(0.5),
                      strokeColor: Colors.blue.withOpacity(0.5),
                      radius: radius,
                    ))
                .toSet(),
            onMapCreated: (GoogleMapController controller) {},
            onTap: (LatLng latLng) {
              context.read<CustomerCubit>().customersLocation.add(
                    CustomerLocation(
                        latitude: latLng.latitude, longitude: latLng.longitude),
                  );
              setState(() {
                markers.add(
                  Marker(
                    markerId: const MarkerId('1'),
                    position: latLng,
                    draggable: true,
                    onDragEnd: (value) {},
                  ),
                );
              });
            },
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 60),
            initialCameraPosition: const CameraPosition(
                target: LatLng(30.033333, 31.233334), zoom: 10)),
        Positioned(
          bottom: 20,
          right: 20,
          left: 20,
          child: Column(
            children: [
              markers.isEmpty
                  ? Container()
                  : FlutterSlider(
                      values: [radius],
                      max: 500,
                      min: 0,
                      onDragging: (handlerIndex, lowerValue, upperValue) {
                        radius = lowerValue;

                        setState(() {});
                      },
                    ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: CustomAppButton(
                    textButton: 'Submit'.tr(context: context),
                    buttonColor: ColorsManger.primaryColor,
                    onPressed: () {
                      if (context
                          .read<CustomerCubit>()
                          .customersLocation
                          .isNotEmpty) {
                        Navigator.of(context).pop();
                      } else {
                        showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.error(
                            message:
                                'Please Select Location'.tr(context: context),
                            // backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
        Positioned(
          top: MediaQuery.sizeOf(context).height * 0.06,
          right: 20,
          left: 20,
          child: CustomAppTextFormField(
              hint: 'Search Location'.tr(context: context)),
        )
      ])),
    );
  }
}
