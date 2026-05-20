import 'package:flutter/material.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  // 🎨 प्रीमियम डार्क नियॉन थीम कलर्स भाई
  static const neonCyan = Color(0xFF00E5FF);
  static const neonGreen = Color(0xFF00FF9F);
  static const darkBackground = Color(0xFF0F172A);
  static const cardBackground = Color(0xFF1E293B);
  static const borderTextColor = Color(0xFF334155);

  @override
  Widget build(BuildContext context) {
    // 📊 डमी ट्रांजैक्शन डेटा की लिस्ट
    final List<Map<String, dynamic>> transactions = [
      {'type': 'Reward', 'amount': '+0.452 TAO', 'date': 'May 16, 2026', 'status': 'Success', 'isPositive': true},
      {'type': 'Staked', 'amount': '-50.000 TAO', 'date': 'May 14, 2026', 'status': 'Success', 'isPositive': false},
      {'type': 'Reward', 'amount': '+0.448 TAO', 'date': 'May 12, 2026', 'status': 'Success', 'isPositive': true},
      {'type': 'Unstaked', 'amount': '+10.000 TAO', 'date': 'May 09, 2026', 'status': 'Success', 'isPositive': true},
      {'type': 'Withdraw', 'amount': '-5.210 TAO', 'date': 'May 05, 2026', 'status': 'Pending', 'isPositive': false},
    ];

    return Scaffold(
      backgroundColor: darkBackground, 
      appBar: AppBar(
        backgroundColor: cardBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'TRANSACTION HISTORY',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: transactions.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history_toggle_off_rounded, color: Color(0xFF64748B), size: 48),
                    SizedBox(height: 12),
                    Text('No transactions found', style: TextStyle(color: Color(0xFF64748B), fontSize: 15, fontWeight: FontWeight.w500)),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final tx = transactions[index];
                  
                  // 🛠️ ट्रांजैक्शन के हिसाब से आइकॉन और कलर असाइनमेंट भाई
                  IconData txIcon = Icons.arrow_upward_rounded;
                  Color txColor = Colors.redAccent;

                  if (tx['type'] == 'Reward') {
                    txIcon = Icons.auto_awesome_rounded;
                    txColor = neonGreen;
                  } else if (tx['type'] == 'Unstaked') {
                    txIcon = Icons.arrow_downward_rounded;
                    txColor = neonCyan;
                  } else if (tx['type'] == 'Staked') {
                    txIcon = Icons.lock_clock_rounded;
                    txColor = Colors.orangeAccent;
                  }

                  // ⏳ स्टेटस कैप्सूल कलर्स
                  final bool isSuccess = tx['status'] == 'Success';
                  final Color statusColor = isSuccess ? neonGreen : Colors.orangeAccent;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBackground,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderTextColor, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 🔄 लेफ्ट साइड: रिफाइंड आइकॉन और डिटेल्स
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: txColor.withAlpha(25),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: txColor.withAlpha(40), width: 1),
                              ),
                              child: Icon(
                                txIcon,
                                color: txColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tx['type'],
                                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.3),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  tx['date'],
                                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                        
                        // 💰 राइट साइड: मोनोस्पेस अमाउंट और पिल स्टेटस
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              tx['amount'],
                              style: TextStyle(
                                color: tx['isPositive'] ? neonGreen : Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Courier', 
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: statusColor.withAlpha(15),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: statusColor.withAlpha(30), width: 0.5),
                              ),
                              child: Text(
                                tx['status'].toUpperCase(),
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}