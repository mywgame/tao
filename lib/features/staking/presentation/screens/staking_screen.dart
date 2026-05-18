import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';
import 'package:tao_boost/core/providers/staking_provider.dart';
import 'package:tao_boost/core/providers/wallet_provider.dart';
import 'package:tao_boost/core/providers/tao_price_provider.dart';
import 'package:tao_boost/core/providers/calculator_provider.dart'; // 👈 StakingPackage मॉडल के लिए इम्पोर्टेड भाई
import 'package:tao_boost/core/widgets/custom_confetti.dart';

class StakingScreen extends ConsumerStatefulWidget {
  const StakingScreen({super.key});

  @override
  ConsumerState<StakingScreen> createState() => _StakingScreenState();
}

class _StakingScreenState extends ConsumerState<StakingScreen> {
  double _currentAmount = 100.0;
  final TextEditingController _amountController = TextEditingController(text: "100");
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _amountController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stakingState = ref.watch(stakingProvider);
    final walletState = ref.watch(walletProvider);
    
    // 🔒 वॉलेट का असली बैलेंस $12,450 पर सेट
    final double maxSliderLimit = walletState.usdtBalance > 0 ? walletState.usdtBalance : 12450.0;

    // 🪙 लाइव TAO प्राइस (फॉलबैक $350)
    final taoPriceAsync = ref.watch(taoPriceProvider);
    final double currentTaoPrice = taoPriceAsync.maybeWhen(
      data: (price) => price,
      orElse: () => 350.00, 
    );

    // 📦 पैकेज रेट्स
    double dailyRate = 1.0; 
    if (stakingState.selectedPackage == 'Pro') dailyRate = 1.4;
    if (stakingState.selectedPackage == 'VIP') dailyRate = 1.8;

    // 🧮 कैलकुलेशन लॉजिक
    final double calculatedTao = _currentAmount / currentTaoPrice;
    final double dailyUsdtProfit = _currentAmount * (dailyRate / 100);
    final double monthlyUsdtProfit = dailyUsdtProfit * 30;

