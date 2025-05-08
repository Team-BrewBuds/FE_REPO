import 'dart:async';
import 'dart:math';

import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/domain/search/models/search_result_model.dart';
import 'package:brew_buds/model/events/comment_event.dart';
import 'package:brew_buds/model/events/post_event.dart';
import 'package:brew_buds/model/events/user_follow_event.dart';

sealed class SearchResultPresenter {}

final class TastedRecordSearchResultPresenter extends Presenter implements SearchResultPresenter {
  final TastedRecordSearchResultModel _resultModel;

  int get id => _resultModel.id;

  String get imageUrl => _resultModel.imageUrl;

  String get beanName => _resultModel.title;

  String get beanType => _resultModel.beanType;

  double get rating => _resultModel.rating;

  List<String> get tasteList => List.unmodifiable(_resultModel.taste.sublist(0, min(4, _resultModel.taste.length)));

  String get contents => _resultModel.contents;

  TastedRecordSearchResultPresenter({
    required TastedRecordSearchResultModel resultModel,
  }) : _resultModel = resultModel;
}

final class PostSearchResultPresenter extends Presenter implements SearchResultPresenter {
  late final StreamSubscription _postSub;
  late final StreamSubscription _commentSub;
  PostSearchResultModel _resultModel;

  int get id => _resultModel.id;

  String get title => _resultModel.title;

  String get contents => _resultModel.contents;

  int get likeCount => _resultModel.likeCount;

  int get commentsCount => _resultModel.commentCount;

  String get subject => _resultModel.subject;

  String get createdAt => _resultModel.createdAt;

  int get hits => _resultModel.hits;

  String get writerNickName => _resultModel.authorNickname;

  String get imageUrl => _resultModel.imageUrl;

  PostSearchResultPresenter({
    required PostSearchResultModel resultModel,
  }) : _resultModel = resultModel {
    _postSub = EventBus.instance.on<PostEvent>().listen(_onPostEvent);
    _commentSub = EventBus.instance.on<CommentEvent>().listen(_onCommentEvent);
  }

  @override
  dispose() {
    _postSub.cancel();
    _commentSub.cancel();
    super.dispose();
  }

  _onPostEvent(PostEvent event) {
    if (event.senderId != presenterId) {
      switch (event) {
        case PostLikeEvent():
          if (event.id == _resultModel.id && event.likeCount != _resultModel.likeCount) {
            _resultModel = _resultModel.copyWith(likeCount: event.likeCount);
            notifyListeners();
          }
          break;
        default:
          break;
      }
    }
  }

  _onCommentEvent(CommentEvent event) {
    if (event.senderId != presenterId) {
      switch (event) {
        case OnChangeCommentCountEvent():
          if (event.objectId == _resultModel.id &&
              event.objectType != 'post' &&
              event.count != _resultModel.commentCount) {
            _resultModel = _resultModel.copyWith(commentCount: event.count);
            notifyListeners();
          }
          break;
        default:
          break;
      }
    }
  }
}

final class CoffeeBeanSearchResultPresenter extends Presenter implements SearchResultPresenter {
  final CoffeeBeanSearchResultModel _resultModel;

  int get id => _resultModel.id;

  String get beanName => _resultModel.name;

  double get rating => _resultModel.rating;

  int get recordCount => _resultModel.recordedCount;

  String get imagePath => _resultModel.imagePath;

  CoffeeBeanSearchResultPresenter({
    required CoffeeBeanSearchResultModel resultModel,
  }) : _resultModel = resultModel;
}

final class BuddySearchResultPresenter extends Presenter implements SearchResultPresenter {
  late final StreamSubscription _followSub;
  BuddySearchResultModel _resultModel;

  int get id => _resultModel.id;

  String get profileImageUrl => _resultModel.profileImageUrl;

  String get nickname => _resultModel.nickname;

  int get followerCount => _resultModel.followerCount;

  int get tastedRecordsCount => _resultModel.tastedRecordsCount;

  BuddySearchResultPresenter({
    required BuddySearchResultModel resultModel,
  }) : _resultModel = resultModel {
    _followSub = EventBus.instance.on<UserFollowEvent>().listen(_onEvent);
  }

  @override
  dispose() {
    _followSub.cancel();
    super.dispose();
  }

  _onEvent(UserFollowEvent event) {
    if (event.senderId != presenterId && event.userId == _resultModel.id) {
      if (event.isFollow) {
        _resultModel = _resultModel.copyWith(followerCount: followerCount + 1);
      } else {
        _resultModel = _resultModel.copyWith(followerCount: followerCount - 1);
      }
    }
  }
}
