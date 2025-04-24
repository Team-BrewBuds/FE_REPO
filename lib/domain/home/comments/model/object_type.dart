enum ObjectType {
  post,
  tastingRecord;

  @override
  String toString() => switch (this) {
    ObjectType.post => 'post',
    ObjectType.tastingRecord => 'tasted_record',
  };
}