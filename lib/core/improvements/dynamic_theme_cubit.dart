import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../styles/colors.dart';

class DynamicThemeState {
  final Color primaryColor;
  final Color primaryColorLight;
  DynamicThemeState({required this.primaryColor, required this.primaryColorLight});
}

class DynamicThemeCubit extends Cubit<DynamicThemeState> {
  DynamicThemeCubit()
      : super(DynamicThemeState(
          primaryColor: ColorsManger.primaryColor,
          primaryColorLight: ColorsManger.primaryColorLight,
        )) {
    loadCachedTheme();
  }

  Future<void> loadCachedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedPrimary = prefs.getInt('theme_primary_color');
    final cachedLight = prefs.getInt('theme_light_color');
    if (cachedPrimary != null && cachedLight != null) {
      final oldDefaults = [
        0XFFF97316, 4294538006,
        0xFFDA9F2A, 4292517674,
        0xFFDC2626, 4292584998,
        0xFF757575, 4285887861,
        0xFF1D50D7, 4280144087,
        0xFF00ADEF, 4278234607,
        0xFF2596BE, 4280686270,
      ];
      if (oldDefaults.contains(cachedPrimary)) {
        // Upgrade legacy cached themes to the new Brand Blue theme
        ColorsManger.primaryColor = const Color(0xFF295BDD);
        ColorsManger.primaryColorLight = const Color(0xFF6B7280);
        await prefs.setInt('theme_primary_color', ColorsManger.primaryColor.value);
        await prefs.setInt('theme_light_color', ColorsManger.primaryColorLight.value);
        emit(DynamicThemeState(
          primaryColor: ColorsManger.primaryColor,
          primaryColorLight: ColorsManger.primaryColorLight,
        ));
      } else {
        final pColor = Color(cachedPrimary);
        final lColor = Color(cachedLight);
        ColorsManger.primaryColor = pColor;
        ColorsManger.primaryColorLight = lColor;
        emit(DynamicThemeState(primaryColor: pColor, primaryColorLight: lColor));
      }
    } else {
      await prefs.setInt('theme_primary_color', ColorsManger.primaryColor.value);
      await prefs.setInt('theme_light_color', ColorsManger.primaryColorLight.value);
      emit(DynamicThemeState(
        primaryColor: ColorsManger.primaryColor,
        primaryColorLight: ColorsManger.primaryColorLight,
      ));
    }
  }

  Future<void> updateTheme({required Color primary, required Color light}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_primary_color', primary.value);
    await prefs.setInt('theme_light_color', light.value);
    ColorsManger.primaryColor = primary;
    ColorsManger.primaryColorLight = light;
    emit(DynamicThemeState(primaryColor: primary, primaryColorLight: light));
  }
}
