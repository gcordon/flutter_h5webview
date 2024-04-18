import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class H5Page extends StatefulWidget {
  const H5Page({super.key});

  @override
  State<H5Page> createState() => _H5PageState();
}

class _H5PageState extends State<H5Page> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
    isInspectable: kDebugMode, // 是否开启调试
    mediaPlaybackRequiresUserGesture: false, //
    allowsInlineMediaPlayback: true, // 是否允许内联媒体播放
    iframeAllow: "camera; microphone", // 允许iframe的权限
    iframeAllowFullscreen: true, // 是否允许iframe全屏
    cacheEnabled: false, // 是否启用缓存
  );

  PullToRefreshController? pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(
              color: Colors.blue,
            ),
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                webViewController?.loadUrl(
                  urlRequest: URLRequest(
                    url: await webViewController?.getUrl(),
                  ),
                );
              }
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    // 手机安全高度
    EdgeInsets safeAreaInsets = MediaQuery.of(context).padding;
    double safeAreaHeight = safeAreaInsets.top; //  + safeAreaInsets.bottom

    return Scaffold(
      appBar: AppBar(title: const Text("Official InAppWebView website")),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TextField(
              decoration:
                  const InputDecoration(prefixIcon: Icon(Icons.search)), // 输入框
              controller: urlController, // 控制器
              keyboardType: TextInputType.url, // 键盘类型
              onSubmitted: (value) {
                // 提交
                var url = WebUri(value);
                if (url.scheme.isEmpty) {
                  url = WebUri("https://www.google.com/search?q=$value");
                }
                webViewController?.loadUrl(
                  urlRequest: URLRequest(url: url),
                ); // 加载网页
              },
            ),
            Expanded(
              child: Stack(
                children: [
                  InAppWebView(
                    // webview
                    key: webViewKey, // key
                    initialUrlRequest: URLRequest(
                      // url: WebUri("https://inappwebview.dev/"),
                      //   url: WebUri("http://localhost:5173/popularize"),
                      url: WebUri(
                          "http://localhost:5173/h5ToFlutterJsbridge"), // 加载的url
                    ),
                    initialSettings: settings, // 设置
                    pullToRefreshController: pullToRefreshController, // 下拉刷新
                    onWebViewCreated: (controller) {
                      // webview 创建完成
                      // 加载成功网页，之后保存成一个变量维护
                      webViewController = controller;

                      // 监听获取 h5调用ios的自定义方法
                      //  关闭webview页面
                      controller.addJavaScriptHandler(
                        handlerName: 'finishPage',
                        callback: (List<dynamic> args) {
                          // 关闭当前页面
                          Navigator.of(context).pop();
                        },
                      );
                      // 调用支付功能
                      controller.addJavaScriptHandler(
                        handlerName: 'appStart',
                        callback: (List<dynamic> args) {
                          // args 传递的格式是这样子的
                          // data: {
                          //         target_page: 'PAYMENT',
                          //         value: 'skuID值',
                          //         sub1: {
                          //             // 展示 优惠券弹窗
                          //             couponSwitch: false,
                          //         }
                          //     },
                          //     from: 'ios的首页',
                          // }
                          var arg1 = args[0];
                          //   var type = arg1.runtimeType.toString();
                          //   print('变量类型: $type');

                          var data = arg1['data'];
                          var targetType = data['target_page'];
                          // 支付
                          if (targetType == 'PAYMENT') {
                            // 支付调用
                            // 这里客户端会处理，然后调用支付接口，再返回给h5说支付成功了
                            Future.delayed(
                              Duration(seconds: 2),
                              () {
                                // 定义要注入的 JS 代码
                                String userScript = '''
                                    window.iosBridgePostMessageCallback.PAYMENT_CALLBACK(JSON.stringify({
                                        res: {
                                            state: true, // 支付成功或失败
                                        },
                                    }))
                                ''';
                                webViewController!
                                    .evaluateJavascript(source: userScript);
                              },
                            );

                            // return 的话，它将自动使用 dart:convert 库中的 jsonEncode 进行json编码。
                            return {};
                          }
                          // print arguments coming from the JavaScript side!
                          // print(args);
                          // return data to the JavaScript side!

                          return {
                            'lin': 'lin1',
                          };
                        },
                      );

                      //
                    },
                    initialUserScripts: UnmodifiableListView<UserScript>(
                      // 初始化用户脚本
                      [
                        // https://wiki.ducafecat.tech/blog/2211/51-webview-javascript-injection-with-user-scripts-flutter-inappwebview.html#%E7%BB%93%E6%9D%9F%E8%AF%AD
                        UserScript(
                          source: '''
                            window.iosBridgePostMessageData = {
                                'getUserInfo': () => { // 用户信息
                                    return JSON.stringify({
                                        token: 'token123',
                                    })
                                },
                                'getPhoneInfo': () => { // 用户信息
                                    return JSON.stringify({
                                        safeAreaHeight: $safeAreaHeight, // 顶部安全高度，验证过了，ios固定是59，但是anroid还不知道
                                    })
                                },
                            }
                              console.log('加载 webview 开始');
                          ''',
                          injectionTime: UserScriptInjectionTime
                              .AT_DOCUMENT_START, // 加载 webview 开始
                        ),
                        UserScript(
                          // 获取 flutter 顶部安全高度
                          source: '''
                              console.log('加载 webview 结束');
                           ''',
                          injectionTime: UserScriptInjectionTime
                              .AT_DOCUMENT_END, // 加载 webview 结束
                        ),
                      ],
                    ),
                    onLoadStart: (controller, url) {
                      // 开始加载 webview 页面
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onPermissionRequest: (controller, request) async {
                      return PermissionResponse(
                          resources: request.resources,
                          action: PermissionResponseAction.GRANT);
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      var uri = navigationAction.request.url!;

                      if (![
                        "http",
                        "https",
                        "file",
                        "chrome",
                        "data",
                        "javascript",
                        "about"
                      ].contains(uri.scheme)) {
                        if (await canLaunchUrl(uri)) {
                          // Launch the App
                          await launchUrl(
                            uri,
                          );
                          // and cancel the request
                          return NavigationActionPolicy.CANCEL;
                        }
                      }

                      return NavigationActionPolicy.ALLOW;
                    },
                    //  该事件可以被多次调用。这是特定于平台的，它与本机平台如何实现WebView有关！ 页面加载完毕了
                    onLoadStop: (controller, url) async {
                      // addEventListener flutterInAppWebViewPlatformReady 已经被触发了
                      pullToRefreshController?.endRefreshing();
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onPageCommitVisible: (controller, url) {
                      // ，当Web视图开始接收Web内容时
                      print('，当Web视图开始接收Web内容时');
                    },
                    // http 错误
                    onReceivedHttpError: (controller, request, errorResponse) {
                      print('onReceivedHttpError http 错误: $errorResponse');
                    },
                    // 页面加载失败
                    onReceivedError: (controller, request, error) {
                      print('onReceivedError 页面加载失败: $error');
                      pullToRefreshController?.endRefreshing();
                    },
                    onProgressChanged: (controller, progress) {
                      if (progress == 100) {
                        pullToRefreshController?.endRefreshing();
                      }
                      setState(() {
                        this.progress = progress / 100;
                        urlController.text = url;
                      });
                    },
                    onUpdateVisitedHistory: (controller, url, androidIsReload) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      if (kDebugMode) {
                        print(consoleMessage);
                      }
                    },
                  ),
                  progress < 1.0
                      ? LinearProgressIndicator(value: progress)
                      : Container(),
                ],
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  child: const Icon(Icons.arrow_back),
                  onPressed: () {
                    webViewController?.goBack();
                  },
                ),
                ElevatedButton(
                  child: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    webViewController?.goForward();
                  },
                ),
                ElevatedButton(
                  child: const Icon(Icons.refresh),
                  onPressed: () {
                    webViewController?.reload();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
