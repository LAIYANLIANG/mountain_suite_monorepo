

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mountain_hiking_app/generated/app_localizations.dart';
import 'package:mountain_hiking_app/src/business_logic/gpx_library/gpx_library_bloc.dart';
import 'package:mountain_hiking_app/src/business_logic/tracking/tracking_bloc.dart';
import 'package:mountain_hiking_app/src/presentation/screens/gpx_library_screen.dart';
import 'package:mountain_hiking_app/src/presentation/widgets/main_scaffold.dart';
import 'package:permission_handler/permission_handler.dart';

/// V1.0 - 軌跡記錄畫面
///
/// 負責提供地圖介面，讓使用者可以匯入參考軌跡、即時記錄自己的移動軌跡，
/// 並將記錄下來的軌跡儲存為新的 GPX 檔案。
class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TrackingBloc(
        // 將已存在的 GpxLibraryBloc 實例注入 TrackingBloc
        gpxLibraryBloc: BlocProvider.of<GpxLibraryBloc>(context),
      ),
      child: const _TrackingView(),
    );
  }
}

class _TrackingView extends StatefulWidget {
  const _TrackingView();

  @override
  State<_TrackingView> createState() => _TrackingViewState();
}

class _TrackingViewState extends State<_TrackingView> {
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MainScaffold(
      appBar: AppBar(
        title: Text(l10n.trackingFeatureTitle),
        actions: [
          // 匯入參考軌跡按鈕
          IconButton(
            icon: const Icon(Icons.folder_open_outlined),
            tooltip: '載入參考軌跡',
            onPressed: () => _showGpxSourceDialog(context),
          ),
        ],
      ),
      body: BlocConsumer<TrackingBloc, TrackingState>(
        listener: (context, state) {
          // 監聽錯誤狀態並顯示提示
          if (state.status == TrackingStatus.error && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red),
            );
          }
          // 當有新的 GPS 位置時，移動地圖視角
          if (state.currentPosition != null) {
            _mapController?.animateCamera(
              CameraUpdate.newLatLngZoom(
                LatLng(state.currentPosition!.latitude, state.currentPosition!.longitude),
                16,
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(23.9738, 120.982), // 台灣中心
                  zoom: 8,
                ),
                onMapCreated: (controller) => _mapController = controller,
                polylines: _buildPolylines(state),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
              // 頂部資訊卡 (計時器)
              _buildTopInfoCard(state.duration),
              // 底部控制按鈕面板
              Positioned(
                bottom: 16.0,
                left: 16.0,
                right: 16.0,
                child: _buildControlButtons(context, state, l10n),
              ),
              // Gemini: Add new FAB for centering map on user location
              Positioned(
                bottom: 100.0, // Adjust position to be above the main controls
                right: 16.0,
                child: FloatingActionButton(
                  onPressed: () async {
                    try {
                      final position = await Geolocator.getCurrentPosition();
                      _mapController?.animateCamera(
                        CameraUpdate.newLatLngZoom(
                          LatLng(position.latitude, position.longitude),
                          16.0,
                        ),
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('無法取得目前位置: $e'), backgroundColor: Colors.red),
                      );
                    }
                  },
                  tooltip: '偵測目前所在位置',
                  child: const Icon(Icons.my_location),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 根據 BLoC 狀態建立地圖上的軌跡線
  Set<Polyline> _buildPolylines(TrackingState state) {
    final polylines = <Polyline>{};
    // 加入參考軌跡線 (紅色)
    polylines.addAll(state.referencePolylines.map((p) => p.copyWith(colorParam: Colors.red)));
    // 加入即時記錄的軌跡線 (藍色)
    if (state.liveTrackPoints.isNotEmpty) {
      polylines.add(Polyline(
        polylineId: const PolylineId('live_track'),
        points: state.liveTrackPoints,
        color: Colors.blue,
        width: 5,
      ));
    }
    return polylines;
  }

  /// 建立頂部的計時器資訊卡
  Widget _buildTopInfoCard(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return Positioned(
      top: 10,
      left: 10,
      right: 10,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$hours:$minutes:$seconds',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  /// 顯示選擇 GPX 來源的對話框 (裝置或地圖庫)
  void _showGpxSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          title: const Text('選擇參考軌跡來源'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(dialogContext);
                final selectedFilePath = await Navigator.of(context).push<String>(
                  MaterialPageRoute(
                    // FEATURE: 進入地圖庫的「選擇模式」
                    builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<GpxLibraryBloc>(context),
                      child: const GpxLibraryScreen(isSelectionMode: true),
                    ),
                  ),
                );
                if (selectedFilePath != null && context.mounted) {
                  context.read<TrackingBloc>().add(GpxFileLoaded(filePath: selectedFilePath));
                }
              },
              child: const ListTile(leading: Icon(Icons.folder_open), title: Text('從 GPX 地圖庫選擇')),
            ),
          ],
        );
      },
    );
  }

  /// 根據 BLoC 狀態建立底部的控制按鈕
  Widget _buildControlButtons(BuildContext context, TrackingState state, AppLocalizations l10n) {
    switch (state.status) {
      case TrackingStatus.recording:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () => context.read<TrackingBloc>().add(TrackingPaused()),
              icon: const Icon(Icons.pause),
              label: Text(l10n.pauseTrackingButton),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
            ),
            ElevatedButton.icon(
              onPressed: () => context.read<TrackingBloc>().add(TrackingStopped()),
              icon: const Icon(Icons.stop),
              label: Text(l10n.stopTrackingButton),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            ),
          ],
        );
      case TrackingStatus.paused:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () => context.read<TrackingBloc>().add(TrackingResumed()),
              icon: const Icon(Icons.play_arrow),
              label: Text(l10n.resumeTrackingButton),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            ),
            ElevatedButton.icon(
              onPressed: () => context.read<TrackingBloc>().add(TrackingStopped()),
              icon: const Icon(Icons.stop),
              label: Text(l10n.stopTrackingButton),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            ),
          ],
        );
      case TrackingStatus.stopped:
        return _buildSaveTrackWidget(context, l10n);
      case TrackingStatus.permissionDenied:
        return ElevatedButton.icon(
          onPressed: () => openAppSettings(),
          icon: const Icon(Icons.settings),
          label: const Text('權限被拒絕，請至設定頁面開啟'),
        );
      case TrackingStatus.ready:
      case TrackingStatus.initial:
      default:
        return ElevatedButton.icon(
          onPressed: () => context.read<TrackingBloc>().add(TrackingStarted()),
          icon: const Icon(Icons.play_arrow),
          label: Text(l10n.startTrackingButton),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
          ),
        );
    }
  }

  /// 建立儲存軌跡的輸入框和按鈕
  Widget _buildSaveTrackWidget(BuildContext context, AppLocalizations l10n) {
    final controller = TextEditingController(text: l10n.defaultTrackName);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(labelText: l10n.trackNameLabel, border: const OutlineInputBorder()),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {
            final name = controller.text.trim();
            if (name.isNotEmpty) {
              context.read<TrackingBloc>().add(TrackSaved(fileName: name));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('軌跡名稱不可為空'), backgroundColor: Colors.red),
              );
            }
          },
          icon: const Icon(Icons.save),
          label: Text(l10n.saveTrackButton),
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
        ),
      ],
    );
  }
}
