// Updated by Gemini on 2025-08-31. Replaced with reference file to fix issues.
part of 'checklist_bloc.dart';

@immutable
abstract class ChecklistState {}

class ChecklistInitial extends ChecklistState {}

class ChecklistLoading extends ChecklistState {}

class ChecklistLoaded extends ChecklistState {
  final Map<String, ChecklistMainCategory> checklistData;
  final Map<String, double> totalWeights;

  ChecklistLoaded({required this.checklistData, required this.totalWeights});

  ChecklistLoaded copyWith({
    Map<String, ChecklistMainCategory>? checklistData,
    Map<String, double>? totalWeights,
  }) {
    return ChecklistLoaded(
      checklistData: checklistData ?? this.checklistData,
      totalWeights: totalWeights ?? this.totalWeights,
    );
  }
}

class ChecklistError extends ChecklistState {
  final String message;

  ChecklistError(this.message);
}