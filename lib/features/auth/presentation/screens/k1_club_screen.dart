import 'package:flutter/material.dart';
import 'package:tao_boost/core/theme/app_colors.dart';

class K1ClubScreen extends StatefulWidget {
  const K1ClubScreen({super.key});

  @override
  State<K1ClubScreen> createState() => _K1ClubScreenState();
}

class _K1ClubScreenState extends State<K1ClubScreen> {
  // 👑 लीडerशिप क्लब टियर्स का प्रीमियम डेटा (सॉलिड और कड़क कलर्स भाई)
  final List<Map<String, dynamic>> clubTiers = [
    {
      "name": "Silver Executive",
      "requirement": "Own Team Volume: \$10,000",
      "booster": "+0.2% Daily ROI Boost",
      "color": const Color(0xFF94A3B8), // सिल्वर ग्रे
      "icon": Icons.workspace_premium_outlined,
    },
    {
      "name": "Gold Director",
      "requirement": "Own Team Volume: \$50,000",
      "booster": "+0.5% Daily ROI Boost",
      "color": const Color(0xFFF59E0B), // गोल्डन
      "icon": Icons.stars_outlined,
    },
    {
      "name": "Diamond Ambassador",
      "requirement": "Own Team Volume: \$200,000",
      "booster": "+0.8% Daily ROI Boost",
      "color": const Color(0xFF00E5FF), // नियॉन सियान डायमंड लुक
      "icon": Icons.diamond_outlined,
    },
    {
      "name": "Elite Apex King",
      "requirement": "Own Team Volume: \$500,000+",
      "booster": "+1.2% Global Pool Share",
      "color": const Color(0xFFA855F7), // रॉयल पर्पल
      "icon": Icons.bolt_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // 🎨 Kaspamine Inspired - लक्ज़री कलर थीम पैलेट भाई
    const neonCyan = Color(0xFF00E5FF);
    const neonGreen = Color(0xFF00FF9F);
    const darkBackground = Color(0xFF0B0F19); // गहरा डीप स्पेस ब्लैक
    const cardBackground = Color(0xFF131C2E); // डार्क ग्लास सरफेस
    const borderTextColor = Color(0xFF1E293B); 

    return Scaffold(
      backgroundColor: darkBackground, 
      body: SafeArea(
        child: Stack(
          children: [
            // ✨ बैकग्राउंड एम्बिएंट वीआईपी ग्लो इफेक्ट
            Positioned(
              top: -60,
              right: -60,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1E1B4B).withOpacity(0.4), // इंडिगो ग्लो
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: neonCyan.withOpacity(0.04),
                ),
              ),
            ),

            SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 📱 HEADER SECTION (प्रीमियम वेलकम)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'K1 CLUB',
                                style: TextStyle(
                                  fontSize: 24, 
                                  fontWeight: FontWeight.w900, 
                                  color: neonCyan, 
                                  letterSpacing: 2,
                                  shadows: [
                                    Shadow(color: neonCyan, blurRadius: 10), // टेक्स्ट पर ग्लो भाई
                                  ]
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: neonCyan.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.workspace_premium_rounded, color: neonCyan, size: 20),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'The Ultimate Leadership & VIP Zone',
                            style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // 📊 GLOBAL POOL STATS CARD (ग्लोबल रिवॉर्ड पूल भाई - सुपर प्रीमियम लुक)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [cardBackground, Color(0xFF0F1423)], 
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: neonCyan.withOpacity(0.2), width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: neonCyan.withOpacity(0.03),
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
                            const Text(
                              "K1 GLOBAL REWARD POOL", 
                              style: TextStyle(color: Color(0xFF475569), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0)
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: neonGreen.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.blur_circular_rounded, color: neonGreen, size: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          "\$1,245,800.00",
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 32, 
                            fontWeight: FontWeight.w900, 
                            letterSpacing: 0.5,
                            fontFamily: 'Courier', // क्रिप्टो लुक फॉन्ट भाई
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // मिनी पूल स्टेट्स की अंदरूनी ग्रिड
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: darkBackground.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildMiniPoolStat("Active Qualifiers", "42 Members"),
                              Container(width: 1, height: 25, color: borderTextColor),
                              _buildMiniPoolStat("Next Payout", "In 3 Days"),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // SECTION TITLE
                  const Text(
                    'Leadership Club Tiers',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.3),
                  ),
                  const SizedBox(height: 16),

                  // 👑 TIERS LIST (रैंक्स की पूरी लिस्ट नियॉन शैडो और बॉर्डर्स के साथ भाई)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: clubTiers.length,
                    itemBuilder: (context, index) {
                      final tier = clubTiers[index];
                      final Color tierColor = tier["color"];
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: cardBackground,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderTextColor, width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: tierColor.withOpacity(0.04), // हर टियर के अपने रंग का हल्का सा बैक ग्लो भाई
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // टियर रैंक का प्रीमियम आइकॉन कंटेनर
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: tierColor.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: tierColor.withOpacity(0.2), width: 1),
                              ),
                              child: Icon(tier["icon"], color: tierColor, size: 24),
                            ),
                            const SizedBox(width: 16),
                            
                            // रैंक का नाम और रिक्वायरमेंट
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tier["name"],
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.2),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    tier["requirement"], 
                                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w500, fontFamily: 'Courier')
                                  ),
                                ],
                              ),
                            ),
                            
                            // बूस्टर वैल्यू बैज
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: neonGreen.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: neonGreen.withOpacity(0.15)),
                              ),
                              child: Text(
                                tier["booster"],
                                style: const TextStyle(color: neonGreen, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.2),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // 💎 EXCLUSIVE PRIVILEGES SECTION (वीआईपी प्रिविलेज बॉक्स भाई)
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderTextColor, width: 1.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.gavel_rounded, color: neonCyan, size: 18),
                            const SizedBox(width: 8),
                            const Text(
                              "K1 Member Privileges",
                              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.3),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildPrivilegeRow(Icons.bolt_rounded, "Instant Withdrawals (No 24h Hold)", neonCyan),
                        _buildPrivilegeRow(Icons.card_giftcard_rounded, "Weekly TAO Token Airdrops", neonCyan),
                        _buildPrivilegeRow(Icons.support_agent_rounded, "24/7 Dedicated VIP Account Manager", neonCyan),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 📊 मिनी स्टेट्स हेल्पर विजेट
  Widget _buildMiniPoolStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF475569), fontSize: 11, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(
          value, 
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Courier')
        ),
      ],
    );
  }

  // 💎 वीआईपी प्रिविलेज रो हेल्पर विजेट
  Widget _buildPrivilegeRow(IconData icon, String text, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text, 
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w500)
            )
          ),
        ],
      ),
    );
  }
}