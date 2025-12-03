import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mountain_hiking_app/generated/app_localizations.dart';
import 'package:mountain_hiking_app/src/business_logic/gpx_library/gpx_library_bloc.dart';
import 'package:mountain_hiking_app/src/business_logic/gpx_planning/gpx_planning_bloc.dart';
import 'package:mountain_hiking_app/src/config/feature_flags.dart';
import 'package:mountain_hiking_app/src/presentation/screens/auth_screen.dart';
import 'package:mountain_hiking_app/src/presentation/screens/equipment_checklist_screen.dart';
import 'package:mountain_hiking_app/src/presentation/screens/gpx_library_screen.dart';
import 'package:mountain_hiking_app/src/presentation/screens/gpx_merge_screen.dart';
import 'package:mountain_hiking_app/src/presentation/screens/gpx_planning/gpx_planning_screen.dart';
import 'package:mountain_hiking_app/src/presentation/screens/home_screen.dart';
import 'package:mountain_hiking_app/src/presentation/screens/info_screen.dart';
import 'package:mountain_hiking_app/src/presentation/screens/route_evaluation_screen.dart';
import 'package:mountain_hiking_app/src/presentation/screens/social_screen.dart';
import 'package:mountain_hiking_app/src/presentation/screens/tracking_screen.dart';

class AppSpeedDial extends StatelessWidget {
  const AppSpeedDial({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SpeedDial(
      icon: Icons.menu,
      activeIcon: Icons.close,
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      activeBackgroundColor: Colors.deepPurpleAccent,
      activeForegroundColor: Colors.white,
      buttonSize: const Size(56.0, 56.0),
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      elevation: 8.0,
      shape: const CircleBorder(),
      children: [
        SpeedDialChild(
          child: const Icon(Icons.home),
          backgroundColor: Colors.red,
          label: l10n.homeScreenTitle,
          labelStyle: const TextStyle(fontSize: 18.0, color: Colors.black),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen())),
        ),
        SpeedDialChild(
          child: const Icon(Icons.info),
          backgroundColor: Colors.blue,
          label: l10n.infoScreenTitle,
          labelStyle: const TextStyle(fontSize: 18.0, color: Colors.black),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InfoScreen())),
        ),
        SpeedDialChild(
          child: const Icon(Icons.map),
          backgroundColor: Colors.green,
          label: l10n.gpxPlanningScreenTitle,
          labelStyle: const TextStyle(fontSize: 18.0, color: Colors.black),
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => GpxPlanningBloc(gpxLibraryBloc: context.read<GpxLibraryBloc>()),
              child: const GpxPlanningScreen(),
            ),
          )),
        ),
        SpeedDialChild(
          child: const Icon(Icons.merge_type),
          backgroundColor: Colors.yellow,
          label: l10n.gpxMergeScreenTitle,
          labelStyle: const TextStyle(fontSize: 18.0, color: Colors.black),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GpxMergeScreen())),
        ),
        SpeedDialChild(
          child: const Icon(Icons.assessment),
          backgroundColor: Colors.orange,
          label: l10n.routeEstimationScreenTitle,
          labelStyle: const TextStyle(fontSize: 18.0, color: Colors.black),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RouteEvaluationScreen())),
        ),
        SpeedDialChild(
          child: const Icon(Icons.checklist),
          backgroundColor: Colors.purple,
          label: l10n.equipmentChecklistScreenTitle,
          labelStyle: const TextStyle(fontSize: 18.0, color: Colors.black),
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => const EquipmentChecklistScreen(),
          )),
        ),
        SpeedDialChild(
          child: const Icon(Icons.storage),
          backgroundColor: Colors.cyan,
          label: l10n.gpxLibraryScreenTitle,
          labelStyle: const TextStyle(fontSize: 18.0, color: Colors.black),
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => const GpxLibraryScreen(),
          )),
        ),
        // FIX: Use feature flags to conditionally show/hide these buttons.
        if (FeatureFlags.isLoginEnabled)
          SpeedDialChild(
            child: const Icon(Icons.person),
            backgroundColor: Colors.brown,
            label: l10n.authScreenTitle,
            labelStyle: const TextStyle(fontSize: 18.0, color: Colors.black),
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => const AuthScreen(),
            )),
          ),
        if (FeatureFlags.isSocialFeatureEnabled)
          SpeedDialChild(
            child: const Icon(Icons.group),
            backgroundColor: Colors.pink,
            label: l10n.socialFeedTitle,
            labelStyle: const TextStyle(fontSize: 18.0, color: Colors.black),
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => const SocialScreen(),
            )),
          ),
        SpeedDialChild(
          child: const Icon(Icons.track_changes),
          backgroundColor: Colors.teal,
          label: l10n.trackingFeatureTitle,
          labelStyle: const TextStyle(fontSize: 18.0, color: Colors.black),
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => const TrackingScreen(),
          )),
        ),
      ],
    );
  }
}