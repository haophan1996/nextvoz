import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../reuseWidget.dart';
import 'BrowserLoginController.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

class BrowserLoginUI extends GetView<BrowserLoginController>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarOnly('WebviewLogin', []),
      body: SafeArea(
        child:
        InAppWebView(
          initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                  userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.82 Safari/537.36',
                      cacheEnabled: false,
                clearCache: true,
              ),
              android: AndroidInAppWebViewOptions(
                useHybridComposition: true,
                cacheMode: AndroidCacheMode.LOAD_NO_CACHE,
                clearSessionCache: true,
              ),
              ios: IOSInAppWebViewOptions(
                allowsInlineMediaPlayback: true,
              )
          ),
          onWebViewCreated: (webView)   {
             controller.inAppWebViewController = webView;
          },
          initialUrlRequest: URLRequest(
              url:Uri.parse('https://voz.vn/login/login')),
          onLoadStop: (controllers, uri) async {
            dom.Document doc = parser.parse(await controller.inAppWebViewController!.getHtml());
            if (doc.getElementsByTagName('html')[0].attributes['data-logged-in'] == 'true'){
              setDialog();
              controller.getData();
            } else {
              ///If this case, let user loggin
              //Get.back();
            }
          },
          onLoadStart: (controller, uri){
            //setDialog();
          },
        ),
      ),
    );
  }

}