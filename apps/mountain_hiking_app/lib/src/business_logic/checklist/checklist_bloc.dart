
// Updated by Gemini on 2025-08-31. Replaced with reference file to fix issues.
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mountain_hiking_app/src/data/models/equipment_model.dart';
import 'package:mountain_hiking_app/src/data/repositories/equipment_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'checklist_event.dart';
part 'checklist_state.dart';

class ChecklistBloc extends Bloc<ChecklistEvent, ChecklistState> {
  final EquipmentRepository _equipmentRepository;
  late SharedPreferences _prefs;

  ChecklistBloc(this._equipmentRepository) : super(ChecklistInitial()) {
    on<LoadChecklist>(_onLoadChecklist);
    on<ToggleItemChecked>(_onToggleItemChecked);
    on<UpdateItemQuantity>(_onUpdateItemQuantity);
    on<UpdateItemWeight>(_onUpdateItemWeight);
  }

  Future<void> _onLoadChecklist(LoadChecklist event, Emitter<ChecklistState> emit) async {
    emit(ChecklistLoading());
    try {
      _prefs = await SharedPreferences.getInstance();
      final checklistData = _equipmentRepository.getDefaultChecklist();

      // Load saved states from SharedPreferences
      checklistData.forEach((mainCategoryKey, mainCategory) {
        mainCategory.subCategories.forEach((subCategoryKey, subCategory) {
          for (var item in subCategory.items) {
            item.isChecked = _prefs.getBool(_keyForItem(item.id, 'checked')) ?? item.isChecked;
            item.quantity = _prefs.getInt(_keyForItem(item.id, 'quantity')) ?? item.quantity;
            item.weight = _prefs.getDouble(_keyForItem(item.id, 'weight')) ?? item.weight;
          }
        });
      });

      final totalWeights = _calculateAllTotalWeights(checklistData);
      emit(ChecklistLoaded(checklistData: checklistData, totalWeights: totalWeights));
    } catch (e) {
      emit(ChecklistError(e.toString()));
    }
  }

  Future<void> _onToggleItemChecked(ToggleItemChecked event, Emitter<ChecklistState> emit) async {
    if (state is ChecklistLoaded) {
      final currentState = state as ChecklistLoaded;
      final updatedData = _updateItemState(currentState.checklistData, event.itemId, (item) {
        item.isChecked = event.isChecked;
        return item;
      });

      await _prefs.setBool(_keyForItem(event.itemId, 'checked'), event.isChecked);
      final totalWeights = _calculateAllTotalWeights(updatedData);
      emit(currentState.copyWith(checklistData: updatedData, totalWeights: totalWeights));
    }
  }

  Future<void> _onUpdateItemQuantity(UpdateItemQuantity event, Emitter<ChecklistState> emit) async {
    if (state is ChecklistLoaded) {
      final currentState = state as ChecklistLoaded;
      final updatedData = _updateItemState(currentState.checklistData, event.itemId, (item) {
        item.quantity = event.quantity;
        return item;
      });

      await _prefs.setInt(_keyForItem(event.itemId, 'quantity'), event.quantity);
      final totalWeights = _calculateAllTotalWeights(updatedData);
      emit(currentState.copyWith(checklistData: updatedData, totalWeights: totalWeights));
    }
  }

  Future<void> _onUpdateItemWeight(UpdateItemWeight event, Emitter<ChecklistState> emit) async {
    if (state is ChecklistLoaded) {
      final currentState = state as ChecklistLoaded;
      final updatedData = _updateItemState(currentState.checklistData, event.itemId, (item) {
        item.weight = event.weight;
        return item;
      });

      await _prefs.setDouble(_keyForItem(event.itemId, 'weight'), event.weight);
      final totalWeights = _calculateAllTotalWeights(updatedData);
      emit(currentState.copyWith(checklistData: updatedData, totalWeights: totalWeights));
    }
  }

  // Helper to generate a unique key for SharedPreferences
  String _keyForItem(String itemId, String attribute) => 'checklist_${itemId}_$attribute';

  // Helper to update an item in the nested map structure
  Map<String, ChecklistMainCategory> _updateItemState(
    Map<String, ChecklistMainCategory> originalData,
    String itemId,
    ChecklistItem Function(ChecklistItem) updateFn,
  ) {
    final newData = Map<String, ChecklistMainCategory>.from(originalData);
    for (var mainCategory in newData.values) {
      for (var subCategory in mainCategory.subCategories.values) {
        final itemIndex = subCategory.items.indexWhere((item) => item.id == itemId);
        if (itemIndex != -1) {
          subCategory.items[itemIndex] = updateFn(subCategory.items[itemIndex]);
          return newData; // Item found and updated, exit
        }
      }
    }
    return newData;
  }

  // Helper to calculate total weights for all main categories
  Map<String, double> _calculateAllTotalWeights(Map<String, ChecklistMainCategory> data) {
    final Map<String, double> weights = {};
    data.forEach((mainCategoryKey, mainCategory) {
      double total = 0;
      mainCategory.subCategories.forEach((subCategoryKey, subCategory) {
        for (var item in subCategory.items) {
          if (item.isChecked) {
            total += item.weight * item.quantity;
          }
        }
      });
      weights[mainCategoryKey] = total;
    });
    return weights;
  }
}
