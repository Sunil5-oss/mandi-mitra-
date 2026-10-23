class SellingOptionInput {
  final String id;
  String name; // e.g. "Indore Mandi", "Local Trader / Vyapari", "Dewas Mandi"
  double pricePerQuintal;
  double transportCost;
  double loadingUnloadingCost;
  double labourCost;
  double packagingCost;
  double commissionCost;
  double otherCost;

  SellingOptionInput({
    required this.id,
    required this.name,
    required this.pricePerQuintal,
    this.transportCost = 0.0,
    this.loadingUnloadingCost = 0.0,
    this.labourCost = 0.0,
    this.packagingCost = 0.0,
    this.commissionCost = 0.0,
    this.otherCost = 0.0,
  });

  SellingOptionInput copyWith({
    String? id,
    String? name,
    double? pricePerQuintal,
    double? transportCost,
    double? loadingUnloadingCost,
    double? labourCost,
    double? packagingCost,
    double? commissionCost,
    double? otherCost,
  }) {
    return SellingOptionInput(
      id: id ?? this.id,
      name: name ?? this.name,
      pricePerQuintal: pricePerQuintal ?? this.pricePerQuintal,
      transportCost: transportCost ?? this.transportCost,
      loadingUnloadingCost: loadingUnloadingCost ?? this.loadingUnloadingCost,
      labourCost: labourCost ?? this.labourCost,
      packagingCost: packagingCost ?? this.packagingCost,
      commissionCost: commissionCost ?? this.commissionCost,
      otherCost: otherCost ?? this.otherCost,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'pricePerQuintal': pricePerQuintal,
    'transportCost': transportCost,
    'loadingUnloadingCost': loadingUnloadingCost,
    'labourCost': labourCost,
    'packagingCost': packagingCost,
    'commissionCost': commissionCost,
    'otherCost': otherCost,
  };

  factory SellingOptionInput.fromJson(Map<String, dynamic> json) {
    return SellingOptionInput(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      pricePerQuintal: (json['pricePerQuintal'] ?? 0.0).toDouble(),
      transportCost: (json['transportCost'] ?? 0.0).toDouble(),
      loadingUnloadingCost: (json['loadingUnloadingCost'] ?? 0.0).toDouble(),
      labourCost: (json['labourCost'] ?? 0.0).toDouble(),
      packagingCost: (json['packagingCost'] ?? 0.0).toDouble(),
      commissionCost: (json['commissionCost'] ?? 0.0).toDouble(),
      otherCost: (json['otherCost'] ?? 0.0).toDouble(),
    );
  }
}

class SellingOptionCalculation {
  final SellingOptionInput option;
  final double quantity; // in quintals
  final double grossSaleValue;
  final double totalExpenses;
  final double estimatedNetReturn;
  final double estimatedNetReturnPerQuintal;

  SellingOptionCalculation({
    required this.option,
    required this.quantity,
    required this.grossSaleValue,
    required this.totalExpenses,
    required this.estimatedNetReturn,
    required this.estimatedNetReturnPerQuintal,
  });
}

class SellingRecommendation {
  final SellingOptionCalculation recommendedOption;
  final SellingOptionCalculation? nextBestOption;
  final double earningsDifference;
  final bool isCloseCall;
  final bool isNegativeReturn;
  final String explanationHindi;
  final String explanationEnglish;
  final List<SellingOptionCalculation> rankedOptions;

  SellingRecommendation({
    required this.recommendedOption,
    this.nextBestOption,
    required this.earningsDifference,
    required this.isCloseCall,
    required this.isNegativeReturn,
    required this.explanationHindi,
    required this.explanationEnglish,
    required this.rankedOptions,
  });
}

class WaitingScenarioResult {
  final double currentNetReturn;
  final double futurePricePerQuintal;
  final double additionalStorageCost;
  final double additionalHandlingCost;
  final double futureGrossValue;
  final double futureTotalExpenses;
  final double futureNetReturn;
  final double netEarningsDifference;
  final bool isProfitableToWait;
  final String advisoryNotes;

  WaitingScenarioResult({
    required this.currentNetReturn,
    required this.futurePricePerQuintal,
    required this.additionalStorageCost,
    required this.additionalHandlingCost,
    required this.futureGrossValue,
    required this.futureTotalExpenses,
    required this.futureNetReturn,
    required this.netEarningsDifference,
    required this.isProfitableToWait,
    required this.advisoryNotes,
  });
}

/// Decision Support Engine with pure, verified arithmetic logic
class SellingDecisionEngine {
  /// Calculate Gross Sale Value = Quantity * Price Per Quintal
  static double calculateGrossValue(double quantity, double pricePerQuintal) {
    if (quantity <= 0 || pricePerQuintal <= 0) return 0.0;
    return quantity * pricePerQuintal;
  }

  /// Calculate Total Expenses
  static double calculateTotalExpenses({
    required double transport,
    double loadingUnloading = 0.0,
    double labour = 0.0,
    double packaging = 0.0,
    double commission = 0.0,
    double other = 0.0,
  }) {
    final t = transport < 0 ? 0.0 : transport;
    final lu = loadingUnloading < 0 ? 0.0 : loadingUnloading;
    final lb = labour < 0 ? 0.0 : labour;
    final pkg = packaging < 0 ? 0.0 : packaging;
    final com = commission < 0 ? 0.0 : commission;
    final oth = other < 0 ? 0.0 : other;
    return t + lu + lb + pkg + com + oth;
  }

  /// Calculate Estimated Net Return = Gross - Total Expenses
  static double calculateNetReturn(double grossValue, double totalExpenses) {
    return grossValue - totalExpenses;
  }

  /// Calculate Net Return Per Quintal
  static double calculateNetReturnPerQuintal(double netReturn, double quantity) {
    if (quantity <= 0) return 0.0;
    return netReturn / quantity;
  }

  /// Perform calculation on a single option
  static SellingOptionCalculation calculateOption(double quantity, SellingOptionInput option) {
    final validQty = quantity <= 0 ? 0.0 : quantity;
    final gross = calculateGrossValue(validQty, option.pricePerQuintal);
    final expenses = calculateTotalExpenses(
      transport: option.transportCost,
      loadingUnloading: option.loadingUnloadingCost,
      labour: option.labourCost,
      packaging: option.packagingCost,
      commission: option.commissionCost,
      other: option.otherCost,
    );
    final net = calculateNetReturn(gross, expenses);
    final netPerQtl = calculateNetReturnPerQuintal(net, validQty);

    return SellingOptionCalculation(
      option: option,
      quantity: validQty,
      grossSaleValue: double.parse(gross.toStringAsFixed(2)),
      totalExpenses: double.parse(expenses.toStringAsFixed(2)),
      estimatedNetReturn: double.parse(net.toStringAsFixed(2)),
      estimatedNetReturnPerQuintal: double.parse(netPerQtl.toStringAsFixed(2)),
    );
  }

  /// Rank selling options from highest to lowest net return
  static List<SellingOptionCalculation> rankOptions(double quantity, List<SellingOptionInput> options) {
    final calculations = options.map((opt) => calculateOption(quantity, opt)).toList();
    calculations.sort((a, b) => b.estimatedNetReturn.compareTo(a.estimatedNetReturn));
    return calculations;
  }

  /// Generate Explainable Recommendation
  static SellingRecommendation generateRecommendation(
    double quantity,
    List<SellingOptionInput> options, {
    String cropName = 'फसल',
  }) {
    if (options.isEmpty) {
      final dummy = calculateOption(0, SellingOptionInput(id: 'none', name: 'कोई विकल्प नहीं', pricePerQuintal: 0));
      return SellingRecommendation(
        recommendedOption: dummy,
        earningsDifference: 0,
        isCloseCall: false,
        isNegativeReturn: false,
        explanationHindi: 'कृपया तुलना करने के लिए कम से कम दो विक्रय विकल्प जोड़ें।',
        explanationEnglish: 'Please provide at least two selling options to compare.',
        rankedOptions: [],
      );
    }

    final ranked = rankOptions(quantity, options);
    final best = ranked.first;
    final nextBest = ranked.length > 1 ? ranked[1] : null;

    final diff = nextBest != null ? (best.estimatedNetReturn - nextBest.estimatedNetReturn) : 0.0;
    final isNegative = best.estimatedNetReturn < 0;

    // A close call if difference is less than 1.5% of gross value or < ₹500
    final isClose = nextBest != null && diff >= 0 && (diff < 500 || (best.grossSaleValue > 0 && (diff / best.grossSaleValue) < 0.015));

    final hindiBuffer = StringBuffer();
    final englishBuffer = StringBuffer();

    if (isNegative) {
      hindiBuffer.writeln('चेतावनी: दर्ज किए गए सभी विकल्पों में कुल खर्च बिक्री मूल्य से अधिक है। इस दर पर बेचने पर हानि होगी।');
      englishBuffer.writeln('Warning: All entered options yield negative net returns due to high selling expenses.');
    } else {
      hindiBuffer.writeln('दर्ज की गई दरों और खर्चों के आधार पर, "${best.option.name}" से उच्चतम अनुमानित शुद्ध आय (Net Return) प्राप्त होगी।');
      englishBuffer.writeln('Based on the prices and expenses you entered, "${best.option.name}" provides the highest estimated net return.');
    }

    hindiBuffer.writeln('');
    hindiBuffer.writeln('• कुल सकल बिक्री मूल्य (Gross Sale Value): ₹${best.grossSaleValue.toStringAsFixed(0)}');
    hindiBuffer.writeln('• परिवहन भाड़ा (Transportation): ₹${best.option.transportCost.toStringAsFixed(0)}');
    final otherExp = best.totalExpenses - best.option.transportCost;
    hindiBuffer.writeln('• अन्य मंडी व मजदूरी खर्च: ₹${otherExp.toStringAsFixed(0)}');
    hindiBuffer.writeln('• कुल विक्रय खर्च (Total Expenses): ₹${best.totalExpenses.toStringAsFixed(0)}');
    hindiBuffer.writeln('• अनुमानित शुद्ध आय (Net Return): ₹${best.estimatedNetReturn.toStringAsFixed(0)} (₹${best.estimatedNetReturnPerQuintal.toStringAsFixed(0)}/क्विंटल)');

    englishBuffer.writeln('');
    englishBuffer.writeln('• Gross Sale Value: ₹${best.grossSaleValue.toStringAsFixed(0)}');
    englishBuffer.writeln('• Transportation: ₹${best.option.transportCost.toStringAsFixed(0)}');
    englishBuffer.writeln('• Other Selling Expenses: ₹${otherExp.toStringAsFixed(0)}');
    englishBuffer.writeln('• Total Expenses: ₹${best.totalExpenses.toStringAsFixed(0)}');
    englishBuffer.writeln('• Estimated Net Return: ₹${best.estimatedNetReturn.toStringAsFixed(0)} (₹${best.estimatedNetReturnPerQuintal.toStringAsFixed(0)}/qtl)');

    if (nextBest != null) {
      hindiBuffer.writeln('');
      if (isClose) {
        hindiBuffer.writeln('नोट: "${nextBest.option.name}" का शुद्ध लाभ भी लगभग समान है (केवल ₹${diff.toStringAsFixed(0)} का अंतर)। दोनों विकल्प आर्थिक दृष्टि से काफी नजदीक हैं।');
        englishBuffer.writeln('\nNote: "${nextBest.option.name}" is financially very close (only ₹${diff.toStringAsFixed(0)} difference). Both options are viable.');
      } else {
        hindiBuffer.writeln('दूसरे विकल्प "${nextBest.option.name}" की तुलना में इस विकल्प से लगभग ₹${diff.toStringAsFixed(0)} का अतिरिक्त शुद्ध लाभ प्राप्त होता है।');
        englishBuffer.writeln('\nCompared with "${nextBest.option.name}", this option provides an estimated additional return of ₹${diff.toStringAsFixed(0)}.');
      }
    }

    hindiBuffer.writeln('');
    hindiBuffer.writeln('महत्वपूर्ण: यह अनुशंसा किसान द्वारा प्रविष्ट आंकड़ों पर आधारित है और वास्तविक बाजार में तौल, नमी कटौती या बोली दरों के आधार पर अंतिम राशि में भिन्नता हो सकती है।');
    englishBuffer.writeln('\nDisclaimer: This recommendation is based strictly on entered figures and does not guarantee the final amount received.');

    return SellingRecommendation(
      recommendedOption: best,
      nextBestOption: nextBest,
      earningsDifference: double.parse(diff.toStringAsFixed(2)),
      isCloseCall: isClose,
      isNegativeReturn: isNegative,
      explanationHindi: hindiBuffer.toString(),
      explanationEnglish: englishBuffer.toString(),
      rankedOptions: ranked,
    );
  }

  /// Simulate Transportation Cost Change
  static SellingOptionCalculation simulateTransportChange(
    SellingOptionCalculation baseline, {
    double percentChange = 0.0,
    double absoluteChange = 0.0,
  }) {
    double newTransport = baseline.option.transportCost;
    if (percentChange != 0.0) {
      newTransport += baseline.option.transportCost * (percentChange / 100.0);
    }
    newTransport += absoluteChange;
    if (newTransport < 0) newTransport = 0.0;

    final updatedInput = baseline.option.copyWith(transportCost: newTransport);
    return calculateOption(baseline.quantity, updatedInput);
  }

  /// Simulate Buyer Offer Modification
  static SellingOptionCalculation simulateBuyerOffer(
    SellingOptionCalculation baseline, {
    double priceChangePerQuintal = 0.0,
    double? exactNewPrice,
  }) {
    double newPrice = exactNewPrice ?? (baseline.option.pricePerQuintal + priceChangePerQuintal);
    if (newPrice < 0) newPrice = 0.0;

    final updatedInput = baseline.option.copyWith(pricePerQuintal: newPrice);
    return calculateOption(baseline.quantity, updatedInput);
  }

  /// Simulate What If the Farmer Waits scenario
  static WaitingScenarioResult simulateWaitingScenario({
    required double currentNetReturn,
    required double quantity,
    required double futurePricePerQuintal,
    required double currentTotalExpenses,
    required double additionalStorageCost,
    double additionalHandlingCost = 0.0,
  }) {
    final validQty = quantity <= 0 ? 0.0 : quantity;
    final futureGross = calculateGrossValue(validQty, futurePricePerQuintal);
    final futureExpenses = currentTotalExpenses + additionalStorageCost + additionalHandlingCost;
    final futureNet = futureGross - futureExpenses;
    final diff = futureNet - currentNetReturn;
    final isProfitable = diff > 0;

    final advisory = isProfitable
        ? 'यदि भविष्य में भाव ₹${futurePricePerQuintal.toStringAsFixed(0)} मिलता है और भंडारण खर्च ₹${additionalStorageCost.toStringAsFixed(0)} रहता है, तो ₹${diff.toStringAsFixed(0)} अधिक शुद्ध लाभ संभव है। ध्यान रहे कि उपज भंडारण में नमी कमी, कीट प्रकोप और मूल्य अनिश्चितता का जोखिम रहता है।'
        : 'भविष्य में भाव ₹${futurePricePerQuintal.toStringAsFixed(0)} होने पर भी भंडारण व अतिरिक्त खर्च के कारण ₹${(-diff).toStringAsFixed(0)} की कमी आ सकती है। वर्तमान दर पर तुरंत बेचना अधिक सुरक्षित प्रतीत होता है।';

    return WaitingScenarioResult(
      currentNetReturn: currentNetReturn,
      futurePricePerQuintal: futurePricePerQuintal,
      additionalStorageCost: additionalStorageCost,
      additionalHandlingCost: additionalHandlingCost,
      futureGrossValue: futureGross,
      futureTotalExpenses: futureExpenses,
      futureNetReturn: futureNet,
      netEarningsDifference: diff,
      isProfitableToWait: isProfitable,
      advisoryNotes: advisory,
    );
  }
}
