import 'dart:typed_data';
import 'package:xml/xml.dart';
import 'package:intl/intl.dart';

class GpxMerger {
  static const String gpxNamespace = 'http://www.topografix.com/GPX/1/1';
  static const String xsiNamespace = 'http://www.w3.org/2001/XMLSchema-instance';
  
  /// 合併多個GPX檔案
  static Uint8List mergeGpxFiles(List<Uint8List> gpxFiles) {
    // 初始化用於存放所有資料的列表
    final List<XmlElement> allWpts = [];
    final List<XmlElement> allRtes = [];
    final List<XmlElement> allTrks = [];
    
    // 解析所有GPX檔案
    for (int i = 0; i < gpxFiles.length; i++) {
      try {
        final String content = String.fromCharCodes(gpxFiles[i]);
        final XmlDocument document = XmlDocument.parse(content);
        final XmlElement? root = document.rootElement;
        
        if (root != null) {
          // 提取所有的 <wpt>, <rte>, <trk> 元素
          allWpts.addAll(root.findElements('wpt'));
          allRtes.addAll(root.findElements('rte'));
          allTrks.addAll(root.findElements('trk'));
        }
      } catch (e) {
        print('解析第 ${i + 1} 個檔案時發生錯誤: $e');
      }
    }
    
    // 根據 (緯度, 經度) 進行排序，由大到小
    allWpts.sort((a, b) => _compareElements(b, a));
    allRtes.sort((a, b) => _compareElements(b, a));
    allTrks.sort((a, b) => _compareElements(b, a));
    
    // 建立新的GPX檔案
    final XmlDocument mergedDoc = _createMergedGpx(allWpts, allRtes, allTrks);
    
    // 轉換為字串並編碼為UTF-8
    final String xmlString = mergedDoc.toXmlString(pretty: true);
    return Uint8List.fromList(xmlString.codeUnits);
  }
  
  /// 比較兩個元素的座標用於排序
  static int _compareElements(XmlElement a, XmlElement b) {
    final coords1 = _getSortKey(a);
    final coords2 = _getSortKey(b);
    
    // 先比較緯度，再比較經度
    final latCompare = coords1.$1.compareTo(coords2.$1);
    if (latCompare != 0) return latCompare;
    return coords1.$2.compareTo(coords2.$2);
  }
  
  /// 從GPX元素中提取用於排序的緯度和經度
  static (double, double) _getSortKey(XmlElement element) {
    double lat = -91.0;
    double lon = -181.0;
    
    try {
      if (element.name.local == 'wpt') {
        // 處理 <wpt> (航點)
        lat = double.parse(element.getAttribute('lat') ?? '-91.0');
        lon = double.parse(element.getAttribute('lon') ?? '-181.0');
      } else if (element.name.local == 'rte') {
        // 處理 <rte> (路線) - 找第一個 <rtept>
        final rtept = element.findElements('rtept').firstOrNull;
        if (rtept != null) {
          lat = double.parse(rtept.getAttribute('lat') ?? '-91.0');
          lon = double.parse(rtept.getAttribute('lon') ?? '-181.0');
        }
      } else if (element.name.local == 'trk') {
        // 處理 <trk> (航跡) - 找第一個 <trkseg> 中的第一個 <trkpt>
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
  
  /// 建立合併後的GPX文件
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
      
      // 加入 metadata
      builder.element('metadata', nest: () {
        builder.element('time', nest: () {
          final now = DateTime.now().toUtc();
          final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
          builder.text(formatter.format(now));
        });
      });
      
      // 加入所有元素
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