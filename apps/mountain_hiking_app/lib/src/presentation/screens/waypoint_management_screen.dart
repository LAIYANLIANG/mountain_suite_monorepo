
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mountain_hiking_app/src/business_logic/gpx_planning/gpx_planning_bloc.dart';
import 'package:mountain_hiking_app/src/data/models/gpx_planning_model.dart';

/// V1.0 - 航點管理畫面 (重構後)
///
/// 提供一個介面讓使用者可以對 GPX 檔案中的航點 (Waypoints) 進行管理，
/// 包含編輯名稱/描述、透過拖曳重新排序、以及刪除。
/// FIX: 改為 StatelessWidget，所有狀態都由 GpxPlanningBloc 提供。
class WaypointManagementScreen extends StatelessWidget {
  const WaypointManagementScreen({super.key});

  /// 顯示一個對話框來編輯指定航點的名稱和描述。
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
                // FIX: 建立一個更新後的 Wpt 物件並發送事件
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('管理與排序航點'),
      ),
      // FIX: 使用 BlocBuilder 來根據 BLoC 的最新狀態建立 UI
      body: BlocBuilder<GpxPlanningBloc, GpxPlanningState>(
        builder: (context, state) {
          // 如果沒有 gpxData，則不顯示任何內容
          if (state.gpxData == null) {
            return const Center(child: Text('沒有可用的航點資料'));
          }

          final waypoints = state.gpxData!.wpts;

          // ReorderableListView 是一個可拖曳排序的列表 Widget。
          return ReorderableListView.builder(
            itemCount: waypoints.length,
            itemBuilder: (context, index) {
              final waypoint = waypoints[index];
              return ListTile(
                // Key 對於 ReorderableListView 的正確運作至關重要。
                key: ValueKey('${waypoint.name}_$index'),
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(waypoint.name ?? '未命名航點'),
                subtitle: Text(waypoint.desc ?? '沒有描述'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: '編輯',
                      onPressed: () => _showEditDialog(context, waypoint, index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      tooltip: '刪除',
                      onPressed: () {
                        // FIX: 發送帶有索引的刪除事件
                        context.read<GpxPlanningBloc>().add(WaypointDeleted(index: index));
                      },
                    ),
                  ],
                ),
              );
            },
            // 當使用者完成拖曳排序時觸發的回呼函式。
            onReorder: (oldIndex, newIndex) {
              // ReorderableListView 的 newIndex 在向下拖曳時需要做調整。
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              // FIX: 直接發送帶有新舊索引的事件給 BLoC
              context.read<GpxPlanningBloc>().add(WaypointsReordered(oldIndex: oldIndex, newIndex: newIndex));
            },
          );
        },
      ),
    );
  }
}
