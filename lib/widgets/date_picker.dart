import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;
import 'package:google_fonts/google_fonts.dart';
import 'package:nust_students/controller/my_provider.dart';
import 'package:nust_students/models/usermodel.dart';
import 'package:nust_students/widgets/custom_edit_button.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../utls/date_picker_dialog.dart';
import '../utls/formate_date_of_birth.dart';

class CustomDatePicker extends StatefulWidget {
  final UserModel userModel;
  final bool isReadOnly;

  const CustomDatePicker({
    super.key,
    required this.userModel,
    required this.isReadOnly,
  });

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: formattedDate(widget.userModel.ldDateOfBirth.toString())
    );
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);

    if (provider.newBirthDay.isNotEmpty) {
      _controller.text = provider.newBirthDay;
    }

    return Row(
      children: [
        widget.isReadOnly
            ? CustomEditButton(onTap: () {
          showDatePickerDialog(context, widget.userModel, false);
        })
            : Container(),
        provider.newBirthDay.isNotEmpty && widget.isReadOnly
            ? Expanded(
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.rightSlide,
                    title: "حذف تاريخ الميلاد المعدل",
                    titleTextStyle: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold),
                    descTextStyle: GoogleFonts.cairo(),
                    desc: "هل انت متاكد من حذف هذا التعديل ؟",
                    btnOk: submitButton(() {
                      provider.setNewBirthDay('');
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                        Text("نعم",
                            style: GoogleFonts.cairo(
                                fontSize: 18, color: Colors.white)),
                        Color(0xff1d284c)),
                    btnCancel: submitButton(() {
                      Navigator.pop(context);
                    },
                        Text("الغاء",
                            style: GoogleFonts.cairo(
                                fontSize: 18, color: Colors.white)),
                        Color(0xffAF9512)),
                    btnCancelOnPress: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ).show();
                },
                icon: Icon(Icons.delete_outline, color: Colors.deepOrange),
              ),
              Expanded(
                child: SizedBox(
                  height: 6.h,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      controller: _controller,
                      style: TextStyle(fontSize: 14.sp),
                      decoration: InputDecoration(
                        labelText: "تاريخ الميلاد المعدل",
                        labelStyle: GoogleFonts.cairo(fontSize: 14.sp),
                        prefixIcon: Icon(Icons.calendar_today,
                            color: Color(0xffAA9516)),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'الرجاء إدخال تاريخ';
                        }

                        // حاول تحويل القيمة إلى كائن DateTime
                        try {
                          DateTime.parse(value); // إذا كان التنسيق صحيحًا سيمر بدون خطأ
                          return null; // لا يوجد خطأ، التاريخ صحيح
                        } catch (e) {
                          return 'الرجاء إدخال تاريخ صحيح بصيغة yyyy-MM-dd';
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
            : Container(),
        SizedBox(width: provider.newBirthDay.isNotEmpty && widget.isReadOnly ? 10 : 0),
        Expanded(
          child: SizedBox(
            height: 6.h,
            child: GestureDetector(
              onTap: widget.isReadOnly
                  ? null
                  : () {
                picker.DatePicker.showDatePicker(
                  context,
                  showTitleActions: true,
                  theme: picker.DatePickerTheme(
                    headerColor: Color(0xffAF9512),
                    backgroundColor: Color(0xff1d284c),
                    itemStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    doneStyle: TextStyle(color: Colors.white, fontSize: 13.sp),
                  ),
                  minTime: DateTime(1920, 1, 1),
                  maxTime: DateTime(2030, 12, 31),
                  onChanged: (date) {},
                  onConfirm: (date) {
                    String formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                    provider.setNewBirthDay(formattedDate);
                    _controller.text = formattedDate;
                  },
                  currentTime: DateTime.now(),
                  locale: picker.LocaleType.en,
                );
              },
              child: AbsorbPointer(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    controller: _controller,
                    style: TextStyle(fontSize: 14.sp),
                    decoration: InputDecoration(
                      labelText: "تاريخ الميلاد",
                      labelStyle: GoogleFonts.cairo(fontSize: 14.sp),
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: Color(0xffAF9512),
                      ),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'الرجاء إدخال تاريخ';
                      }

                      // حاول تحويل القيمة إلى كائن DateTime
                      try {
                        DateTime.parse(value); // إذا كان التنسيق صحيحًا سيمر بدون خطأ
                        return null; // لا يوجد خطأ، التاريخ صحيح
                      } catch (e) {
                        return 'الرجاء إدخال تاريخ صحيح بصيغة yyyy-MM-dd';
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget submitButton(Function()? fun, Widget widget, Color color) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
        onPressed: fun,
        child: widget,
      ),
    );
  }
}
