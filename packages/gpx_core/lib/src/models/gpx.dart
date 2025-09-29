import 'package:equatable/equatable.dart';

class Gpx extends Equatable {
  String creator;
  List<Wpt> wpts = [];
  List<Trk> trks = [];

  Gpx({this.creator = 'Mountain Hiking App'});

  @override
  List<Object> get props => [creator, wpts, trks];
}

class Wpt extends Equatable {
  double lat;
  double lon;
  double? ele;
  DateTime? time;
  String? name;
  String? desc;
  String? sym;

  Wpt({
    required this.lat,
    required this.lon,
    this.ele,
    this.time,
    this.name,
    this.desc,
    this.sym,
  });

  @override
  List<Object?> get props => [lat, lon, ele, time, name, desc, sym];
}

class Trk extends Equatable {
  String? name;
  String? desc;
  List<Trkseg> trksegs = [];

  Trk({this.name, this.desc, this.trksegs = const []});

  @override
  List<Object?> get props => [name, desc, trksegs];
}

class Trkseg extends Equatable {
  List<Wpt> trkpts = [];

  Trkseg({this.trkpts = const []});

  @override
  List<Object> get props => [trkpts];
}
