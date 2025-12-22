import 'package:flutter/material.dart';

import '../../../../../../core/packages/src/floating_search_bar.dart';
import '../../../../../../core/packages/src/floating_search_bar_actions.dart';
import '../../../../../../core/packages/src/floating_search_bar_transition.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key, required this.searchText, required this.child, this.onQueryChanged});
  final String searchText;
  final Widget child;
  final Function(String)? onQueryChanged;

  @override
  Widget build(BuildContext context) {
   final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
//   return Container(
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(10),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey.withOpacity(0.5),
//           spreadRadius: 2,
//           blurRadius: 5,
//           offset: const Offset(0, 3),
//         ),
//       ],
//     ),
//     child: TextField(
//       onChanged: onQueryChanged,
//       decoration: InputDecoration(
//         hintText: searchText,
//         prefixIcon: const Icon(Icons.search, color: Colors.grey),
//         border: InputBorder.none,
//         contentPadding: EdgeInsets.symmetric(
//           vertical: isPortrait ? 15 : 10,
//           horizontal: 20,
//         ),
//       ),
//       )
//   )
// ;

  return FloatingSearchBar(
      showCursor: false,
      elevation: 0,
      backgroundColor: Colors.white,
      borderRadius: BorderRadius.circular(8),
      hint: searchText,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      clearQueryOnClose: false,
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: onQueryChanged,
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return child;
      });
  }
}