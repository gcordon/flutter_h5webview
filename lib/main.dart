import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // TODO: 没效果~~但是先留着后面可能就有效果了
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent, // 设置状态栏透明
    //   systemNavigationBarColor: Colors.transparent, // 设置底部导航栏透明
    // ));

    return ScreenUtilInit(
      designSize: const Size(
        375, // 设计稿宽度
        812, // 设计稿高度
      ),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'First Method',
          // You can use the library anywhere in the app even in theme
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          home: child,
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
              // 点击回调函数
              // 在这里执行您希望触发的操作
              print('点击我的奖品');
            },
            child: Container(
              width: 96,
              height: 34,
              alignment: Alignment.center, // 居中对齐
              decoration: BoxDecoration(
                color: const Color.fromRGBO(0, 0, 0, 0.2),
                border: Border.all(color: Colors.transparent), // 去除默认div边框
                borderRadius: const BorderRadius.only(
                  // 添加圆角
                  topLeft: Radius.circular(17.0),
                  bottomLeft: Radius.circular(17.0),
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
                    // 因为是全面屏了，所以需要减去距离顶部的高度
                    height: appBarHeight + safeAreaHeight,
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
                        30.sp,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(
                        12.sp,
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
                                    Image.asset(
                                      'assets/img/colorful/抽卡/Activity1.png',
                                      width: 162.sp, // 注意卡1-2宽度不一样
                                      height: 24.sp,
                                    ),
                                    Text(
                                      '活动一',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w800,
                                        color:
                                            const Color.fromRGBO(23, 27, 61, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // 单纯占据高度
                              const SizedBox(
                                height: 12,
                              ),
                              // 抽奖可点击区域
                              Stack(
                                // 默认居中方式， 也就是如果 Positioned 水平left right 没填写的话，就默认水平居中，垂直 top bottom  没填写的话，就默认垂直居中
                                alignment: Alignment.center,
                                children: [
                                  //////////////// 没中奖
                                  1 == 2
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
                                                width: 154.sp, // 注意卡1-2宽度不一样
                                                height: 198.sp,
                                              ),
                                              // 抽奖按钮
                                              Positioned(
                                                bottom: 10.sp,
                                                child: Image.asset(
                                                  'assets/img/colorful/抽卡/bt_lottery.png',
                                                  width: 126.sp, // 注意卡1-2宽度不一样
                                                  height: 46.sp,
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
                                                width: 154.sp, // 注意卡1-2宽度不一样
                                                height: 198.sp,
                                              ),
                                              // // 中奖物品
                                              Positioned(
                                                top: 20, // 不填写，默认居中
                                                // left: 0, // 不填写，默认居中
                                                child: Image.network(
                                                  'https://resource.magfic.com/luckDraw/%E5%90%A7%E5%94%A7_1704858508000.png',
                                                  width: 126.sp, // 注意卡1-2宽度不一样
                                                  height: 126.sp,
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
                          // Column(
                          //   children: [
                          //     Image.asset(
                          //       'assets/img/colorful/抽卡/Activity2.png',
                          //       width: 156.sp, // 注意卡1-2宽度不一样
                          //       height: 24.sp,
                          //     )
                          //   ],
                          // ),
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
