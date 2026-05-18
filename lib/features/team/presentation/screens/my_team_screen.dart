import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MyTeamScreen extends ConsumerWidget {
  const MyTeamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // यहाँ आप अपनी थीम के हिसाब से डमी डेटा या प्रोवाइडर डेटा रख सकते हैं भाई
    final int totalTeamMembers = 14;
    final double totalTeamInvestment = 48500.00;
    final double teamCommissionEarned = 2425.50;

    // डमी टीम मेंबर्स की लिस्ट जो स्क्रीन पर नीचे दिखेगी
    final List<Map<String, String>> teamMembers = [
      {'name': 'Rahul Sharma', 'role': 'Level 1', 'invested': '\$12,500', 'status': 'Active'},
      {'name': 'Amit Verma', 'role': 'Level 1', 'invested': '\$8,000', 'status': 'Active'},
      {'name': 'Priya Patel', 'role': 'Level 2', 'invested': '\$15,000', 'status': 'Active'},
      {'name': 'Vikram Singh', 'role': 'Level 2', 'invested': '\$5,000', 'status': 'Active'},
      {'name': 'Sanjay Gupta', 'role': 'Level 3', 'invested': '\$8,000', 'status': 'Inactive'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // आपकी ऐप की डार्क थीम भाई
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/'), // वापस डैशबोर्ड पर जाने के लिए
        ),
        title: const Text(
          'My Team Network',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👋 टीम वेलकम टेक्स्ट
              const Text(
                'Team Overview 📊',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 4),
              const Text(
                'Track your referral network performance and commissions.',
                style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 24),

              // 📈 टीम स्टेट्स ग्रिड (डैशबोर्ड की तरह)
              LayoutBuilder(
                builder: (context, constraints) {
                  double cardWidth = constraints.maxWidth > 600 ? (constraints.maxWidth - 20) / 2 : constraints.maxWidth;
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _buildTeamStatCard('Total Members', '$totalTeamMembers Users', Icons.group_outlined, cardWidth),
                      _buildTeamStatCard('Team Staked', '\$${totalTeamInvestment.toStringAsFixed(2)}', Icons.monetization_on_outlined, cardWidth),
                      _buildTeamStatCard('Total Commission', '\$${teamCommissionEarned.toStringAsFixed(2)}', Icons.workspace_premium_outlined, cardWidth),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),

              // 👥 टीम मेंबर्स लिस्ट हेडर
              const Text(
                'Active Referral List',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),

              // 📋 मेंबर्स कार्ड लिस्ट
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: teamMembers.length,
                itemBuilder: (context, index) {
                  final member = teamMembers[index];
                  final bool isActive = member['status'] == 'Active';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF334155), width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // प्रोफाइल आइकॉन
                            CircleAvatar(
                              backgroundColor: const Color(0xFF38BDF8).withOpacity(0.1),
                              child: const Icon(Icons.person, color: Color(0xFF38BDF8)),
                            ),
                            const SizedBox(width: 12),
                            // नाम और लेवल
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  member['name']!,
                                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  member['role']!,
                                  style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // इन्वेस्टेड अमाउंट और स्टेटस भाई
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Staked: ${member['invested']}',
                              style: const TextStyle(color: Color(0xFF00FF9F), fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: isActive ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                member['status']!,
                                style: TextStyle(
                                  color: isActive ? Colors.greenAccent : Colors.redAccent,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
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
            ],
          ),
        ),
      ),
    );
  }

  // 📇 कस्टमाइज्ड स्टेट कार्ड विजेट भाई
  Widget _buildTeamStatCard(String title, String value, IconData icon, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          Icon(icon, color: const Color(0xFF38BDF8), size: 26),
        ],
      ),
    );
  }
}