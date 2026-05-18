import 'package:flutter/material.dart';
import 'package:tao_boost/core/theme/app_colors.dart';

class K1ClubScreen extends StatefulWidget {
  const K1ClubScreen({super.key});

  @override
  State<K1ClubScreen> createState() => _K1ClubScreenState();
}

class _K1ClubScreenState extends State<K1ClubScreen> {
  // क्लब टियर्स का प्रीमियम डेटा
  final List<Map<String, dynamic>> clubTiers = [
    {
      "name": "Silver Executive",
      "requirement": "Own Team Volume: \$10,000",
      "booster": "+0.2% Daily ROI Boost",
      "color": const Color(0xFF94A3B8),
      "icon": Icons.workspace_premium_outlined,
    },
    {
      "name": "Gold Director",
      "requirement": "Own Team Volume: \$50,000",
      "booster": "+0.5% Daily ROI Boost",
      "color": const Color(0xFFF59E0B), // Golden
      "icon": Icons.stars_outlined,
    },
    {
      "name": "Diamond Ambassador",
      "requirement": "Own Team Volume: \$200,000",
      "booster": "+0.8% Daily ROI Boost",
      "color": const Color(0xFF38BDF8), // Diamond Blue
      "icon": Icons.diamond_outlined,
    },
    {
      "name": "Elite Apex King",
      "requirement": "Own Team Volume: \$500,000+",
      "booster": "+1.2% Global Pool Share",
      "color": const Color(0xFFA855F7), // Royal Purple
      "icon": Icons.bolt_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER (Premium Welcome)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'K1 CLUB',
                            style: TextStyle(
                              fontSize: 26, 
                              fontWeight: FontWeight.w900, 
                              color: const Color(0xFFF59E0B), // Golden Color
                              letterSpacing: 2,
                              shadows: [
                                Shadow(
                                  color: const Color(0xFFF59E0B).withValues(alpha: 0.5),
                                  blurRadius: 10,
                                )
                              ]
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.workspace_premium, color: Color(0xFFF59E0B), size: 24),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'The Ultimate Leadership & VIP Zone',
                        style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 📊 GLOBAL POOL STATS CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF1E293B), const Color(0xFF1E1B4B)], // Dark Indigo Blend
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3), width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("K1 Global Reward Pool", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
                        Icon(Icons.blur_circular, color: Color(0xFFF59E0B), size: 24),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "\$1,245,800.00",
                      style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMiniPoolStat("Active Qualifiers", "42 Members"),
                        _buildMiniPoolStat("Next Payout", "In 3 Days"),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // SECTION TITLE
              const Text(
                'Leadership Club Tiers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),

              // 👑 TIERS LIST
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: clubTiers.length,
                itemBuilder: (context, index) {
                  final tier = clubTiers[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF334155), width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: tier["color"].withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(tier["icon"], color: tier["color"], size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tier["name"],
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: tier["color"]),
                              ),
                              const SizedBox(height: 4),
                              Text(tier["requirement"], style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00FF9F).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tier["booster"],
                            style: const TextStyle(color: Color(0xFF00FF9F), fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // 💎 EXCLUSIVE BENEFITS SECTION
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "K1 Member Privileges",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildPrivilegeRow(Icons.bolt, "Instant Withdrawals (No 24h Hold)"),
                    _buildPrivilegeRow(Icons.card_giftcard, "Weekly TAO Token Airdrops"),
                    _buildPrivilegeRow(Icons.support_agent, "24/7 Dedicated VIP Account Manager"),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniPoolStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPrivilegeRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFF59E0B), size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13))),
        ],
      ),
    );
  }
}