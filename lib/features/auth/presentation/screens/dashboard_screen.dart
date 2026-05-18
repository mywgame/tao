import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart'; 
import 'package:confetti/confetti.dart'; 

import 'package:tao_boost/core/theme/app_colors.dart';
import 'package:tao_boost/core/providers/tao_price_provider.dart';
import 'package:tao_boost/core/providers/calculator_provider.dart';
import 'package:tao_boost/core/providers/wallet_provider.dart'; // 👈 वॉलेट प्रोवाइडर इम्पोर्टेड भाई
import 'package:tao_boost/core/widgets/custom_confetti.dart'; 
import '../widgets/dashboard_shimmer.dart';
import 'profile_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late ConfettiController _dashboardConfettiController;
  final TextEditingController _calcController = TextEditingController(text: "10");

  @override
  void initState() {
    super.initState();
    _dashboardConfettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _dashboardConfettiController.dispose(); 
    _calcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taoPriceState = ref.watch(taoPriceProvider);
    final calcState = ref.watch(calculatorProvider);
    final walletState = ref.watch(walletProvider); // 👈 वॉलेट स्टेट लाइव वॉच हो रही है

    final double currentTaoPrice = taoPriceState.maybeWhen(
      data: (price) => price,
      orElse: () => 350.00,
    );

    final double totalStakedInUsdt = walletState.stakedBalance * currentTaoPrice;
    bool isLoading = false;

    if (isLoading) {
      return buildDashboardShimmer(context);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), 
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Bar Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'TAO BOOST',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF38BDF8), letterSpacing: 1.5),
                      ),
                      
                      taoPriceState.when(
                        data: (price) => _buildPriceBadge("TAO: \$${price.toStringAsFixed(2)}"),
                        loading: () => _buildPriceBadge("Loading..."),
                        error: (_, __) => _buildPriceBadge("TAO: \$350.00"),
                      ),

                      IconButton(
                        icon: const Icon(Icons.account_circle_outlined, color: Colors.white, size: 28),
                        onPressed: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => const ProfileScreen(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeTransition(opacity: animation, child: child);
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome Back, Investor 👋',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Monitor your Bittensor staking performance and earnings.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                  ),
                  const SizedBox(height: 24),
       
                  // Stat Cards Grid (बैलेंस अब प्रोवाइडर से लाइव अपडेट होगा भाई)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double cardWidth = constraints.maxWidth > 600 ? (constraints.maxWidth - 40) / 3 : constraints.maxWidth;
                      return Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: [
                          _buildStatCard(
                            'Total Staked', 
                            '${walletState.stakedBalance.toStringAsFixed(2)} TAO', 
                            '\$${totalStakedInUsdt.toStringAsFixed(2)}', 
                            Icons.account_balance_wallet, 
                            cardWidth,
                          ),
                          _buildStatCard('Current APR', '18.42%', '+1.2% this week', Icons.bolt, cardWidth),
                          _buildStatCard('Total Earnings', '4.21 TAO', '\$1,566.12', Icons.trending_up, cardWidth),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Staking Calculator
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF334155), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calculate_outlined, color: Color(0xFF38BDF8), size: 22),
                                const SizedBox(width: 8),
                                const Text(
                                  'Staking Calculator',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ],
                            ),
          
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F172A),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFF334155)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<StakingPackage>(
                                  value: calcState.selectedPackage,
                                  dropdownColor: const Color(0xFF0F172A),
                                  icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF38BDF8)),
                                  items: calcState.availablePackages.map((package) {
                                    return DropdownMenuItem<StakingPackage>(
                                      value: package,
                                      child: Text(
                                        '${package.name} (${package.dailyPercentage}%)',
                                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (newPackage) {
                                    if (newPackage != null) {
                                      ref.read(calculatorProvider.notifier).selectPackage(newPackage);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _calcController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: "Enter TAO Amount",
                                  labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                                  suffixText: "TAO",
                                  suffixStyle: const TextStyle(color: Colors.white70),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFF334155)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFF38BDF8)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onChanged: (value) => ref.read(calculatorProvider.notifier).calculate(
                                  amount: double.tryParse(value) ?? 0.0, 
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildCalcResult("Daily Est.", "\$${calcState.dailyProfit.toStringAsFixed(2)}"),
                            _buildCalcResult("Monthly Est.", "\$${calcState.monthlyProfit.toStringAsFixed(2)}"),
                            _buildCalcResult("Yearly Est.", "\$${calcState.yearlyProfit.toStringAsFixed(2)}"),
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                  const Text(
                    'Staking Yield History',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  
                  // Chart Container
                  Container(
                    height: 260,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF334155), width: 1),
                    ),
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(
                          show: true,
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              const FlSpot(0, 12),
                              const FlSpot(1, 14),
                              const FlSpot(2, 13),
                              const FlSpot(3, 16),
                              const FlSpot(4, 15),
                              const FlSpot(5, 17),
                              const FlSpot(6, 18.42),
                            ],
                            isCurved: true,
                            color: const Color(0xFF38BDF8),
                            barWidth: 4,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: const Color(0xFF38BDF8).withAlpha(25),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // 📊 Action Buttons (लॉजिक के साथ फिक्स किया हुआ हिस्सा)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // 1️⃣ इनपुट फ़ील्ड से टोकन अमाउंट निकालो और डॉलर वैल्यू कैलकुलेट करो
                            double taoAmount = double.tryParse(_calcController.text) ?? 0.0;
                            double dollarAmount = taoAmount * currentTaoPrice;

                            if (taoAmount <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a valid TAO amount to stake.'), // ✅ English Text
                                  backgroundColor: Colors.orange,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }

                            // 2️⃣ प्रोवाइडर ACTION कॉल करो और पैकेज वैलिडेशन चेक करो भाई
                            String result = ref.read(walletProvider.notifier).deductUsdt(
                                  dollarAmount: dollarAmount,
                                  selectedPackage: calcState.selectedPackage,
                                  currentTaoPrice: currentTaoPrice,
                                );

                            // 3️⃣ रिजल्ट हैंडलिंग
                            if (result == 'SUCCESS') {
                              _dashboardConfettiController.play(); // 🎉 पटाखे चलाओ भाई
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Staking completed successfully! 🚀'), // ✅ English Text
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            } else if (result == 'BELOW_MIN_LIMIT') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'The entered amount is insufficient for the ${calcState.selectedPackage.name} package.', // ✅ English Text
                                  ),
                                  backgroundColor: Colors.deepOrange,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            } else if (result == 'INSUFFICIENT_FUNDS') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Insufficient USDT balance in your wallet.'), // ✅ English Text
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          }, 
                          icon: const Icon(Icons.add_circle_outline),
                          label: const Text('Stake TAO', style: TextStyle(fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF38BDF8),
                            foregroundColor: const Color(0xFF0F172A),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => context.go('/team'), 
                          icon: const Icon(Icons.group_outlined), 
                          label: const Text('My Team', style: TextStyle(fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF334155)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Confetti
            Align(
              alignment: Alignment.topCenter,
              child: CustomConfetti(controller: _dashboardConfettiController),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF00E5FF).withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF00E5FF).withAlpha(76)),
      ),
      child: Row(
        children: [
          const Icon(Icons.show_chart, color: Color(0xFF00FF9F), size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String subtext, IconData icon, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
              Icon(icon, color: const Color(0xFF38BDF8), size: 22),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtext, style: const TextStyle(color: Colors.greenAccent, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCalcResult(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Color(0xFF00FF9F), fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}