import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mountain_hiking_app/src/business_logic/gpx_library/gpx_library_bloc.dart';
import 'package:mountain_hiking_app/src/business_logic/gpx_merge/gpx_merge_bloc.dart';
import 'package:mountain_hiking_app/src/business_logic/gpx_planning/gpx_planning_bloc.dart';
import 'package:mountain_hiking_app/src/presentation/screens/gpx_planning/gpx_planning_screen.dart';
import 'package:mountain_hiking_app/src/presentation/widgets/app_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:mountain_hiking_app/generated/app_localizations.dart';

class GpxMergeScreen extends StatelessWidget {
  final List<String>? initialFilePaths;

  const GpxMergeScreen({super.key, this.initialFilePaths});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = GpxMergeBloc();
        if (initialFilePaths != null && initialFilePaths!.isNotEmpty) {
          bloc.add(LoadInitialFiles(initialFilePaths!));
        }
        return bloc;
      },
      child: const _GpxMergeView(),
    );
  }
}

class _GpxMergeView extends StatelessWidget {
  const _GpxMergeView();

  String _getErrorMessage(BuildContext context, GpxMergeError errorState) {
    final l10n = AppLocalizations.of(context)!;
    switch (errorState.errorCode) {
      case 'too_many_files':
        return l10n.merge_errorTooManyFiles;
      case 'too_few_files':
        return l10n.merge_errorTooFewFiles;
      case 'not_gpx_file':
        return l10n.merge_errorNotGpx(errorState.details!['fileName']);
      case 'file_too_large':
        return l10n.merge_errorFileTooLarge(errorState.details!['fileName']);
      default:
        return l10n.merge_errorGeneric(errorState.message);
    }
  }

  void _showFilenameDialog(BuildContext context, Uint8List mergedBytes) {
    final mainScreenContext = context;
    final l10n = AppLocalizations.of(context)!;
    final fileNameController = TextEditingController(text: 'Merged_GPX_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}');
    bool isFileNameValid = true;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(l10n.trackNameLabel),
            content: TextField(
              controller: fileNameController,
              decoration: InputDecoration(
                labelText: l10n.trackNameLabel,
                errorText: isFileNameValid ? null : '檔案名稱不可為空白',
              ),
              onChanged: (value) {
                setState(() {
                  isFileNameValid = value.trim().isNotEmpty;
                });
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: isFileNameValid
                    ? () async {
                        final fileName = fileNameController.text.trim();
                        if (fileName.isEmpty) {
                          setState(() {
                            isFileNameValid = false;
                          });
                          return;
                        }
                        try {
                          mainScreenContext.read<GpxLibraryBloc>().add(FileAdded(
                                fileName: fileName,
                                gpxContent: utf8.decode(mergedBytes, allowMalformed: true),
                              ));
                          Navigator.of(dialogContext).pop();
                          ScaffoldMessenger.of(mainScreenContext).showSnackBar(
                            SnackBar(content: Text('檔案 "$fileName.gpx" 已儲存至地圖庫'), backgroundColor: Colors.green),
                          );
                          showDialog(
                            context: mainScreenContext,
                            builder: (innerDialogContext) => AlertDialog(
                              title: Text(l10n.merge_successDialogTitle),
                              content: Text(l10n.merge_successDialogContent),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(innerDialogContext).pop(),
                                  child: Text(l10n.merge_stayHereButton),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(innerDialogContext).pop();
                                    Navigator.of(mainScreenContext).push(
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider(
                                          create: (context) => GpxPlanningBloc(
                                            gpxLibraryBloc: context.read<GpxLibraryBloc>(),
                                          )..add(LoadGpxRequested(gpxRawXml: utf8.decode(mergedBytes, allowMalformed: true))),
                                          child: const GpxPlanningScreen(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(l10n.merge_goToPlanningButton),
                                ),
                              ],
                            ),
                          );
                        } catch (e) {
                          Navigator.of(dialogContext).pop();
                          ScaffoldMessenger.of(mainScreenContext).showSnackBar(
                            SnackBar(content: Text(l10n.merge_errorGeneric(e.toString())), backgroundColor: Colors.red),
                          );
                        }
                      }
                    : null,
                child: Text(l10n.save),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<GpxMergeBloc, GpxMergeState>(
      listener: (context, state) {
        if (state is GpxMergeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_getErrorMessage(context, state)), backgroundColor: Colors.red),
          );
        } else if (state is GpxMergeSuccess) {
          _showFilenameDialog(context, state.mergedGpxBytes);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.gpxMergeScreenTitle),
        ),
        floatingActionButton: const AppSpeedDial(),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BlocBuilder<GpxMergeBloc, GpxMergeState>(
                builder: (context, state) {
                  final bool canAddMoreFiles = !(state is GpxMergeLoaded && state.files.length >= 3);
                  return ElevatedButton.icon(
                    icon: const Icon(Icons.file_upload_outlined),
                    label: Text(l10n.merge_selectButton),
                    onPressed: canAddMoreFiles
                        ? () => context.read<GpxMergeBloc>().add(AddFilesClicked())
                        : null,
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(l10n.merge_selectedFilesTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: BlocBuilder<GpxMergeBloc, GpxMergeState>(
                  builder: (context, state) {
                    if (state is GpxMergeLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is GpxMergeLoaded) {
                      if (state.files.isEmpty) {
                        return Center(child: Text(l10n.merge_noFilesSelected));
                      }
                      return ListView.builder(
                        itemCount: state.files.length,
                        itemBuilder: (context, index) {
                          final file = state.files[index];
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.map_outlined),
                              title: Text(file.name),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () => context.read<GpxMergeBloc>().add(DeleteFile(file)),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return Center(child: Text(l10n.merge_noFilesSelected));
                  },
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<GpxMergeBloc, GpxMergeState>(
                builder: (context, state) {
                  bool isLoading = state is GpxMergeLoading;
                  int fileCount = state is GpxMergeLoaded ? state.files.length : 0;

                  return ElevatedButton.icon(
                    icon: isLoading ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(color: Colors.white)) : const Icon(Icons.merge_type),
                    label: Text(l10n.merge_mergeButton),
                    // Gemini: 修改 onPressed 邏輯，先彈出對話框讓使用者命名。
                    onPressed: fileCount < 2 || isLoading
                        ? null
                        : () => _showMergeNamingDialog(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Gemini: 新增方法，用於顯示合併前的命名對話框。
  void _showMergeNamingDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fileNameController = TextEditingController(
      text: 'Merged_GPX_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}',
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.trackNameLabel),
          content: TextField(
            controller: fileNameController,
            decoration: InputDecoration(labelText: l10n.trackNameLabel),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                final trackName = fileNameController.text.trim();
                if (trackName.isNotEmpty) {
                  context.read<GpxMergeBloc>().add(MergeFilesClicked(trackName: trackName));
                  Navigator.of(dialogContext).pop();
                }
              },
              child: Text(l10n.merge_mergeButton),
            ),
          ],
        );
      },
    );
  }
}
