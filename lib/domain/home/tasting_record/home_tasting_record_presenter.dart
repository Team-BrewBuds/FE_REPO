import 'package:brew_buds/data/repository/tasted_record_repository.dart';
import 'package:brew_buds/domain/home/core/home_view_presenter.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_feed.dart';

final class HomeTastingRecordPresenter extends HomeViewPresenter<TastedRecordInFeed> {
  final TastedRecordRepository _tastedRecordRepository = TastedRecordRepository.instance;

  @override
  Future<void> fetchMoreData() async {
    if (hasNext) {
      final newPage = await _tastedRecordRepository.fetchTastedRecordFeedPage(
        pageNo: currentPage + 1,
      );
      defaultPage = defaultPage.copyWith(
        results: defaultPage.results + newPage.results,
        hasNext: newPage.hasNext,
      );
      currentPage += 1;
      notifyListeners();
    }
  }

  @override
  onTappedLikeAt(int index) {
    final tastedRecord = data[index];
    _tastedRecordRepository.like(id: tastedRecord.id, isLiked: tastedRecord.isLiked).then(
          (_) => _updateFeed(
            newTastedRecord: tastedRecord.isLiked
                ? tastedRecord.copyWith(isLiked: !tastedRecord.isLiked, likeCount: tastedRecord.likeCount - 1)
                : tastedRecord.copyWith(isLiked: !tastedRecord.isLiked, likeCount: tastedRecord.likeCount + 1),
          ),
        );
  }

  @override
  onTappedSavedAt(int index) {
    final tastedRecord = data[index];
    _tastedRecordRepository
        .save(id: tastedRecord.id, isSaved: tastedRecord.isSaved)
        .then((_) => _updateFeed(newTastedRecord: tastedRecord.copyWith(isSaved: !tastedRecord.isSaved)));
  }

  @override
  onTappedFollowAt(int index) {
    final tastedRecord = data[index];
    _tastedRecordRepository.follow(id: tastedRecord.id, isFollow: tastedRecord.isAuthorFollowing).then(
          (_) => _updateFeed(
            newTastedRecord: tastedRecord.copyWith(isAuthorFollowing: !tastedRecord.isAuthorFollowing),
          ),
        );
  }

  _updateFeed({required TastedRecordInFeed newTastedRecord}) {
    defaultPage = defaultPage.copyWith(
      results: defaultPage.results.map(
        (tastedRecord) {
          if (tastedRecord.id == newTastedRecord.id) {
            return newTastedRecord;
          } else {
            return tastedRecord;
          }
        },
      ).toList(),
    );
    notifyListeners();
  }
}
