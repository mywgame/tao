import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 📂 स्टेकिंग की अलग-अलग स्टेट्स के लिए Enum
enum StakingStatus { idle, loading, success, error }

/// 📂 Staking Screen की स्टेट को होल्ड करने वाला मॉडल
class StakingState {
  final double selectedApy; // 1.0, 1.4, या 1.8%
  final String selectedPackage; // "Basic", "Pro", "VIP"
  final StakingStatus status;
  final String? errorMessage;

  StakingState({
    this.selectedApy = 1.4, // डिफ़ॉल्ट Pro पैकेज
    this.selectedPackage = 'Pro',
    this.status = StakingStatus.idle,
    this.errorMessage,
  });

  StakingState copyWith({
    double? selectedApy,
    String? selectedPackage,
    StakingStatus? status,
    String? errorMessage,
  }) {
    return StakingState(
      selectedApy: selectedApy ?? this.selectedApy,
      selectedPackage: selectedPackage ?? this.selectedPackage,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// 🚀 Riverpod 3.x का नया Notifier इंजन स्टेकिंग के लिए
class StakingNotifier extends Notifier<StakingState> {
  @override
  StakingState build() {
    return StakingState();
  }

  // पैकेज बदलने का फंक्शन
  void selectPackage(String package, double apy) {
    state = state.copyWith(selectedPackage: package, selectedApy: apy);
  }

  // स्टेक सबमिट करने का नकली API कॉल (Mocking API) भाई
  Future<bool> stakeTokens(double amount) async {
    if (amount <= 0) {
      state = state.copyWith(status: StakingStatus.error, errorMessage: 'Please enter a valid amount');
      return false;
    }

    state = state.copyWith(status: StakingStatus.loading);

    try {
      // ⏳ 2 सेकंड का नकली नेटवर्क डिले (Dio या API कॉल की जगह)
      await Future.delayed(const Duration(seconds: 2));
      
      state = state.copyWith(status: StakingStatus.success);
      return true;
    } catch (e) {
      state = state.copyWith(status: StakingStatus.error, errorMessage: e.toString());
      return false;
    }
  }

  // स्टेट को वापस नॉर्मल करने के लिए
  void resetStatus() {
    state = state.copyWith(status: StakingStatus.idle, errorMessage: null);
  }
}

/// 🔗 ग्लोबल प्रोवाइडर
final stakingProvider = NotifierProvider<StakingNotifier, StakingState>(() {
  return StakingNotifier();
});

