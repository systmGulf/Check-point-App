import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/custom_app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../helpers/app_spaces.dart';
import '../styles/colors.dart';
import '../styles/styles.dart';

/// Predefined date-period options that map to a computed [DateTimeRange].
enum DatePeriodOption {
  last90Days,
  last180Days,
  lastYear,
  custom,
}

class CustomFilterContainer extends StatefulWidget {
  final String statusOne;
  final String statusTwo;
  final String statusThree;
  const CustomFilterContainer({
    super.key,
    required this.statusOne,
    required this.statusTwo,
    required this.statusThree,
  });

  @override
  State<CustomFilterContainer> createState() => _CustomFilterContainerState();
}

class _CustomFilterContainerState extends State<CustomFilterContainer> {
  bool statusOne = false;
  bool statusTwo = false;
  bool statusThree = false;

  DatePeriodOption? _selectedPeriod;
  DateTimeRange? _customRange;

  // ── helpers ──

  DateTimeRange? get _computedRange {
    final now = DateTime.now();
    switch (_selectedPeriod) {
      case DatePeriodOption.last90Days:
        return DateTimeRange(
          start: now.subtract(const Duration(days: 90)),
          end: now,
        );
      case DatePeriodOption.last180Days:
        return DateTimeRange(
          start: now.subtract(const Duration(days: 180)),
          end: now,
        );
      case DatePeriodOption.lastYear:
        return DateTimeRange(
          start: DateTime(now.year - 1, now.month, now.day),
          end: now,
        );
      case DatePeriodOption.custom:
        return _customRange;
      case null:
        return null;
    }
  }

  String _periodLabel(DatePeriodOption option) {
    switch (option) {
      case DatePeriodOption.last90Days:
        return 'filter.last90Days'.tr();
      case DatePeriodOption.last180Days:
        return 'filter.last180Days'.tr();
      case DatePeriodOption.lastYear:
        return 'filter.lastYear'.tr();
      case DatePeriodOption.custom:
        return 'filter.custom'.tr();
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd').format(date);
  }

  Future<void> _pickCustomRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: _customRange ??
          DateTimeRange(
            start: now.subtract(const Duration(days: 30)),
            end: now,
          ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorsManger.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _customRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text(
                    'Filter'.tr(),
                    style: AppStylesManger.font16BoldBlack,
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
              verticalSpace(16),

              // ── Date Period Section ──
              Text(
                'filter.period'.tr(),
                style: AppStylesManger.font14MediumBlack,
              ),
              verticalSpace(8),

              // Date range display (shown when a period is selected)
              if (_computedRange != null) ...[
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    '${_formatDate(_computedRange!.end)}  ←  ${_formatDate(_computedRange!.start)}',
                    style: AppStylesManger.font14RegularBlack,
                    textAlign: TextAlign.center,
                  ),
                ),
                verticalSpace(8),
              ],

              // Period dropdown
              Container(
                width: double.infinity,
                padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<DatePeriodOption>(
                    isExpanded: true,
                    value: _selectedPeriod,
                    hint: Text(
                      'filter.selectPeriod'.tr(),
                      style: AppStylesManger.font14RegularBlack
                          .copyWith(color: Colors.grey),
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: DatePeriodOption.values.map((option) {
                      return DropdownMenuItem<DatePeriodOption>(
                        value: option,
                        child: Text(
                          _periodLabel(option),
                          style: AppStylesManger.font14RegularBlack,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPeriod = value;
                      });
                      if (value == DatePeriodOption.custom) {
                        _pickCustomRange();
                      }
                    },
                  ),
                ),
              ),

              verticalSpace(16),

              // ── Status Section ──
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Status'.tr(),
                            style: AppStylesManger.font16BoldBlack,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                statusOne = false;
                                statusTwo = false;
                                statusThree = false;
                                _selectedPeriod = null;
                                _customRange = null;
                              });
                              final filterData = {
                                'statusOne': false,
                                'statusTwo': false,
                                'statusThree': false,
                                'date': null,
                                'dateFrom': null,
                                'dateTo': null,
                              };
                              Navigator.pop(context, filterData);
                            },
                            child: Text(
                              'Reset Filters'.tr(),
                              style: AppStylesManger.font16BoldBlack.copyWith(
                                color: ColorsManger.primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalSpace(8),
                    const Divider(),
                    verticalSpace(8),
                    Row(
                      children: [
                        Checkbox(
                          value: statusOne,
                          onChanged: (val) {
                            setState(() {
                              statusOne = val!;
                            });
                          },
                          activeColor: ColorsManger.primaryColor,
                        ),
                        Text(
                          widget.statusOne,
                          style: AppStylesManger.font14RegularBlack,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: statusTwo,
                          onChanged: (val) {
                            setState(() {
                              statusTwo = val!;
                            });
                          },
                          activeColor: ColorsManger.primaryColor,
                        ),
                        Text(
                          widget.statusTwo,
                          style: AppStylesManger.font14RegularBlack,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: statusThree,
                          onChanged: (val) {
                            setState(() {
                              statusThree = val!;
                            });
                          },
                          activeColor: ColorsManger.primaryColor,
                        ),
                        Text(
                          widget.statusThree,
                          style: AppStylesManger.font14RegularBlack,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              verticalSpace(16),

              // ── Action Buttons ──
              Row(
                spacing: 8,
                children: [
                  Flexible(
                    child: CustomAppButton(
                      textButton: 'Submit'.tr(),
                      buttonColor: ColorsManger.primaryColor,
                      onPressed: () {
                        final range = _computedRange;
                        final filterData = {
                          'statusOne': statusOne,
                          'statusTwo': statusTwo,
                          'statusThree': statusThree,
                          'dateFrom': range?.start,
                          'dateTo': range?.end,
                        };
                        Navigator.pop(context, filterData);
                      },
                    ),
                  ),
                ],
              ),
              verticalSpace(30),
            ],
          ),
        ),
      ],
    );
  }
}
