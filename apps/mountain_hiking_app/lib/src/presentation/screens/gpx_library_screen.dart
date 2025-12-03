import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mountain_hiking_app/src/business_logic/gpx_library/gpx_library_bloc.dart';
import 'package:mountain_hiking_app/src/business_logic/gpx_planning/gpx_planning_bloc.dart';
import 'package:mountain_hiking_app/src/data/models/gpx_library_item.dart';
import 'package:mountain_hiking_app/src/presentation/screens/gpx_planning/gpx_planning_screen.dart';
import 'package:mountain_hiking_app/src/presentation/widgets/main_scaffold.dart';

/// V1.0 - GPX 地圖庫畫面
///
/// 負責顯示和管理儲存在 App 本地的 GPX 檔案。
class GpxLibraryScreen extends StatelessWidget {
  final bool isSelectionMode;
  const GpxLibraryScreen({super.key, this.isSelectionMode = false});

  @override
  Widget build(BuildContext context) {
    // FIX: BlocProvider is now managed at a higher level or when navigating.
    // This assumes the BLoC is already provided.
    return _GpxListView(isSelectionMode: isSelectionMode);
  }
}

class _GpxListView extends StatelessWidget {
  final bool isSelectionMode;
  const _GpxListView({required this.isSelectionMode});

  /// FEATURE: 處理從裝置選擇並上傳 GPX 檔案的邏輯。
  // Gemini: 根據使用者反饋，移除明確的權限請求，直接使用 FilePicker。
  // FilePicker 會自行處理讓使用者選擇檔案的系統 UI，這更符合新版 Android 的 Scoped Storage 策略。
  Future<void> _uploadGpxFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any, // FIX: Use FileType.any for broader compatibility
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      // 篩選出有效的 GPX 檔案
      final List<PlatformFile> validFiles = result.files
          .where((file) => file.name.toLowerCase().endsWith('.gpx'))
          .toList();

      // 對於無效檔案給出提示
      for (final file in result.files) {
        if (!file.name.toLowerCase().endsWith('.gpx')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('檔案 "${file.name}" 不是 GPX 檔案，已略過。'),
                backgroundColor: Colors.orange),
          );
        }
      }

      if (validFiles.isNotEmpty) {
        context
            .read<GpxLibraryBloc>()
            .add(FileUploaded(platformFiles: validFiles));
      }
    }
    // 如果使用者取消選擇，則不執行任何操作。
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: AppBar(
        title: Text(isSelectionMode ? '選擇 GPX 檔案' : 'GPX 地圖庫'),
        actions: [
          // 在非選擇模式下，顯示上傳按鈕
          if (!isSelectionMode)
            IconButton(
              icon: const Icon(Icons.upload_file),
              tooltip: '從裝置匯入 GPX',
              onPressed: () => _uploadGpxFile(context),
            ),
        ],
      ),
      body: BlocConsumer<GpxLibraryBloc, GpxLibraryState>(
        listener: (context, state) {
          // 監聽各種狀態並顯示 SnackBar
          if (state.status == GpxLibraryStatus.error && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red),
            );
          } else if (state.status == GpxLibraryStatus.success && state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.successMessage!), backgroundColor: Colors.green),
            );
          } else if (state.status == GpxLibraryStatus.idle) {
            // 可選：如果需要，可以為取消操作提供反饋
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(content: Text('操作已取消'), backgroundColor: Colors.grey),
            // );
          }
        },
        builder: (context, state) {
          // 根據 BLoC 的狀態顯示不同的 UI
          switch (state.status) {
            case GpxLibraryStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case GpxLibraryStatus.empty:
              return const Center(
                child: Text('您的地圖庫是空的.\n點擊右上角的圖示來匯入一個 GPX 檔案。', textAlign: TextAlign.center),
              );
            case GpxLibraryStatus.error:
              return Center(
                child: Text('發生錯誤: ${state.errorMessage ?? "未知錯誤"}'),
              );
            case GpxLibraryStatus.loaded:
              return _buildGpxFileList(context, state.files);
            default:
              return const Center(child: Text('請稍候...'));
          }
        },
      ),
    );
  }

  /// 建立 GPX 檔案列表的 ListView
  Widget _buildGpxFileList(BuildContext context, List<GpxLibraryItem> files) {
    return ListView.builder(
      itemCount: files.length,
      itemBuilder: (context, index) {
        final item = files[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: const Icon(Icons.map_outlined, color: Colors.deepPurple),
            title: Text(item.displayName),
            subtitle: Text('修改日期: ${DateFormat('yyyy-MM-dd HH:mm').format(item.modifiedDate)}'),
            trailing: isSelectionMode
                ? null
                : _buildItemActions(context, item),
            onTap: () async {
              if (isSelectionMode) {
                // 在選擇模式下，返回檔案路徑
                Navigator.of(context).pop(item.filePath);
              } else {
                // 在一般模式下，讀取檔案內容並導航到規劃頁面
                try {
                  final gpxContent = await File(item.filePath).readAsString();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (blocContext) => GpxPlanningBloc(
                          gpxLibraryBloc: context.read<GpxLibraryBloc>(),
                        )..add(LoadGpxRequested(gpxRawXml: gpxContent)),
                        child: const GpxPlanningScreen(),
                      ),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('讀取檔案失敗: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
          ),
        );
      },
    );
  }

  /// 建立列表項目的操作按鈕 (下載和刪除)
  Widget _buildItemActions(BuildContext context, GpxLibraryItem item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.download_for_offline_outlined),
          tooltip: '匯出至下載資料夾',
          onPressed: () {
            context.read<GpxLibraryBloc>().add(FileDownloaded(filePath: item.filePath));
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          tooltip: '刪除檔案',
          onPressed: () => _showDeleteConfirmationDialog(context, item),
        ),
      ],
    );
  }

  /// 顯示刪除確認對話框
  void _showDeleteConfirmationDialog(BuildContext context, GpxLibraryItem item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('刪除軌跡'),
        content: Text('您確定要刪除 "${item.displayName}" 嗎？\n此操作無法復原。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              context.read<GpxLibraryBloc>().add(FileDeleted(filePath: item.filePath));
              Navigator.of(dialogContext).pop();
            },
            child: const Text('刪除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}