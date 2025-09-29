import 'package:xml/xml.dart';
import 'gpx.dart';

class GpxReader {
  Gpx parse(String xmlString) {
    final document = XmlDocument.parse(xmlString);
    final gpxElement = document.findAllElements('gpx').first;

    final gpx = Gpx(
      creator: gpxElement.getAttribute('creator') ?? '',
    );

    // Parse waypoints
    for (var wptElement in gpxElement.findAllElements('wpt')) {
      gpx.wpts.add(Wpt(
        lat: double.parse(wptElement.getAttribute('lat')!),
        lon: double.parse(wptElement.getAttribute('lon')!),
        ele: _parseDouble(wptElement, 'ele'),
        time: _parseDateTime(wptElement, 'time'),
        name: _parseString(wptElement, 'name'),
        desc: _parseString(wptElement, 'desc'),
        sym: _parseString(wptElement, 'sym'),
      ));
    }

    // Parse tracks
    for (var trkElement in gpxElement.findAllElements('trk')) {
      final trk = Trk(
        name: _parseString(trkElement, 'name'),
        desc: _parseString(trkElement, 'desc'),
      );

      for (var trksegElement in trkElement.findAllElements('trkseg')) {
        final trkseg = Trkseg();
        for (var trkptElement in trksegElement.findAllElements('trkpt')) {
          trkseg.trkpts.add(Wpt(
            lat: double.parse(trkptElement.getAttribute('lat')!),
            lon: double.parse(trkptElement.getAttribute('lon')!),
            ele: _parseDouble(trkptElement, 'ele'),
            time: _parseDateTime(trkptElement, 'time'),
          ));
        }
        trk.trksegs.add(trkseg);
      }
      gpx.trks.add(trk);
    }

    return gpx;
  }

  double? _parseDouble(XmlElement element, String tagName) {
    final text = element.findAllElements(tagName).firstOrNull?.text;
    return text != null ? double.tryParse(text) : null;
  }

  DateTime? _parseDateTime(XmlElement element, String tagName) {
    final text = element.findAllElements(tagName).firstOrNull?.text;
    return text != null ? DateTime.tryParse(text) : null;
  }

  String? _parseString(XmlElement element, String tagName) {
    return element.findAllElements(tagName).firstOrNull?.text;
  }
}
