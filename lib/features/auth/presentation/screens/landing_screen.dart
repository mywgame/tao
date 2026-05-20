import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'dart:async';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  // 🎨 फिग्मा ओरिएंटेड प्रीमियम डार्क नियॉन पैलेट
  static const neonCyan = Color(0xFF00E5FF);
  static const neonGreen = Color(0xFF00FF9F);
  static const darkBackground = Color(0xFF060913); // डीप स्पेस ब्लैक
  static const cardBackground = Color(0xFF0F1626); // ग्लास सरफेस कार्ड
  static const borderTextColor = Color(0xFF1E293B);

  // 📸 इंस्टाग्राम स्लाइडर के लिए कंट्रोलर्स और डेटा
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;
  Timer? _sliderTimer;

  // 🎯 इमेज पाथ डेटा - सिर्फ पहले कार्ड में 3D डैशबोर्ड इमेज आएगी
  final List<Map<String, String>> _sliderItems = [
    {
    
      'image': 'assets/images/analytics_dashboard.png', // 👈 तुम्हारी 501x280 वाली इमेज भाई
    },
    {
      'title': 'Instant Yield Multiplier',
      'desc': 'Automated strategies to boost your staking rewards.',
      'image': '',
    },
    {
      'title': 'Secure Institutional Custody',
      'desc': 'Top-tier safety and multi-sig network encryption.',
      'image': '',
    },
  ];

  @override
  void initState() {
    super.initState();
    _sliderTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _sliderItems.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn);
      }
    });
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return Scaffold(
      backgroundColor: darkBackground,
      body: SafeArea(
        child: Stack(
          children: [
            // 🌠 बैकग्राउंड एम्बिएंट लाइटिंग
            Positioned(
              top: -120,
              right: isDesktop ? screenWidth * 0.1 : -40,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: neonCyan.withOpacity(0.09),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: isDesktop ? screenWidth * 0.05 : -60,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: neonGreen.withOpacity(0.06),
                ),
              ),
            ),

            // 🕸️ क्रिप्टो नेटवर्क एब्सट्रैक्ट लाइन्स
            Positioned.fill(
              child: CustomPaint(
                painter: CryptoNetworkPainter(),
              ),
            ),

            // 🪟 ग्लासमोर्फिज्म ब्लर ओवरले
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                child: Container(color: Colors.transparent),
              ),
            ),

            // 📜 मुख्य स्क्रोल लेआउट
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      // 🏢 1. PREMIUM GLASS NAVBAR SECTION
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: neonCyan.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.blur_circular_rounded, color: neonCyan, size: 24),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'TAO BOOST',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () => context.go('/login'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.04),
                                foregroundColor: Colors.white,
                                side: BorderSide(color: Colors.white.withOpacity(0.15), width: 1),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                              child: const Text('LOGIN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            ),
                          ],
                        ),
                      ),

                      // 🚀 2. HERO CORE CONTENT SECTION
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 40),
                            const Text(
                              'NEXT GENERATION\nBITTENSOR STAKING',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                height: 1.2,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: isDesktop ? 800 : double.infinity),
                              child: const Text(
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation.',
                                style: TextStyle(fontSize: 15, color: Color(0xFF64748B), height: 1.6, fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(height: 30),

                            ElevatedButton(
                              onPressed: () => context.go('/login'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: neonGreen,
                                foregroundColor: const Color(0xFF06111C),
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                elevation: 0,
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('LAUNCH APP NOW', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1)),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward_ios_rounded, size: 14),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),

                            // 📸 3. INSTAGRAM STYLE SLIDER SECTION WITH PERFECT ASPECT RATIO FIX 🔥
                            const Text(
                              'PLATFORM HIGHLIGHTS',
                              style: TextStyle(color: neonCyan, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                            ),
                            const SizedBox(height: 16),
                            
                            // 📐 एस्पेक्ट रेशियो विजेट जो इमेज को क्रॉप होने से परमानेंटली बचाएगा भाई
                            AspectRatio(
                              aspectRatio: isDesktop ? 3.0 : 1.8, // स्क्रीन के हिसाब से कड़क रिस्पॉन्सिव रेशियो
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: _sliderItems.length,
                                onPageChanged: (int index) {
                                  setState(() {
                                    _currentPage = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return _buildInstagramSliderCard(
                                    _sliderItems[index]['title']!,
                                    _sliderItems[index]['desc']!,
                                    _sliderItems[index]['image']!,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // स्लाइडर डॉट्स भाई
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(_sliderItems.length, (index) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  height: 6,
                                  width: _currentPage == index ? 18 : 6,
                                  decoration: BoxDecoration(
                                    color: _currentPage == index ? neonGreen : const Color(0xFF334155),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 40),

                            // 📊 4. STATS STRIP SECTION
                            isDesktop
                                ? Row(
                                    children: [
                                      Expanded(child: _buildFigmaStatCard('\$42.8M+', 'TOTAL POOL')),
                                      const SizedBox(width: 16),
                                      Expanded(child: _buildFigmaStatCard('1,452+', 'ACTIVE NODES')),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      _buildFigmaStatCard('\$42.8M+', 'TOTAL POOL'),
                                      const SizedBox(height: 16),
                                      _buildFigmaStatCard('1,452+', 'ACTIVE NODES'),
                                    ],
                                  ),
                            
                            const SizedBox(height: 50),
                            const Text(
                              'WHY TAO BOOST?',
                              style: TextStyle(color: neonCyan, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
                            ),
                            const SizedBox(height: 24),

                            Column(
                              children: [
                                _buildFigmaFeatureRow(Icons.bolt_rounded, 'Automated High-Yield APR', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
                                const SizedBox(height: 24),
                                _buildFigmaFeatureRow(Icons.hub_rounded, 'Decentralized Genealogy Network', 'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'),
                                const SizedBox(height: 24),
                                _buildFigmaFeatureRow(Icons.shield_outlined, 'Secure Institutional Custody', 'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur ex ea commodo.'),
                              ],
                            ),
                            
                            const SizedBox(height: 60),
                            const Center(
                              child: Text(
                                '© 2026 TAO BOOST. Built for the Decentralized Future.',
                                style: TextStyle(color: Color(0xFF334155), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 📸 इंस्टाग्राम स्लाइडर कार्ड हेल्पर (100% परफेक्ट फिट नो-क्रॉप नो-स्ट्रेच के साथ)
  Widget _buildInstagramSliderCard(String title, String desc, String imagePath) {
    final bool hasImage = imagePath.isNotEmpty;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: cardBackground.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderTextColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: neonCyan.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            
            // 🎯 जादू: इमेज बॉक्सफिट .contain के साथ डार्क बैकग्राउंड पर बैठेगी, यानी 1 पिक्सेल भी क्रॉप नहीं होगा!
            if (hasImage)
              Positioned.fill(
                child: Container(
                  color: const Color(0xFF070B14), // इमेज के पीछे का बैकग्राउंड ताकि किनारों पर खाली न लगे
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain, // 👈 इमेज पूरी की पूरी परफेक्ट दिखेगी भाई!
                    alignment: Alignment.center,
                  ),
                ),
              ),

            // 🪙 प्रीमियम डार्क ग्रेडिएंट ओवरले ताकि इमेज के ऊपर टेक्स्ट का कंट्रास्ट कड़क रहे
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.9), // नीचे डार्क ताकि टेक्स्ट चमके
                      hasImage ? Colors.black.withOpacity(0.1) : Colors.transparent, // इमेज के ऊपर एकदम सॉफ्ट शेड
                    ],
                  ),
                ),
              ),
            ),

            // 📝 फ्रंट कंटेंट (टेक्स्ट और चिप)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: neonCyan.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'FEATURE',
                      style: TextStyle(color: neonCyan, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    desc,
                    style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFigmaStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: cardBackground.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderTextColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF475569), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(color: neonCyan, fontSize: 28, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFigmaFeatureRow(IconData icon, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: cardBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderTextColor),
          ),
          child: Icon(icon, color: neonCyan, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(desc, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}

class CryptoNetworkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = const Color(0xFF00E5FF).withOpacity(0.03) 
      ..strokeWidth = 1.0;

    final paintDot = Paint()
      ..color = const Color(0xFF00FF9F).withOpacity(0.06) 
      ..style = PaintingStyle.fill;

    final List<Offset> points = [
      Offset(size.width * 0.1, size.height * 0.15),
      Offset(size.width * 0.3, size.height * 0.08),
      Offset(size.width * 0.2, size.height * 0.35),
      Offset(size.width * 0.5, size.height * 0.22),
      Offset(size.width * 0.7, size.height * 0.12),
      Offset(size.width * 0.85, size.height * 0.3),
      Offset(size.width * 0.6, size.height * 0.45),
      Offset(size.width * 0.9, size.height * 0.6),
    ];

    for (int i = 0; i < points.length; i++) {
      for (int j = i + 1; j < points.length; j++) {
        double distance = (points[i] - points[j]).distance;
        if (distance < size.width * 0.5) {
          canvas.drawLine(points[i], points[j], paintLine);
        }
      }
    }

    for (var point in points) {
      canvas.drawCircle(point, 3.0, paintDot);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}