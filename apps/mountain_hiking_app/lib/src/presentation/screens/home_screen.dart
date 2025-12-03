import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mountain_hiking_app/src/config/feature_flags.dart';
import 'package:mountain_hiking_app/src/presentation/screens/gpx_planning/gpx_planning_screen.dart';
import 'package:mountain_hiking_app/src/presentation/screens/tracking_screen.dart'; // Import TrackRecordingScreen
// Import GpxLibraryScreen
// Import FilePicker
import 'package:mountain_hiking_app/src/presentation/screens/auth_screen.dart';
import 'package:mountain_hiking_app/src/presentation/widgets/main_scaffold.dart';
import 'package:mountain_hiking_app/generated/app_localizations.dart';
import 'package:mountain_hiking_app/src/business_logic/auth/auth_bloc.dart'; // Import AuthBloc
// Import AuthState
import 'package:mountain_hiking_app/src/business_logic/gpx_library/gpx_library_bloc.dart';
import 'package:mountain_hiking_app/src/business_logic/gpx_planning/gpx_planning_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.appTitle ?? 'Hiking App'),
        actions: [
          // Add a button to open app settings for permissions
          IconButton(
            icon: const Icon(Icons.settings_applications),
            tooltip: '權限設定',
            onPressed: () => openAppSettings(),
          ),
          if (FeatureFlags.isLoginEnabled)
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  return IconButton(
                    icon: const Icon(Icons.logout),
                    tooltip: '登出',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('確認登出'),
                          content: const Text('您確定要登出嗎？'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(dialogContext).pop(),
                              child: const Text('取消'),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<AuthBloc>().add(AuthLoggedOut());
                                Navigator.of(dialogContext).pop();
                              },
                              child: const Text('登出'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                if (state is AuthLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3.0)
                    ),
                  );
                }
                return IconButton(
                  icon: const Icon(Icons.person_outline),
                  tooltip: '登入/註冊',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const AuthScreen()),
                    );
                  },
                );
              },
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroSection(context),
                  // [MVP Refactor] Hide sections for future release.
                  // const SizedBox(height: 24),
                  // _buildSectionTitle(context, '🔥 本週熱門'),
                  // const SizedBox(height: 16),
                  // _buildPopularRoutes(constraints),
                  // const SizedBox(height: 24),
                  // _buildSectionTitle(context, '💡 登山小知識'),
                  // const SizedBox(height: 16),
                  // _buildInfoCard(
                  //   context,
                  //   icon: Icons.terrain,
                  //   title: '如何正確使用登山杖？',
                  // ),
                  // const SizedBox(height: 12),
                  // _buildInfoCard(
                  //   context,
                  //   icon: Icons.camera_alt_outlined,
                  //   title: '社群分享：阿里山眠月線絕美秘境',
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
          image: AssetImage('assets/icon/app_icon.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: Theme.of(context).textTheme.titleLarge,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (context) => GpxPlanningBloc(
                        gpxLibraryBloc: context.read<GpxLibraryBloc>(),
                      ),
                      child: const GpxPlanningScreen(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add_location_alt_outlined),
              label: Text(AppLocalizations.of(context)!.home_startPlanning),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: Theme.of(context).textTheme.titleLarge,
              ),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TrackingScreen())),
              icon: const Icon(Icons.play_circle_outline),
              label: Text(AppLocalizations.of(context)!.trackingFeatureTitle),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildPopularRoutes(BoxConstraints constraints) {
    bool isWide = constraints.maxWidth > 600;
    
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildRouteCard('陽明山', '輕鬆一日'),
          _buildRouteCard('玉山主峰', '百岳挑戰'),
          _buildRouteCard('合歡北峰', '新手百岳'),
          _buildRouteCard('加里山', '中級山'),
        ],
      ),
    );
  }

  Widget _buildRouteCard(String title, String subtitle) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              color: Colors.grey[400],
              child: const Center(child: Icon(Icons.image, color: Colors.white, size: 40)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required IconData icon, required String title}) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}