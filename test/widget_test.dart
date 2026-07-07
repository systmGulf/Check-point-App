import 'package:employee_mangement/core/widgets/custom_app_button.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  testWidgets('CustomAppButton renders label and taps', (WidgetTester tester) async {
    var tapped = false;

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          home: Scaffold(
            body: CustomAppButton(
              textButton: 'Grant Permissions',
              buttonColor: ColorsManger.primaryColor,
              onPressed: () {
                tapped = true;
              },
            ),
          ),
        ),
      ),
    );

    expect(find.text('Grant Permissions'), findsOneWidget);

    await tester.tap(find.text('Grant Permissions'));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
