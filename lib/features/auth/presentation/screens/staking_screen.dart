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

  // 🎨 प्रीमियम डार्क नियॉन थीम कलर्स भाई
  static const neonCyan = Color(0xFF00E5FF);
  static const neonGreen = Color(0xFF00FF9F);
  static const darkBackground = Color(0xFF0F172A);
  static const cardBackground = Color(0xFF1E293B);
  static const borderTextColor = Color(0xFF334155);

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
    
    // 🔒 वॉलेट का असली बैलेंस $12,450 पर फॉलबैक सेट भाई
    final double maxSliderLimit = walletState.usdtBalance > 0 ? walletState.usdtBalance : 12450.0;

    // 🪙 लाइव TAO प्राइस (फॉलबैक $350)
    final taoPriceAsync = ref.watch(taoPriceProvider);
    final double currentTaoPrice = taoPriceAsync.maybeWhen(
      data: (price) => price,
      orElse: () => 350.00, 
    );

    // 📦 पैकेज रेट्स लॉजिक
    double dailyRate = 1.0; 
    if (stakingState.selectedPackage == 'Pro') dailyRate = 1.4;
    if (stakingState.selectedPackage == 'VIP') dailyRate = 1.8;

    // 🧮 कैलकुलेशन मैथमेटिक्स भाई
    final double calculatedTao = _currentAmount / currentTaoPrice;
    final double dailyUsdtProfit = _currentAmount * (dailyRate / 100);
    final double monthlyUsdtProfit = dailyUsdtProfit * 30;

    // 🛑 वैलिडेशन चेकपॉइंट्स
    final bool isInsufficient = _currentAmount > maxSliderLimit;
    final bool isInputValid = _currentAmount > 0 && !isInsufficient;

    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: cardBackground,
        elevation: 0,
        title: const Text(
          'STAKE ASSETS', // 🎯 प्रीमियम टाइटल
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18, letterSpacing: 1),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
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
                  // 💵 अवेलेबल फंड कार्ड (पॉलिश लुक भाई)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderTextColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF64748B), size: 20),
                            SizedBox(width: 8),
                            Text(
                              "Available Fund:",
                              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Text(
                          "\$${walletState.usdtBalance.toStringAsFixed(2)} USDT", 
                          style: const TextStyle(color: neonGreen, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Courier'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Select Staking Package',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 16),

                  // 📦 थ्री-टियर पैकेजेस ग्रिड भाई
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

                  // 🎚️ स्लाइडर एडजस्टमेंट टूल
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Slide to Adjust Amount',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
                      ),
                      Text(
                        "\$${_currentAmount.toStringAsFixed(0)} USDT",
                        style: const TextStyle(color: neonCyan, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Courier'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: neonCyan,
                      inactiveTrackColor: borderTextColor,
                      thumbColor: Colors.white,
                      overlayColor: neonCyan.withAlpha(40),
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                    ),
                    child: Slider(
                      value: _currentAmount.clamp(0.0, maxSliderLimit),
                      min: 0.0,
                      max: maxSliderLimit, 
                      onChanged: (double value) {
                        setState(() {
                          _currentAmount = value;
                          _amountController.text = value.toStringAsFixed(0);
                        });
                      },
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("\$0", style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w500)),
                      Text("Max: \$${maxSliderLimit.toStringAsFixed(0)}", style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // ✍️ मैनुअल अमाउंट इनपुट बॉक्स (ग्लोइंग बॉर्डर)
                  const Text(
                    'Or Enter Preferred Amount',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 12),
                  
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: cardBackground,
                      hintText: 'Enter custom amount',
                      hintStyle: const TextStyle(color: Color(0xFF64748B)),
                      suffixText: 'USDT',
                      suffixStyle: const TextStyle(color: neonCyan, fontWeight: FontWeight.bold, fontSize: 15),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: borderTextColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: isInsufficient ? Colors.redAccent : neonCyan, 
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
                          Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 16),
                          SizedBox(width: 6),
                          Text(
                            "Insufficient USDT Balance!", 
                            style: TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 32),

                  // 💎 लाइव यूजर बेनिफिट्स कार्ड (प्राइम डिटेल्स भाई)
                  const Text(
                    'Your Staking Benefits',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 12),
                  
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderTextColor),
                    ),
                    child: Column(
                      children: [
                        _buildBenefitRow(Icons.currency_exchange_rounded, "Estimated TAO Tokens:", "${calculatedTao.toStringAsFixed(4)} TAO"),
                        const Divider(color: borderTextColor, height: 28),
                        _buildBenefitRow(Icons.bolt_rounded, "Daily Profit ($dailyRate%):", "+\$${dailyUsdtProfit.toStringAsFixed(2)} USDT", valueColor: neonGreen),
                        const Divider(color: borderTextColor, height: 28),
                        _buildBenefitRow(Icons.calendar_month_rounded, "Estimated Monthly Profit:", "+\$${monthlyUsdtProfit.toStringAsFixed(2)} USDT", valueColor: neonGreen),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 🚀 फाइनल सबमिट बटन
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: (stakingState.status == StakingStatus.loading || !isInputValid)
                          ? null
                          : () async {
                              bool success = await ref.read(stakingProvider.notifier).stakeTokens(_currentAmount);
                              
                              if (success && mounted) {
                                final StakingPackage dummyPackage = StakingPackage(
                                  name: stakingState.selectedPackage,
                                  dailyPercentage: dailyRate,
                                );

                                String result = ref.read(walletProvider.notifier).deductUsdt(
                                  dollarAmount: _currentAmount,
                                  selectedPackage: dummyPackage,
                                  currentTaoPrice: currentTaoPrice,
                                );

                                if (result == 'SUCCESS') {
                                  _confettiController.play();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: cardBackground,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      duration: const Duration(seconds: 3),
                                      content: Row(
                                        children: [
                                          const Icon(Icons.check_circle_rounded, color: neonGreen, size: 20),
                                          const SizedBox(width: 10),
                                          Text(
                                            '\$${_currentAmount.toStringAsFixed(0)} USDT Staked Successfully! 🚀',
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                  setState(() {
                                    _currentAmount = 100.0;
                                    _amountController.text = "100";
                                  });
                                } else if (result == 'BELOW_MIN_LIMIT') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: cardBackground,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      content: Text(
                                        'The entered amount is insufficient for the ${stakingState.selectedPackage} package.',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.deepOrange,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: cardBackground,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      content: const Text('Insufficient USDT balance in your wallet.', style: TextStyle(color: Colors.white)),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isInputValid ? neonCyan : Colors.grey.shade800,
                        foregroundColor: darkBackground,
                        disabledBackgroundColor: Colors.white10,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: isInputValid ? 4 : 0,
                        shadowColor: neonCyan.withAlpha(100),
                      ),
                      child: stakingState.status == StakingStatus.loading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(color: darkBackground, strokeWidth: 2.5),
                            )
                          : Text(
                              isInsufficient ? 'Insufficient USDT Balance' : 'Confirm & Stake Assets', 
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
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

  // 🚀 हेल्पिंग विजेट्स भाई
  Widget _buildBenefitRow(IconData icon, String title, String value, {Color valueColor = Colors.white}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: neonCyan, size: 18),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
        Text(
          value, 
          style: TextStyle(color: valueColor, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: value.contains('TAO') || value.contains('USDT') ? 'Courier' : null),
        ),
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? neonCyan.withAlpha(25) : cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? neonCyan : borderTextColor,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected ? [BoxShadow(color: neonCyan.withAlpha(30), blurRadius: 8, offset: const Offset(0, 2))] : null,
          ),
          child: Column(
            children: [
              Text(name, style: TextStyle(color: isSelected ? Colors.white : const Color(0xFF94A3B8), fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(rate, style: const TextStyle(color: neonGreen, fontSize: 22, fontWeight: FontWeight.w900, fontFamily: 'Courier')),
              const SizedBox(height: 4),
              const Text('Daily', style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}