import 'package:brew_buds/core/result.dart';
import 'package:brew_buds/data/api/report_api.dart';
import 'package:flutter/foundation.dart';

final class ReportPresenter extends ChangeNotifier {
  final ReportApi _reportApi = ReportApi();
  final int id;
  final String type;
  String _reason = '';

  ReportPresenter({
    required this.id,
    required this.type,
  });

  List<String> get reasonList => [
        '광고 및 홍보',
        '욕설 및 혐오 발언',
        '음란 및 성적인 글',
        '개인정보 노출',
        '부적절한 닉네임 및 프로필 이미지',
        '기타',
      ];

  String get selectedReason => _reason;

  bool get canReport => _reason.isNotEmpty;

  onSelectReason(String reason) {
    if (_reason == reason) {
      _reason = '';
    } else {
      _reason = reason;
    }
    notifyListeners();
  }

  Future<Result<String>> report() {
    if (_reason.isNotEmpty) {
      return _reportApi
          .report(type: type, id: id, data: {'reason': _reason})
          .then((value) => Result.success('신고를 완료했어요.'))
          .onError((error, stackTrace) => Result.error('신고를 실패했어요.'));
    } else {
      return Future.value(Result.error('신고 사유를 선택해 주세요.'));
    }
  }
}
