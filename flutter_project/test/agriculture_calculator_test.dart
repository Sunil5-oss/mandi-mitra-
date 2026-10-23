import 'package:flutter_test/flutter_test.dart';
import '../lib/models/mandi_comparison.dart';
import '../lib/models/selling_decision_model.dart';

void main() {
  group('Mandi Mitra AI - Decision Support & Selling Calculator Tests', () {
    test('Net Return Calculation: Gross, Expenses, Net and Net Per Quintal', () {
      // 50 Quintals at ₹2,500/quintal
      const quantity = 50.0;
      final option = SellingOptionInput(
        id: 'opt_1',
        name: 'Mandi A (Local)',
        pricePerQuintal: 2500.0,
        transportCost: 1500.0,
        loadingUnloadingCost: 500.0,
        labourCost: 400.0,
        packagingCost: 300.0,
        commissionCost: 1250.0, // e.g. 1%
        otherCost: 200.0,
      );

      final calc = SellingDecisionEngine.calculateOption(quantity, option);

      // Gross: 50 * 2500 = 125,000
      expect(calc.grossSaleValue, equals(125000.0));

      // Total Expenses: 1500 + 500 + 400 + 300 + 1250 + 200 = 4,150
      expect(calc.totalExpenses, equals(4150.0));

      // Net Return: 125000 - 4150 = 120,850
      expect(calc.estimatedNetReturn, equals(120850.0));

      // Net Return Per Quintal: 120850 / 50 = 2417.0
      expect(calc.estimatedNetReturnPerQuintal, equals(2417.0));
    });

    test('Two Options with Different Net Returns: Highest Net Return Chosen (Not Highest Price)', () {
      const quantity = 60.0;
      // Option 1: Higher Price (₹2,800) but Heavy Transport (₹8,000)
      final distantMandi = SellingOptionInput(
        id: 'opt_distant',
        name: 'Distant Big Mandi',
        pricePerQuintal: 2800.0,
        transportCost: 8000.0,
        loadingUnloadingCost: 1200.0,
        labourCost: 600.0,
        commissionCost: 2000.0,
      );

      // Option 2: Lower Price (₹2,720) but Very Low Transport & No Commission (Sold at Farmgate / Nearby)
      final localBuyer = SellingOptionInput(
        id: 'opt_local',
        name: 'Local Farmer Producer Org',
        pricePerQuintal: 2720.0,
        transportCost: 800.0,
        loadingUnloadingCost: 400.0,
        labourCost: 300.0,
        commissionCost: 0.0,
      );

      final distantCalc = SellingDecisionEngine.calculateOption(quantity, distantMandi);
      final localCalc = SellingDecisionEngine.calculateOption(quantity, localBuyer);

      // Distant gross = 60 * 2800 = 168,000; expenses = 11,800; net = 156,200
      expect(distantCalc.estimatedNetReturn, equals(156200.0));

      // Local gross = 60 * 2720 = 163,200; expenses = 1,500; net = 161,700
      expect(localCalc.estimatedNetReturn, equals(161700.0));

      // Local buyer gives ₹5,500 more net profit despite a ₹80 lower gross price per quintal!
      final recommendation = SellingDecisionEngine.generateRecommendation(quantity, [distantMandi, localBuyer]);
      expect(recommendation.recommendedOption.option.name, equals('Local Farmer Producer Org'));
      expect(recommendation.earningsDifference, equals(5500.0));
    });

    test('Two Options with Identical Net Returns: Flagged as Financially Close', () {
      const quantity = 40.0;
      final opt1 = SellingOptionInput(
        id: 'opt_1',
        name: 'Mandi X',
        pricePerQuintal: 2500.0,
        transportCost: 2000.0,
      );
      final opt2 = SellingOptionInput(
        id: 'opt_2',
        name: 'Mandi Y',
        pricePerQuintal: 2500.0,
        transportCost: 2000.0,
      );

      final recommendation = SellingDecisionEngine.generateRecommendation(quantity, [opt1, opt2]);
      expect(recommendation.earningsDifference, equals(0.0));
      expect(recommendation.isCloseCall, isTrue);
      expect(recommendation.explanationHindi.contains('काफी नजदीक'), isTrue);
    });

    test('Zero Quantity and Negative / Invalid Input Handling', () {
      // Zero quantity should return 0 gross and 0 per-quintal without divide-by-zero crash
      final zeroCalc = SellingDecisionEngine.calculateOption(
        0.0,
        SellingOptionInput(id: 'opt', name: 'Zero Test', pricePerQuintal: 2400.0, transportCost: 1000.0),
      );
      expect(zeroCalc.grossSaleValue, equals(0.0));
      expect(zeroCalc.estimatedNetReturnPerQuintal, equals(0.0));

      // Negative expenses should be sanitized to 0
      final negativeExpenses = SellingDecisionEngine.calculateTotalExpenses(
        transport: -500.0,
        loadingUnloading: -100.0,
        labour: 300.0,
      );
      expect(negativeExpenses, equals(300.0));
    });

    test('What-If Scenario A: Transportation Cost Changes (Increase and Decrease)', () {
      const quantity = 50.0;
      final baselineInput = SellingOptionInput(
        id: 'mandi_1',
        name: 'Indore Mandi',
        pricePerQuintal: 2600.0,
        transportCost: 3000.0,
      );
      final baselineCalc = SellingDecisionEngine.calculateOption(quantity, baselineInput);

      // Baseline: Gross = 130,000, Exp = 3,000, Net = 127,000
      expect(baselineCalc.estimatedNetReturn, equals(127000.0));

      // Simulate Transport Increases by 20%
      final simIncrease = SellingDecisionEngine.simulateTransportChange(baselineCalc, percentChange: 20.0);
      expect(simIncrease.option.transportCost, equals(3600.0));
      expect(simIncrease.estimatedNetReturn, equals(126400.0));
      expect(simIncrease.estimatedNetReturn - baselineCalc.estimatedNetReturn, equals(-600.0));

      // Simulate Transport Decreases by ₹500
      final simDecrease = SellingDecisionEngine.simulateTransportChange(baselineCalc, absoluteChange: -500.0);
      expect(simDecrease.option.transportCost, equals(2500.0));
      expect(simDecrease.estimatedNetReturn, equals(127500.0));
      expect(simDecrease.estimatedNetReturn - baselineCalc.estimatedNetReturn, equals(500.0));
    });

    test('What-If Scenario B: Buyer Offer Modification (+₹100 / -₹150)', () {
      const quantity = 50.0;
      final baselineInput = SellingOptionInput(
        id: 'mandi_1',
        name: 'Local Buyer',
        pricePerQuintal: 2500.0,
        transportCost: 1000.0,
      );
      final baselineCalc = SellingDecisionEngine.calculateOption(quantity, baselineInput);

      // Offer increased by ₹100/qtl -> net should increase by 50 * 100 = ₹5,000
      final simBetter = SellingDecisionEngine.simulateBuyerOffer(baselineCalc, priceChangePerQuintal: 100.0);
      expect(simBetter.option.pricePerQuintal, equals(2600.0));
      expect(simBetter.estimatedNetReturn - baselineCalc.estimatedNetReturn, equals(5000.0));

      // Offer decreased by ₹150/qtl -> net should decrease by 50 * 150 = ₹7,500
      final simLower = SellingDecisionEngine.simulateBuyerOffer(baselineCalc, priceChangePerQuintal: -150.0);
      expect(simLower.option.pricePerQuintal, equals(2350.0));
      expect(simLower.estimatedNetReturn - baselineCalc.estimatedNetReturn, equals(-7500.0));
    });

    test('What-If Scenario C: Waiting Scenario with Storage and Handling Costs', () {
      const quantity = 60.0;
      const currentNetReturn = 150000.0; // Current immediate sale
      const currentExpenses = 4000.0;

      // Scenario 1: Future price rises to ₹2,800 (Gross = 168,000), storage = ₹5,000, handling = ₹1,000
      // Total expenses = 4000 + 5000 + 1000 = 10,000; Future net = 158,000 -> Profit +₹8,000
      final waitingProfitable = SellingDecisionEngine.simulateWaitingScenario(
        currentNetReturn: currentNetReturn,
        quantity: quantity,
        futurePricePerQuintal: 2800.0,
        currentTotalExpenses: currentExpenses,
        additionalStorageCost: 5000.0,
        additionalHandlingCost: 1000.0,
      );
      expect(waitingProfitable.isProfitableToWait, isTrue);
      expect(waitingProfitable.netEarningsDifference, equals(8000.0));

      // Scenario 2: Future price only rises slightly to ₹2,600 (Gross = 156,000), storage = ₹8,000
      // Total expenses = 12,000; Future net = 144,000 -> Loss of ₹6,000 compared to selling now
      final waitingUnprofitable = SellingDecisionEngine.simulateWaitingScenario(
        currentNetReturn: currentNetReturn,
        quantity: quantity,
        futurePricePerQuintal: 2600.0,
        currentTotalExpenses: currentExpenses,
        additionalStorageCost: 8000.0,
      );
      expect(waitingUnprofitable.isProfitableToWait, isFalse);
      expect(waitingUnprofitable.netEarningsDifference, equals(-6000.0));
    });

    test('Dynamic Recommendation Flip under What-If Transportation Simulation', () {
      const quantity = 50.0;
      final mandiA = SellingOptionInput(
        id: 'A',
        name: 'Mandi A (Far, Higher Price)',
        pricePerQuintal: 2600.0,
        transportCost: 2000.0, // Gross 130k, Exp 2k -> Net 128k
      );
      final mandiB = SellingOptionInput(
        id: 'B',
        name: 'Mandi B (Near, Lower Price)',
        pricePerQuintal: 2570.0,
        transportCost: 600.0, // Gross 128.5k, Exp 600 -> Net 127.9k
      );

      // Baseline: Mandi A wins by ₹100
      final baselineRec = SellingDecisionEngine.generateRecommendation(quantity, [mandiA, mandiB]);
      expect(baselineRec.recommendedOption.option.name, equals('Mandi A (Far, Higher Price)'));

      // If Mandi A transport increases by ₹500 (from 2000 to 2500)
      final simulatedMandiA = mandiA.copyWith(transportCost: 2500.0);
      final simulatedRec = SellingDecisionEngine.generateRecommendation(quantity, [simulatedMandiA, mandiB]);

      // Now Mandi B wins! Net of B (127.9k) > Net of A (127.5k)
      expect(simulatedRec.recommendedOption.option.name, equals('Mandi B (Near, Lower Price)'));
    });
  });
}
