import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/notification_repository.dart';
import 'package:brew_buds/domain/notification/notification_tap_action.dart';
import 'package:brew_buds/model/common/object_type.dart';
import 'package:brew_buds/model/notification/notification_model.dart';

final class NotificationItemPresenter extends Presenter {
  final NotificationRepository _notificationRepository = NotificationRepository.instance;
  NotificationModel _notificationModel;

  int get id => _notificationModel.id;

  bool get isRead => _notificationModel.isRead;

  String get body => _notificationModel.body;

  String get createdAt => _notificationModel.createdAt;

  NotificationItemPresenter({
    required NotificationModel notificationModel,
  }) : _notificationModel = notificationModel;

  Future<NotificationTapAction> onTap() async {
    if (_notificationModel.isRead) {
      return _getTapAction();
    }

    _notificationModel = _notificationModel.read();
    notifyListeners();

    try {
      await _notificationRepository.readNotification(id: _notificationModel.id);
      return _getTapAction();
    } catch (e) {
      _notificationModel = _notificationModel.unRead();
      notifyListeners();
      rethrow;
    }
  }

  NotificationTapAction _getTapAction() {
    final model = _notificationModel;
    final NotificationTapAction action;
    switch (model) {
      case FollowNotification():
        final id = model.followUserId;
        if (id != null) {
          action = PushToProfile(id: id);
        } else {
          action = JustTap();
        }
      case CommentNotification():
        final objectId = model.objectId;
        final objectType = model.objectType;
        if (objectType != null && objectId != null) {
          switch (objectType) {
            case ObjectType.post:
              action = PushToPostDetail(id: objectId);
            case ObjectType.tastingRecord:
              action = PushToTastedRecordDetail(id: objectId);
          }
        } else {
          action = JustTap();
        }
      case DefaultLikeNotification():
        action = JustTap();
      case PostLikeNotification():
        final id = model.objectId;
        if (id != null) {
          action = PushToPostDetail(id: id);
        } else {
          action = JustTap();
        }
      case TastedRecordLikeNotification():
        final id = model.objectId;
        if (id != null) {
          action = PushToTastedRecordDetail(id: id);
        } else {
          action = JustTap();
        }
      case CommentLikeNotification():
        final objectId = model.objectId;
        final objectType = model.objectType;
        if (objectType != null && objectId != null) {
          switch (objectType) {
            case ObjectType.post:
              action = PushToPostDetail(id: objectId);
            case ObjectType.tastingRecord:
              action = PushToTastedRecordDetail(id: objectId);
          }
        } else {
          action = JustTap();
        }
    }

    return action;
  }
}
