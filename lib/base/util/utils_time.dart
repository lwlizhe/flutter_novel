///refer:[https://github.com/shichunlei/flutter_app/blob/acec8f0c8a32532801f85741425f75e3104703e5/lib/utils/date_format.dart]
class TimeUtils{

  /// 输出四位数年份
  ///
  /// Example:
  ///     formatDate(DateTime(1989), [yyyy]);
  ///     // => 1989
  static const String yyyy = 'yyyy';

  /// 输出两位数年份
  ///
  /// Example:
  ///     formatDate(DateTime(1989), [yy]);
  ///     // => 89
  static const String yy = 'yy';

  /// 输出两位数月份
  ///
  /// Example:
  ///     formatDate(DateTime(1989, 11), [mm]);
  ///     // => 11
  ///     formatDate(DateTime(1989, 5), [mm]);
  ///     // => 05
  static const String mm = 'mm';

  /// 输出月份（小于10月的前面不补0）
  ///
  /// Example:
  ///     formatDate(DateTime(1989, 11), [mm]);
  ///     // => 11
  ///     formatDate(DateTime(1989, 5), [m]);
  ///     // => 5
  static const String m = 'm';

  /// 输出英文月份
  ///
  /// Example:
  ///     formatDate(DateTime(1989, 2), [MM]);
  ///     // => february
  static const String MM = 'MM';

  /// 输出英文月份（缩写）
  ///
  /// Example:
  ///     formatDate(DateTime(1989, 2), [M]);
  ///     // => feb
  static const String M = 'M';

  /// 输出中文月份
  ///
  /// Example:
  ///     formatDate(DateTime(1989, 2), [MM]);
  ///     // => 二月
  static const String MM_ZH = 'MM_ZH';

  /// 输出两位数天
  ///
  /// Example:
  ///     formatDate(DateTime(1989, 2, 21), [dd]);
  ///     // => 21
  ///     formatDate(DateTime(1989, 2, 5), [dd]);
  ///     // => 05
  static const String dd = 'dd';

  /// 输出天（小于10月的前面不补0）
  ///
  /// Example:
  ///     formatDate(DateTime(1989, 2, 21), [d]);
  ///     // => 21
  ///     formatDate(DateTime(1989, 2, 5), [d]);
  ///     // => 5
  static const String d = 'd';

  /// 输出该日期所在该月的周数
  ///
  /// Example:
  ///     formatDate(DateTime(1989, 2, 21), [w]);
  ///     // => 4
  static const String w = 'w';

  /// 输出该日期所在年的周数（两位，小于10的周数前面补0）
  ///
  /// Example:
  ///     formatDate(DateTime(1989, 12, 31), [W]);
  ///     // => 53
  ///     formatDate(DateTime(1989, 2, 21), [W]);
  ///     // => 08
  static const String WW = 'WW';

  /// 输出该日期所在年的周数
  ///
  /// Example:
  ///     formatDate(DateTime(1989, 2, 21), [W]);
  ///     // => 8
  static const String W = 'W';

  /// Outputs week day as long name
  ///
  /// Example:
  ///     formatDate(DateTime(2018, 1, 14), [DD]);
  ///     // => sunday
  static const String EEEE_EN = 'EEEE_EN';

  /// Outputs week day as long name
  ///
  /// Example:
  ///     formatDate(DateTime(2018, 1, 14), [D]);
  ///     // => sun
  static const String EE_EN = 'EE_EN';

  /// Outputs week day as long name
  ///
  /// Example:
  ///     formatDate(DateTime(2018, 1, 14), [DD]);
  ///     // => 星期日
  static const String EEEE_ZH = 'EEEE_ZH';

  /// Outputs week day as long name
  ///
  /// Example:
  ///     formatDate(DateTime(2018, 1, 14), [D]);
  ///     // => 周日
  static const String EE_ZH = 'EE_ZH';

  /// Outputs hour (0 - 11) as two digits
  ///
  /// Example:
  ///     formatDate(DateTime(1989, 02, 1, 15), [hh]);
  ///     // => 03
  static const String hh = 'hh';

  /// Outputs hour (0 - 11) compactly
  ///
  /// Example:
  ///     formatDate(DateTime(1989, 02, 1, 15), [h]);
  ///     // => 3
  static const String h = 'h';

  /// Outputs hour (0 to 23) as two digits
  ///
  /// Example:
  ///     formatDate(DateTime(1989, 02, 1, 15), [HH]);
  ///     // => 15
  static const String HH = 'HH';

  /// Outputs hour (0 to 23) compactly
  ///
  /// Example:
  ///     formatDate(DateTime(1989, 02, 1, 5), [H]);
  ///     // => 5
  static const String H = 'H';

  /// Outputs minute as two digits
  ///
  /// Example:
  ///     formatDate(DateTime(1989, 02, 1, 15, 40), [nn]);
  ///     // => 40
  ///     formatDate(DateTime(1989, 02, 1, 15, 4), [nn]);
  ///     // => 04
  static const String nn = 'nn';

