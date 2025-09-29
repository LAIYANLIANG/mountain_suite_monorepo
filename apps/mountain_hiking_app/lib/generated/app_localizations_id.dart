// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Aplikasi Hiking';

  @override
  String get homeScreenTitle => 'Beranda';

  @override
  String get infoScreenTitle => 'Informasi';

  @override
  String get gpxPlanningScreenTitle => 'Perencanaan Peta GPX';

  @override
  String get gpxMergeScreenTitle => 'Gabungkan GPX';

  @override
  String get routeEstimationScreenTitle => 'Estimasi Rute';

  @override
  String get equipmentChecklistScreenTitle => 'Daftar Periksa Peralatan';

  @override
  String get gpxLibraryScreenTitle => 'Perpustakaan GPX';

  @override
  String get authScreenTitle => 'Manajemen Akun';

  @override
  String get socialFeedTitle => 'Feed Sosial';

  @override
  String get trackingFeatureTitle => 'Perekaman Jejak';

  @override
  String get trackingStoppedMessage => 'Pelacakan dihentikan.';

  @override
  String get startTrackingButton => 'Mulai Pelacakan';

  @override
  String get pauseTrackingButton => 'Jeda';

  @override
  String get stopTrackingButton => 'Hentikan';

  @override
  String get resumeTrackingButton => 'Lanjutkan';

  @override
  String get defaultTrackName => 'Jejak Saya';

  @override
  String get trackNameLabel => 'Nama Jejak';

  @override
  String get saveTrackButton => 'Simpan Jejak';

  @override
  String get startNewTrackButton => 'Mulai Jejak Baru';

  @override
  String get home_startPlanning => 'Mulai Merencanakan Rute Baru';

  @override
  String get checklist_personalGear => 'Peralatan Pribadi';

  @override
  String get checklist_groupGear => 'Peralatan Grup';

  @override
  String get checklist_baseGear => 'Peralatan Dasar';

  @override
  String get checklist_technicalGear => 'Peralatan Teknis/Salju';

  @override
  String get checklist_otherGear => 'Barang Lainnya';

  @override
  String get checklist_totalWeight => 'Berat Total';

  @override
  String get checklist_quantity => 'Jml';

  @override
  String get checklist_weightGrams => 'Berat(g)';

  @override
  String get checklist_snowEssential => 'Penting Musim Salju';

  @override
  String get estimation_routeQixing => 'PP Puncak Utama Gn. Qixing';

  @override
  String get estimation_routeTianmu => 'Jalur Kuno Tianmu';

  @override
  String get estimation_routeYushan => 'Puncak Utama Gn. Yushan';

  @override
  String get estimation_routeHehuan => 'Puncak Utara Gn. Hehuan';

  @override
  String get estimation_yourTimeHint => 'Waktu Anda';

  @override
  String get estimation_minutesUnit => 'menit';

  @override
  String get estimation_breathingLevelQuestion =>
      'Tingkat sesak napas saat naik dari lantai 1 ke 5 dengan kecepatan normal?';

  @override
  String get estimation_breathingLevel1 => '1 - Tidak terasa';

  @override
  String get estimation_breathingLevel3 => '3 - Lelah tapi tidak sesak';

  @override
  String get estimation_breathingLevel5 => '5 - Sangat sesak';

  @override
  String get estimation_inactivityLabel => 'Bulan tidak aktif (mis: 3)';

  @override
  String get estimation_monthsUnit => 'bulan';

  @override
  String get estimation_calculateButton =>
      'Hitung & Simpan Koefisien Kecepatan Saya';

  @override
  String get estimation_resultTitle => 'Koefisien Kecepatan Anda sekitar';

  @override
  String get estimation_resultDescription =>
      '(Ini adalah pengali relatif terhadap waktu peta standar. Cth: 1.0 sama dengan standar, 0.8 lebih cepat, 1.2 lebih lambat.)';

  @override
  String get estimation_resultWarning =>
      'Pengingat: Jika Anda tidak berolahraga atau mendaki selama sebulan, disarankan untuk mengalikan perkiraan waktu dengan 1.1. Selama tiga bulan, kalikan dengan 1.1 pangkat tiga.';

  @override
  String get merge_selectButton => 'Pilih File GPX (Maks 3)';

  @override
  String get merge_mergeButton => 'Gabungkan File GPX';

  @override
  String get merge_selectedFilesTitle => 'File yang Dipilih:';

  @override
  String get merge_noFilesSelected => 'Belum ada file yang dipilih.';

  @override
  String get merge_successDialogTitle => 'Penggabungan Berhasil';

  @override
  String get merge_successDialogContent =>
      'File GPX yang digabungkan telah disimpan ke perpustakaan Anda.\n\nApakah Anda ingin pergi ke halaman Perencanaan GPX untuk pengeditan lebih lanjut?';

  @override
  String get merge_stayHereButton => 'Tetap di Sini';

  @override
  String get merge_goToPlanningButton => 'Pergi ke Perencanaan';

  @override
  String get merge_errorTooManyFiles => 'Maksimal 3 file yang dapat dipilih.';

  @override
  String get merge_errorTooFewFiles =>
      'Pilih setidaknya 2 file untuk digabungkan.';

  @override
  String merge_errorFileTooLarge(String fileName) {
    return 'File \"$fileName\" terlalu besar (batas 1000KB).';
  }

  @override
  String merge_errorNotGpx(String fileName) {
    return 'File \"$fileName\" bukan file GPX.';
  }

  @override
  String merge_errorGeneric(String error) {
    return 'Terjadi kesalahan: $error';
  }

  @override
  String get loading => 'Memuat...';

  @override
  String get error => 'Terjadi kesalahan';

  @override
  String get retry => 'Coba lagi';

  @override
  String get cancel => 'Batal';

  @override
  String get confirm => 'Konfirmasi';

  @override
  String get save => 'Simpan';

  @override
  String get delete => 'Hapus';

  @override
  String get edit => 'Edit';

  @override
  String get search => 'Cari';

  @override
  String get filter => 'Filter';

  @override
  String get sort => 'Urutkan';

  @override
  String get share => 'Bagikan';

  @override
  String get export => 'Ekspor';

  @override
  String get import => 'Impor';

  @override
  String get upload => 'Unggah';

  @override
  String get download => 'Unduh';

  @override
  String get settings => 'Pengaturan';

  @override
  String get profile => 'Profil';

  @override
  String get logout => 'Keluar';

  @override
  String get login => 'Masuk';

  @override
  String get register => 'Daftar';

  @override
  String get welcome => 'Selamat Datang';

  @override
  String get back => 'Kembali';

  @override
  String get next => 'Berikutnya';

  @override
  String get previous => 'Sebelumnya';

  @override
  String get done => 'Selesai';

  @override
  String get close => 'Tutup';

  @override
  String get open => 'Buka';

  @override
  String get yes => 'Ya';

  @override
  String get no => 'Tidak';

  @override
  String get ok => 'OK';

  @override
  String get selectFile => 'Pilih File';

  @override
  String fileSelected(int count) {
    return '$count file dipilih';
  }

  @override
  String get noFileSelected => 'Tidak ada file yang dipilih';

  @override
  String get fileUploadSuccess => 'File berhasil diunggah';

  @override
  String get fileUploadError => 'Gagal mengunggah file';

  @override
  String fileSizeLimit(String size) {
    return 'Batas ukuran file: $size';
  }

  @override
  String get distance => 'Jarak';

  @override
  String get elevation => 'Ketinggian';

  @override
  String get elevationGain => 'Kenaikan Ketinggian';

  @override
  String get elevationLoss => 'Penurunan Ketinggian';

  @override
  String get duration => 'Durasi';

  @override
  String get speed => 'Kecepatan';

  @override
  String get pace => 'Laju';

  @override
  String get difficulty => 'Tingkat Kesulitan';

  @override
  String get easy => 'Mudah';

  @override
  String get moderate => 'Sedang';

  @override
  String get hard => 'Sulit';

  @override
  String get expert => 'Ahli';

  @override
  String get startPoint => 'Titik Awal';

  @override
  String get endPoint => 'Titik Akhir';

  @override
  String get waypoint => 'Titik Jalan';

  @override
  String get currentLocation => 'Lokasi Saat Ini';

  @override
  String get destination => 'Tujuan';

  @override
  String get route => 'Rute';

  @override
  String get track => 'Jejak';

  @override
  String get map => 'Peta';

  @override
  String get satellite => 'Satelit';

  @override
  String get terrain => 'Medan';

  @override
  String get hybrid => 'Hibrida';

  @override
  String get weather => 'Cuaca';

  @override
  String get temperature => 'Suhu';

  @override
  String get humidity => 'Kelembaban';

  @override
  String get windSpeed => 'Kecepatan Angin';

  @override
  String get precipitation => 'Curah Hujan';

  @override
  String get equipment => 'Peralatan';

  @override
  String get required => 'Wajib';

  @override
  String get optional => 'Opsional';

  @override
  String get quantity => 'Jumlah';

  @override
  String get weight => 'Berat';

  @override
  String get totalWeight => 'Berat Total';

  @override
  String get checklist => 'Daftar Periksa';

  @override
  String get completed => 'Selesai';

  @override
  String get incomplete => 'Tidak Lengkap';

  @override
  String get mergeGpx => 'Gabungkan GPX';

  @override
  String get selectFilesToMerge => 'Pilih file untuk digabungkan';

  @override
  String get mergeSuccess => 'Penggabungan berhasil';

  @override
  String get mergeError => 'Penggabungan gagal';

  @override
  String get processing => 'Memproses...';

  @override
  String get aiSuggestion => 'Saran AI';

  @override
  String get optimizeRoute => 'Optimalkan Rute';

  @override
  String get shortestPath => 'Jalur Terpendek';

  @override
  String get leastElevation => 'Ketinggian Terendah';

  @override
  String get safestRoute => 'Rute Teraman';

  @override
  String get favorites => 'Favorit';

  @override
  String get addToFavorites => 'Tambahkan ke Favorit';

  @override
  String get removeFromFavorites => 'Hapus dari Favorit';

  @override
  String get favoritesLimit =>
      'Batas favorit adalah 4, harap hapus satu untuk menambahkan yang lain';

  @override
  String get announcement => 'Pengumuman';

  @override
  String get news => 'Berita';

  @override
  String get notification => 'Notifikasi';

  @override
  String get message => 'Pesan';

  @override
  String get networkError => 'Kesalahan koneksi jaringan';

  @override
  String get serverError => 'Kesalahan server';

  @override
  String get unknownError => 'Kesalahan tidak diketahui';

  @override
  String get tryAgainLater => 'Silakan coba lagi nanti';

  @override
  String get privacyPolicy => 'Kebijakan Privasi';

  @override
  String get termsOfService => 'Ketentuan Layanan';

  @override
  String get about => 'Tentang';

  @override
  String get version => 'Versi';

  @override
  String get contactUs => 'Hubungi Kami';

  @override
  String get feedback => 'Umpan Balik';

  @override
  String get reportBug => 'Laporkan Bug';

  @override
  String get lastUpdated => 'Terakhir Diperbarui';

  @override
  String get createdAt => 'Dibuat Pada';

  @override
  String get modifiedAt => 'Diubah Pada';

  @override
  String get syncData => 'Sinkronkan Data';

  @override
  String get offlineMode => 'Mode Offline';

  @override
  String get onlineMode => 'Mode Online';

  @override
  String get tutorial => 'Tutorial';

  @override
  String get help => 'Bantuan';

  @override
  String get faq => 'FAQ';

  @override
  String get guide => 'Panduan Pengguna';

  @override
  String get tips => 'Tips';

  @override
  String get shareWith => 'Bagikan dengan';

  @override
  String get copyLink => 'Salin Tautan';

  @override
  String get qrCode => 'Kode QR';

  @override
  String get scanQrCode => 'Pindai Kode QR';

  @override
  String get year => 'Tahun';

  @override
  String get month => 'Bulan';

  @override
  String get day => 'Hari';

  @override
  String get hour => 'Jam';

  @override
  String get minute => 'Menit';

  @override
  String get second => 'Detik';

  @override
  String get today => 'Hari Ini';

  @override
  String get yesterday => 'Kemarin';

  @override
  String get tomorrow => 'Besok';

  @override
  String get thisWeek => 'Minggu Ini';

  @override
  String get lastWeek => 'Minggu Lalu';

  @override
  String get thisMonth => 'Bulan Ini';

  @override
  String get lastMonth => 'Bulan Lalu';

  @override
  String get male => 'Pria';

  @override
  String get female => 'Wanita';

  @override
  String get other => 'Lainnya';

  @override
  String get age => 'Usia';

  @override
  String get height => 'Tinggi';

  @override
  String get weight_unit => 'Berat';

  @override
  String get experience => 'Pengalaman';

  @override
  String get beginner => 'Pemula';

  @override
  String get intermediate => 'Menengah';

  @override
  String get advanced => 'Mahir';

  @override
  String get professional => 'Profesional';

  @override
  String get achievement => 'Pencapaian';

  @override
  String get badge => 'Lencana';

  @override
  String get level => 'Tingkat';

  @override
  String get points => 'Poin';

  @override
  String get ranking => 'Peringkat';

  @override
  String get leaderboard => 'Papan Peringkat';

  @override
  String get statistics => 'Statistik';

  @override
  String get progress => 'Kemajuan';

  @override
  String get connectionLost => 'Koneksi Terputus';

  @override
  String get reconnecting => 'Menyambungkan kembali...';

  @override
  String get connected => 'Terhubung';

  @override
  String get disconnected => 'Terputus';
}
