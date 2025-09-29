import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mountain_hiking_app/src/business_logic/gpx_planning/gpx_planning_bloc.dart';
import 'package:mountain_hiking_app/src/data/models/gpx_planning_model.dart';
import 'package:mountain_hiking_app/src/presentation/screens/gpx_library_screen.dart';
import 'package:mountain_hiking_app/src/presentation/widgets/main_scaffold.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mountain_hiking_app/src/business_logic/gpx_library/gpx_library_bloc.dart';
import 'dart:io';

/// V1.0 - GPX 地圖規劃畫面
///
/// 核心視覺化編輯器，整合了地圖、航點列表和海拔剖面圖。
class GpxPlanningScreen extends StatelessWidget {
  const GpxPlanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GpxPlanningBloc, GpxPlanningState>(
      listener: (context, state) {
        if (state.status == GpxPlanningStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return MainScaffold(
          appBar: AppBar(
            title: const Text('GPX 地圖規劃'),
            actions: _buildAppBarActions(context, state),
          ),
          body: state.status == GpxPlanningStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : state.gpxData == null
                  ? const Center(child: Text('請從地圖庫載入或上傳一個 GPX 檔案'))
                  : _buildBody(context, state.gpxData!),
        );
      },
    );
  }

  /// 根據 BLoC 狀態建立 AppBar 的操作按鈕
  List<Widget> _buildAppBarActions(BuildContext context, GpxPlanningState state) {
    return [
              IconButton( // 新增這個按鈕
                icon: const Icon(Icons.file_open_outlined),
                tooltip: '讀取 GPX 檔案',
                onPressed: () => _showGpxSourceDialog(context),
              ),
              IconButton(
                icon: const Icon(Icons.undo),
                tooltip: '復原',
                onPressed: state.canUndo ? () => context.read<GpxPlanningBloc>().add(UndoRequested()) : null,
              ),
              IconButton(
                icon: const Icon(Icons.redo),
                tooltip: '重做',
                onPressed: state.canRedo ? () => context.read<GpxPlanningBloc>().add(RedoRequested()) : null,
              ),
              IconButton(
                icon: const Icon(Icons.save),
                tooltip: '儲存',
                onPressed: state.gpxData != null ? () => _showSaveDialog(context, state.gpxData!) : null,
              ),
    ];
  }

  ///  顯示 GPX 檔案來源選擇對話框。
  void _showGpxSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          title: const Text('選擇 GPX 檔案來源'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(dialogContext);
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.any, // FIX: Use FileType.any for broader compatibility
                  allowMultiple: false,
                );

