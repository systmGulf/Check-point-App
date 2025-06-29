import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/custom_app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

import '../../../../../../core/enums/customer_type.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../controllers/customer_cubit/customer_cubit.dart';
import '../molecules/client_image_and_name.dart';
import '../organism/edit_customer_bloc_listener.dart';

class ClientProfileScreen extends StatefulWidget {
  final String name;
  final String workedAs;
  final String location;
  final String id;
  final LatLng mapLoaction;

  const ClientProfileScreen({
    super.key,
    required this.name,
    required this.workedAs,
    required this.location,
    required this.id,
    required this.mapLoaction,
  });

  @override
  State<ClientProfileScreen> createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  String _name = '';
  String _workedAs = '';
  String _location = '';

  bool _isEditEnabled = false;

  @override
  void initState() {
    _name = widget.name;
    _workedAs = widget.workedAs;
    _location = widget.location;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(_name, style: AppStylesManger.font15BoldBlack),
        actions: [
          IconButton(
            onPressed: () async {
              if (_isEditEnabled) {
                await BlocProvider.of<CustomerCubit>(context).editCustomer(
                  customerType: CustomerType.Customer,
                  id: widget.id,
                );
              }

              setState(() {
                _isEditEnabled = !_isEditEnabled;
              });
            },
            icon: Icon(
              _isEditEnabled ? null : Icons.edit,
              color: Colors.black,
              size: 20,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: BlocProvider.of<CustomerCubit>(context).formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (!_isEditEnabled)
                  ClientImageAndName(
                    name: _name,
                    workedAs: _workedAs,
                  ),
                if (_isEditEnabled)
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: const AssetImage(
                            'assets/images/icon-default-user.png'),
                        backgroundColor: Colors.grey[200],
                      ),
                      const SizedBox(height: 16),
                      CustomAppTextFormField(
                        hint: 'Name'.tr(context: context),
                        controller: BlocProvider.of<CustomerCubit>(context)
                            .editNameController
                          ..text = _name,
                        onChanged: (value) => setState(() => _name = value),
                      ),
                      const SizedBox(height: 8),
                      CustomAppTextFormField(
                        hint: 'Worked As'.tr(context: context),
                        controller: BlocProvider.of<CustomerCubit>(context)
                            .editWorkedAsController
                          ..text = _workedAs,
                        onChanged: (value) => setState(() => _workedAs = value),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                if (!_isEditEnabled)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          const Icon(Icons.location_on, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            'Location:'.tr(context: context),
                            style: TextStyle(
                                fontSize: 15, color: Colors.blue[600]),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _location,
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[600]),
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                    ),
                  ),
                if (_isEditEnabled)
                  CustomAppTextFormField(
                    hint: 'Location'.tr(context: context),
                    controller: BlocProvider.of<CustomerCubit>(context)
                        .editLocationController
                      ..text = _location,
                    onChanged: (value) => setState(() => _location = value),
                  ),
                verticalSpace(20),
                SizedBox(
                  height: 300,
                  child: GoogleMap(
                      markers: {
                        Marker(
                          markerId: const MarkerId('1'),
                          position: widget.mapLoaction,
                        )
                      },
                      circles: {
                        Circle(
                          circleId: const CircleId('1'),
                          center: widget.mapLoaction,
                          radius: 250,
                          strokeWidth: 1,
                          fillColor: Colors.blue.withOpacity(0.5),
                        ),
                      },
                      initialCameraPosition: CameraPosition(
                        target: widget.mapLoaction,
                        zoom: 14.4746,
                      )),
                ),
                verticalSpace(20),
                if (_isEditEnabled)
                  CustomAppButton(
                    height: 50.h,
                    width: MediaQuery.of(context).size.width,
                    textButton: 'Save'.tr(context: context),
                    buttonColor: ColorsManger.primaryColor,
                    onPressed: () async {
                      if (_isEditEnabled) {
                        if (BlocProvider.of<CustomerCubit>(context)
                            .formKey
                            .currentState!
                            .validate()) {
                          context.read<CustomerCubit>().customersLocation.add(
                              CustomerLocation(
                                  latitude: widget.mapLoaction.latitude,
                                  longitude: widget.mapLoaction.longitude));
                          await BlocProvider.of<CustomerCubit>(context)
                              .editCustomer(
                            customerType: CustomerType.Customer,
                            id: widget.id,
                          );
                        }
                      }

                      setState(() {
                        _isEditEnabled = !_isEditEnabled;
                      });
                    },
                  ),
                const SizedBox(height: 16),
                const EditCustomerBlocListener(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
