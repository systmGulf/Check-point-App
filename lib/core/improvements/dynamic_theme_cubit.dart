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
      if (cachedPrimary == 0XFFF97316 || cachedPrimary == 4294538006 || cachedPrimary == 0xFFDA9F2A || cachedPrimary == 4292517674) {
        // Upgrade legacy cached themes to new Red theme
        ColorsManger.primaryColor = const Color(0xFFDC2626);
        ColorsManger.primaryColorLight = const Color(0xFFEF5350);
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
