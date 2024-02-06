import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:gua_flutter_h5webview/views/H5Page.dart';
import 'package:permission_handler/permission_handler.dart';

import 'utils/Log.dart';

void main() async {
  // 初始化应用程序
  // 下面两个函数的配套使用的
  WidgetsFlutterBinding.ensureInitialized();
  // await saveLoggerToFile();

  // var p = await Permission.camera.request();
  // print('得到相机权限了吗');
  // print(p);
  // await Permission.microphone.request(); // if you need microphone permission

  setupAppInit();

  runApp(const MyApp());
}

// 自定义 loading toast widget 样式
void customSetupEasyLoading() {
  // 因为 EasyLoading 是一个全局单例, 所以你可以在任意一个地方自定义它的样式:
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 1500)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  // ..customAnimation = CustomAnimation();
}

// app 初始化需要做的事情
void setupAppInit() {
  customSetupEasyLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void initState() {}

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //设置状态栏为透明
    // SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent,
    //   statusBarIconBrightness: Brightness.dark,
    // );
    // SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

    return ScreenUtilInit(
      designSize: const Size(
        375, // 设计稿宽度
        812, // 设计稿高度
      ),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          initialRoute: '/',
          // initialRoute: '/h5-page',
          getPages: [
            GetPage(name: '/', page: () => MyHomePage(title: '')),
            GetPage(name: '/h5-page', page: () => H5Page()),
          ],
          // 路由中间件
          // navigatorObservers: [],

          debugShowCheckedModeBanner: false,
          title: 'First Method',
          // You can use the library anywhere in the app even in theme
          // theme: ThemeData(
          //   primarySwatch: Colors.blue,
          //   textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          // ),
          home: child,
          builder: EasyLoading.init(),
        );
      },
      child: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController dialogTextFieldController = TextEditingController();
  @override
  void initState() {
    // EasyLoading.showSuccess('Great Success!');
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // OpenLInkDialog();
    });
  }

  Future<dynamic> OpenLInkDialog() {
    return Get.dialog(
      Stack(
        children: [
          AlertDialog(
            backgroundColor: const Color.fromARGB(255, 250, 250, 250),
            alignment: Alignment.topCenter,
            // 最外层间距
            insetPadding:
                // EdgeInsets.symmetric(horizontal: 16.r, vertical: 137.r),
                // EdgeInsets.symmetric(horizontal: 16.r, ),
                EdgeInsets.only(
              left: 16.r,
              right: 16.r,
              top: 137.r,
              bottom: 0.r,
            ),
            // 圆角
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
            ),
            titlePadding:
                EdgeInsets.symmetric(horizontal: 16.r, vertical: 30.r),
            title: const Text('提交作品链接\n获得抽奖机会 '),
            titleTextStyle: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: const Color.fromRGBO(23, 27, 61, 1),
            ),

            // 主内容间距
            contentPadding: EdgeInsets.symmetric(
              vertical: 0.r,
              horizontal: 24.r,
            ),
            contentTextStyle: TextStyle(
              color: const Color.fromRGBO(23, 27, 61, 1),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            // 主内容
            content: Container(
              // constraints: const BoxConstraints(minHeight: 200),
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.maxFinite, // 将内容的宽度设置为最大
                  // height: double.maxFinite, // 将内容的宽度设置为最大
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 水平偏左
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      const DialogTextTip(
                        title: '第一步',
                        c1: '创建',
                        c2: '自定义主题',
                        c3: '，并将主题安装到桌面',
                      ),
                      SizedBox(
                        height: 18.r,
                      ),
                      const DialogTextTip(
                        title: '第二步',
                        c1: '截图或者路平发布',
                        c2: '小红书',
                        c3: '后,讲作品链接粘贴到下方并点击提交。',
                      ),
                      SizedBox(
                        height: 42.r,
                      ),
                      // 输入框
                      TextField(
                        controller: dialogTextFieldController, // 控制器，获取输入的值
                        autofocus: false,
                        enableSuggestions: false, // 输入建议
                        // onChanged
                        // onSubmitted
                        // 内容样式
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          // labelText: '请输入发布的作品链接',
                          labelStyle: const TextStyle(
                            color: Color(0xFF2E2E2E),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none, // 不要边框
                          ),
                          filled: true, // 如果要设置背景这个要设置为true
                          fillColor: Colors.black12, // 背景颜色
                          //  内容距离外部
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 14.r, // 上下距离
                            horizontal: 16.r, // 左右距离
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              // FilledButton(
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //   },
              //   child: const Text('OK'),
              // ),
              GestureDetector(
                onTap: () {
                  print('点击提交链接');
                },
                child: Container(
                  width: 217.sp,
                  height: 55.sp,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromRGBO(255, 62, 0, 1),
                        Color.fromRGBO(255, 93, 175, 1),
                      ], // 渐变色的颜色列表
                      begin: Alignment.centerLeft, // 渐变的起始位置
                      end: Alignment.centerRight, // 渐变的结束位置
                    ),
                    border: Border.all(color: Colors.transparent), // 去除默认div边框
                    borderRadius: const BorderRadius.all(
                      Radius.circular(27.0),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '提交',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            actionsAlignment: MainAxisAlignment.center,
            actionsPadding:
                EdgeInsets.symmetric(horizontal: 0.r, vertical: 34.r),
          ),
        ],
      ),
    );
  }

  int counter = 0;
  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 手机appbar高度
    double appBarHeight = AppBar().preferredSize.height;
    // 手机安全高度
    EdgeInsets safeAreaInsets = MediaQuery.of(context).padding;
    double safeAreaHeight = safeAreaInsets.top; //  + safeAreaInsets.bottom
    // 手机宽度
    double phoneWidth = MediaQuery.of(context).size.width;
    double phoneHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // https://juejin.cn/post/7143181602124726308
      extendBodyBehindAppBar:
          true, // [扩展AppBar到背景之后] !如果加了这个，appbar的背景颜色要改成透明，才有效果
      appBar: AppBar(
        title: Text(widget.title),
        // 透明导航头 start
        backgroundColor: Colors.transparent,
        elevation: 0.0, // // 移除AppBar的阴影
        // 透明导航头 end
        // 左侧
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Image.asset('assets/img/colorful/icon/back@2x.png'),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        // 右侧
        actions: <Widget>[
          InkWell(
            // 点击效果的小部件，它在被点击时会有一个水波纹效果。
            onTap: () {
              Log.f("点击我的奖品");
              Get.toNamed("/h5-page");
            },
            child: Container(
              width: 96,
              height: 34,
              alignment: Alignment.center, // 居中对齐
              decoration: BoxDecoration(
                color: const Color.fromRGBO(0, 0, 0, 0.2),
                border: Border.all(color: Colors.transparent), // 去除默认div边框
                borderRadius: BorderRadius.only(
                  // 添加圆角
                  topLeft: Radius.circular(17.r),
                  bottomLeft: Radius.circular(17.r),
                ),
              ),
              child: Text(
                '我的奖品',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromRGBO(255, 255, 255, 1),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // 固定屏幕，不随页面滚动而滚动
          Image.asset(
            'assets/img/colorful/bg.png',
            fit: BoxFit.contain,
            width: phoneWidth, // 宽度撑满
            height: phoneHeight, // 高度撑满
            // 调试参数
            // width: 100,
            // height: 300,
          ),
          // 可滚动区域            单滚动视图
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // 【【整个水平左右距离】】
                horizontal: 16.0,
              ),
              child: Column(
                children: [
                  SizedBox(
                    // 因为是全面屏了，所以需要e减去距离顶部的高度
                    height: appBarHeight + safeAreaHeight,
                    // height: ScreenUtil().statusBarHeight,
                  ),
                  //
                  //
                  //
                  //
                  // 图片【创主题 抽好礼】
                  Image.asset(
                    'assets/img/colorful/标题.png',
                    fit: BoxFit.contain,
                    // 不填写宽高，默认自动撑开
                  ),
                  // 抽奖区域
                  Container(
                    alignment: Alignment.topLeft,
                    width: phoneWidth, // 宽度撑满
                    decoration: BoxDecoration(
                      color: const Color(0xff7c94b6),
                      image: const DecorationImage(
                        image: AssetImage('assets/img/colorful/抽卡/bg2.png'),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(
                        30.r,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(
                        12.r,
                      ),
                      child: Row(
                        children: [
                          // 左---活动1
                          Column(
                            children: [
                              // 标题
                              Opacity(
                                opacity: 1, // 1 || 0.3
                                child: Stack(
                                  // 默认居中方式， 也就是如果 Positioned 水平left right 没填写的话，就默认水平居中，垂直 top bottom  没填写的话，就默认垂直居中
                                  alignment: Alignment.center,
                                  children: [
                                    // 旋转图片
                                    Transform.rotate(
                                      angle: 0 * 3.14159, // 360度的弧度值
                                      child: Image.asset(
                                        'assets/img/colorful/抽卡/Activity1.png',
                                        width: 160.r, // 注意卡1-2宽度不一样
                                        height: 24.r,
                                      ),
                                    ),
                                    Text(
                                      '活动一',
                                      style: TextStyle(
                                        fontSize: 13.r,
                                        fontWeight: FontWeight.w800,
                                        color:
                                            const Color.fromRGBO(23, 27, 61, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // 单纯占据高度
                              SizedBox(
                                height: 12.r,
                              ),
                              // 抽奖可点击区域
                              Stack(
                                // 默认居中方式， 也就是如果 Positioned 水平left right 没填写的话，就默认水平居中，垂直 top bottom  没填写的话，就默认垂直居中
                                alignment: Alignment.center,
                                children: [
                                  //////////////// 没中奖
                                  1 == 1
                                      ? InkWell(
                                          // 点击效果的小部件，它在被点击时会有一个水波纹效果。
                                          onTap: () {
                                            print('点击 抽奖可点击区域');
                                          },
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              // 背景
                                              Image.asset(
                                                'assets/img/colorful/抽卡/抽卡2@3x.png',
                                                width: 154.r, // 注意卡1-2宽度不一样
                                                height: 198.r,
                                              ),
                                              // 马上抽奖 按钮
                                              Positioned(
                                                bottom: 10.r,
                                                child: Image.asset(
                                                  'assets/img/colorful/抽卡/bt_lottery.png',
                                                  width: 126.r, // 注意卡1-2宽度不一样
                                                  height: 46.r,
                                                ),
                                              ),
                                              // 待解锁 按钮
                                              Positioned(
                                                bottom: 10.r,
                                                child: Image.asset(
                                                  'assets/img/colorful/抽卡/bt_lock.png',
                                                  width: 126.r, // 注意卡1-2宽度不一样
                                                  height: 46.r,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      :
                                      // //////////////// 中奖
                                      InkWell(
                                          // 点击效果的小部件，它在被点击时会有一个水波纹效果。
                                          onTap: () {
                                            print('点击 抽奖已中奖击区域');
                                          },
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              // 背景
                                              Image.asset(
                                                'assets/img/colorful/抽卡/抽卡2-中奖@3x.png',
                                                width: 154.r, // 注意卡1-2宽度不一样
                                                height: 198.r,
                                              ),
                                              // // 中奖物品
                                              Positioned(
                                                top: 20, // 不填写，默认居中
                                                // left: 0, // 不填写，默认居中
                                                child: Image.network(
                                                  'https://resource.magfic.com/luckDraw/%E5%90%A7%E5%94%A7_1704858508000.png',
                                                  width: 126.r, // 注意卡1-2宽度不一样
                                                  height: 126.r,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ],
                              ),
                              // const DebugLookWidget(),
                            ],
                          ),
                          // 右---活动2
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DialogTextTip extends StatelessWidget {
  const DialogTextTip({
    super.key,
    required this.title,
    required this.c1,
    required this.c2,
    required this.c3,
  });
  final String title;
  final String c1;
  final String c2;
  final String c3;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 水平偏左
      children: [
        Text(
          // '第一步',
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: const Color.fromRGBO(23, 27, 61, 1),
          ),
        ),

        // 单纯占据高度
        SizedBox(
          height: 6.r,
        ),
        RichText(
          text: TextSpan(
            // text: '创建',
            text: c1, // '创建',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color.fromRGBO(23, 27, 61, 1),
            ),
            children: <TextSpan>[
              TextSpan(
                text: c2, //'自定义主题，',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  inherit: true, // 继承其父级小部件的样式属性，包括颜色。
                ),
              ),
              TextSpan(
                text: c3, // ' 并将主题安装到桌面!'
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DebugLookWidget extends StatelessWidget {
  const DebugLookWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: const BoxDecoration(
        color: Colors.red,
      ),
    );
  }
}
