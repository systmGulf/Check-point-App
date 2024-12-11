import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../../../../core/helpers/app_spaces.dart';

class TimeLineTile extends StatelessWidget {
  const TimeLineTile(
      {super.key,
      required this.isFirst,
      required this.isLast,
      required this.name,
      required this.workesAs,
      required this.location,
      required this.notes,
      required this.visited,
      required this.visitType,
      required this.date});
  final bool isFirst, isLast, visited;
  final String name, workesAs, location, notes, visitType, date;

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        alignment: TimelineAlign.start,
        indicatorStyle: IndicatorStyle(
            width: 20,
            color: Colors.orange,
            padding: const EdgeInsets.all(6),
            indicator: visited
                ? const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 26,
                  )
                : const Icon(
                    Icons.radio_button_unchecked_outlined,
                    color: Colors.grey,
                    size: 15,
                  )),
        beforeLineStyle: const LineStyle(
          thickness: 2,
          color: Colors.grey,
        ),
        afterLineStyle: const LineStyle(
          thickness: 2,
          color: Colors.grey,
        ),
        endChild: Card(
            color: Colors.white,
            borderOnForeground: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  enableFeedback: true,

                  // dense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  title: Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        color: Color(0xFF24252C),
                        fontSize: 16,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  leading: visitType == "Customer"
                      ? CircleAvatar(
                          backgroundColor: Color(0XFFF0ECFF),
                          child: const Icon(
                            Icons.person_4,
                            color: Colors.black,
                          ),
                        )
                      : CircleAvatar(
                          backgroundColor: Color(0XFFF0ECFF),
                          child: const Icon(
                            Icons.factory_outlined,
                            color: Colors.black,
                          ),
                        ),
                  subtitle: Text(workesAs,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                      overflow: TextOverflow.ellipsis),
                  trailing: Container(
                    height: 22.h,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF0ECFF),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Text(
                            visitType,
                            style: const TextStyle(
                              color: Color(0xFF5F33E1),
                              fontSize: 11,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 15,
                                color: Colors.grey,
                              ),
                              horizontalSpace(5),
                              Text(
                                location,
                                style:
                                    const TextStyle(color: Color(0XFF24252C)),
                              ),
                              Expanded(
                                child: Text(
                                  date.substring(0, 10),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    color: Color(0x9924252C),
                                    fontSize: 12,
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w400,
                                    height: 0.12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        verticalSpace(10),
                        Text(
                          "Notes:  $notes",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                verticalSpace(10),
              ],
            )));
  }
}

Widget _buildRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title: ",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    ),
  );
}
