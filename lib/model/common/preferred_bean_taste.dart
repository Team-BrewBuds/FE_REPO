final class PreferredBeanTaste {
  final int body;
  final int acidity;
  final int bitterness;
  final int sweetness;

  const PreferredBeanTaste({
    this.body = 0,
    this.acidity = 0,
    this.bitterness = 0,
    this.sweetness = 0,
  });

  factory PreferredBeanTaste.init() => const PreferredBeanTaste(body: 0, acidity: 0, bitterness: 0, sweetness: 0);

  PreferredBeanTaste copyWith({
    int? body,
    int? acidity,
    int? bitterness,
    int? sweetness,
  }) {
    return PreferredBeanTaste(
      body: body ?? this.body,
      acidity: acidity ?? this.acidity,
      bitterness: bitterness ?? this.bitterness,
      sweetness: sweetness ?? this.sweetness,
    );
  }
}
