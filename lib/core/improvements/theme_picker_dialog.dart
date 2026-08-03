import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dynamic_theme_cubit.dart';

class ThemePickerDialog extends StatelessWidget {
  const ThemePickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, Color>> colors = [
      {'primary': const Color(0xFFDA9F2A), 'light': const Color(0xFFE8BE6B)}, // Art Attack Gold
      {'primary': const Color(0XFF7C3AED), 'light': const Color(0XFFC084FC)}, // Purple
      {'primary': const Color(0XFF0ea5e9), 'light': const Color(0XFF7dd3fc)}, // Sky Blue
      {'primary': const Color(0XFF10b981), 'light': const Color(0XFF6ee7b7)}, // Teal/Green
      {'primary': const Color(0XFFef4444), 'light': const Color(0XFFfca5a5)}, // Red
    ];

    return AlertDialog(
      title: const Text('Select Theme Color'),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: colors.length,
          itemBuilder: (context, index) {
            final colorSet = colors[index];
            return InkWell(
              onTap: () {
                context.read<DynamicThemeCubit>().updateTheme(
                      primary: colorSet['primary']!,
                      light: colorSet['light']!,
                    );
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: colorSet['primary'],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 4),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
