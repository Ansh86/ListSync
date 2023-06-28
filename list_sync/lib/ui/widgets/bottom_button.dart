import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:list_sync/ui/theme.dart';

class BottomButton extends StatelessWidget {
  String label;
  Function()? onTap;
  Color clr;
  bool isClose;
  BuildContext context;


  BottomButton({Key? key,
    required this.label,
    required this.onTap,
    required this.clr,
    this.isClose=false,
    required this.context
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width*0.9,
        decoration:BoxDecoration(
          color: isClose==true?Colors.transparent:clr,
          border: Border.all(width: 2, color: isClose==true? Get.isDarkMode?Colors.grey[600]!:Colors.grey[300]! :clr),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(label, style: isClose?titleStyle:titleStyle.copyWith(color: Colors.white),),
        ),
      ),
    );
  }
}
