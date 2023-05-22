import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/controllers/task_controller.dart';
import 'package:to_do_app/ui/theme.dart';
import 'package:to_do_app/ui/widgets/button.dart';
import 'package:to_do_app/ui/widgets/input_field.dart';

import '../Models/task.dart';



class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController= TextEditingController();
  final TextEditingController _noteController= TextEditingController();
  DateTime _selectedDate= DateTime.now();
  String _startTime=DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _endTime="10:30 PM";
  int _selectedRemind=5;
  List<int> remindList=[5,10,15,30,45,60];

  String _selectedRepeat="None";
  List<String> repeatList=["None", "Daily", "Weekly", "Monthly"];

  int _selectedColor=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add Task", style: headingStyle,),
              MyInputField(title: "Title", hint: "Enter your title", controller: _titleController,),
              MyInputField(title: "Note", hint: "Enter your note", controller: _noteController,),
              MyInputField(title: "Date", hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: (){
                      _getDateFromUser();
                  },
                  icon: Icon(Icons.calendar_today_outlined),
                  color: Colors.grey,
                )
                ,),
             Row(
               children: [
                Expanded(child:  MyInputField(title: "Start Time",
                  hint:_startTime,
                  widget: IconButton(
                    onPressed:(){
                      _getTimeFromUser(isStartTime: true );
                    } ,
                    icon:Icon(Icons.access_time_rounded, color: Colors.grey,) ,

                  ),)),
                 SizedBox(width: 12,),
                 Expanded(child:  MyInputField(title: "End Time",
                   hint:_endTime,
                   widget: IconButton(
                     onPressed:(){
                       _getTimeFromUser(isStartTime: false );
                     } ,
                     icon:Icon(Icons.access_time_rounded, color: Colors.grey,) ,

                   ),)),

               ],
             ),
              MyInputField(title: "Remind", hint: "${_selectedRemind} minutes early",
              widget: DropdownButton(
                icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey,),
                iconSize: 32,
                elevation: 4,
                style: subTitleStyle,
                underline: Container(height: 0,),
                items: remindList.map<DropdownMenuItem<String>>((int value){
                  return DropdownMenuItem<String>(
                    child: Text(value.toString()),
                    value: value.toString(),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedRemind= int.parse(value!);
                  });
                },
              ),
              ),
              MyInputField(title: "Repeat", hint: _selectedRepeat,
                widget: DropdownButton(
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey,),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0,),
                  items: repeatList.map<DropdownMenuItem<String>>((String value){
                    return  DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(color: Colors.grey),),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedRepeat= value!;
                    });
                  },
                ),
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                _colorPallete(),
                  MyButton(label: "Create Task", onTap: (){
                    _validateData();
                    print("Hello task is added");
                  })

                ],
              )
            ],
          ),
        ),
      ),
    );

  }
  
  _validateData(){
    if(_titleController.text.isNotEmpty && _noteController.text.isNotEmpty){
      _addTaskToDb();
      Get.back();
    }
    else if(_titleController.text.isEmpty|| _noteController.text.isEmpty){
      Get.snackbar("Required", "All fields are required!",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.amberAccent,
      icon: Icon(Icons.warning_amber_rounded));
    }
    
  }
  _addTaskToDb()async{
   int value = await  _taskController.addTask(
          task : Task(
              note: _noteController.text,
              title: _titleController.text,
              date: DateFormat.yMd().format(_selectedDate),
              startTime:_startTime,
              endTime: _endTime,
              remind: _selectedRemind,
              repeat: _selectedRepeat,
              color: _selectedColor,
              isCompleted: 0
          )
      );
   print("My id is "+value.toString());

  }
  _colorPallete(){
    return   Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color",style: titleStyle,),
        SizedBox(height: 8,),
        Wrap(
          children: List<Widget>.generate(
              3,
                  (index) {
                return  GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor=index;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: index==0?primaryClr:index==1?pinkClr:yellowClr,
                      child: _selectedColor==index?Icon(Icons.done, size: 16,color: Colors.white,):Container(),
                    ),
                  ),
                );
              }),
        )

      ],
    );
  }

  _appBar(BuildContext context){
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: (){
               Get.back();
        },
        child: Icon(Icons.arrow_back_ios,
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

  _getDateFromUser() async {
    DateTime? _pickerDate= await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(3000));

    if(_pickerDate!=null){
      setState(() {
        _selectedDate=_pickerDate;
        print(_selectedDate);
      });
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime= await _showTimePicker();
    String _formatedTime=  pickedTime.format(context);
    if(pickedTime==null){
      print('Time Canceled');
    }
    else if(isStartTime==true){
      setState(() {
        _startTime=_formatedTime;
      });
    }
    else if(isStartTime==false){
   setState(() {
     _endTime= _formatedTime;
   });
    }
  }

  _showTimePicker(){
    return   showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          // start time 10:10 AM
            hour: int.parse(_startTime.split(":")[0]),
            minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
        ));
  }
  }



