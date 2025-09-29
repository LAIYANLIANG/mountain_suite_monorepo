
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// V1.0 - GPX 規劃功能的資料模型
///
/// 這些類別被設計為可變的 (mutable)，以方便在 BLoC 中進行編輯。
/// 每個類別都包含一個 `clone` 方法，用於實現深拷貝，這對於 Undo/Redo 功能至關重要。

// ===========================================================================
// GPX 根物件
// ===========================================================================
class GpxData {
  String? creator;
  Metadata? metadata;
  List<Wpt> wpts; // 航點
  List<Trk> trks; // 軌跡

  GpxData({
    this.creator,
    this.metadata,
    List<Wpt>? wpts,
    List<Trk>? trks,
  })  : wpts = wpts ?? [],
        trks = trks ?? [];

  /// 建立一個此物件的深拷貝
  GpxData clone() {
    return GpxData(
      creator: creator,
      metadata: metadata?.clone(),
      wpts: wpts.map((e) => e.clone()).toList(),
      trks: trks.map((e) => e.clone()).toList(),
    );
  }
}

// ===========================================================================
// 元數據
// ===========================================================================
class Metadata {
  String? name;
  String? desc;
  DateTime? time;

  Metadata({this.name, this.desc, this.time});

  Metadata clone() {
    return Metadata(name: name, desc: desc, time: time);
  }
}

// ===========================================================================
// 航點 (Waypoint)
// ===========================================================================
class Wpt {
  double lat;
  double lon;
  double? ele;
  DateTime? time;
  String? name;
  String? desc;

  Wpt({
    required this.lat,
    required this.lon,
    this.ele,
    this.time,
    this.name,
    this.desc,
  });

  LatLng toLatLng() => LatLng(lat, lon);

  Wpt clone() {
    return Wpt(
      lat: lat,
      lon: lon,
      ele: ele,
      time: time,
      name: name,
      desc: desc,
    );
  }
}

// ===========================================================================
// 軌跡 (Track)
// ===========================================================================
class Trk {
  String? name;
  List<Trkseg> trksegs;

  Trk({this.name, List<Trkseg>? trksegs}) : trksegs = trksegs ?? [];

  Trk clone() {
    return Trk(
      name: name,
      trksegs: trksegs.map((e) => e.clone()).toList(),
    );
  }
}

// ===========================================================================
// 軌跡段 (Track Segment)
// ===========================================================================
class Trkseg {
  List<Trkpt> trkpts;

  Trkseg({List<Trkpt>? trkpts}) : trkpts = trkpts ?? [];

  Trkseg clone() {
    return Trkseg(trkpts: trkpts.map((e) => e.clone()).toList());
  }
}

// ===========================================================================
// 軌跡點 (Track Point)
// ===========================================================================
class Trkpt {
  double lat;
  double lon;
  double? ele;
  DateTime? time;

  Trkpt({
    required this.lat,
    required this.lon,
    this.ele,
    this.time,
  });

  LatLng toLatLng() => LatLng(lat, lon);

  Trkpt clone() {
    return Trkpt(
      lat: lat,
      lon: lon,
      ele: ele,
      time: time,
    );
  }
}