                if (result != null && result.files.single.path != null) {
                  final file = result.files.single;
                  if (file.name.toLowerCase().endsWith('.gpx')) {
                    final bytes = await File(file.path!).readAsBytes();
                    context.read<GpxPlanningBloc>().add(LoadGpxRequested(gpxRawXml: utf8.decode(bytes, allowMalformed: true)));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('檔案 "${file.name}" 不是 GPX 檔案。'), backgroundColor: Colors.red),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('未選擇檔案或檔案讀取失敗。'), backgroundColor: Colors.red),
                  );
                }
              },
              child: const ListTile(leading: Icon(Icons.devices), title: Text('從裝置選擇')),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(dialogContext);
                final selectedFilePath = await Navigator.of(context).push<String>(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<GpxLibraryBloc>(context),
                      child: const GpxLibraryScreen(isSelectionMode: true),
                    ),
                  ),
                );
                if (selectedFilePath != null) {
                  try {
                    final bytes = await File(selectedFilePath).readAsBytes();
                    final gpxContent = utf8.decode(bytes, allowMalformed: true);
                    context.read<GpxPlanningBloc>().add(LoadGpxRequested(gpxRawXml: gpxContent));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('讀取檔案失敗: ${e.toString()}'), backgroundColor: Colors.red),
                    );
                  }
                }
              },
              child: const ListTile(leading: Icon(Icons.folder_open), title: Text('從 GPX 地圖庫選擇')),
            ),
          ],
        );
      },
    );
  }


  /// 建立主畫面內容，包含地圖和底部面板
  Widget _buildBody(BuildContext context, GpxData gpxData) {
    return Stack(
      children: [
        _buildGoogleMap(context, gpxData),
        _buildBottomSheet(gpxData),
      ],
    );
  }

  /// 建立 GoogleMap 元件
  Widget _buildGoogleMap(BuildContext context, GpxData gpxData) {
    final polylines = _createPolylines(gpxData);
    final markers = _createMarkers(gpxData);

    return GoogleMap(
      initialCameraPosition: _calculateInitialCameraPosition(polylines, markers),
      polylines: polylines,
      markers: markers,
      onLongPress: (latLng) {
        // ADD: Add waypoint on long press
        context.read<GpxPlanningBloc>().add(WaypointAdded(position: latLng));
      },
    );
  }

  /// 建立底部可拖動的面板
  Widget _buildBottomSheet(GpxData gpxData) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.1,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Card(
          elevation: 12.0,
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  tabs: [Tab(text: '航點'), Tab(text: '海拔剖面')],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildWaypointsList(context, gpxData.wpts, scrollController),
                      _buildElevationProfile(gpxData, scrollController),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 建立可排序的航點列表
  Widget _buildWaypointsList(BuildContext context, List<Wpt> waypoints, ScrollController controller) {
    return ReorderableListView.builder(
      itemCount: waypoints.length,
      itemBuilder: (context, index) {
        final wpt = waypoints[index];
        return ListTile(
          key: ValueKey(wpt.name ?? index),
          leading: CircleAvatar(child: Text('${index + 1}')),
          title: Text(wpt.name ?? '未命名航點'),
          subtitle: Text('緯度: ${wpt.lat.toStringAsFixed(4)}, 經度: ${wpt.lon.toStringAsFixed(4)}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ADD: Edit button
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: '編輯',
                onPressed: () => _showEditDialog(context, wpt, index),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => context.read<GpxPlanningBloc>().add(WaypointDeleted(index: index)),
              ),
            ],
          ),
        );
      },
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        context.read<GpxPlanningBloc>().add(WaypointsReordered(oldIndex: oldIndex, newIndex: newIndex));
      },
    );
  }

  // ADD: Method to show the edit dialog
  void _showEditDialog(BuildContext context, Wpt waypoint, int index) {
    final nameController = TextEditingController(text: waypoint.name);
    final descController = TextEditingController(text: waypoint.desc);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('編輯航點'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: '名稱'),
                autofocus: true,
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: '描述'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('取消'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('儲存'),
              onPressed: () {
                final updatedWpt = waypoint.clone()
                  ..name = nameController.text
                  ..desc = descController.text;

                context.read<GpxPlanningBloc>().add(WaypointUpdated(
                      index: index,
                      updatedWpt: updatedWpt,
                    ));
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// 建立海拔剖面圖
  Widget _buildElevationProfile(GpxData gpxData, ScrollController controller) {
    final spots = _generateElevationSpots(gpxData);
    if (spots.isEmpty) {
      return const Center(child: Text('沒有軌跡點可顯示海拔剖面'));
    }

    return SingleChildScrollView(
      controller: controller,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AspectRatio(
          aspectRatio: 2,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: true),
              titlesData: const FlTitlesData(show: true),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 從 GPX 資料產生軌跡線 (Polylines)
  Set<Polyline> _createPolylines(GpxData gpxData) {
    return gpxData.trks.map((trk) {
      final points = trk.trksegs.expand((seg) => seg.trkpts).map((pt) => pt.toLatLng()).toList();
      return Polyline(
        polylineId: PolylineId(trk.name ?? math.Random().nextDouble().toString()),
        points: points,
        color: Colors.blue,
        width: 5,
      );
    }).toSet();
  }

  /// 從 GPX 資料產生航點標記 (Markers)
  Set<Marker> _createMarkers(GpxData gpxData) {
    return gpxData.wpts.asMap().entries.map((entry) {
      final index = entry.key;
      final wpt = entry.value;
      return Marker(
        markerId: MarkerId(wpt.name ?? index.toString()),
        position: wpt.toLatLng(),
        infoWindow: InfoWindow(title: '${index + 1}. ${wpt.name ?? "航點"}'),
      );
    }).toSet();
  }

  /// 計算地圖的初始視角，使其能完整顯示所有軌跡和航點
  CameraPosition _calculateInitialCameraPosition(Set<Polyline> polylines, Set<Marker> markers) {
    final allPoints = <LatLng>[];
    for (var p in polylines) {
      allPoints.addAll(p.points);
    }
    for (var m in markers) {
      allPoints.add(m.position);
    }

    if (allPoints.isEmpty) {
      return const CameraPosition(target: LatLng(23.9738, 120.982), zoom: 8);
    }

    final bounds = _boundsFromLatLngList(allPoints);
    final center = LatLng(
      (bounds.southwest.latitude + bounds.northeast.latitude) / 2,
      (bounds.southwest.longitude + bounds.northeast.longitude) / 2,
    );

    return CameraPosition(target: center, zoom: 12); // Zoom level could be calculated more dynamically
  }

  /// 從軌跡點產生海拔圖表的資料點
  List<FlSpot> _generateElevationSpots(GpxData gpxData) {
    final spots = <FlSpot>[];
    double distance = 0.0;
    Trkpt? lastPoint;

    for (final trk in gpxData.trks) {
      for (final seg in trk.trksegs) {
        for (final pt in seg.trkpts) {
          if (lastPoint != null) {
            distance += _calculateDistance(lastPoint, pt);
          }
          if (pt.ele != null) {
            spots.add(FlSpot(distance / 1000, pt.ele!)); // X: km, Y: meters
          }
          lastPoint = pt;
        }
      }
    }
    return spots;
  }

  /// 計算兩點之間的距離 (Haversine 公式)
  double _calculateDistance(Trkpt p1, Trkpt p2) {
    const R = 6371e3; // Earth radius in meters
    final phi1 = p1.lat * math.pi / 180;
    final phi2 = p2.lat * math.pi / 180;
    final deltaPhi = (p2.lat - p1.lat) * math.pi / 180;
    final deltaLambda = (p2.lon - p1.lon) * math.pi / 180;

    final a = math.sin(deltaPhi / 2) * math.sin(deltaPhi / 2) +
        math.cos(phi1) * math.cos(phi2) * math.sin(deltaLambda / 2) * math.sin(deltaLambda / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return R * c;
  }

  /// 從 LatLng 列表計算邊界
  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double? x0, x1, y0, y1;
    for (final latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  /// 顯示儲存對話框
  // Gemini: 根據使用者反饋，重構儲存邏輯。
  void _showSaveDialog(BuildContext context, GpxData gpxData) {
    // 建議的檔名：移除特殊字元並用底線取代空格
    final suggestedName = (gpxData.metadata?.name ?? 'My Planned Route')
        .replaceAll(RegExp(r'[\/:]'), '') // 移除路徑中的非法字元
        .replaceAll(' ', '_'); // 用底線取代空格
    final nameController = TextEditingController(text: suggestedName);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('儲存軌跡'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: '檔案名稱',
              hintText: '請輸入有效的檔名',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('取消')),
            TextButton(
              onPressed: () {
                final newName = nameController.text;
                // 檔名驗證：不可為空或只包含空格
                if (newName.trim().isNotEmpty) {
                  // 將使用者輸入的名稱同時用於檔案系統的檔名和 GPX 內部的軌跡名
                  context.read<GpxPlanningBloc>().add(SaveGpxRequested(
                        fileName: newName, // 用於檔案系統
                        trackName: newName, // 用於 GPX <metadata><name>
                      ));
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('已儲存至地圖庫'),
                        backgroundColor: Colors.green),
                  );
                } else {
                  // 可以在此處顯示錯誤提示
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('檔名不可為空'),
                        backgroundColor: Colors.red),
                  );
                }
              },
              child: const Text('儲存'),
            ),
          ],
        );
      },
    );
  }
}