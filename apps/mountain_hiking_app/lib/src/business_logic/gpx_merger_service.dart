import 'dart:convert';
import 'dart:typed_data';
import 'package:xml/xml.dart';
import 'package:intl/intl.dart';

class GpxMergerService {
  static const String gpxNamespace = 'http://www.topografix.com/GPX/1/1';
  static const String xsiNamespace = 'http://www.w3.org/2001/XMLSchema-instance';

  static Uint8List mergeGpxFiles(List<Uint8List> gpxFiles) {
    final List<XmlElement> allWpts = [];
    final List<XmlElement> allRtes = [];
    final List<XmlElement> allTrks = [];
    
    for (int i = 0; i < gpxFiles.length; i++) {
      try {
        // FIX: Decode using utf8 with allowMalformed to prevent encoding errors.
        final String content = utf8.decode(gpxFiles[i], allowMalformed: true);
        final XmlDocument document = XmlDocument.parse(content);
        final XmlElement root = document.rootElement;
        
        allWpts.addAll(root.findElements('wpt'));
        allRtes.addAll(root.findElements('rte'));
        allTrks.addAll(root.findElements('trk'));
            } catch (e) {
        print('解析第 ${i + 1} 個檔案時發生錯誤: $e');
      }
    }
    
    allWpts.sort((a, b) => _compareElements(b, a));
    allRtes.sort((a, b) => _compareElements(b, a));
    allTrks.sort((a, b) => _compareElements(b, a));

    final mergedDoc = _createMergedGpx(allWpts, allRtes, allTrks);
    
    final String xmlString = mergedDoc.toXmlString(pretty: true);
    return Uint8List.fromList(xmlString.codeUnits);
  }
  
  static int _compareElements(XmlElement a, XmlElement b) {
    final coords1 = _getSortKey(a);
    final coords2 = _getSortKey(b);
    
    final latCompare = coords1.$1.compareTo(coords2.$1);
    if (latCompare != 0) return latCompare;
    return coords1.$2.compareTo(coords2.$2);
  }
  
  static (double, double) _getSortKey(XmlElement element) {
    double lat = -91.0;
    double lon = -181.0;
    
    try {
      if (element.name.local == 'wpt') {
        lat = double.parse(element.getAttribute('lat') ?? '-91.0');
        lon = double.parse(element.getAttribute('lon') ?? '-181.0');
      } else if (element.name.local == 'rte') {
        final rtept = element.findElements('rtept').firstOrNull;
        if (rtept != null) {
          lat = double.parse(rtept.getAttribute('lat') ?? '-91.0');
          lon = double.parse(rtept.getAttribute('lon') ?? '-181.0');
        }
      } else if (element.name.local == 'trk') {
        final trkseg = element.findElements('trkseg').firstOrNull;
        if (trkseg != null) {
          final trkpt = trkseg.findElements('trkpt').firstOrNull;
          if (trkpt != null) {
            lat = double.parse(trkpt.getAttribute('lat') ?? '-91.0');
            lon = double.parse(trkpt.getAttribute('lon') ?? '-181.0');
          }
        }
      }
    } catch (e) {
      print('提取座標時發生錯誤: $e');
    }
    
    return (lat, lon);
  }
  
  static XmlDocument _createMergedGpx(
    List<XmlElement> wpts,
    List<XmlElement> rtes,
    List<XmlElement> trks,
  ) {
    final builder = XmlBuilder();
    
    builder.element('gpx', nest: () {
      builder.attribute('xmlns', gpxNamespace);
      builder.attribute('xmlns:xsi', xsiNamespace);
      builder.attribute('xsi:schemaLocation', 
        '$gpxNamespace http://www.topografix.com/GPX/1/1/gpx.xsd');
      builder.attribute('version', '1.1');
      builder.attribute('creator', 'GPX Merger App');
      
      builder.element('metadata', nest: () {
        builder.element('time', nest: () {
          final now = DateTime.now().toUtc();
          final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
          builder.text(formatter.format(now));
        });
      });
      
      for (final wpt in wpts) {
        builder.xml(wpt.toXmlString());
      }
      for (final rte in rtes) {
        builder.xml(rte.toXmlString());
      }
      for (final trk in trks) {
        builder.xml(trk.toXmlString());
      }
    });
    
    return builder.buildDocument();
  }
}
