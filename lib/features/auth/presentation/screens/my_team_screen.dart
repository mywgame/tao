import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

class MyTeamScreen extends StatefulWidget {
  const MyTeamScreen({super.key});

  @override
  State<MyTeamScreen> createState() => _MyTeamScreenState();
}

class _MyTeamScreenState extends State<MyTeamScreen> {
  final String referralCode = "TAO-BOOST-89X7";
  final String referralLink = "https://taoboost.io/register?ref=TAO-BOOST-89X7";

  // 📋 डमी टीम डेटा (असली ऐप में यह API से आएगा)
  final List<Map<String, dynamic>> teamMembers = [
    {"name": "Rahul Sharma", "level": "Level 1", "staked": "45.50 TAO", "status": "Active", "color": Colors.greenAccent},
    {"name": "Ankit Verma", "level": "Level 1", "staked": "12.00 TAO", "status": "Active", "color": Colors.greenAccent},
    {"name": "Vikram Singh", "level": "Level 2", "staked": "110.00 TAO", "status": "Active", "color": Colors.greenAccent},
    {"name": "Amit Patel", "level": "Level 2", "staked": "0.00 TAO", "status": "Inactive", "color": Colors.redAccent},
    {"name": "Suresh Raina", "level": "Level 3", "staked": "5.25 TAO", "status": "Active", "color": Colors.greenAccent},
  ];

  void _copyToClipboard(String text, String message) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        content: Text("🎉 $message", style: const TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // हमारी डार्क थीम
      appBar: AppBar(
        title: const Text("Referral & My Team", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 💰 Referral Stats Card
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total Referral Earnings", style: TextStyle(color: Colors.white70, fontSize: 14)),
                        SizedBox(height: 6),
                        Text("18.45 TAO", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF00FF9F))),
                        Text("≈ \$6,850.00", style: TextStyle(color: Colors.white38, fontSize: 12)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFF38BDF8).withAlpha(25), shape: BoxShape.circle),
                      child: const Icon(Icons.monetization_on_rounded, size: 35, color: Color(0xFF00E5FF)),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 🔗 Referral Link Sharing Box
            const Text("Invite Your Friends", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                children: [
                  // Code Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Your Referral Code", style: TextStyle(color: Colors.white54, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(referralCode, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy_rounded, color: Color(0xFF38BDF8)),
                        onPressed: () => _copyToClipboard(referralCode, "Referral Code Copied!"),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFF334155), height: 24),
                  // Link Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Referral Link", style: TextStyle(color: Colors.white54, fontSize: 12)),
                            SizedBox(height: 4),
                            Text("https://taoboost.io/register?...", style: TextStyle(color: Colors.white70, fontSize: 14), overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _copyToClipboard(referralLink, "Registration Link Copied!"),
                        icon: const Icon(Icons.share_rounded, size: 16),
                        label: const Text("Copy"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00E5FF),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            //👥 Team Statistics Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("My Network Team", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFF334155), borderRadius: BorderRadius.circular(20)),
                  child: Text("${teamMembers.length} Members", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 📋 Team Members List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: teamMembers.length,
              itemBuilder: (context, index) {
                final member = teamMembers[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left side: Name & Level
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFF334155),
                            child: Text(member["name"][0], style: const TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(member["name"], style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(member["level"], style: const TextStyle(color: Colors.white54, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      // Right side: Staked Amount & Status
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(member["staked"], style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(
                            member["status"],
                            style: TextStyle(color: member["color"], fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}