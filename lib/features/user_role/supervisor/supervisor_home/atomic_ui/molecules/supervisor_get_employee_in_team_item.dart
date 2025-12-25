import 'package:employee_mangement/core/widgets/user_image.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/styles.dart';

class SupervisorGetEmployeesInTeamItem extends StatelessWidget {
  const SupervisorGetEmployeesInTeamItem({
    super.key,
    required this.name,
    required this.id,
    required this.getAllEmployeesValue,
  });
  final String name, id;
  final EmployeeData getAllEmployeesValue;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.white,
      child: Column(
        children:[
          verticalSpace(10),
          Row(
            children: [
              horizontalSpace(MediaQuery.of(context).size.width * 0.05),
              UserImage(imageUrl: getAllEmployeesValue.imageUrl,height: 30,),
              horizontalSpace(MediaQuery.of(context).size.width * 0.05),
              Expanded(
                child: Text("$name",
                    style: AppStylesManger.font16regulerBlack
                        .copyWith(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),
              ),
             
              GestureDetector(
                  onTap: () {
                    context.pushName(
                      Routes.supervisorAttendSomeEmployeeScreen,
                      arguments: getAllEmployeesValue,
                    );
                  },
                  child: const Icon(
                    Icons.phone_android,
                    color: Colors.black,
                  )),
              horizontalSpace(10),
              GestureDetector(
                onTap: () {
                  context.pushName(Routes.employeePreview, arguments: [
                    id,
                    DateTime.now().month,
                    DateTime.now().year
                  ]);
                },
                child: const Icon(Icons.remove_red_eye_outlined,
                    color: Colors.black),
              ),
              horizontalSpace(MediaQuery.of(context).size.width * 0.06),
            ],
          ),
        ],
      ),
    );
  }
}
