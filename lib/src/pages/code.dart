
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as whtml;

class CodePage extends StatelessWidget {
  const CodePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var code = Get.parameters['code'];
    print('hmhm code page $code');
    //whtml.window.postMessage("messaged", "http://localhost:8888");
    if (code != null) {
      //html.window.localStorage['code'] = code;
    }
    whtml.window.onBeforeUnload.listen((event) async{
      whtml.window.localStorage['code'] = 'close';
    });
    //toMain();
    return Container();
  }

  void toMain() async {
    await Future.delayed(const Duration(seconds: 1));
    Get.offAllNamed('/');
  }
}
