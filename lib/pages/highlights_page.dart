import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/home_bloc.dart';
import '../obs/footballHighlightOb.dart';
import '../obs/response_ob.dart';
import 'view_highlight_page.dart';

class HighlightsPage extends StatefulWidget {
  String title ;
  String competitionUrl;
  HighlightsPage({Key? key, required this.title,required this.competitionUrl}) : super(key: key);

  @override
  _HighlightsPageState createState() => _HighlightsPageState();
}

class _HighlightsPageState extends State<HighlightsPage> {
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
  // getData()async{
  //   var response = await http.get(Uri.parse(BASE_URL));
  //   if(response.statusCode == 200){
  //     List<dynamic> list = json.decode(response.body);
  //     list.forEach((element) {oblist.add(HightlightOb.fromJson(element));});
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: ()async{
              if (!await launch(widget.competitionUrl)) throw 'Could not launch ${widget.competitionUrl}';
            }, 
            icon: Icon(Icons.language)
          )
        ],
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
              List<Response> compt = fList.where((ele)=>ele.competition!.contains(widget.title)).toList();
              // removeDuplicate.add(fList.map((value)=> value.competition!).toString());
              return SmartRefresher(
                controller: _refreshController,
                onRefresh: () async {
                  // await Future.delayed(Duration(milliseconds: 1000));
                  _homeBloc.getHighlightData();
                  // if failed,use refreshFailed()
                  
                  
                },
                child: ListView.builder(
                    itemCount: compt.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewHighlightPage(title: compt[index].title.toString(),url: compt[index].videos![0].embed.toString(),result: compt[index].videos![0].title.toString(),matchUrl: compt[index].matchviewUrl.toString(),)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                                  decoration: const BoxDecoration(
                                    // image: DecorationImage(image: AssetImage("assets/images/PLlogo.png"),fit: BoxFit.cover,opacity: 0.5),
                                    color: Colors.blueAccent,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          compt[index].title.toString(),
                                          style: TextStyle(
                                            backgroundColor: Colors.red,
                                              color: Colors.yellow,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          compt[index]
                                              .date
                                              .toString()
                                              .split("T")[0],
                                          style: TextStyle(fontSize: 20,backgroundColor: Colors.red,color: Colors.yellow,),
                                        ),
                                        SizedBox(
                                          height: 250,
                                          width: double.infinity,
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl:
                                                compt[index].thumbnail.toString(),
                                            progressIndicatorBuilder:
                                                (context, url, downloadProgress) =>
                                                    Center(
                                              child: CircularProgressIndicator(
                                                  color: Colors.yellow,
                                                  value: downloadProgress.progress),
                                            ),
                                            errorWidget: (context, url, error) =>
                                                Icon(Icons.error),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                        ),
                      );
                    }),
              );
            } else {
              return const Center(child: CircularProgressIndicator(color: Colors.yellow));
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
