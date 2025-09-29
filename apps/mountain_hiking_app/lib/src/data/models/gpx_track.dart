import 'package:cloud_firestore/cloud_firestore.dart';

class GpxTrack {
  final String id;
  final String name;
  final String storagePath; // Path in Firebase Storage
  final String? downloadUrl; // Optional: To display thumbnail/link
  final DateTime date;
  final double distanceKm;
  final double elevationGainMeters;

  GpxTrack({
    required this.id,
    required this.name,
    required this.storagePath,
    this.downloadUrl,
    required this.date,
    required this.distanceKm,
    required this.elevationGainMeters,
  });

  // Helper for creating a GpxTrack from a Firestore document
  factory GpxTrack.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return GpxTrack(
      id: doc.id,
      name: data['name'] ?? '',
      storagePath: data['storagePath'] ?? '',
      downloadUrl: data['downloadUrl'],
      // Handle Firestore Timestamp conversion
      date: (data['date'] as Timestamp).toDate(),
      distanceKm: (data['distanceKm'] as num?)?.toDouble() ?? 0.0,
      elevationGainMeters: (data['elevationGainMeters'] as num?)?.toDouble() ?? 0.0,
    );
  }

  factory GpxTrack.fromMap(Map<String, dynamic> map) {
    return GpxTrack(
      id: map['id'] as String,
      name: map['name'] as String,
      storagePath: map['storagePath'] as String,
      distanceKm: map['distanceKm'] as double,
      elevationGainMeters: map['elevationGainMeters'] as double,
      date: DateTime.parse(map['date'] as String),
      downloadUrl: map['downloadUrl'] as String?, // [FIX] Corrected to downloadUrl
    );
  }

  // Helper for converting a GpxTrack to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'storagePath': storagePath,
      'downloadUrl': downloadUrl,
      // Convert DateTime to Firestore Timestamp
      'date': Timestamp.fromDate(date),
      'distanceKm': distanceKm,
      'elevationGainMeters': elevationGainMeters,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'storagePath': storagePath,
      'distanceKm': distanceKm,
      'elevationGainMeters': elevationGainMeters,
      'date': date.toIso8601String(),
      'downloadUrl': downloadUrl, // [FIX] Corrected to downloadUrl
    };
  }
}
