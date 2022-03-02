
import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import '../obs/footballHighlightOb.dart';
import '../obs/response_ob.dart';
import '../utils/app_constants.dart';
// import 'package:http/http.dart' as http;

class HomeBloc{

  StreamController<ResponseOb> _controller = StreamController<ResponseOb>.broadcast();
  Stream<ResponseOb> getHighlightStream() => _controller.stream;

  Dio dio = Dio();
  // List<FootballHighlightOb> hob = [];

  getHighlightData() async{
    ResponseOb responseOb = ResponseOb(msgState: MsgState.loading);
    // _controller.sink.add(responseOb);
    
      // var response = await http.get(Uri.parse(BASE_URL));
      var response = await dio.get(BASE_URL+"?token="+TOKEN);
      print(response.data);
    try{
      if(response.statusCode == 200) {
      Map<String,dynamic> responseMap = response.data;
      // List<dynamic> list = json.decode(response.body);
      // list.forEach((element) {hob.add(FootballHighlightOb.fromJson(element));});
      FootballHighlightOb footballHighlightOb = FootballHighlightOb.fromJson(responseMap);
      responseOb.msgState = MsgState.data;
      responseOb.data = footballHighlightOb.response;
      _controller.sink.add(responseOb);
    }else if(response.statusCode == 404){
      responseOb.msgState = MsgState.error;
      responseOb.errState = ErrState.notFoundErr;
      _controller.sink.add(responseOb);
    }else if(response.statusCode == 500){
      responseOb.msgState = MsgState.error;
      responseOb.errState = ErrState.severErr;
      _controller.sink.add(responseOb);
    }else{
      responseOb.msgState = MsgState.error;
      responseOb.errState = ErrState.unKnownErr;
      _controller.sink.add(responseOb);
    }
    }catch(e){
      if (e.toString().contains("SocketException")) {
        responseOb.data = "Internet Connection Error";
        responseOb.msgState = MsgState.error;
        responseOb.errState = ErrState.noConnection;
        _controller.sink.add(responseOb);
      } else {
        responseOb.data = "Unknown Error";
        responseOb.msgState = MsgState.error;
        responseOb.errState = ErrState.unKnownErr;
        _controller.sink.add(responseOb);
      }
    }
    
  }
}