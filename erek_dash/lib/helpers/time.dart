import 'package:flutter/material.dart';

class TimeHelper {
  TimeOfDay selectedTime = TimeOfDay.now();
  Future<String> selectTime(BuildContext cntxt) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: cntxt,
      initialTime: selectedTime,
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      selectedTime = pickedTime;

      return "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
    } else {
      return '';
    }
  }

  DateTime selectedDate = DateTime.now();
  Future<String> selectDate(BuildContext cntxt) async {
    final DateTime? picked = await showDatePicker(
      context: cntxt,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      if (cntxt.mounted) {
        // String timestr = await selectTime(cntxt);
        String pickedDate = picked.toString().substring(0, 10);
        return pickedDate;
      } else {
        return '';
      }
    }
    return '';
  }

  int calculateHoursDifference(String dateTimeStr1, String dateTimeStr2) {
    DateTime dateTime1 = DateTime.parse(dateTimeStr1);
    DateTime dateTime2 = DateTime.parse(dateTimeStr2);

    Duration difference = dateTime2.difference(dateTime1);

    int hoursDifference = difference.inHours;

    return hoursDifference;
  }
}
