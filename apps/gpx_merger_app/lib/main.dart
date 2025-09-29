import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gpx_core/gpx_core.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'info_screen.dart'; // 假設這個檔案存在

void main() {
  // 建立 Repository 實例
  final gpxRepository = GpxRepository();

  runApp(
    // 在最上層提供 Repository
    RepositoryProvider.value(
      value: gpxRepository,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPX 檔案合併工具',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // 在這裡提供 BLoC
      home: BlocProvider(
        create: (context) => GpxBloc(
          gpxRepository: RepositoryProvider.of<GpxRepository>(context),
        ),
        child: const GpxMergerScreen(),
      ),
    );
  }
}

class GpxMergerScreen extends StatelessWidget {
  const GpxMergerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GpxBloc, GpxState>(
      // Listener 只負責執行一次性的動作，如顯示 Dialog, SnackBar, 導航等
      listener: (context, state) {
        if (state.status == GpxStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.replaceFirst('Exception: ', '')),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state.status == GpxStatus.success) {
          _showSuccessDialog(context, state.savedFilePath);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('GPX 檔案合併工具'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          // Builder 負責根據狀態不斷重建 UI
          child: BlocBuilder<GpxBloc, GpxState>(
            builder: (context, state) {
              final bool isProcessing = state.status == GpxStatus.loading;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInfoCard(),
                  const SizedBox(height: 20),
                  for (int i = 0; i < GpxBloc.maxFiles; i++) ...[
                    _buildFilePickerCard(context, state, i),
                    if (i < GpxBloc.maxFiles - 1) const SizedBox(height: 12),
                  ],
                  const Spacer(),
                  _buildMergeButton(context, state, isProcessing),
                ],
              );
            },
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(context),
      ),
    );
  }

  // 將各部分 UI 拆分成小方法，增加可讀性
  Widget _buildInfoCard() {
    return const Card(
      color: Colors.blue,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.info_outline, color: Colors.white, size: 32),
            SizedBox(height: 8),
            Text('GPX 檔案合併工具', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('• 選擇最多 2 個 GPX 檔案\n• 每個檔案不超過 500KB\n• 合併後的檔案將按座標排序', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFilePickerCard(BuildContext context, GpxState state, int i) {
    final bool fileExists = i < state.files.length;
    final PlatformFile? file = fileExists ? state.files[i] : null;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('GPX 檔案 ${i + 1}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (fileExists && file != null)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          const Icon(Icons.map, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(child: Text(file.name, overflow: TextOverflow.ellipsis)),
                          Text('${(file.size / 1024).toStringAsFixed(1)} KB', style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => context.read<GpxBloc>().add(GpxFileRemoved(index: i)),
                  ),
                ],
              )
            else
              ElevatedButton.icon(
                onPressed: state.files.length >= GpxBloc.maxFiles
                    ? null
                    : () => context.read<GpxBloc>().add(GpxFilePickRequested(index: i)),
                icon: const Icon(Icons.upload_file),
                label: const Text('選擇檔案'),
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMergeButton(BuildContext context, GpxState state, bool isProcessing) {
    return ElevatedButton(
      onPressed: isProcessing || state.files.isEmpty
          ? null
          : () => context.read<GpxBloc>().add(GpxMergeStarted()),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      child: isProcessing
          ? const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                SizedBox(width: 12),
                Text('處理中...'),
              ],
            )
          : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.merge),
                SizedBox(width: 8),
                Text('合併檔案', style: TextStyle(fontSize: 18)),
              ],
            ),
    );
  }

  // 原本的 Dialog 方法，現在是靜態的或放在外部，因為它不依賴 widget 內部狀態
  void _showSuccessDialog(BuildContext context, String filePath) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Row(children: [Icon(Icons.check_circle, color: Colors.green, size: 32), SizedBox(width: 8), Text('合併成功！')]),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('檔案已成功合併並儲存。', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('儲存位置：', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(filePath, style: const TextStyle(fontSize: 12)),
                ]),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await OpenFile.open(filePath);
              },
              child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.folder_open, size: 18), SizedBox(width: 4), Text('開啟檔案')]),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await Share.shareXFiles([XFile(filePath)], text: '分享合併後的 GPX 檔案');
              },
              child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.share, size: 18), SizedBox(width: 4), Text('分享')]),
            ),
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('關閉')),
          ],
        );
      },
    );
  }
  
  Widget _buildFloatingActionButton(BuildContext context) {
    return SpeedDial(
      icon: Icons.menu,
      activeIcon: Icons.close,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.merge_type),
          label: '合併工具',
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          onTap: () {},
        ),
        SpeedDialChild(
          child: const Icon(Icons.info_outline),
          label: '建議資訊',
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const InfoScreen())),
        ),
      ],
    );
  }
}