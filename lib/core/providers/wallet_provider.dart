import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tao_boost/core/providers/calculator_provider.dart';

// 📝 ट्रांजैक्शन का कड़क मॉडल भाई
class WalletTransaction {
  final String type;
  final String amount;
  final String date;
  final String status;
  final bool isPositive;

  WalletTransaction({
    required this.type,
    required this.amount,
    required this.date,
    required this.status,
    required this.isPositive,
  });
}

class WalletState {
  final double usdtBalance;     // 💵 उपलब्ध फंड डॉलर में
  final double stakedBalance;   // 🔒 कुल स्टेक किए हुए TAO टोकन्स
  final double networkEarnings; // 🌐 कुल रेफ़रल कमीशन
  final List<WalletTransaction> transactions; // 👈 लाइव ट्रांजैक्शन लिस्ट भाई

  WalletState({
    this.usdtBalance = 12450.00,
    this.stakedBalance = 145.82,
    this.networkEarnings = 0.00,
    this.transactions = const [], // शुरुआत में खाली या बेस डेटा दे सकते हैं
  });

  WalletState copyWith({
    double? usdtBalance,
    double? stakedBalance,
    double? networkEarnings,
    List<WalletTransaction>? transactions,
  }) {
    return WalletState(
      usdtBalance: usdtBalance ?? this.usdtBalance,
      stakedBalance: stakedBalance ?? this.stakedBalance,
      networkEarnings: networkEarnings ?? this.networkEarnings,
      transactions: transactions ?? this.transactions,
    );
  }
}

class WalletNotifier extends Notifier<WalletState> {
  @override
  WalletState build() {
    // शुरुआती मॉक ट्रांजैक्शन लिस्ट भाई ताकि स्क्रीन खाली न लगे
    return WalletState(
      transactions: [
        WalletTransaction(type: 'Reward', amount: '+0.452 TAO', date: 'May 16, 2026', status: 'Success', isPositive: true),
        WalletTransaction(type: 'Staked', amount: '-50.000 TAO', date: 'May 14, 2026', status: 'Success', isPositive: false),
        WalletTransaction(type: 'Reward', amount: '+0.448 TAO', date: 'May 12, 2026', status: 'Success', isPositive: true),
      ],
    );
  }

  /// 💰 🚀 टीम रेफ़रल से आने वाले कमीशन को जोड़ने और हिस्ट्री में डालने का फंक्शन भाई
  void addNetworkCommission(double commissionAmount) {
    final newTx = WalletTransaction(
      type: 'Referral Commission',
      amount: '+\$${commissionAmount.toStringAsFixed(2)} USDT',
      date: 'Just Now',
      status: 'Success',
      isPositive: true,
    );

    state = state.copyWith(
      usdtBalance: state.usdtBalance + commissionAmount,
      networkEarnings: state.networkEarnings + commissionAmount,
      transactions: [newTx, ...state.transactions], // 👈 नया ट्रांजैक्शन सबसे ऊपर जुड़ेगा भाई!
    );
  }

  /// 🔄 डॉलर काटना और स्टेक बढ़ाना + हिस्ट्री में एंट्री
  String deductUsdt({
    required double dollarAmount, 
    required StakingPackage selectedPackage, 
    double currentTaoPrice = 350.00
  }) {
    double minRequired = 100.0;
    String packageName = selectedPackage.name.toLowerCase();
    if (packageName.contains('vip')) {
      minRequired = 5000.0;
    } else if (packageName.contains('pro')) {
      minRequired = 1000.0;
    }

    if (dollarAmount < minRequired) {
      return 'BELOW_MIN_LIMIT';
    }

    if (state.usdtBalance < dollarAmount) {
      return 'INSUFFICIENT_FUNDS';
    }

    double taoTokensEarned = dollarAmount / currentTaoPrice;

    final newTx = WalletTransaction(
      type: 'Staked',
      amount: '-${taoTokensEarned.toStringAsFixed(3)} TAO',
      date: 'Just Now',
      status: 'Success',
      isPositive: false,
    );

    state = state.copyWith(
      usdtBalance: state.usdtBalance - dollarAmount,
      stakedBalance: state.stakedBalance + taoTokensEarned,
      transactions: [newTx, ...state.transactions], // 👈 स्टेक का ट्रांजैक्शन भी लाइव जुड़ेगा भाई!
    );
    
    return 'SUCCESS';
  }
}

final walletProvider = NotifierProvider<WalletNotifier, WalletState>(() {
  return WalletNotifier();
});