import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  // 幫助建立可點擊連結的輔助功能
  Widget _buildLink(BuildContext context, String text, String url) {
    return InkWell(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          // 如果無法開啟連結，顯示錯誤訊息
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('無法開啟連結 $url')),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text.rich(
          TextSpan(
            text: text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('建議與參考資訊'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            const Text(
              '建議使用開啟 App 為：',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('OruxMaps, GPX Viewer', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            const Text(
              '如合併路徑較小可使用：',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('健行筆記', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            const Text(
              '其他大神與參考資訊：',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildLink(
              context,
              '馬克褚工作室',
              'https://www.markchoo.com.tw/',
            ),
            _buildLink(
              context,
              '上河文化',
              'https://www.sunriver.com.tw/step2020.htm',
            ),
            _buildLink(context, '獨步山林間', 'https://www.waytogo.cc/user/kenny/'),
            _buildLink(context, '玉山國家公園', 'https://www.ysnp.gov.tw/'),
            _buildLink(context, '雪霸國家公園', 'https://www.spnp.gov.tw/'),
            _buildLink(context, '太魯閣國家公園', 'https://www.taroko.gov.tw/'),
            _buildLink(context, '內政部國家公園署-一站式申請', 'https://hike.taiwan.gov.tw/web_index.aspx')
          ],
        ),
      ),
    );
  }
}