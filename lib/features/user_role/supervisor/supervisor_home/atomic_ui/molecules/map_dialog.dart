import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

import '../../../../../../core/common/google_places_search_service.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../../../admin/admin_home/controllers/branch_cubit/branch_cubit.dart';

class MapDialog extends StatefulWidget {
  const MapDialog({
    super.key,
    this.initialCoordinates = const [],
    this.initialAddress = '',
  });

  final List<LocationFrameLatLng> initialCoordinates;
  final String initialAddress;

  @override
  State<MapDialog> createState() => _MapDialogState();
}

class _MapDialogState extends State<MapDialog> {
  Set<Marker> markers = {};
  List<LatLng> points = [];
  Set<Polygon> polygons = {};
  String selectedAddress = '';
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
    points = widget.initialCoordinates
        .map((coordinate) => LatLng(coordinate.latitude, coordinate.longitude))
        .toList();
    selectedAddress = widget.initialAddress;
    _rebuildMapState();
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
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 190.h),
            markers: markers,
            polygons: polygons,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            onTap: _onMapTap,
            initialCameraPosition: CameraPosition(
              target: points.isEmpty
                  ? const LatLng(30.056996415506003, 31.34547305832398)
                  : points.first,
              zoom: 6,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Text(
                    'Pick Location'.tr(),
                    style: AppStylesManger.font15BoldBlack,
                  ),
                ),
                verticalSpace(12),
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
                    if (selectedAddress.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child:
                            Text(selectedAddress, textAlign: TextAlign.center),
                      ),
                    if (points.isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48.h,
                              child: OutlinedButton(
                                onPressed: _undoLastPoint,
                                child: Text('Undo'.tr()),
                              ),
                            ),
                          ),
                          horizontalSpace(12),
                          Expanded(
                            child: SizedBox(
                              height: 48.h,
                              child: OutlinedButton(
                                onPressed: _clearAllPoints,
                                child: Text('Clear All'.tr()),
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (points.isNotEmpty) verticalSpace(12),
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
                              onPressed: _setAddressFromFirstPoint,
                              child: Text(
                                'set'.tr(),
                                style: AppStylesManger.font14regularWhite
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        horizontalSpace(10),
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
                              },
                              child: Text(
                                'cancel'.tr(),
                                style: AppStylesManger.font14regularWhite
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    verticalSpace(12),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 55.h,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            ColorsManger.primaryColor,
                          ),
                        ),
                        onPressed: _applyAndClose,
                        child: Text(
                          'Done'.tr(),
                          style: AppStylesManger.font14regularWhite
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
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

  void _onMapTap(LatLng point) {
    setState(() {
      points.add(point);
      _rebuildMapState();
    });
  }

  Future<void> _setAddressFromFirstPoint() async {
    if (points.isEmpty) return;
    try {
      final placemarks = await placemarkFromCoordinates(
        points.first.latitude,
        points.first.longitude,
      );
      if (!mounted || placemarks.isEmpty) return;
      setState(() {
        final address = placemarks.first;
        selectedAddress =
            ' ${address.name} ${address.subAdministrativeArea} ${address.administrativeArea} ${address.country}';
      });
    } catch (_) {}
  }

  void _applyAndClose() {
    final branchCubit = context.read<BranchCubit>();
    branchCubit.locationFrame
      ..clear()
      ..addAll(
        points
            .map(
              (point) => LocationFrameLatLng(
                latitude: point.latitude,
                longitude: point.longitude,
              ),
            )
            .toList(),
      );
    branchCubit.locationController.text = selectedAddress;
    Navigator.pop(context);
  }

  void _undoLastPoint() {
    if (points.isEmpty) return;
    setState(() {
      points.removeLast();
      if (points.isEmpty) {
        selectedAddress = '';
      }
      _rebuildMapState();
    });
  }

  void _clearAllPoints() {
    setState(() {
      points.clear();
      selectedAddress = '';
      _rebuildMapState();
    });
  }

  void _rebuildMapState() {
    markers = points
        .map(
          (point) => Marker(
            markerId: MarkerId(point.toString()),
            position: point,
          ),
        )
        .toSet();

    if (points.length >= 2) {
      polygons = {
        Polygon(
          polygonId: const PolygonId('poly'),
          points: points,
          strokeWidth: 2,
          strokeColor: Colors.blue,
          fillColor: Colors.blue.withValues(alpha: 0.3),
        ),
      };
    } else {
      polygons = {};
    }
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
