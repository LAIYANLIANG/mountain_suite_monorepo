
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

abstract class TrackRecordingEvent extends Equatable {
  const TrackRecordingEvent();

  @override
  List<Object> get props => [];
}

class RequestInitialLocation extends TrackRecordingEvent {}

class StartTracking extends TrackRecordingEvent {}

class PauseTracking extends TrackRecordingEvent {}

class StopTracking extends TrackRecordingEvent {}

class SaveTrack extends TrackRecordingEvent {
  final String fileName;

  const SaveTrack(this.fileName);

  @override
  List<Object> get props => [fileName];
}

class UpdateTracking extends TrackRecordingEvent {
  final Position position;

  const UpdateTracking(this.position);

  @override
  List<Object> get props => [position];
}
