enum NewsCategory {
  all('Semua', 'all'),
  technology('Teknologi', 'tech'),
  science('Sains', 'science'),
  politics('Politik', 'politics'),
  business('Bisnis', 'business'),
  health('Kesehatan', 'health'); 

  final String label;
  final String apiKey;

  const NewsCategory(this.label, this.apiKey);

  static NewsCategory fromString(String value) {
    return values.firstWhere(
      (e) => e.apiKey == value,
      orElse: () => all,
    );
  }
}