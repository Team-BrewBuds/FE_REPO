import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/api/report_api.dart';
import 'package:brew_buds/exception/report_exception.dart';

final class ReportPresenter extends Presenter {
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

  Future<void> report() async {
    if (_reason.isNotEmpty) {
      try {
        await _reportApi.report(type: type, id: id, data: {'reason': _reason});
      } catch (_) {
        throw const ReportFailedException();
      }
    } else {
      throw const EmptyReasonReportException();
    }
  }
}
