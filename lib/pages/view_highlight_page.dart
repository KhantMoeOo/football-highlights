import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ViewHighlightPage extends StatefulWidget {
  // const ViewHighlightPage({ Key? key }) : super(key: key);
  String title;
  String url;
  String result;
  String matchUrl;
  ViewHighlightPage({Key? key, required this.title,required this.url,required this.result,required this.matchUrl}) : super(key: key);

  @override
  _ViewHighlightPageState createState() => _ViewHighlightPageState();
}

class _ViewHighlightPageState extends State<ViewHighlightPage> {
  late WebViewController controller;

  void loadLocalHtml()async{
    final Url = Uri.dataFromString(
      widget.url,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    ).toString();
    controller.loadUrl(Url);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.url);
  }
  @override
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Column(
          children: [
            Row(
                children: [
                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    }, 
                    icon: const Icon(Icons.keyboard_backspace,color: Colors.white)
                  ),
                  Expanded(child: SizedBox(width: 280, child: Text(widget.title,style: const TextStyle(overflow: TextOverflow.ellipsis, fontSize: 20,color: Colors.white),maxLines: 2,overflow: TextOverflow.ellipsis,))),
                  IconButton(
            onPressed: ()async{
              if (!await launch(widget.matchUrl)) throw 'Could not launch ${widget.matchUrl}';
            }, 
            icon: const Icon(Icons.language,color: Colors.white,)
          )
                ]
              ),SizedBox(
                height: 250,
                width: double.infinity,
                child: WebView(
                  backgroundColor: Colors.blueAccent,
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (controller){
                        this.controller = controller;
                        loadLocalHtml();
                      },
                    ),
            ),
              
            
          ],
        )
      ),
    );
  }
}