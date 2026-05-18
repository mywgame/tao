import 'dart:async'; // 👈 अब इम्पोर्ट एकदम सही है भाई
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tao_boost/core/services/tao_price_service.dart';

// 🚀 ऑटो-रिफ्रेश वाला मॉडर्न AsyncNotifier
class TAOPriceNotifier extends AsyncNotifier<double> {
  Timer? _timer;

  @override
  Future<double> build() async {
    // ⏰ हर 30 सेकंड में प्राइस को ऑटोमैटिक रिफ्रेश करने का लूप चालू करो
    _startPolling();

    // स्क्रीन लोड होते ही पहली बार का लाइव प्राइस
    return await TAOPriceService.fetchLiveTAOPrice();
  }

  void _startPolling() {
    _timer?.cancel();

    // हर 30 सेकंड में बैकग्राउंड में हिट मारेगा भाई
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      // 🚀 Riverpod 3.x में isActive की जगह ref.mounted चेक करते हैं
      if (!ref.mounted) return; 
      
      try {
        final newPrice = await TAOPriceService.fetchLiveTAOPrice();
        state = AsyncValue.data(newPrice);
      } catch (e, stackTrace) {
        // 🚀 यहाँ <double> टाइप स्पेसिफाई कर दिया ताकि टाइप एरर न आए भाई
        state = AsyncValue<double>.error(e, stackTrace).copyWithPrevious(state);
      }
    });

    // 🧹 जैसे ही यह प्रोवाइडर अनमाउंट होगा, टाइमर खत्म!
    ref.onDispose(() {
      _timer?.cancel();
    });
  }

  // अगर यूजर मैन्युअली बटन दबाकर तुरंत रिफ्रेश करना चाहे
  Future<void> forceRefresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => TAOPriceService.fetchLiveTAOPrice());
  }
}

// 🚀 प्रोवाइडर
final taoPriceProvider = AsyncNotifierProvider<TAOPriceNotifier, double>(() {
  return TAOPriceNotifier();
});