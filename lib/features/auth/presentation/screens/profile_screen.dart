import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'transaction_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎨 प्रीमियम डार्क नियॉन-सियान थीम कलर्स भाई
    const neonCyan = Color(0xFF00E5FF);
    const neonGreen = Color(0xFF00FF9F);
    const darkBackground = Color(0xFF0F172A);
    const cardBackground = Color(0xFF1E293B);
    const borderTextColor = Color(0xFF334155);

    // टेस्ट के लिए एक डमी TAO वॉलेट एड्रेस भाई
    const String walletAddress = "5GsnB...W7q9Xzp8YvM4kRbc2hT5";

    return Scaffold(
      backgroundColor: darkBackground, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'INVESTOR PROFILE',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: neonCyan, letterSpacing: 1.5),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 👤 यूजर अवतार और स्टेटस बैज (नियॉन हाइलाइट भाई)
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: neonCyan,
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundColor: cardBackground,
                        child: Icon(Icons.person_rounded, size: 55, color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: neonGreen, shape: BoxShape.circle),
                      child: const Icon(Icons.bolt_rounded, size: 16, color: darkBackground),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Alok Kumar',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
              ),
              const SizedBox(height: 4),
              const Text(
                'Tier: Validator Node Pro',
                style: TextStyle(fontSize: 14, color: neonCyan, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 32),

              // 💳 Bittensor (TAO) Connected Wallet Card ভাই
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderTextColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'CONNECTED WALLET', 
                          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                        Icon(Icons.link_rounded, color: neonGreen, size: 20),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.account_balance_wallet_rounded, color: neonCyan, size: 24),
                            SizedBox(width: 12),
                            Text(
                              walletAddress,
                              style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Courier', fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, color: Color(0xFF64748B), size: 20),
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(text: "5GsnB...W7q9Xzp8YvM4kRbc2hT5"));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: cardBackground,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                duration: const Duration(seconds: 2),
                                content: const Row(
                                  children: [
                                    Icon(Icons.check_circle_rounded, color: neonGreen, size: 18),
                                    SizedBox(width: 10),
                                    Text(
                                      'Wallet address copied to clipboard! 📋', // 🎯 प्रोफेशनल इंग्लिश
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ⚙️ सेटिंग्स लिस्ट टाइल्स भाई
              _buildSettingTile(Icons.security_rounded, 'Security & 2FA', 'Secure your staking nodes', neonCyan),
              _buildSettingTile(Icons.lan_rounded, 'Connected Subnets', 'Subnet 1, Subnet 18 active', neonCyan),
              
              // 🎯 ट्रांजैक्शन हिस्ट्री टाइल (Perfected)
              _buildSettingTile(
                Icons.history_toggle_off_rounded, 
                'Transaction History', 
                'View all reward distributions',
                neonCyan,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TransactionHistoryScreen()),
                  );
                },
              ),
              _buildSettingTile(Icons.help_outline_rounded, 'Support & Docs', 'Bittensor staking guide', neonCyan),
              
              const SizedBox(height: 32),
              
              // 🚪 वॉलेट डिस्कनेक्ट बटन (प्रीमियम आउटलाइन लुक)
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    // भाई यहाँ अपना वॉलेट डिस्कनेक्ट या लॉगआउट लॉजिक डाल सकते हो
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.redAccent, width: 1.2),
                    ),
                  ),
                  child: const Text(
                    'Disconnect Wallet', 
                    style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 0.3),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🚀 हेल्पिंग विजेट फंक्शन (थीम कलर पैरामीटर के साथ भाई)
  Widget _buildSettingTile(IconData icon, String title, String subtitle, Color iconColor, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF334155), size: 14),
        onTap: onTap,
      ),
    );
  }
}