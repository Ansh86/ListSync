// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:to_do_app/ui/add_task_page.dart';
//
// import '../../controllers/task_controller.dart';
// import '../theme.dart';
// import 'button.dart';
//
// class AddTaskBar extends StatelessWidget {
//
//   const AddTaskBar({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final _taskController = Get.put(TaskController());
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(DateFormat.yMMMMd().format(DateTime.now()),
//                   style: subHeadingStyle,),
//                 Text("Today", style: headingStyle,),
//               ],
//             ),
//           ),
//           MyButton(label: "+ Add Task",onTap: ()async{
//             await Get.to(()=>AddTaskPage());
//             _taskController.getTasks();
//           }),
//         ],
//       ),
//     );
//   }
// }
