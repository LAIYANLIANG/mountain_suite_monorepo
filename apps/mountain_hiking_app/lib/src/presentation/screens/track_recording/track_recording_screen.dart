
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mountain_hiking_app/src/business_logic/track_recording/track_recording_bloc.dart';
import 'package:mountain_hiking_app/src/business_logic/track_recording/track_recording_event.dart';
import 'package:mountain_hiking_app/src/business_logic/track_recording/track_recording_state.dart';

class TrackRecordingScreen extends StatefulWidget {
  const TrackRecordingScreen({super.key});

  @override
  State<TrackRecordingScreen> createState() => _TrackRecordingScreenState();
}

class _TrackRecordingScreenState extends State<TrackRecordingScreen> {
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    // Trigger an event to get the initial location
    context.read<TrackRecordingBloc>().add(RequestInitialLocation());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('地圖與軌跡記錄'),
      ),
      body: BlocConsumer<TrackRecordingBloc, TrackRecordingState>(
        listener: (context, state) {
          if (state.currentLocation != null) {
            _mapController?.animateCamera(
              CameraUpdate.newLatLng(state.currentLocation!),
            );
          }
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
            );
          }
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.successMessage!), backgroundColor: Colors.green),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(25.0340, 121.5645), // Default to Taipei 101
                  zoom: 14,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                polylines: state.polylines,
              ),
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: _buildControlButton(state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildControlButton(TrackRecordingState state) {
    if (state.isRecording) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              if (state.isPaused) {
                // This is a simplification. A 'Resume' event would be better.
                context.read<TrackRecordingBloc>().add(StartTracking());
              } else {
                context.read<TrackRecordingBloc>().add(PauseTracking());
              }
            },
            label: Text(state.isPaused ? '繼續' : '暫停'),
            icon: Icon(state.isPaused ? Icons.play_arrow : Icons.pause),
            backgroundColor: Colors.orange,
          ),
          FloatingActionButton.extended(
            onPressed: () {
              _showSaveDialog();
            },
            label: const Text('停止'),
            icon: const Icon(Icons.stop),
            backgroundColor: Colors.red,
          ),
        ],
      );
    } else {
      return FloatingActionButton.extended(
        onPressed: () {
          context.read<TrackRecordingBloc>().add(StartTracking());
        },
        label: const Text('開始記錄'),
        icon: const Icon(Icons.play_arrow),
      );
    }
  }

  Future<void> _showSaveDialog() async {
    final TextEditingController textController = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('儲存軌跡'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: "請輸入檔案名稱"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('儲存'),
              onPressed: () {
                final fileName = textController.text;
                if (fileName.isNotEmpty) {
                  context.read<TrackRecordingBloc>().add(SaveTrack(fileName));
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
