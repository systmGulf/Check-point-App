import 'package:flutter/material.dart';

class AdminManagementScreenItems extends StatelessWidget {
  const AdminManagementScreenItems(
      {super.key,
      required this.color,
      required this.text,
      required this.icon,
      this.onTap});
  final Color color;
  final String text;
  final IconData icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: IntrinsicWidth(
          child: Row(
            children: [
              Container(
                width: 5,
                height: 60,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.88,
                child: ListTile(
                  dense: true,
                  leading: Icon(icon, color: color),
                  title: Text(text, style: const TextStyle(fontSize: 14)),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
