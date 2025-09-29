// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Ứng dụng Leo núi';

  @override
  String get homeScreenTitle => 'Trang chủ';

  @override
  String get infoScreenTitle => 'Thông tin';

  @override
  String get gpxPlanningScreenTitle => 'Lập kế hoạch Bản đồ GPX';

  @override
  String get gpxMergeScreenTitle => 'Gộp GPX';

  @override
  String get routeEstimationScreenTitle => 'Ước tính Lộ trình';

  @override
  String get equipmentChecklistScreenTitle => 'Danh sách kiểm tra thiết bị';

  @override
  String get gpxLibraryScreenTitle => 'Thư viện GPX';

  @override
  String get authScreenTitle => 'Quản lý tài khoản';

  @override
  String get socialFeedTitle => 'Bảng tin xã hội';

  @override
  String get trackingFeatureTitle => 'Ghi lại เส้นทาง';

  @override
  String get trackingStoppedMessage => 'Đã dừng theo dõi.';

  @override
  String get startTrackingButton => 'Bắt đầu theo dõi';

  @override
  String get pauseTrackingButton => 'Tạm dừng';

  @override
  String get stopTrackingButton => 'Dừng';

  @override
  String get resumeTrackingButton => 'Tiếp tục';

  @override
  String get defaultTrackName => 'Đường đi của tôi';

  @override
  String get trackNameLabel => 'Tên đường đi';

  @override
  String get saveTrackButton => 'Lưu đường đi';

  @override
  String get startNewTrackButton => 'Bắt đầu đường đi mới';

  @override
  String get home_startPlanning => 'Bắt đầu lập kế hoạch tuyến đường mới';

  @override
  String get checklist_personalGear => 'Trang bị cá nhân';

  @override
  String get checklist_groupGear => 'Trang bị nhóm';

  @override
  String get checklist_baseGear => 'Trang bị cơ bản';

  @override
  String get checklist_technicalGear => 'Trang bị kỹ thuật/tuyết';

  @override
  String get checklist_otherGear => 'Các mục khác';

  @override
  String get checklist_totalWeight => 'Tổng trọng lượng';

  @override
  String get checklist_quantity => 'SL';

  @override
  String get checklist_weightGrams => 'Nặng(g)';

  @override
  String get checklist_snowEssential => 'Cần thiết cho mùa tuyết';

  @override
  String get estimation_routeQixing => 'Khứ hồi đỉnh chính núi Qixing';

  @override
  String get estimation_routeTianmu => 'Đường cổ Tianmu';

  @override
  String get estimation_routeYushan => 'Đỉnh chính núi Yushan';

  @override
  String get estimation_routeHehuan => 'Đỉnh Bắc núi Hehuan';

  @override
  String get estimation_yourTimeHint => 'Thời gian của bạn';

  @override
  String get estimation_minutesUnit => 'phút';

  @override
  String get estimation_breathingLevelQuestion =>
      'Mức độ khó thở khi leo từ tầng 1 lên tầng 5 với tốc độ bình thường?';

  @override
  String get estimation_breathingLevel1 => '1 - Không cảm thấy gì';

  @override
  String get estimation_breathingLevel3 => '3 - Mệt nhưng không khó thở';

  @override
  String get estimation_breathingLevel5 => '5 - Rất khó thở';

  @override
  String get estimation_inactivityLabel =>
      'Số tháng không hoạt động (ví dụ: 3)';

  @override
  String get estimation_monthsUnit => 'tháng';

  @override
  String get estimation_calculateButton => 'Tính & Lưu hệ số tốc độ của tôi';

  @override
  String get estimation_resultTitle => 'Hệ số tốc độ của bạn là khoảng';

  @override
  String get estimation_resultDescription =>
      '(Đây là một hệ số nhân so với thời gian bản đồ tiêu chuẩn. Ví dụ: 1.0 giống như tiêu chuẩn, 0.8 nhanh hơn, 1.2 chậm hơn.)';

  @override
  String get estimation_resultWarning =>
      'Nhắc nhở: Nếu bạn không tập thể dục hoặc đi bộ đường dài trong một tháng, bạn nên nhân thời gian ước tính với 1.1. Trong ba tháng, nhân với 1.1 lũy thừa 3.';

  @override
  String get merge_selectButton => '選擇 GPX 檔案 (最多3個)';

  @override
  String get merge_mergeButton => '合併 GPX 檔案';

  @override
  String get merge_selectedFilesTitle => '已選檔案:';

  @override
  String get merge_noFilesSelected => '尚未選擇任何檔案。';

  @override
  String get merge_successDialogTitle => '合併成功';

  @override
  String get merge_successDialogContent =>
      '合併後的 GPX 檔案已儲存至您的地圖庫.\n\n您是否要前往「GPX 地圖規劃」頁面進一步編輯？';

  @override
  String get merge_stayHereButton => '留在本頁';

  @override
  String get merge_goToPlanningButton => '前往規劃';

  @override
  String get merge_errorTooManyFiles => '最多只能選擇 3 個檔案。';

  @override
  String get merge_errorTooFewFiles => '請至少選擇 2 個檔案進行合併。';

  @override
  String merge_errorFileTooLarge(String fileName) {
    return '檔案 \"$fileName\" 過大，超過 1000KB 的限制。';
  }

  @override
  String merge_errorNotGpx(String fileName) {
    return '檔案 \"$fileName\" 不是 GPX 檔案。';
  }

  @override
  String merge_errorGeneric(String error) {
    return '發生錯誤: $error';
  }

  @override
  String get loading => 'Đang tải...';

  @override
  String get error => 'Đã xảy ra lỗi';

  @override
  String get retry => 'Thử lại';

  @override
  String get cancel => 'Hủy';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get save => 'Lưu';

  @override
  String get delete => 'Xóa';

  @override
  String get edit => 'Chỉnh sửa';

  @override
  String get search => 'Tìm kiếm';

  @override
  String get filter => 'Lọc';

  @override
  String get sort => 'Sắp xếp';

  @override
  String get share => 'Chia sẻ';

  @override
  String get export => 'Xuất';

  @override
  String get import => 'Nhập';

  @override
  String get upload => 'Tải lên';

  @override
  String get download => 'Tải xuống';

  @override
  String get settings => 'Cài đặt';

  @override
  String get profile => 'Hồ sơ';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get login => 'Đăng nhập';

  @override
  String get register => 'Đăng ký';

  @override
  String get welcome => 'Chào mừng';

  @override
  String get back => 'Quay lại';

  @override
  String get next => 'Tiếp theo';

  @override
  String get previous => 'Trước đó';

  @override
  String get done => 'Hoàn thành';

  @override
  String get close => 'Đóng';

  @override
  String get open => 'Mở';

  @override
  String get yes => 'Có';

  @override
  String get no => 'Không';

  @override
  String get ok => 'OK';

  @override
  String get selectFile => 'Chọn tệp';

  @override
  String fileSelected(int count) {
    return 'Đã chọn $count tệp';
  }

  @override
  String get noFileSelected => 'Chưa có tệp nào được chọn';

  @override
  String get fileUploadSuccess => 'Tải tệp lên thành công';

  @override
  String get fileUploadError => 'Tải tệp lên thất bại';

  @override
  String fileSizeLimit(String size) {
    return 'Giới hạn kích thước tệp: $size';
  }

  @override
  String get distance => 'Khoảng cách';

  @override
  String get elevation => 'Độ cao';

  @override
  String get elevationGain => 'Độ cao tăng';

  @override
  String get elevationLoss => 'Độ cao giảm';

  @override
  String get duration => 'Thời lượng';

  @override
  String get speed => 'Tốc độ';

  @override
  String get pace => 'Nhịp độ';

  @override
  String get difficulty => 'Độ khó';

  @override
  String get easy => 'Dễ';

  @override
  String get moderate => 'Trung bình';

  @override
  String get hard => 'Khó';

  @override
  String get expert => 'Chuyên gia';

  @override
  String get startPoint => 'Điểm bắt đầu';

  @override
  String get endPoint => 'Điểm kết thúc';

  @override
  String get waypoint => 'Điểm tham chiếu';

  @override
  String get currentLocation => 'Vị trí hiện tại';

  @override
  String get destination => 'Điểm đến';

  @override
  String get route => 'Lộ trình';

  @override
  String get track => 'Đường đi';

  @override
  String get map => 'Bản đồ';

  @override
  String get satellite => 'Vệ tinh';

  @override
  String get terrain => 'Địa hình';

  @override
  String get hybrid => 'Kết hợp';

  @override
  String get weather => 'Thời tiết';

  @override
  String get temperature => 'Nhiệt độ';

  @override
  String get humidity => 'Độ ẩm';

  @override
  String get windSpeed => 'Tốc độ gió';

  @override
  String get precipitation => 'Lượng mưa';

  @override
  String get equipment => 'Thiết bị';

  @override
  String get required => 'Bắt buộc';

  @override
  String get optional => 'Tùy chọn';

  @override
  String get quantity => 'Số lượng';

  @override
  String get weight => 'Trọng lượng';

  @override
  String get totalWeight => 'Tổng trọng lượng';

  @override
  String get checklist => 'Danh sách kiểm tra';

  @override
  String get completed => 'Hoàn thành';

  @override
  String get incomplete => 'Chưa hoàn thành';

  @override
  String get mergeGpx => 'Gộp GPX';

  @override
  String get selectFilesToMerge => 'Chọn tệp để gộp';

  @override
  String get mergeSuccess => 'Gộp thành công';

  @override
  String get mergeError => 'Gộp thất bại';

  @override
  String get processing => 'Đang xử lý...';

  @override
  String get aiSuggestion => 'Gợi ý của AI';

  @override
  String get optimizeRoute => 'Tối ưu hóa lộ trình';

  @override
  String get shortestPath => 'Đường đi ngắn nhất';

  @override
  String get leastElevation => 'Độ cao thấp nhất';

  @override
  String get safestRoute => 'Lộ trình an toàn nhất';

  @override
  String get favorites => 'Yêu thích';

  @override
  String get addToFavorites => 'Thêm vào yêu thích';

  @override
  String get removeFromFavorites => 'Xóa khỏi yêu thích';

  @override
  String get favoritesLimit =>
      'Giới hạn yêu thích là 4, vui lòng xóa một mục để thêm mục khác';

  @override
  String get announcement => 'Thông báo';

  @override
  String get news => 'Tin tức';

  @override
  String get notification => 'Thông báo';

  @override
  String get message => 'Tin nhắn';

  @override
  String get networkError => 'Lỗi kết nối mạng';

  @override
  String get serverError => 'Lỗi máy chủ';

  @override
  String get unknownError => 'Lỗi không xác định';

  @override
  String get tryAgainLater => 'Vui lòng thử lại sau';

  @override
  String get privacyPolicy => 'Chính sách bảo mật';

  @override
  String get termsOfService => 'Điều khoản dịch vụ';

  @override
  String get about => 'Giới thiệu';

  @override
  String get version => 'Phiên bản';

  @override
  String get contactUs => 'Liên hệ với chúng tôi';

  @override
  String get feedback => 'Phản hồi';

  @override
  String get reportBug => 'Báo cáo lỗi';

  @override
  String get lastUpdated => 'Cập nhật lần cuối';

  @override
  String get createdAt => 'Tạo lúc';

  @override
  String get modifiedAt => 'Sửa đổi lúc';

  @override
  String get syncData => 'Đồng bộ hóa dữ liệu';

  @override
  String get offlineMode => 'Chế độ ngoại tuyến';

  @override
  String get onlineMode => 'Chế độ trực tuyến';

  @override
  String get tutorial => 'Hướng dẫn';

  @override
  String get help => 'Trợ giúp';

  @override
  String get faq => 'Câu hỏi thường gặp';

  @override
  String get guide => 'Hướng dẫn sử dụng';

  @override
  String get tips => 'Mẹo';

  @override
  String get shareWith => 'Chia sẻ với';

  @override
  String get copyLink => 'Sao chép liên kết';

  @override
  String get qrCode => 'Mã QR';

  @override
  String get scanQrCode => 'Quét mã QR';

  @override
  String get year => 'Năm';

  @override
  String get month => 'Tháng';

  @override
  String get day => 'Ngày';

  @override
  String get hour => 'Giờ';

  @override
  String get minute => 'Phút';

  @override
  String get second => 'Giây';

  @override
  String get today => 'Hôm nay';

  @override
  String get yesterday => 'Hôm qua';

  @override
  String get tomorrow => 'Ngày mai';

  @override
  String get thisWeek => 'Tuần này';

  @override
  String get lastWeek => 'Tuần trước';

  @override
  String get thisMonth => 'Tháng này';

  @override
  String get lastMonth => 'Tháng trước';

  @override
  String get male => 'Nam';

  @override
  String get female => 'Nữ';

  @override
  String get other => 'Khác';

  @override
  String get age => 'Tuổi';

  @override
  String get height => 'Chiều cao';

  @override
  String get weight_unit => 'Cân nặng';

  @override
  String get experience => 'Kinh nghiệm';

  @override
  String get beginner => 'Người mới bắt đầu';

  @override
  String get intermediate => 'Trung cấp';

  @override
  String get advanced => 'Nâng cao';

  @override
  String get professional => 'Chuyên nghiệp';

  @override
  String get achievement => 'Thành tích';

  @override
  String get badge => 'Huy hiệu';

  @override
  String get level => 'Cấp độ';

  @override
  String get points => 'Điểm';

  @override
  String get ranking => 'Xếp hạng';

  @override
  String get leaderboard => 'Bảng xếp hạng';

  @override
  String get statistics => 'Thống kê';

  @override
  String get progress => 'Tiến trình';

  @override
  String get connectionLost => 'Mất kết nối';

  @override
  String get reconnecting => 'Đang kết nối lại...';

  @override
  String get connected => 'Đã kết nối';

  @override
  String get disconnected => 'Đã ngắt kết nối';
}
