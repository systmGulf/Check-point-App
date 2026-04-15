import 'dart:convert';

import 'package:employee_mangement/core/widgets/build_custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../core/styles/styles.dart';
import '../../controller/attendence/attendence_cubit.dart';
import '../organism/time_line_tile.dart';

class MyPlansDetailsScreen extends StatefulWidget {
  const MyPlansDetailsScreen({super.key});

  @override
  State<MyPlansDetailsScreen> createState() => _MyPlansDetailsScreenState();
}

class _MyPlansDetailsScreenState extends State<MyPlansDetailsScreen> {
  Map<String, int> _itemColors = {};

  @override
  void initState() {
    super.initState();
    _loadSavedColors();
  }

  Future<void> _loadSavedColors() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('saved_plan_colors');
    if (jsonString != null) {
      setState(() {
        _itemColors = Map<String, int>.from(jsonDecode(jsonString));
      });
    }
  }

  Future<void> _saveColor(int index, Color color) async {
    final prefs = await SharedPreferences.getInstance();
    _itemColors[index.toString()] = color.value;
    await prefs.setString('saved_plan_colors', jsonEncode(_itemColors));
    setState(() {});
  }

  void _pickColor(int index) {
    showDialog(
      barrierColor: Colors.black26,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          "Choose Item Color",
          style: AppStylesManger.font14RegularBlack
              .copyWith(fontWeight: FontWeight.bold),
        ),
        content: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _colorOption(index, Colors.red),
            _colorOption(index, Colors.green),
            _colorOption(index, Colors.blue),
            _colorOption(index, Colors.orange),
            _colorOption(index, Colors.purple),
            _colorOption(index, Colors.white), // Reset option
          ],
        ),
      ),
    );
  }

  Widget _colorOption(int index, Color color) {
    return GestureDetector(
      onTap: () {
        _saveColor(index, color);
        Navigator.pop(context);
      },
      child: CircleAvatar(
          backgroundColor: Colors.grey[300],
          radius: 22,
          child: CircleAvatar(backgroundColor: color, radius: 20)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context, 'My Plans Details'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<AttendanceCubit, AttendanceState>(
          builder: (context, state) {
            if (state is GetPlanByIdIdDone) {
              return ListView.builder(
                itemCount: state.plansById.customerPlans!.length,
                itemBuilder: (context, index) {
                  // Get the saved color or default to transparent/white
                  int? colorValue = _itemColors[index.toString()];
                  Color bgColor = colorValue != null
                      ? Color(colorValue)
                      : Colors.transparent;

                  return GestureDetector(
                    onLongPress: () =>
                        _pickColor(index), // Long press to pick color
                    child: TimeLineTile(
                      color: bgColor,
                      date: state.plansById.planDate ?? '',
                      visitType: state.plansById.customerPlans![index].customer!
                          .customerType!,
                      visited: state.plansById.customerPlans![index].visited!,
                      isFirst: index == 0,
                      isLast:
                          index == state.plansById.customerPlans!.length - 1,
                      name: state
                              .plansById.customerPlans![index].customer!.name ??
                          '',
                      notes: state.plansById.customerPlans![index].note ?? '',
                      workesAs: state.plansById.customerPlans![index].customer!
                              .workesAs ??
                          '',
                      location: state.plansById.customerPlans![index].customer!
                              .location ??
                          '',
                    ),
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