    // 🛑 वैलिडेशन चेक्स
    final bool isInsufficient = _currentAmount > maxSliderLimit;
    final bool isInputValid = _currentAmount > 0 && !isInsufficient;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('STAKE TEST LIVE', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 💵 अवेलेबल फंड कार्ड
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF64748B), size: 20),
                            SizedBox(width: 8),
                            Text(
                              "Available Fund:",
                              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                            ),
                          ],
                        ),
                        Text(
                          "\$${walletState.usdtBalance.toStringAsFixed(2)} USDT", // Live balance from provider
                          style: const TextStyle(color: Color(0xFF00FF9F), fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Select Staking Package',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      _buildPackageCard('Basic', '1.0%', 1.0, stakingState),
                      const SizedBox(width: 12),
                      _buildPackageCard('Pro', '1.4%', 1.4, stakingState),
                      const SizedBox(width: 12),
                      _buildPackageCard('VIP', '1.8%', 1.8, stakingState),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 🎚️ स्लाइडर टाइटल और लाइव अमाउंट
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Slide to Adjust Amount',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        "\$${_currentAmount.toStringAsFixed(0)} USDT",
                        style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Slider(
                    value: _currentAmount.clamp(0.0, maxSliderLimit),
                    min: 0.0,
                    max: maxSliderLimit, 
                    activeColor: const Color(0xFF38BDF8),
                    inactiveColor: const Color(0xFF1E293B),
                    onChanged: (double value) {
                      setState(() {
                        _currentAmount = value;
                        _amountController.text = value.toStringAsFixed(0);
                      });
                    },
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("\$0", style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                      Text("Max: \$${maxSliderLimit.toStringAsFixed(0)}", style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ✍️ मैनुअल अमाउंट इनपुट बॉक्स
                  const Text(
                    'Or Enter Preferred Amount',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF1E293B),
                      hintText: 'Enter custom amount',
                      hintStyle: const TextStyle(color: Color(0xFF64748B)),
                      suffixText: 'USDT',
                      suffixStyle: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF334155)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: isInsufficient ? Colors.redAccent : const Color(0xFF38BDF8), 
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      double? parsedValue = double.tryParse(value);
                      if (parsedValue != null) {
                        setState(() {
                          _currentAmount = parsedValue;
                        });
                      }
                    },
                  ),

                  if (isInsufficient)
                    const Padding(
                      padding: EdgeInsets.only(top: 10, left: 4),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.redAccent, size: 16),
                          SizedBox(width: 6),
                          Text(
                            "Insufficient USDT Balance!",
                            style: TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 32),

                  // 💎 लाइव यूजर बेनिफिट्स कार्ड
                  const Text(
                    'Your Staking Benefits',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Column(
                      children: [
                        _buildBenefitRow(Icons.currency_exchange, "Estimated TAO Tokens:", "${calculatedTao.toStringAsFixed(4)} TAO"),
                        const Divider(color: Color(0xFF334155), height: 24),
                        _buildBenefitRow(Icons.wb_sunny_outlined, "Daily Profit ($dailyRate%):", "+\$${dailyUsdtProfit.toStringAsFixed(2)} USDT"),
                        const Divider(color: Color(0xFF334155), height: 24),
                        _buildBenefitRow(Icons.calendar_month_outlined, "Estimated Monthly Profit:", "+\$${monthlyUsdtProfit.toStringAsFixed(2)} USDT"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 🚀 सबमिट बटन (लॉजिक और पैरामीटर्स फिक्स भाई)
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: (stakingState.status == StakingStatus.loading || !isInputValid)
                          ? null
                          : () async {
                              // API पर स्टोकन स्टेक करने की कोशिश
                              bool success = await ref.read(stakingProvider.notifier).stakeTokens(_currentAmount);
                              
                              if (success && mounted) {
                                // 📦 स्क्रीन की सिलेक्टेड स्ट्रिंग को StakingPackage मॉडल ऑब्जेक्ट में मैप करो भाई
                                final StakingPackage dummyPackage = StakingPackage(
                                  name: stakingState.selectedPackage,
                                  dailyPercentage: dailyRate,
                                );

                                // 🔄 वॉलेट में नेम्ड पैरामीटर्स के साथ डॉलर डिडक्ट करो
                                String result = ref.read(walletProvider.notifier).deductUsdt(
                                  dollarAmount: _currentAmount,
                                  selectedPackage: dummyPackage,
                                  currentTaoPrice: currentTaoPrice,
                                );

                                if (result == 'SUCCESS') {
                                  _confettiController.play();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('\$${_currentAmount.toStringAsFixed(0)} USDT Staked Successfully! 🚀'), 
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  setState(() {
                                    _currentAmount = 100.0;
                                    _amountController.text = "100";
                                  });
                                } else if (result == 'BELOW_MIN_LIMIT') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('The ammount is ${stakingState.selectedPackage} insufficiant for the package ⚠️'),
                                      backgroundColor: Colors.deepOrange,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Error: Insufficient USDT Balance! 💵'), 
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isInputValid ? const Color(0xFF38BDF8) : Colors.grey.shade800,
                        foregroundColor: const Color(0xFF0F172A),
                        disabledBackgroundColor: Colors.white10,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: stakingState.status == StakingStatus.loading
                          ? const CircularProgressIndicator(color: Color(0xFF0F172A))
                          : Text(
                              isInsufficient ? 'Insufficient USDT Balance' : 'Confirm & Stake Fund', 
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),

            Align(
              alignment: Alignment.topCenter,
              child: CustomConfetti(controller: _confettiController),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitRow(IconData icon, String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF38BDF8), size: 18),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
          ],
        ),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPackageCard(String name, String rate, double apy, StakingState state) {
    bool isSelected = state.selectedPackage == name;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(stakingProvider.notifier).selectPackage(name, apy);
          setState(() {});
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF38BDF8).withAlpha(25) : const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF38BDF8) : const Color(0xFF334155),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(name, style: TextStyle(color: isSelected ? Colors.white : const Color(0xFF94A3B8), fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(rate, style: const TextStyle(color: Color(0xFF00FF9F), fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              const Text('Daily', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}