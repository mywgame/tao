import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tao_boost/core/providers/tao_price_provider.dart';

/// 📂 पैकेज का डेटा होल्ड करने के लिए एक छोटा मॉडल क्लास भाई
class StakingPackage {
  final String name;
  final double dailyPercentage;

  StakingPackage({required this.name, required this.dailyPercentage});
}

/// 📂 कैलकुलेटर की अपडेटेड स्टेट (अब इसमें पैकेज की जानकारी भी स्टोर होगी)
class CalculatorState {
  final double inputAmount;
  final double dailyProfit;
  final double monthlyProfit;
  final double yearlyProfit;
  final StakingPackage selectedPackage; // 👈 करंट सिलेक्टेड पैकेज
  final List<StakingPackage> availablePackages; // 👈 ड्रॉपडाउन के लिए सारे उपलब्ध पैकेजेस

  CalculatorState({
    this.inputAmount = 10.0, // डिफ़ॉल्ट 10 TAO सेट है भाई
    this.dailyProfit = 0.0,
    this.monthlyProfit = 0.0,
    this.yearlyProfit = 0.0,
    StakingPackage? selectedPackage,
    this.availablePackages = const [],
  }) : selectedPackage = selectedPackage ?? StakingPackage(name: 'Pro', dailyPercentage: 1.4);

  // स्टेट को इम्यूटबल (Immutable) रखने के लिए copyWith मेथड
  CalculatorState copyWith({
    double? inputAmount,
    double? dailyProfit,
    double? monthlyProfit,
    double? yearlyProfit,
    StakingPackage? selectedPackage,
    List<StakingPackage>? availablePackages,
  }) {
    return CalculatorState(
      inputAmount: inputAmount ?? this.inputAmount,
      dailyProfit: dailyProfit ?? this.dailyProfit,
      monthlyProfit: monthlyProfit ?? this.monthlyProfit,
      yearlyProfit: yearlyProfit ?? this.yearlyProfit,
      selectedPackage: selectedPackage ?? this.selectedPackage,
      availablePackages: availablePackages ?? this.availablePackages,
    );
  }
}

/// 🚀 Riverpod 3.x का नया और डायनामिक Notifier इंजन
class CalculatorNotifier extends Notifier<CalculatorState> {
  
  // पैकेजेस की मास्टर लिस्ट भाई (Basic, Pro, VIP)
  final List<StakingPackage> _packages = [
    StakingPackage(name: 'Basic', dailyPercentage: 1.0),
    StakingPackage(name: 'Pro', dailyPercentage: 1.4),
    StakingPackage(name: 'VIP', dailyPercentage: 1.8),
  ];

  @override
  CalculatorState build() {
    // 🌟 जैसे ही बैकग्राउंड में लाइव प्राइस बदलेगा, यह लिसनर तुरंत अर्निंग्स दोबारा कैलकुलेट कर देगा
    ref.listen(taoPriceProvider, (previous, next) {
      calculate(amount: state.inputAmount);
    });

    // शुरुआती स्टेट में पैकेजेस लोड कर रहे हैं और डिफ़ॉल्ट 'Pro' सेट कर रहे हैं भाई
    return CalculatorState(
      availablePackages: _packages,
      selectedPackage: _packages[1], // यानी Pro (1.4%)
    );
  }

  /// 📦 पैकेज बदलने का फंक्शन (यह तब कॉल होगा जब यूजर ड्रॉपडाउन से नया पैकेज चुनेगा)
  void selectPackage(StakingPackage package) {
    state = state.copyWith(selectedPackage: package);
    calculate(amount: state.inputAmount, package: package);
  }

  /// 📊 डायनामिक कमाई कैलकुलेट करने का बिजनेस लॉजिक
  void calculate({double? amount, StakingPackage? package}) {
    final targetAmount = amount ?? state.inputAmount;
    final targetPackage = package ?? state.selectedPackage;
    
    // लाइव प्राइस प्रोवाइडर से करंट प्राइस रीड कर रहे हैं भाई
    final priceState = ref.read(taoPriceProvider);
    
    // अगर किसी वजह से प्राइस लोड नहीं हुआ, तो $350 फॉलबैक प्राइस रहेगा
    double currentPrice = 350.0;
    
    // अगर प्राइस सक्सेसफुली आ चुका है, तो उसे वेरिएबल में सेट करो
    priceState.whenData((price) => currentPrice = price);

    // 🪙 कैलकुलेशन फॉर्मूला: (TAO Amount * पैकेज का %) * Current USD Price
    double daily = (targetAmount * targetPackage.dailyPercentage / 100) * currentPrice;
    double monthly = daily * 30;
    double yearly = daily * 365;

    // नई कैलकुलेटेड वैल्यूज से स्टेट को अपडेट कर दो भाई
    state = state.copyWith(
      inputAmount: targetAmount,
      dailyProfit: daily,
      monthlyProfit: monthly,
      yearlyProfit: yearly,
    );
  }
}

/// 🔗 ग्लोबल प्रोवाइडर जो UI में इस्तेमाल होगा
final calculatorProvider = NotifierProvider<CalculatorNotifier, CalculatorState>(() {
  return CalculatorNotifier();
});