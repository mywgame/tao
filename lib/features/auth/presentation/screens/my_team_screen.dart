import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tao_boost/core/providers/referral_provider.dart';

class MyTeamScreen extends ConsumerWidget {
  const MyTeamScreen({super.key});

  static const neonCyan = Color(0xFF00E5FF);
  static const neonGreen = Color(0xFF00FF9F);
  static const darkBackground = Color(0xFF0F172A);
  static const cardBackground = Color(0xFF1E293B);
  static const borderTextColor = Color(0xFF334155);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 📡 लाइव टीम स्टेट सुनो
    final teamMembers = ref.watch(referralProvider);

    // 🧮 स्टेट्स कैलकुलेशन
    final totalMembers = teamMembers.length;
    final activeMembers = teamMembers.where((m) => m.isActive).length;
    final directReferrals = teamMembers.where((m) => m.role == 'Direct Referral').length;

    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'MY GENEALOGY TEAM',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: neonCyan, letterSpacing: 1.5),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded, color: neonGreen, size: 22),
            onPressed: () {
              ref.read(referralProvider.notifier).registerNewUserWithReferral(
                name: 'Rahul Verma',
                enteredReferralCode: 'TAOBOOST777',
                initialInvestment: '1500',
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🎉 Rahul Verma को TAOBOOST777 कोड से डायरेक्ट टीम में जोड़ा गया!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🎯 माई रेफ़रल कोड डिस्प्ले बॉक्स भाई
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: neonCyan.withOpacity(0.2), width: 1),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 👈 'between' फिक्स होकर 'spaceBetween' हुआ भाई
                children: [
                  Text('YOUR REFERRAL CODE:', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
                  Text('TAOBOOST777', style: TextStyle(color: neonCyan, fontSize: 16, fontWeight: FontWeight.w900, fontFamily: 'Courier')), // 👈 'black' फिक्स होकर 'w900' हुआ भाई
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 📊 लाइव स्टेट्स कार्ड्स
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total Team', '$totalMembers', Colors.white),
                _buildStatItem('Directs', '$directReferrals', neonCyan),
                _buildStatItem('Active', '$activeMembers', neonGreen),
              ],
            ),
            const SizedBox(height: 24),

            const Text(
              'GENEALOGY TREE LIST',
              style: TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
            const SizedBox(height: 12),

            // 🌳 लाइव नेटवर्क टीम लिस्ट रेंडरिंग
            Expanded(
              child: teamMembers.isEmpty
                  ? const Center(child: Text('No members in your network yet.', style: TextStyle(color: Colors.white38)))
                  : ListView.builder(
                      itemCount: teamMembers.length,
                      itemBuilder: (context, index) {
                        final member = teamMembers[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: member.isActive ? neonCyan.withOpacity(0.05) : borderTextColor, width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 👈 फिक्स किया भाई
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(member.name, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        member.role, 
                                        style: TextStyle(
                                          color: member.role == 'Direct Referral' ? neonCyan : const Color(0xFF94A3B8), 
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500
                                        )
                                      ),
                                      const SizedBox(width: 8),
                                      Text('• By: ${member.referredBy}', style: const TextStyle(color: Colors.white38, fontSize: 11)),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    member.investment,
                                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Courier'),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    member.isActive ? 'ACTIVE' : 'INACTIVE',
                                    style: TextStyle(
                                      color: member.isActive ? neonGreen : const Color(0xFF64748B), 
                                      fontSize: 10, 
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.5
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
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Courier'),
        ),
      ],
    );
  }
}