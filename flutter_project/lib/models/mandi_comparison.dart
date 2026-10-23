class MandiComparisonItem {
  final String marketName;
  final String state;
  final String district;
  final double distanceKm;
  final double pricePerQuintal;
  final double transportCostPerQuintal;
  final double mandiFeePerQuintal;
  final double netEarningsPerQuintal;
  final double totalNetProfit;
  final bool isRecommended;
  final String dataSource;

  MandiComparisonItem({
    required this.marketName,
    required this.state,
    required this.district,
    required this.distanceKm,
    required this.pricePerQuintal,
    required this.transportCostPerQuintal,
    required this.mandiFeePerQuintal,
    required this.netEarningsPerQuintal,
    required this.totalNetProfit,
    this.isRecommended = false,
    this.dataSource = 'Official Agmarknet Benchmark',
  });

  static MandiComparisonItem calculate({
    required String marketName,
    required String state,
    required String district,
    required double distanceKm,
    required double pricePerQuintal,
    required double totalQuantityQuintals,
    double dieselRatePerKm = 12.0, // per km for small truck/tractor
    double mandiTaxPercent = 1.5, // 1.5% mandi cess
    double loadingUnloadingPerQtl = 25.0, // labor
  }) {
    // Total transport = round trip or freight rate per quintal per km
    // Average freight in India: ~₹2.5 to ₹4.0 per quintal per 10 km
    final freightTotal = (distanceKm * 2 * dieselRatePerKm);
    final freightPerQtl = totalQuantityQuintals > 0 ? (freightTotal / totalQuantityQuintals) : 0.0;
    final mandiFeePerQtl = (pricePerQuintal * (mandiTaxPercent / 100.0)) + loadingUnloadingPerQtl;
    final totalExpensePerQtl = freightPerQtl + mandiFeePerQtl;
    final netPerQtl = pricePerQuintal - totalExpensePerQtl;
    final totalNet = netPerQtl * totalQuantityQuintals;

    return MandiComparisonItem(
      marketName: marketName,
      state: state,
      district: district,
      distanceKm: distanceKm,
      pricePerQuintal: pricePerQuintal,
      transportCostPerQuintal: double.parse(freightPerQtl.toStringAsFixed(1)),
      mandiFeePerQuintal: double.parse(mandiFeePerQtl.toStringAsFixed(1)),
      netEarningsPerQuintal: double.parse(netPerQtl.toStringAsFixed(1)),
      totalNetProfit: double.parse(totalNet.toStringAsFixed(0)),
    );
  }
}
