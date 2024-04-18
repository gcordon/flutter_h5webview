import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class Log {
  static void logPrint(dynamic obj) {
    Log.e(obj.toString());
    // if (obj is Error) {
    // } else if (kDebugMode) {
    //   // 如果应用程序是在调试模式下编译的
    //   print(obj);
    // }
  }

  static t(String message) {
    logger.t("${DateTime.now().toString()}\n$message");
  }

  static d(String message) {
    // debug log
    logger.d("${DateTime.now().toString()}\n$message");
  }

  static i(String message) {
    logger.i("${DateTime.now().toString()}\n$message");
  }

  static w(String message) {
    // 警告
    logger.w("${DateTime.now().toString()}\n$message");
  }

  static e(String message) {
    // 错误
    logger.e("${DateTime.now().toString()}\n$message");
  }

  static f(String message) {
    logger.f("${DateTime.now().toString()}\n$message");
  }

  static Logger logger = Logger(
    printer: PrettyPrinter(
      // methodCount: 2, //要显示的方法调用数
      methodCount: 0, //要显示的方法调用数
      errorMethodCount: 8, //如果提供了stacktrace,方法调用的次数
      lineLength: 120, //输出宽度
      colors: true, //彩色的日志消息
      printEmojis: true, //为每条日志消息打印一个emoji
      printTime: false, //每个日志打印包含一个时间戳
    ),
    output: MultiOutput([
      //  处理 ios 终端输出乱码问题
      // https://github.com/flutter/flutter/issues/64491
      // I have a file output here
      DeveloperConsoleOutput(),
    ]),
  );
}

class DeveloperConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    final StringBuffer buffer = StringBuffer();
    event.lines.forEach(buffer.writeln);
    log(buffer.toString());
  }
}

Future saveLoggerToFile() async {
  // 获取应用程序的文档目录路径
  var dir = await getApplicationDocumentsDirectory();
  var logFile = File(
    '${dir.path}/1707121290531.log',
  );
  var msg = 'linlin';
  await logFile.writeAsString(msg);

  Log.d('文档目录路径：${dir.path}');
}
