import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/user_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/animations/animations.dart';
import '../../../../../../core/dependencyـinjection/registerـfactory.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/utils/assets_manager.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import '../enitities/user_item_entity.dart';
import '../pages/edit_user_screen.dart';

class UserItemListView extends StatelessWidget {
  const UserItemListView({
    super.key,
    required this.userItemEntity,
  });
  final UserItemEntity userItemEntity;
  @override
  Widget build(BuildContext context) {
    return AnimatedCardWidget(
      backgroundColor: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          UserImage(height: 50, imageUrl: userItemEntity.imageUrl),
          horizontalSpace(20),
          Expanded(
            flex: 4,
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userItemEntity.userName,
                    style: AppStylesManger.font15BoldBlue
                        .copyWith(color: ColorsManger.primaryColor)),
                Text(
                  userItemEntity.position,
                  style: AppStylesManger.font14RegularBlack.copyWith(
                      color: const Color.fromARGB(255, 122, 121, 121)),
                  overflow: TextOverflow.ellipsis,
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: "${"Team".tr(context: context)} : ",
                      style: AppStylesManger.font14RegularBlack.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 122, 121, 121))),
                  TextSpan(
                      text: userItemEntity.department,
                      style: AppStylesManger.font14RegularBlack
                          .copyWith(color: Colors.grey))
                ])),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: "${"Shift".tr(context: context)} : ",
                      style: AppStylesManger.font14RegularBlack.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 122, 121, 121))),
                  TextSpan(
                      text: userItemEntity.shiftName.tr(context: context),
                      style: AppStylesManger.font14RegularBlack.copyWith(
                          color: userItemEntity.shiftName == 'No Shift Assigned'
                              ? Colors.blueAccent
                              : Colors.grey))
                ])),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return BlocProvider(
                      create: (context) => getIt<EmployeeCubit>(),
                      child: EditUser(
                        userItemEntity: userItemEntity,
                      ),
                    );
                  },
                ),
              ).then((value) {
                context
                    .read<EmployeeCubit>()
                    .getAllEmployees(pageNumber: 0, itemCount: 10);
              });
            },
            icon: SizedBox(
              height: 26,
              width: 26,
              child: Center(
                child: SvgPicture.asset(
                  Assets.EditImage,
                  color: ColorsManger.primaryColor,
                ),
              ),
            ),
            color: Colors.blue,
          ),
          horizontalSpace(0),
          IconButton(
            onPressed: userItemEntity.onDelete,
            icon: SizedBox(
                height: 24,
                width: 24,
                child: Center(child: SvgPicture.asset(Assets.DeleteIconImage))),
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
