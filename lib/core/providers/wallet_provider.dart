import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tao_boost/core/providers/calculator_provider.dart'; // 👈 StakingPackage मॉडल के लिए इम्पोर्ट करें

class WalletState {
  final double usdtBalance;    // 💵 उपलब्ध फंड डॉलर में
  final double stakedBalance;  // 🔒 कुल स्टेक किए हुए TAO टोकन्स

  WalletState({
    this.usdtBalance = 12450.00,
    this.stakedBalance = 145.82,
  });

  WalletState copyWith({
    double? usdtBalance,
    double? stakedBalance,
  }) {
    return WalletState(
      usdtBalance: usdtBalance ?? this.usdtBalance,
      stakedBalance: stakedBalance ?? this.stakedBalance,
    );
  }
}

class WalletNotifier extends Notifier<WalletState> {
  @override
  WalletState build() {
    return WalletState();
  }

  /// 🔄 डॉलर काटना और लिमिट्स चेक करना
  /// रिटर्न वैल्यू:
  /// 'SUCCESS' -> ट्रांजैक्शन सफल रहा भाई
  /// 'INSUFFICIENT_FUNDS' -> वॉलेट में डॉलर कम हैं
  /// 'BELOW_MIN_LIMIT' -> पैकेज की मिनिमम लिमिट से कम अमाउंट है
  String deductUsdt({
    required double dollarAmount, 
    required StakingPackage selectedPackage, 
    double currentTaoPrice = 350.00
  }) {
    // 1️⃣ सबसे पहले पैकेज के हिसाब से मिनिमम लिमिट तय करो भाई
    double minRequired = 100.0; // Default Basic के लिए
    
    String packageName = selectedPackage.name.toLowerCase();
    if (packageName.contains('vip')) {
      minRequired = 5000.0; // VIP के लिए मिनिमम $5000
    } else if (packageName.contains('pro')) {
      minRequired = 1000.0; // Pro के लिए मिनिमम $1000
    }

    // 2️⃣ चेक करो कि अमाउंट मिनिमम लिमिट से कम तो नहीं है?
    if (dollarAmount < minRequired) {
      return 'BELOW_MIN_LIMIT'; // ❌ लिमिट से कम है भाई!
    }

    // 3️⃣ चेक करो कि वॉलेट में पर्याप्त बैलेंस है या नहीं?
    if (state.usdtBalance < dollarAmount) {
      return 'INSUFFICIENT_FUNDS'; // ❌ पैसे कम हैं भाई!
    }

    // 4️⃣ अगर सब सही है, तो बैलेंस काटो और स्टेक बढ़ाओ
    double taoTokensEarned = dollarAmount / currentTaoPrice;

    state = state.copyWith(
      usdtBalance: state.usdtBalance - dollarAmount,
      stakedBalance: state.stakedBalance + taoTokensEarned,
    );
    
    return 'SUCCESS'; // ✅ सब परफेक्ट रहा भाई!
  }
}

final walletProvider = NotifierProvider<WalletNotifier, WalletState>(() {
  return WalletNotifier();
});