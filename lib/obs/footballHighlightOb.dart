class FootballHighlightOb {
  List<Response>? response;

  FootballHighlightOb({this.response});

  FootballHighlightOb.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      response = <Response>[];
      json['response'].forEach((v) {
        response!.add(new Response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  String? title;
  String? competition;
  String? matchviewUrl;
  String? competitionUrl;
  String? thumbnail;
  String? date;
  List<Videos>? videos;

  Response(
      {this.title,
      this.competition,
      this.matchviewUrl,
      this.competitionUrl,
      this.thumbnail,
      this.date,
      this.videos});

  Response.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    competition = json['competition'];
    matchviewUrl = json['matchviewUrl'];
    competitionUrl = json['competitionUrl'];
    thumbnail = json['thumbnail'];
    date = json['date'];
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(new Videos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['competition'] = this.competition;
    data['matchviewUrl'] = this.matchviewUrl;
    data['competitionUrl'] = this.competitionUrl;
    data['thumbnail'] = this.thumbnail;
    data['date'] = this.date;
    if (this.videos != null) {
      data['videos'] = this.videos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Videos {
  String? title;
  String? embed;

  Videos({this.title, this.embed});

  Videos.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    embed = json['embed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['embed'] = this.embed;
    return data;
  }
}
