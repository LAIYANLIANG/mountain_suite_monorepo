// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '등산 앱';

  @override
  String get homeScreenTitle => '홈';

  @override
  String get infoScreenTitle => '정보';

  @override
  String get gpxPlanningScreenTitle => 'GPX 지도 계획';

  @override
  String get gpxMergeScreenTitle => 'GPX 병합';

  @override
  String get routeEstimationScreenTitle => '경로 평가';

  @override
  String get equipmentChecklistScreenTitle => '장비 체크리스트';

  @override
  String get gpxLibraryScreenTitle => 'GPX 라이브러리';

  @override
  String get authScreenTitle => '계정 관리';

  @override
  String get socialFeedTitle => '소셜 피드';

  @override
  String get trackingFeatureTitle => '트랙 기록';

  @override
  String get trackingStoppedMessage => '추적이 중지되었습니다.';

  @override
  String get startTrackingButton => '추적 시작';

  @override
  String get pauseTrackingButton => '일시 중지';

  @override
  String get stopTrackingButton => '중지';

  @override
  String get resumeTrackingButton => '계속';

  @override
  String get defaultTrackName => '내 트랙';

  @override
  String get trackNameLabel => '트랙 이름';

  @override
  String get saveTrackButton => '트랙 저장';

  @override
  String get startNewTrackButton => '새 트랙 시작';

  @override
  String get home_startPlanning => '새 경로 계획 시작';

  @override
  String get checklist_personalGear => '개인 장비';

  @override
  String get checklist_groupGear => '그룹 장비';

  @override
  String get checklist_baseGear => '기본 장비';

  @override
  String get checklist_technicalGear => '기술/설상 장비';

  @override
  String get checklist_otherGear => '기타 항목';

  @override
  String get checklist_totalWeight => '총 무게';

  @override
  String get checklist_quantity => '수량';

  @override
  String get checklist_weightGrams => '무게(g)';

  @override
  String get checklist_snowEssential => '설상 시즌 필수품';

  @override
  String get estimation_routeQixing => '치싱산 주봉 왕복';

  @override
  String get estimation_routeTianmu => '톈무 옛길';

  @override
  String get estimation_routeYushan => '위산 주봉';

  @override
  String get estimation_routeHehuan => '허환산 북봉';

  @override
  String get estimation_yourTimeHint => '당신의 시간';

  @override
  String get estimation_minutesUnit => '분';

  @override
  String get estimation_breathingLevelQuestion =>
      '정상 속도로 1층에서 5층까지 올라갈 때의 숨가쁨 정도는?';

  @override
  String get estimation_breathingLevel1 => '1 - 느낌 없음';

  @override
  String get estimation_breathingLevel3 => '3 - 피곤하지만 숨이 차지는 않음';

  @override
  String get estimation_breathingLevel5 => '5 - 매우 숨이 참';

  @override
  String get estimation_inactivityLabel => '비활동 개월 수 (예: 3)';

  @override
  String get estimation_monthsUnit => '개월';

  @override
  String get estimation_calculateButton => '내 페이스 계수 계산 및 저장';

  @override
  String get estimation_resultTitle => '당신의 페이스 계수는 약';

  @override
  String get estimation_resultDescription =>
      '(이것은 표준 지도 시간에 대한 승수입니다. 예: 1.0은 표준과 동일, 0.8은 더 빠름, 1.2는 더 느림.)';

  @override
  String get estimation_resultWarning =>
      '알림: 한 달 동안 운동이나 하이킹을 하지 않은 경우 예상 시간에 1.1을 곱하는 것이 좋습니다. 3개월 동안 운동하지 않은 경우 1.1의 세제곱을 곱하십시오.';

  @override
  String get merge_selectButton => 'GPX 파일 선택 (최대 3개)';

  @override
  String get merge_mergeButton => 'GPX 파일 병합';

  @override
  String get merge_selectedFilesTitle => '선택된 파일:';

  @override
  String get merge_noFilesSelected => '아직 선택된 파일이 없습니다.';

  @override
  String get merge_successDialogTitle => '병합 성공';

  @override
  String get merge_successDialogContent =>
      '병합된 GPX 파일이 라이브러리에 저장되었습니다.\n\n추가 편집을 위해 GPX 계획 페이지로 이동하시겠습니까?';

  @override
  String get merge_stayHereButton => '여기에 머물기';

  @override
  String get merge_goToPlanningButton => '계획으로 이동';

  @override
  String get merge_errorTooManyFiles => '최대 3개의 파일만 선택할 수 있습니다.';

  @override
  String get merge_errorTooFewFiles => '병합하려면 최소 2개의 파일을 선택하십시오.';

  @override
  String merge_errorFileTooLarge(String fileName) {
    return '파일 \"$fileName\"이 너무 큽니다(1000KB 제한).';
  }

  @override
  String merge_errorNotGpx(String fileName) {
    return '파일 \"$fileName\"은(는) GPX 파일이 아닙니다.';
  }

  @override
  String merge_errorGeneric(String error) {
    return '오류가 발생했습니다: $error';
  }

  @override
  String get loading => '로드 중...';

  @override
  String get error => '오류가 발생했습니다';

  @override
  String get retry => '재시도';

  @override
  String get cancel => '취소';

  @override
  String get confirm => '확인';

  @override
  String get save => '저장';

  @override
  String get delete => '삭제';

  @override
  String get edit => '편집';

  @override
  String get search => '검색';

  @override
  String get filter => '필터';

  @override
  String get sort => '정렬';

  @override
  String get share => '공유';

  @override
  String get export => '내보내기';

  @override
  String get import => '가져오기';

  @override
  String get upload => '업로드';

  @override
  String get download => '다운로드';

  @override
  String get settings => '설정';

  @override
  String get profile => '프로필';

  @override
  String get logout => '로그아웃';

  @override
  String get login => '로그인';

  @override
  String get register => '등록';

  @override
  String get welcome => '환영합니다';

  @override
  String get back => '뒤로';

  @override
  String get next => '다음';

  @override
  String get previous => '이전';

  @override
  String get done => '완료';

  @override
  String get close => '닫기';

  @override
  String get open => '열기';

  @override
  String get yes => '예';

  @override
  String get no => '아니요';

  @override
  String get ok => '확인';

  @override
  String get selectFile => '파일 선택';

  @override
  String fileSelected(int count) {
    return '$count개의 파일이 선택되었습니다';
  }

  @override
  String get noFileSelected => '선택된 파일이 없습니다';

  @override
  String get fileUploadSuccess => '파일 업로드 성공';

  @override
  String get fileUploadError => '파일 업로드 실패';

  @override
  String fileSizeLimit(String size) {
    return '파일 크기 제한: $size';
  }

  @override
  String get distance => '거리';

  @override
  String get elevation => '고도';

  @override
  String get elevationGain => '누적 상승 고도';

  @override
  String get elevationLoss => '누적 하강 고도';

  @override
  String get duration => '기간';

  @override
  String get speed => '속도';

  @override
  String get pace => '페이스';

  @override
  String get difficulty => '난이도';

  @override
  String get easy => '쉬움';

  @override
  String get moderate => '보통';

  @override
  String get hard => '어려움';

  @override
  String get expert => '전문가';

  @override
  String get startPoint => '시작점';

  @override
  String get endPoint => '종료점';

  @override
  String get waypoint => '경유지';

  @override
  String get currentLocation => '현재 위치';

  @override
  String get destination => '목적지';

  @override
  String get route => '경로';

  @override
  String get track => '트랙';

  @override
  String get map => '지도';

  @override
  String get satellite => '위성';

  @override
  String get terrain => '지형';

  @override
  String get hybrid => '하이브리드';

  @override
  String get weather => '날씨';

  @override
  String get temperature => '온도';

  @override
  String get humidity => '습도';

  @override
  String get windSpeed => '풍속';

  @override
  String get precipitation => '강수량';

  @override
  String get equipment => '장비';

  @override
  String get required => '필수';

  @override
  String get optional => '선택';

  @override
  String get quantity => '수량';

  @override
  String get weight => '무게';

  @override
  String get totalWeight => '총 무게';

  @override
  String get checklist => '체크리스트';

  @override
  String get completed => '완료됨';

  @override
  String get incomplete => '미완료';

  @override
  String get mergeGpx => 'GPX 병합';

  @override
  String get selectFilesToMerge => '병합할 파일 선택';

  @override
  String get mergeSuccess => '병합 성공';

  @override
  String get mergeError => '병합 실패';

  @override
  String get processing => '처리 중...';

  @override
  String get aiSuggestion => 'AI 제안';

  @override
  String get optimizeRoute => '경로 최적화';

  @override
  String get shortestPath => '최단 경로';

  @override
  String get leastElevation => '최소 고도';

  @override
  String get safestRoute => '가장 안전한 경로';

  @override
  String get favorites => '즐겨찾기';

  @override
  String get addToFavorites => '즐겨찾기에 추가';

  @override
  String get removeFromFavorites => '즐겨찾기에서 삭제';

  @override
  String get favoritesLimit => '즐겨찾기는 4개까지 가능합니다. 다른 항목을 추가하려면 하나를 삭제하세요';

  @override
  String get announcement => '공지';

  @override
  String get news => '뉴스';

  @override
  String get notification => '알림';

  @override
  String get message => '메시지';

  @override
  String get networkError => '네트워크 연결 오류';

  @override
  String get serverError => '서버 오류';

  @override
  String get unknownError => '알 수 없는 오류';

  @override
  String get tryAgainLater => '나중에 다시 시도해주세요';

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get termsOfService => '서비스 이용약관';

  @override
  String get about => '정보';

  @override
  String get version => '버전';

  @override
  String get contactUs => '문의하기';

  @override
  String get feedback => '피드백';

  @override
  String get reportBug => '버그 신고';

  @override
  String get lastUpdated => '마지막 업데이트';

  @override
  String get createdAt => '생성일';

  @override
  String get modifiedAt => '수정일';

  @override
  String get syncData => '데이터 동기화';

  @override
  String get offlineMode => '오프라인 모드';

  @override
  String get onlineMode => '온라인 모드';

  @override
  String get tutorial => '튜토리얼';

  @override
  String get help => '도움말';

  @override
  String get faq => '자주 묻는 질문';

  @override
  String get guide => '사용자 가이드';

  @override
  String get tips => '팁';

  @override
  String get shareWith => '공유하기';

  @override
  String get copyLink => '링크 복사';

  @override
  String get qrCode => 'QR 코드';

  @override
  String get scanQrCode => 'QR 코드 스캔';

  @override
  String get year => '년';

  @override
  String get month => '월';

  @override
  String get day => '일';

  @override
  String get hour => '시간';

  @override
  String get minute => '분';

  @override
  String get second => '초';

  @override
  String get today => '오늘';

  @override
  String get yesterday => '어제';

  @override
  String get tomorrow => '내일';

  @override
  String get thisWeek => '이번 주';

  @override
  String get lastWeek => '지난 주';

  @override
  String get thisMonth => '이번 달';

  @override
  String get lastMonth => '지난 달';

  @override
  String get male => '남성';

  @override
  String get female => '여성';

  @override
  String get other => '기타';

  @override
  String get age => '나이';

  @override
  String get height => '키';

  @override
  String get weight_unit => '몸무게';

  @override
  String get experience => '경험';

  @override
  String get beginner => '초급';

  @override
  String get intermediate => '중급';

  @override
  String get advanced => '고급';

  @override
  String get professional => '전문가';

  @override
  String get achievement => '업적';

  @override
  String get badge => '배지';

  @override
  String get level => '레벨';

  @override
  String get points => '포인트';

  @override
  String get ranking => '순위';

  @override
  String get leaderboard => '리더보드';

  @override
  String get statistics => '통계';

  @override
  String get progress => '진행률';

  @override
  String get connectionLost => '연결 끊김';

  @override
  String get reconnecting => '재연결 중...';

  @override
  String get connected => '연결됨';

  @override
  String get disconnected => '연결 끊김';
}
