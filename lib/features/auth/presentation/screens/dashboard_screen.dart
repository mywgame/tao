import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart'; 
import 'package:confetti/confetti.dart'; 

import 'package:tao_boost/core/theme/app_colors.dart';
import 'package:tao_boost/core/providers/tao_price_provider.dart';
import 'package:tao_boost/core/providers/calculator_provider.dart';
import 'package:tao_boost/core/providers/wallet_provider.dart'; 
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
    final walletState = ref.watch(walletProvider); 

    final double currentTaoPrice = taoPriceState.maybeWhen(
      data: (price) => price,
      orElse: () => 350.00,
    );

    final double totalStakedInUsdt = walletState.stakedBalance * currentTaoPrice;
    bool isLoading = false;

    if (isLoading) {
      return buildDashboardShimmer(context);
    }

    // 🎨 Kaspamine Inspired - लक्ज़री नियॉन कलर पैलेट भाई
    const neonCyan = Color(0xFF00E5FF);
    const neonGreen = Color(0xFF00FF9F);
    const darkBackground = Color(0xFF0B0F19); // और ज़्यादा गहरा डीप स्पेस ब्लैक
    const cardBackground = Color(0xFF131C2E); // डार्क ग्लास सरफेस कलर
    const borderTextColor = Color(0xFF1E293B); 

    return Scaffold(
      backgroundColor: darkBackground, 
      body: SafeArea(
        child: Stack(
          children: [
            // ✨ बैकग्राउंड एम्बिएंट ग्लो इफेक्ट
            Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: neonCyan.withOpacity(0.06),
                ),
              ),
            ),
            
            SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 📱 APP BAR SECTION
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'TAO BOOST',
                        style: TextStyle(
                          fontSize: 22, 
                          fontWeight: FontWeight.w900, 
                          color: neonCyan, 
                          letterSpacing: 2.0,
                          shadows: [
                            Shadow(color: neonCyan, blurRadius: 10),
                          ],
                        ),
                      ),
                      
                      taoPriceState.when(
                        data: (price) => _buildPriceBadge("TAO: \$${price.toStringAsFixed(2)}"),
                        loading: () => _buildPriceBadge("Loading..."),
                        error: (_, __) => _buildPriceBadge("TAO: \$350.00"),
                      ),

                      IconButton(
                        icon: const Icon(Icons.account_circle_outlined, color: Colors.white70, size: 26),
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
                  const SizedBox(height: 28),
                  
                  // वेलकम हेडर सेक्शन
                  const Text(
                    'Welcome Back, Investor',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.3),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Monitor your Bittensor staking performance and earnings.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 28),
       
                  // 📊 STAT CARDS GRID (अब 4 रिस्पॉन्सिव और फुली लाइव कार्ड्स भाई!)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // बड़ी स्क्रीन्स पर 2-2 कार्ड्स और मोबाइल पर फुल विड्थ ग्रिड भाई
                      double cardWidth = constraints.maxWidth > 600 ? (constraints.maxWidth - 16) / 2 : constraints.maxWidth;
                      return Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          _buildStatCard(
                            'Total Staked', 
                            '${walletState.stakedBalance.toStringAsFixed(2)} TAO', 
                            '\$${totalStakedInUsdt.toStringAsFixed(2)}', 
                            Icons.account_balance_wallet_outlined, 
                            cardWidth,
                          ),
                          _buildStatCard(
                            'Current APR', 
                            '18.42%', 
                            '+1.2% this week', 
                            Icons.bolt_outlined, 
                            cardWidth,
                          ),
                          // 💵 1. उपलब्ध लाइव USDT बैलेंस कार्ड जो रेफ़रल आते ही बढ़ेगा भाई!
                          _buildStatCard(
                            'Available USDT', 
                            '\$${walletState.usdtBalance.toStringAsFixed(2)}', 
                            'Ready to Stake', 
                            Icons.monetization_on_outlined, 
                            cardWidth,
                          ),
                          // 🌐 2. लाइव नेटवर्क अर्निंग्स कार्ड जो राहुल वर्मा को जोड़ते ही बढ़ेगा भाई!
                          _buildStatCard(
                            'Network Earnings', 
                            '\$${walletState.networkEarnings.toStringAsFixed(2)} USDT', 
                            'From Team Tree', 
                            Icons.trending_up_rounded, 
                            cardWidth,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 28),

                  // 🧮 STAKING CALCULATOR SECTION
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: neonCyan.withOpacity(0.15), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: neonCyan.withOpacity(0.02),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calculate_outlined, color: neonCyan, size: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  'Staking Calculator',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.3),
                                ),
                              ],
                            ),
          
                            // प्रीमियम पैकेज ड्रॉपडाउन पिल
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                              decoration: BoxDecoration(
                                color: darkBackground,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: borderTextColor, width: 1.5),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<StakingPackage>(
                                  value: calcState.selectedPackage,
                                  dropdownColor: darkBackground,
                                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: neonCyan, size: 18),
                                  items: calcState.availablePackages.map((package) {
                                    return DropdownMenuItem<StakingPackage>(
                                      value: package,
                                      child: Text(
                                        '${package.name} (${package.dailyPercentage}%)',
                                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
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
                        const SizedBox(height: 20),
                        
                        // मॉडर्न इनपुट फील्ड भाई
                        TextField(
                          controller: _calcController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Courier', fontSize: 16),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: darkBackground.withOpacity(0.5),
                            labelText: "Enter TAO Amount",
                            labelStyle: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w500, fontSize: 13),
                            suffixText: "TAO",
                            suffixStyle: const TextStyle(color: neonCyan, fontWeight: FontWeight.bold, fontFamily: 'Courier'),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: borderTextColor),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: neonCyan, width: 1.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: (value) => ref.read(calculatorProvider.notifier).calculate(
                            amount: double.tryParse(value) ?? 0.0, 
                          ),
                        ),
                        const SizedBox(height: 22),
                        
                        // एस्टिमेटेड प्रॉफिट रिजल्ट्स
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                          decoration: BoxDecoration(
                            color: darkBackground.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildCalcResult("Daily Est.", "\$${calcState.dailyProfit.toStringAsFixed(2)}"),
                              Container(width: 1, height: 25, color: borderTextColor),
                              _buildCalcResult("Monthly Est.", "\$${calcState.monthlyProfit.toStringAsFixed(2)}"),
                              Container(width: 1, height: 25, color: borderTextColor),
                              _buildCalcResult("Yearly Est.", "\$${calcState.yearlyProfit.toStringAsFixed(2)}"),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                  const Text(
                    'Staking Yield History',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.3),
                  ),
                  const SizedBox(height: 16),
                  
                  // 📈 CHART CONTAINER
                  Container(
                    height: 240,
                    padding: const EdgeInsets.only(top: 24, bottom: 12, right: 20, left: 10),
                    decoration: BoxDecoration(
                      color: cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderTextColor, width: 1),
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
                            color: neonCyan, 
                            barWidth: 3.5,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  neonCyan.withOpacity(0.15),
                                  neonCyan.withOpacity(0.00),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  
                  // ⚡ ACTION BUTTONS
                  Row(
                    children: [
                      // स्टेक TAO बटन
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: neonGreen.withOpacity(0.2), 
                                blurRadius: 15,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              double taoAmount = double.tryParse(_calcController.text) ?? 0.0;
                              double dollarAmount = taoAmount * currentTaoPrice;

                              if (taoAmount <= 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter a valid TAO amount to stake.'),
                                    backgroundColor: Colors.orange,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                return;
                              }

                              String result = ref.read(walletProvider.notifier).deductUsdt(
                                    dollarAmount: dollarAmount,
                                    selectedPackage: calcState.selectedPackage,
                                    currentTaoPrice: currentTaoPrice,
                                  );

                              if (result == 'SUCCESS') {
                                _dashboardConfettiController.play(); 
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Staking completed successfully! 🚀'),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              } else if (result == 'BELOW_MIN_LIMIT') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'The entered amount is insufficient for the ${calcState.selectedPackage.name} package.',
                                    ),
                                    backgroundColor: Colors.deepOrange,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              } else if (result == 'INSUFFICIENT_FUNDS') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Insufficient USDT balance in your wallet.'),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }, 
                            icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                            label: const Text('STAKE TAO', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1.0)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: neonGreen, 
                              foregroundColor: const Color(0xFF06111C),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // माई टीम बटन
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => context.go('/team'), 
                          icon: const Icon(Icons.group_outlined, size: 18, color: Colors.white70), 
                          label: const Text('MY TEAM', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1.0, color: Colors.white)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF334155), width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            backgroundColor: cardBackground.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 🎊 कॉन्फेटी विजेट
            Align(
              alignment: Alignment.topCenter,
              child: CustomConfetti(controller: _dashboardConfettiController),
            ),
          ],
        ),
      ),
    );
  }

  // 🏷️ लाइव प्राइस दिखाने वाला बैज विजेट
  Widget _buildPriceBadge(String label) {
    const neonCyan = Color(0xFF00E5FF);
    const neonGreen = Color(0xFF00FF9F);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: neonCyan.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: neonCyan.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.circle, color: neonGreen, size: 8), 
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Courier'),
          ),
        ],
      ),
    );
  }

  // 🎴 स्टेट्स कार्ड्स बनाने वाला प्रीमियम हेल्पर विजेट
  Widget _buildStatCard(String title, String value, String subtext, IconData icon, double width) {
    const neonCyan = Color(0xFF00E5FF);
    const neonGreen = Color(0xFF00FF9F);
    const cardBackground = Color(0xFF131C2E);
    const borderTextColor = Color(0xFF1E293B);

    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderTextColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Color(0xFF475569), fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
              Icon(icon, color: neonCyan.withOpacity(0.8), size: 20),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            value, 
            style: const TextStyle(
              color: Colors.white, 
              fontSize: 22, 
              fontWeight: FontWeight.bold, 
              letterSpacing: 0.5,
              fontFamily: 'Courier' 
            )
          ),
          const SizedBox(height: 6),
          Text(subtext, style: const TextStyle(color: neonGreen, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Courier')),
        ],
      ),
    );
  }

  // 🧮 कैल्कुलेटर Result विजेट
  Widget _buildCalcResult(String title, String value) {
    const neonGreen = Color(0xFF00FF9F);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: const TextStyle(color: Color(0xFF475569), fontSize: 11, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(
          value, 
          style: const TextStyle(
            color: neonGreen, 
            fontSize: 15, 
            fontWeight: FontWeight.bold,
            fontFamily: 'Courier'
          )
        ),
      ],
    );
  }
}
