
class ResponseOb{
  MsgState? msgState;
  ErrState? errState;
  dynamic data;
  PageState? pageState;
  ResponseOb({this.msgState,this.errState,this.data,this.pageState});

}

enum MsgState{
  data,
  error,
  loading,
}

enum ErrState{
  unKnownErr,
  notFoundErr,
  severErr,
  noConnection,
  other,
  userErr,
}

enum PageState{

  first,
  load,
  noMore,
}