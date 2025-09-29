import 'package:flutter/material.dart';
import 'package:mountain_hiking_app/src/presentation/widgets/app_speed_dial.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  // Data for the information links, structured for easy maintenance.
  static const List<Map<String, String>> _toolApps = [
    {
      'title': 'OruxMaps',
      'subtitle': '強大的離線地圖與軌跡記錄工具',
      'url': 'https://www.oruxmaps.com/',
    },
    // Add other apps here
  ];

  static const List<Map<String, String>> _officialSites = [
    {
      'title': '台灣國家公園入園入山線上申請服務網',
      'subtitle': '一站式申請玉山、雪霸、太魯閣等國家公園',
      'url': 'https://npm.cpami.gov.tw/index.aspx',
    },
    {
      'title': '玉山國家公園',
      'subtitle': '官方網站，提供最新公告與園區資訊',
      'url': 'https://www.ysnp.gov.tw/',
    },
    {
      'title': '雪霸國家公園',
      'subtitle': '官方網站，提供最新公告與園區資訊',
      'url': 'https://www.spnp.gov.tw/',
    },
  ];

  static const List<Map<String, String>> _communityResources = [
    {
      'title': '馬克褚工作室',
      'subtitle': '特色：豐富的 GPX 軌跡庫與路線分析',
      'url': 'https://www.markchoo.com.tw/',
    },
    {
      'title': '上河文化',
      'subtitle': '特色：精確的地圖與步程時間參考',
      'url': 'https://www.sunriver.com.tw/',
    },
    {
      'title': '健行筆記',
      'subtitle': '特色：台灣最大的登山健行社群網站',
      'url': 'https://hiking.biji.co/',
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('參考資訊'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
      ),
      // Add the reusable floating action menu
      floatingActionButton: const AppSpeedDial(),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const _InfoCategoryCard(
            title: '必備工具 App',
            icon: Icons.phone_android,
            items: _toolApps,
          ),
          const SizedBox(height: 16),
          const _InfoCategoryCard(
            title: '官方資訊站台',
            icon: Icons.account_balance,
            items: _officialSites,
          ),
          const SizedBox(height: 16),
          const _InfoCategoryCard(
            title: '登山社群與資源',
            icon: Icons.groups,
            items: _communityResources,
          ),
          const SizedBox(height: 24),
          // Gemini: 新增作者與感謝資訊
          Text(
            '本app由作者一人完成，包含計畫、規格、開發、測試、調整，並感謝屏東正妹-落落依、竹圍帥帥-韓吉、宜蘭男神代表-查理、新店男神-雷比、新莊舞蹈老師神手-小朱，各位好友協助測試。如果有問題歡迎聯絡我（windsong0910@gmail.com）  ps.如果願意請我喝杯咖啡也感謝大家',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// A reusable card widget for a category of information links.
class _InfoCategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Map<String, String>> items;

  const _InfoCategoryCard({
    required this.title,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = Colors.green.shade800;

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(icon, color: iconColor),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ...items.map((item) => _InfoLinkTile(
            title: item['title']!,
            subtitle: item['subtitle']!,
            url: item['url']!,
          )),
        ],
      ),
    );
  }
}

// A reusable list tile for a single information link.
class _InfoLinkTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String url;

  const _InfoLinkTile({
    required this.title,
    required this.subtitle,
    required this.url,
  });

  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // Optionally show a snackbar or dialog if the URL cannot be launched
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('無法開啟連結: $url')),
      // );
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
      trailing: const Icon(Icons.launch, size: 20, color: Colors.grey),
      onTap: _launchUrl,
    );
  }
}
