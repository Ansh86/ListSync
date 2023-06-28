


import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:list_sync/controllers/task_controller.dart';
import 'package:list_sync/services/notifications_services.dart';
import 'package:list_sync/services/theme_services.dart';
import 'package:list_sync/ui/theme.dart';

import 'package:list_sync/ui/widgets/add_date_bar.dart';
import 'package:list_sync/ui/widgets/add_task_bar.dart';
import 'package:list_sync/ui/widgets/bottom_button.dart';
import 'package:list_sync/ui/widgets/button.dart';
import 'package:list_sync/ui/widgets/task_tile.dart';


import '../Models/task.dart';
import 'add_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate= DateTime.now();
  var notifyHelper;
  final _taskController = Get.put(TaskController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper=NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }
  @override
  Widget build(BuildContext context) {
    print("Build method called");
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        children:  [
        _addTaskBar(),
        _addDateBar(),
      SizedBox(height: 10,),
      _showTasks(),
        ],
      ),
    );
  }

_showTasks(){
    return Expanded(
        child: Obx((){
          return ListView.builder(
            itemCount: _taskController.taskList.length,
              itemBuilder: (_, index){
               Task task= _taskController.taskList[index];
               print(task.toJson());
               if(task.repeat=='Daily'){
                 DateTime date= DateFormat.jm().parse(task.startTime.toString());
                 var myTime= DateFormat("HH:mm").format(date);
                 notifyHelper.scheduledNotification(
                   int.parse(myTime.toString().split(":")[0]),
                   int.parse(myTime.toString().split(":")[1]),
                   task
                 );
                 return  AnimationConfiguration.staggeredList(
                     position: index,
                     child: SlideAnimation(
                       child: FadeInAnimation(
                         child: Row(
                           children: [
                             GestureDetector(
                               onTap: (){
                                 _showBottomSheet(context, task);
                               },
                               child: TaskTile(task),
                             )
                           ],
                         ),
                       ),
                     ));

               }
               if(task.date==DateFormat.yMd().format(_selectedDate)){
                 return AnimationConfiguration.staggeredList(
                     position: index,
                     child: SlideAnimation(

                       child: FadeInAnimation(
                         child: Row(
                           children: [
                             GestureDetector(
                               onTap: (){
                                 _showBottomSheet(context, task);
                               },
                               child: TaskTile(task),
                             )
                           ],
                         ),
                       ),
                     ));
               }
               

              else{
               return Container();
               }

          });
        }));
}

_showBottomSheet(BuildContext context, Task task){
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted==1?
            MediaQuery.of(context).size.height*0.24:
            MediaQuery.of(context).size.height*0.32,
        color: Get.isDarkMode?darkGreyClr:Colors.white,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 2),
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode?Colors.grey[600]:Colors.grey[300],
              ),
            ),
            Spacer(),
            task.isCompleted==1?
                Container():BottomButton(
                label: "Task Completed",
                onTap: (){
                  _taskController.markTaskCompleted(task.id!);
                  Get.back();
                },
                clr: primaryClr,
            context: context,),
            SizedBox(height: 2,),
            BottomButton(
              label: "Delete Task",
              onTap: (){
                _taskController.delete(task);

                Get.back();
              },
              clr: Colors.amberAccent,
              context: context,),
            SizedBox(height: 15,),
            BottomButton(
              label: "Close",
              onTap: (){
                Get.back();
              },
              isClose: true,
              clr: Colors.redAccent,
              context: context,),
            SizedBox(height: 15,)

          ],
        ),
      )
    );
}



  _appBar(){
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: (){
         ThemeService().switchTheme();
         // notifyHelper.displayNotification(
         //   title: "Theme Changed",
         //   body: Get.isDarkMode?"You are on Light mode":"You are on Dark Mode",
         // );

         // notifyHelper.scheduledNotification();
        },
        child: Icon(Get.isDarkMode?Icons.wb_sunny_outlined:Icons.nightlight_round,
          size: 20,
          color: Get.isDarkMode? Colors.white:Colors.black ,),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage("assets/images/profile2.png"),
        ),
        SizedBox(width: 20,),



      ],
    );
  }

  _addTaskBar(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,),
                Text("Today", style: headingStyle,),
              ],
            ),
          ),
          MyButton(label: "+ Add Task",onTap: ()async{
            await Get.to(()=>AddTaskPage());
            _taskController.getTasks();
          }),
        ],
      ),
    );
  }

  _addDateBar(){
    return Container(
      margin: EdgeInsets.only(top: 10,left: 20),
      child: DatePicker(
        DateTime.now(),
        daysCount: 28,
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey
          ),
        ),
        onDateChange: (date){
         setState(() {
           _selectedDate=date;
         });
        },

      ),
    );
  }
}