  /// Outputs minute compactly
  ///
  /// Example:
  ///     formatDate(DateTime(1989, 02, 1, 15, 4), [n]);
  ///     // => 4
  static const String n = 'n';

  /// Outputs second as two digits
  ///
  /// Example:
  ///     formatDate(DateTime(1989, 02, 1, 15, 40, 10), [ss]);
  ///     // => 10
  ///     formatDate(DateTime(1989, 02, 1, 15, 40, 5), [ss]);
  ///     // => 05
  static const String ss = 'ss';

  /// Outputs second compactly
  ///
  /// Example:
  ///     formatDate(DateTime(1989, 02, 1, 15, 40, 5), [s]);
  ///     // => 5
  static const String s = 's';

  /// Outputs millisecond as three digits
  ///
  /// Example:
  ///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 999), [SSS]);
  ///     // => 999
  ///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 99), [SS]);
  ///     // => 099
  ///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 0), [SS]);
  ///     // => 009
  static const String SSS = 'SSS';

  /// Outputs millisecond compactly
  ///
  /// Example:
  ///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 999), [SSS]);
  ///     // => 999
  ///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 99), [SS]);
  ///     // => 99
  ///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 9), [SS]);
  ///     // => 9
  static const String S = 'S';

  /// Outputs microsecond as three digits
  ///
  /// Example:
  ///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 0, 999), [uuu]);
  ///     // => 999
  ///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 0, 99), [uuu]);
  ///     // => 099
  ///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 0, 9), [uuu]);
  ///     // => 009
  static const String uuu = 'uuu';

  /// Outputs millisecond compactly
  ///
  /// Example:
  ///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 0, 999), [u]);
  ///     // => 999
  ///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 0, 99), [u]);
  ///     // => 99
  ///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 0, 9), [u]);
  ///     // => 9
  static const String u = 'u';

  /// 输出所在时间为 AM or PM
  ///
  /// Example:
  ///     print(formatDate(DateTime(1989, 02, 1, 5), [am]));
  ///     // => AM
  ///     print(formatDate(DateTime(1989, 02, 1, 15), [am]));
  ///     // => PM
  static const String am = 'am';

  /// 输出上午/下午
  ///
  /// Example:
  ///     print(formatDate(DateTime(1989, 02, 1, 5), [am]));
  ///     // => 上午
  ///     print(formatDate(DateTime(1989, 02, 1, 15), [am]));
  ///     // => 下午
  static const String am_ZH = 'am_ZH';

  /// Outputs timezone as time offset
  ///
  /// Example:
  ///
  static const String z = 'z';
  static const String Z = 'Z';


  static String _digits(int value, int length) {
    String ret = '$value';
    if (ret.length < length) {
      ret = '0' * (length - ret.length) + ret;
    }
    return ret;
  }

  static const List<String> monthShort = const <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  static const List<String> monthLong = const <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  static const List<String> monthZH = const <String>[
    '正月',
    '二月',
    '三月',
    '四月',
    '五月',
    '六月',
    '七月',
    '八月',
    '九月',
    '十月',
    '冬月',
    '腊月'
  ];

  static const List<String> dayShort = const [
    'Mon',
    'Tue',
    'Wed',
    'Thur',
    'Fri',
    'Sat',
    'Sun'
  ];

