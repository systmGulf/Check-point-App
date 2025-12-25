
  import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';

Future<dynamic> buildShowEmployeeImageDialog(BuildContext context,
    {required String? employeeImage}) {
    return showDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                content: SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.5,
                                  width: 300.w,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Employee Image",
                                        style: AppStylesManger.font15BoldrBlue
                                            .copyWith(color: Colors.black),
                                      ),
                                      verticalSpace(5),
                                      CachedNetworkImage(
                                        height: MediaQuery.sizeOf(context)
                                                .height *
                                            0.46,
                                        fit: BoxFit.fill,
                                        imageUrl:
                                            "http://emsdemo.runasp.net${employeeImage}",
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator(
                                          color: ColorsManger.primaryColor,
                                          valueColor: AlwaysStoppedAnimation(
                                            ColorsManger.primaryColor,
                                          ),
                                        )),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
  }

