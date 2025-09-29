
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackRecordingState extends Equatable {
  final bool isRecording;
  final bool isPaused;
  final Set<Polyline> polylines;
  final LatLng? currentLocation;
  final String? error;
  final String? successMessage;

  const TrackRecordingState({
    this.isRecording = false,
    this.isPaused = false,
    this.polylines = const {},
    this.currentLocation,
    this.error,
    this.successMessage,
  });

  TrackRecordingState copyWith({
    bool? isRecording,
    bool? isPaused,
    Set<Polyline>? polylines,
    LatLng? currentLocation,
    String? error,
    String? successMessage,
  }) {
    return TrackRecordingState(
      isRecording: isRecording ?? this.isRecording,
      isPaused: isPaused ?? this.isPaused,
      polylines: polylines ?? this.polylines,
      currentLocation: currentLocation ?? this.currentLocation,
      error: error,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [isRecording, isPaused, polylines, currentLocation, error, successMessage];
}
