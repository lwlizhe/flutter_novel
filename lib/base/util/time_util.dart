class TimeUtil {
  static String formatDateTimeString(String targetDate) {
    DateTime targetDateTime;

    try {
      targetDateTime = DateTime.parse(targetDate);
    } catch (e) {
      print(e);
      return targetDate;
    }

    var currentTime = DateTime.now();

    var result =
        '${targetDateTime.year}-${targetDateTime.month}-${targetDateTime.day}';

    if (targetDateTime.isBefore(currentTime)) {
      var differenceTime = currentTime.difference(targetDateTime);

      if (differenceTime.inSeconds < 60) {
        result = '不久前';
      } else {
        if (differenceTime.inMinutes < 60) {
          result = '${differenceTime.inMinutes}分钟前';
        } else {
          if (differenceTime.inHours < 24) {
            result = '${differenceTime.inHours}小时前';
          } else {
            if (differenceTime.inDays < 3) {
              result = '${differenceTime.inDays}天前';
            }
          }
        }
      }
    }

    return result;
  }
}
