import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tao_boost/core/providers/wallet_provider.dart'; // 👈 वॉलेट प्रोवाइडर लिंक किया भाई

// 👤 टीम मेंबर का कड़क मॉडल
class TeamMember {
  final String name;
  final String role; // 'Direct Referral' या 'Indirect Team'
  final String joinedDate;
  final String investment;
  final bool isActive;
  final String referredBy;

  TeamMember({
    required this.name,
    required this.role,
    required this.joinedDate,
    required this.investment,
    required this.isActive,
    required this.referredBy,
  });
}

// 🧠 रेफ़रल और टीम ट्री स्टेट नोटिफायर
class ReferralNotifier extends Notifier<List<TeamMember>> {
  @override
  List<TeamMember> build() {
    return [
      TeamMember(name: 'Arjun Sharma', role: 'Direct Referral', joinedDate: 'May 10, 2026', investment: '\$1,200 USDT', isActive: true, referredBy: 'YOU'),
      TeamMember(name: 'Sarah Khan', role: 'Direct Referral', joinedDate: 'May 08, 2026', investment: '\$2,500 USDT', isActive: true, referredBy: 'YOU'),
      TeamMember(name: 'Rajesh Patel', role: 'Indirect Team', joinedDate: 'May 02, 2026', investment: '\$500 USDT', isActive: true, referredBy: 'Arjun Sharma'),
      TeamMember(name: 'Michael Chang', role: 'Indirect Team', joinedDate: 'Apr 28, 2026', investment: '\$0 USDT', isActive: false, referredBy: 'Sarah Khan'),
    ];
  }

  // 🚀 नया मेंबर जोड़ना + लाइव वॉलेट कमीशन बांटना भाई
  void registerNewUserWithReferral({
    required String name,
    required String enteredReferralCode,
    required String initialInvestment,
  }) {
    bool isDirect = (enteredReferralCode.toUpperCase() == 'TAOBOOST777');
    double investmentAmount = double.tryParse(initialInvestment) ?? 0.0;
    
    final newMember = TeamMember(
      name: name,
      role: isDirect ? 'Direct Referral' : 'Indirect Team',
      joinedDate: 'Just Now',
      investment: '\$$initialInvestment USDT',
      isActive: investmentAmount > 0,
      referredBy: isDirect ? 'YOU' : 'Sub-Partner',
    );

    // 1️⃣ सबसे पहले टीम लिस्ट अपडेट करो भाई
    state = [...state, newMember];

    // 2️⃣ अगर नए यूजर ने इन्वेस्टमेंट किया है, तो कमीशन काटो और वॉलेट में भेजो भाई
    if (investmentAmount > 0) {
      double commissionEarned = 0.0;
      
      if (isDirect) {
        // Level 1 (Direct Referral): 10% कमीशन
        commissionEarned = investmentAmount * 0.10;
      } else {
        // Level 2 (Indirect Team): 5% कमीशन
        commissionEarned = investmentAmount * 0.05;
      }

      // ⚡ वॉलेट प्रोवाइडर में कमीशन पुश करने का सबसे सही तरीका भाई
      if (commissionEarned > 0) {
        ref.read(walletProvider.notifier).addNetworkCommission(commissionEarned);
      }
    }
  }
}

// 🌐 ग्लोबल प्रोवाइडर
final referralProvider = NotifierProvider<ReferralNotifier, List<TeamMember>>(() {
  return ReferralNotifier();
});