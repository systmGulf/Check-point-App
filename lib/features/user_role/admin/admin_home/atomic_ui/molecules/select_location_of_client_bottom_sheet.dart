import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/app_top_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

import '../../../../../../core/common/google_places_search_service.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../controllers/customer_cubit/customer_cubit.dart';

class SelectLocationOfClientBottomSheet extends StatefulWidget {
  const SelectLocationOfClientBottomSheet({
    super.key,
    this.initialCoordinates = const [],
  });

  final List<CustomerLocation> initialCoordinates;

  @override
  State<SelectLocationOfClientBottomSheet> createState() =>
      _SelectLocationOfClientBottomSheetState();
}

class _SelectLocationOfClientBottomSheetState
    extends State<SelectLocationOfClientBottomSheet> {
  Set<Marker> markers = {};
  List<CustomerLocation> _draftLocations = [];
  double radius = 100;
  final TextEditingController _searchController = TextEditingController();
  final GooglePlacesSearchService _placesSearchService =
      GooglePlacesSearchService();
  List<GooglePlaceSuggestion> _suggestions = [];
  GoogleMapController? _mapController;
  Timer? _debounce;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _draftLocations = widget.initialCoordinates
        .map(
          (location) => CustomerLocation(
            latitude: location.latitude,
            longitude: location.longitude,
          ),
        )
        .toList();
    _rebuildMarkers();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Center(
        child: Stack(
          children: [
            GoogleMap(
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              markers: markers,
              circles: _draftLocations
                  .map(
                    (location) => Circle(
                      circleId: CircleId(
                        '${location.latitude}_${location.longitude}',
                      ),
                      center: LatLng(location.latitude, location.longitude),
                      fillColor: Colors.blue.withValues(alpha: 0.5),
                      strokeColor: Colors.blue.withValues(alpha: 0.5),
                      radius: radius,
                    ),
                  )
                  .toSet(),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              onTap: (LatLng latLng) {
                setState(() {
                  _draftLocations.add(
                    CustomerLocation(
                      latitude: latLng.latitude,
                      longitude: latLng.longitude,
                    ),
                  );
                  _rebuildMarkers();
                });
              },
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 60),
              initialCameraPosition: CameraPosition(
                target: _draftLocations.isEmpty
                    ? const LatLng(30.033333, 31.233334)
                    : LatLng(
                        _draftLocations.first.latitude,
                        _draftLocations.first.longitude,
                      ),
                zoom: 10,
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              left: 20,
              child: Column(
                children: [
                  if (_draftLocations.isNotEmpty)
                    FlutterSlider(
                      values: [radius],
                      max: 500,
                      min: 0,
                      onDragging: (handlerIndex, lowerValue, upperValue) {
                        radius = lowerValue as double;
                        setState(() {});
                      },
                    ),
                  if (_draftLocations.isNotEmpty)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _undoLastPoint,
                            child: Text('Undo'.tr()),
                          ),
                        ),
                        horizontalSpace(12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _clearAllPoints,
                            child: Text('Clear All'.tr()),
                          ),
                        ),
                      ],
                    ),
                  if (_draftLocations.isNotEmpty) verticalSpace(12),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: CustomAppButton(
                      textButton: 'Submit'.tr(),
                      buttonColor: ColorsManger.primaryColor,
                      onPressed: () {
                        if (_draftLocations.isNotEmpty) {
                          context.read<CustomerCubit>().customersLocation =
                              _draftLocations
                                  .map(
                                    (location) => CustomerLocation(
                                      latitude: location.latitude,
                                      longitude: location.longitude,
                                    ),
                                  )
                                  .toList();
                          Navigator.of(context).pop();
                        } else {
                          showTopSnackBar(
                            Overlay.of(context),
                            CustomSnackBar.error(
                              message:
                                  'Please Select Location'.tr(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.sizeOf(context).height * 0.06,
              right: 20,
              left: 20,
              child: Column(
                children: [
                  CustomAppTextFormField(
                    controller: _searchController,
                    hint: 'Search Location'.tr(),
                    onChanged: _onSearchChanged,
                    suffixIcon: _isSearching
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : const Icon(Icons.search),
                  ),
                  if (_suggestions.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      constraints: const BoxConstraints(maxHeight: 220),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _suggestions.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final suggestion = _suggestions[index];
                          return ListTile(
                            leading: const Icon(Icons.location_on_outlined),
                            title: Text(suggestion.description),
                            onTap: () => _selectSuggestion(suggestion),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _undoLastPoint() {
    if (_draftLocations.isEmpty) return;
    setState(() {
      _draftLocations.removeLast();
      _rebuildMarkers();
    });
  }

  void _clearAllPoints() {
    setState(() {
      _draftLocations.clear();
      _rebuildMarkers();
    });
  }

  void _rebuildMarkers() {
    markers = _draftLocations
        .map(
          (location) => Marker(
            markerId: MarkerId(
              '${location.latitude}_${location.longitude}',
            ),
            position: LatLng(location.latitude, location.longitude),
          ),
        )
        .toSet();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    if (value.trim().isEmpty) {
      setState(() {
        _suggestions = [];
        _isSearching = false;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      setState(() {
        _isSearching = true;
      });
      final suggestions = await _placesSearchService.autocomplete(value);
      if (!mounted) return;
      setState(() {
        _suggestions = suggestions;
        _isSearching = false;
      });
    });
  }

  Future<void> _selectSuggestion(GooglePlaceSuggestion suggestion) async {
    final place = await _placesSearchService.getPlaceLocation(
      suggestion.placeId,
    );
    if (!mounted || place == null) return;

    _searchController.text = suggestion.description;
    setState(() {
      _suggestions = [];
    });

    await _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: place.latLng, zoom: 16),
      ),
    );
  }
}