  static const List<String> dayLong = const [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  static const List<String> dayShortZH = const [
    '周一',
    '周二',
    '周三',
    '周四',
    '周五',
    '周六',
    '周日'
  ];

  static const List<String> dayLongZH = const [
    '星期一',
    '星期二',
    '星期三',
    '星期四',
    '星期五',
    '星期六',
    '星期日'
  ];

  static int dayInYear(DateTime date) =>
      date.difference(DateTime(date.year, 1, 1)).inDays;
  
  static String formatDateByStr(String datetimeStr, {List<String> formats}) {
    return formatDate(DateTime.parse(datetimeStr), formats: formats);
  }

  static String formatDate(DateTime date, {List<String> formats}) {
    final sb = StringBuffer();
    if (null == formats) {
      formats = [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss];
    }
    for (String format in formats) {
      if (format == yyyy) {
        sb.write(_digits(date.year, 4));
      } else if (format == yy) {
        sb.write(_digits(date.year % 100, 2));
      } else if (format == mm) {
        sb.write(_digits(date.month, 2));
      } else if (format == m) {
        sb.write(date.month);
      } else if (format == MM) {
        sb.write(monthLong[date.month - 1]);
      } else if (format == MM_ZH) {
        sb.write(monthZH[date.month - 1]);
      } else if (format == M) {
        sb.write(monthShort[date.month - 1]);
      } else if (format == dd) {
        sb.write(_digits(date.day, 2));
      } else if (format == d) {
        sb.write(date.day);
      } else if (format == w) {
        sb.write((date.day + 7) ~/ 7);
      } else if (format == W) {
        sb.write((dayInYear(date) + 7) ~/ 7);
      } else if (format == WW) {
        sb.write(_digits((dayInYear(date) + 7) ~/ 7, 2));
      } else if (format == EEEE_EN) {
        sb.write(dayLong[date.weekday - 1]);
      } else if (format == EE_EN) {
        sb.write(dayShort[date.weekday - 1]);
      } else if (format == EEEE_ZH) {
        sb.write(dayLongZH[date.weekday - 1]);
      } else if (format == EE_ZH) {
        sb.write(dayShortZH[date.weekday - 1]);
      } else if (format == HH) {
        sb.write(_digits(date.hour, 2));
      } else if (format == H) {
        sb.write(date.hour);
      } else if (format == hh) {
        int hour = date.hour % 12;
        if (hour == 0) hour = 12;
        sb.write(_digits(hour, 2));
      } else if (format == h) {
        int hour = date.hour % 12;
        if (hour == 0) hour = 12;
        sb.write(hour);
      } else if (format == am) {
        sb.write(date.hour < 12 ? 'AM' : 'PM');
      } else if (format == am_ZH) {
        sb.write(date.hour < 12 ? '上午' : '下午');
      } else if (format == nn) {
        sb.write(_digits(date.minute, 2));
      } else if (format == n) {
        sb.write(date.minute);
      } else if (format == ss) {
        sb.write(_digits(date.second, 2));
      } else if (format == s) {
        sb.write(date.second);
      } else if (format == SSS) {
        sb.write(_digits(date.millisecond, 3));
      } else if (format == S) {
        sb.write(date.second);
      } else if (format == uuu) {
        sb.write(_digits(date.microsecond, 2));
      } else if (format == u) {
        sb.write(date.microsecond);
      } else if (format == z) {
        if (date.timeZoneOffset.inMinutes == 0) {
          sb.write('Z');
        } else {
          if (date.timeZoneOffset.isNegative) {
            sb.write('-');
            sb.write(_digits((-date.timeZoneOffset.inHours) % 24, 2));
            sb.write(_digits((-date.timeZoneOffset.inMinutes) % 60, 2));
          } else {
            sb.write('+');
            sb.write(_digits(date.timeZoneOffset.inHours % 24, 2));
            sb.write(_digits(date.timeZoneOffset.inMinutes % 60, 2));
          }
        }
      } else if (format == Z) {
        sb.write(date.timeZoneName);
      } else {
        sb.write(format);
      }
    }

    return sb.toString();
  }

  /// 友好式时间展示
  /// [datetime]
  ///
  static String friendlyDateTime(String datetime) {
    String friendly = '';
    String agoOrAfter = '之前';

    int _dateTime = DateTime.parse(datetime).millisecondsSinceEpoch;
    int _now = DateTime.now().millisecondsSinceEpoch;

    if (_now < _dateTime) {
      agoOrAfter = '之后';
    }

    int elapsed = (_now - _dateTime).abs();

    final int seconds = elapsed ~/ 1000;
    final int minutes = seconds ~/ 60;
    final int hours = minutes ~/ 60;
    final int days = hours ~/ 24;
    final int weeks = days ~/ 7;
    final int mounts = days ~/ 30;

    if (seconds < 60) {
      friendly = agoOrAfter == '之后' ? '马上' : '刚刚';
    } else if (seconds >= 60 && seconds < 60 * 60) {
      friendly = '$minutes分钟$agoOrAfter';
    } else if (seconds >= 60 * 60 && seconds < 60 * 60 * 24) {
      friendly = '$hours小时$agoOrAfter';
    } else if (seconds >= 60 * 60 * 24 && seconds < 60 * 60 * 24 * 2) {
      friendly = agoOrAfter == '之后' ? '明天' : '昨天';
    } else if (seconds >= 60 * 60 * 24 * 2 && seconds < 60 * 60 * 24 * 3) {
      friendly = agoOrAfter == '之后' ? '后天' : '前天';
    } else if (seconds >= 60 * 60 * 24 * 3 && seconds < 60 * 60 * 24 * 7) {
      friendly = '$days天$agoOrAfter';
    } else if (seconds >= 60 * 60 * 24 * 7 && seconds < 60 * 60 * 24 * 30) {
      friendly = '$weeks周$agoOrAfter';
    } else if (seconds >= 60 * 60 * 24 * 30 && seconds < 60 * 60 * 24 * 30 * 6) {
      friendly = '$mounts月$agoOrAfter';
    } else if (seconds >= 60 * 60 * 24 * 30 * 6 &&
        seconds < 60 * 60 * 24 * 30 * 12) {
      friendly = '半年$agoOrAfter';
    } else {
      friendly = formatDateByStr(datetime, formats: [yyyy, '-', mm, '-', dd]);
    }

    return friendly;
  }
}