import 'package:intl/intl.dart' as intl;

String formattedDate(String dateString) {
  try {
    // تحقق إن كان النص الممرر صالح أم لا
    if (dateString.isEmpty) {
      return "";
    }

    // تحويل النص إلى كائن DateTime
    DateTime dateTime = DateTime.parse(dateString);

    // إعادة التنسيق
    String formattedDate = intl.DateFormat('yyyy-MM-dd').format(dateTime);

    return formattedDate;
  } catch (e) {
    // طباعة الخطأ في الـ console وارجاع نص فارغ في حال حدوث خطأ
    print("خطأ في تنسيق التاريخ: $e");
    return "";
  }
}
