import 'package:flutter/material.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

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
      backgroundColor: const Color(0xFF0F172A), // हमारा प्रीमियम डार्क थीम
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'TRANSACTION HISTORY',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8), letterSpacing: 1.5),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: transactions.isEmpty
            ? const Center(
                child: Text('No transactions found', style: TextStyle(color: Color(0xFF64748B))),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final tx = transactions[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF334155), width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 🔄 लेफ्ट साइड: आइकॉन और नाम/तारीख
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: tx['isPositive'] 
                                    ? Colors.greenAccent.withValues(alpha: 0.1)
                                    : Colors.redAccent.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                tx['type'] == 'Reward' 
                                    ? Icons.auto_awesome_rounded 
                                    : tx['isPositive'] ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                                color: tx['isPositive'] ? Colors.greenAccent : Colors.redAccent,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tx['type'],
                                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  tx['date'],
                                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // 💰 राइट साइड: अमाउंट और स्टेटस
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              tx['amount'],
                              style: TextStyle(
                                color: tx['isPositive'] ? Colors.greenAccent : Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Courier', // क्रिप्टो अमाउंट के लिए बेस्ट फॉन्ट
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: tx['status'] == 'Success' 
                                    ? Colors.greenAccent.withValues(alpha: 0.05)
                                    : Colors.orangeAccent.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                tx['status'],
                                style: TextStyle(
                                  color: tx['status'] == 'Success' ? Colors.greenAccent : Colors.orangeAccent,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
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