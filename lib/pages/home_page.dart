import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/home_bloc.dart';
import '../obs/footballHighlightOb.dart';
import '../obs/response_ob.dart';
import 'highlights_page.dart';

class HomePage extends StatefulWidget {
  // const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _homeBloc = HomeBloc();
  List<FootballHighlightOb> oblist = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _homeBloc.getHighlightData();
    _homeBloc.getHighlightStream().listen((ResponseOb responseOb) {
      if(responseOb.msgState == MsgState.data){
        _refreshController.refreshCompleted();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: const Text("Football Highlights",style: TextStyle(fontSize: 30)),
        centerTitle: true,
      ),
      body: StreamBuilder<ResponseOb>(
        initialData: ResponseOb(msgState: MsgState.loading),
        stream: _homeBloc.getHighlightStream(),
        builder: (context, AsyncSnapshot<ResponseOb> snapshot) {
          if (snapshot.hasData) {
            ResponseOb? responseOb = snapshot.data;
            if (responseOb?.msgState == MsgState.error) {
              // return Center(child: Text("Error"),);
              if (responseOb?.errState == ErrState.severErr) {
                return const Center(
                  child: Text("505\nSever Error"),
                );
              } else if (responseOb?.errState == ErrState.notFoundErr) {
                return const Center(
                  child: Text("404\nPage not found"),
                );
              } else if (responseOb?.errState == ErrState.noConnection) {
                return const Center(
                  child: Text("No Internet Connection"),
                );
              } else {
                return const Center(
                  child: Text("Unknown error"),
                );
              }
            } else if (responseOb?.msgState == MsgState.data) {
              List<Response> fList = responseOb?.data;
              List<Response> compt = fList.where((ele)=>ele.competition!.contains('ENGLAND: Premier League')).toList();
              List<String> removeDuplicate = fList.map((e) => e.competition!).toSet().toList();
              print(removeDuplicate);
              // removeDuplicate.add(fList.map((value)=> value.competition!).toString());
              return SmartRefresher(
                controller: _refreshController,
                onRefresh: () async {
                  // await Future.delayed(Duration(milliseconds: 1000));
                  _homeBloc.getHighlightData();
                  // if failed,use refreshFailed()
                  
                  
                },child: GridView.builder(
                  itemCount: removeDuplicate.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 4), 
                  itemBuilder: (context, index){
                    return SizedBox(
                      height:20,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> HighlightsPage(title: removeDuplicate[index],competitionUrl: fList[index].competitionUrl.toString(),)));
                        },
                        child: Card(
                          shadowColor: Colors.transparent,
                          elevation: 0.0,
                          color: Colors.red,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: Center(child: Text(removeDuplicate[index].toString(),textAlign: TextAlign.center,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.yellow),)),
                        ),
                      ),
                    );
                  }
                )
              
                );
                
            } else {
              return const Center(child: CircularProgressIndicator(color: Colors.yellow,));
            }
          } else {
            return const Center(
              child: Text("No Data"),
            );
          }
        },
      ),
    );
  }
}
