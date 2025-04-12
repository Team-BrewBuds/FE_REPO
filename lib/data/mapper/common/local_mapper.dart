import 'package:brew_buds/data/dto/common/local_dto.dart';
import 'package:brew_buds/model/common/local.dart';

extension LocalMapper on LocalDTO {
  Local toDomain() => Local(
        name: name,
        distance: distance.isEmpty ? '' : _getDistance(distance),
        address: address,
      );
}

String _getDistance(String distance) {
  final int distanceInMeters = int.parse(distance);

  if (distanceInMeters >= 1000) {
    double distanceInKm = distanceInMeters / 1000;
    return "${distanceInKm.toStringAsFixed(1)}KM";
  } else {
    return "${distanceInMeters}M";
  }
}
