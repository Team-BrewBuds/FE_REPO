enum Gender {
  male,
  female;

  @override
  String toString() => switch (this) {
        Gender.male => '남성',
        Gender.female => '여성',
      };
}
