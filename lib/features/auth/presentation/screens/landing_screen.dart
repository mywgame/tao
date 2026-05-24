import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with TickerProviderStateMixin {
  // 🎨 COLOR PALETTE
  static const neonCyan = Color(0xFF00E5FF);
  static const neonGreen = Color(0xFF00FF9F);
  static const darkBackground = Color(0xFF060913);
  static const cardBackground = Color(0xFF0F1626);
  static const borderTextColor = Color(0xFF1E293B);

  // SLIDER
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;
  Timer? _sliderTimer;

  // DRAWER
  late AnimationController _drawerController;
  late Animation<Offset> _drawerSlide;
  late Animation<double> _backdropFade;
  bool _drawerOpen = false;

  final List<Map<String, String>> _sliderItems = [
    {'image': 'assets/images/analytics_dashboard.png'},
    {'image': 'assets/images/card2.png'},
    {'image': ''},
  ];

  // DRAWER MENU ITEMS
  final List<Map<String, dynamic>> _drawerItems = [
    {'icon': Icons.login_rounded, 'label': 'Login'},
    {'icon': Icons.info_outline_rounded, 'label': 'About'},
    {'icon': Icons.bolt_rounded, 'label': 'Features'},
    {'icon': Icons.support_agent_rounded, 'label': 'Support'},
    {'icon': Icons.pie_chart_outline_rounded, 'label': 'Tokenomics'},
    {'icon': Icons.picture_as_pdf_rounded, 'label': 'Whitepaper PDF'},
  ];

  @override
  void initState() {
    super.initState();
    _sliderTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _currentPage = (_currentPage + 1) % _sliderItems.length;
      if (_pageController.hasClients) {
        _pageController.animateToPage(_currentPage,
            duration: const Duration(milliseconds: 800),
            curve: Curves.fastOutSlowIn);
      }
    });

    _drawerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _drawerSlide = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _drawerController,
      curve: Curves.easeOutCubic,
    ));
    _backdropFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _drawerController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();
    _pageController.dispose();
    _drawerController.dispose();
    super.dispose();
  }

  void _openDrawer() {
    setState(() => _drawerOpen = true);
    _drawerController.forward();
  }

  void _closeDrawer() {
    _drawerController.reverse().then((_) {
      setState(() => _drawerOpen = false);
    });
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
            // 🌠 AMBIENT BLOBS
            Positioned(
              top: -120,
              right: isDesktop ? screenWidth * 0.1 : -40,
              child: Container(
                width: 350, height: 350,
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
                width: 350, height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: neonGreen.withOpacity(0.06),
                ),
              ),
            ),
            Positioned.fill(child: CustomPaint(painter: CryptoNetworkPainter())),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                child: Container(color: Colors.transparent),
              ),
            ),

            // 📜 MAIN SCROLL
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ── NAVBAR ──
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset('assets/images/logo.svg', height: 36, width: 36),
                            // 🍔 HAMBURGER BUTTON
                            GestureDetector(
                              onTap: _openDrawer,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.04),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _hamburgerLine(width: 20),
                                    const SizedBox(height: 5),
                                    _hamburgerLine(width: 14),
                                    const SizedBox(height: 5),
                                    _hamburgerLine(width: 20),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // ── HERO ──
                            const SizedBox(height: 40),
                            const Text('NEXT GENERATION\nBITTENSOR STAKING',
                              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white, height: 1.2, letterSpacing: -0.5)),
                            const SizedBox(height: 20),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: isDesktop ? 800 : double.infinity),
                              child: const Text(
                                'TAO Boost is a next-generation decentralized staking protocol built on the Bittensor network. Maximize your TAO rewards through automated yield strategies, institutional-grade security, and a transparent genealogy-based referral ecosystem.',
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

                            // ── SLIDER ──
                            const Text('PLATFORM HIGHLIGHTS',
                              style: TextStyle(color: neonCyan, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                            const SizedBox(height: 16),
                            AspectRatio(
                              aspectRatio: isDesktop ? 3.0 : 1.8,
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: _sliderItems.length,
                                onPageChanged: (i) => setState(() => _currentPage = i),
                                itemBuilder: (context, index) =>
                                    _buildSliderCard(_sliderItems[index]['image']!),
                              ),
                            ),
                            const SizedBox(height: 16),
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
                            const SizedBox(height: 50),

                            // ── STATS ──
                            isDesktop
                                ? Row(children: [
                                    Expanded(child: _buildStatCard('\$42.8M+', 'TOTAL POOL')),
                                    const SizedBox(width: 16),
                                    Expanded(child: _buildStatCard('1,452+', 'ACTIVE NODES')),
                                    const SizedBox(width: 16),
                                    Expanded(child: _buildStatCard('18.4%', 'AVG APR')),
                                    const SizedBox(width: 16),
                                    Expanded(child: _buildStatCard('99.9%', 'UPTIME')),
                                  ])
                                : Column(children: [
                                    Row(children: [
                                      Expanded(child: _buildStatCard('\$42.8M+', 'TOTAL POOL')),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildStatCard('1,452+', 'ACTIVE NODES')),
                                    ]),
                                    const SizedBox(height: 12),
                                    Row(children: [
                                      Expanded(child: _buildStatCard('18.4%', 'AVG APR')),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildStatCard('99.9%', 'UPTIME')),
                                    ]),
                                  ]),
                            const SizedBox(height: 60),

                            // ── ABOUT BITTENSOR ──
                            _sectionLabel('WHAT IS BITTENSOR?'),
                            const SizedBox(height: 20),
                            _buildGlassCard(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ── LOTTIE ANIMATION ──
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox(
                                      width: 110,
                                      height: 110,
                                      child: Lottie.asset(
                                        'assets/animations/card1.json',
                                        fit: BoxFit.contain,
                                        repeat: true,
                                        animate: true,
                                        errorBuilder: (context, error, stack) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: neonCyan.withOpacity(0.08),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: const Icon(Icons.memory_rounded, color: neonCyan, size: 32),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Bittensor (TAO)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                        SizedBox(height: 10),
                                        Text(
                                          'Bittensor is a decentralized machine learning network that incentivizes the production and sharing of artificial intelligence. TAO is its native token used for staking, governance, and rewarding network participants who contribute computing power and AI models.',
                                          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, height: 1.7),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 50),

                            // ── WHY TAO BOOST ──
                            _sectionLabel('WHY TAO BOOST?'),
                            const SizedBox(height: 24),
                            Column(children: [
                              _buildFeatureRow(Icons.bolt_rounded, 'Automated High-Yield APR',
                                  'Our smart staking engine continuously rebalances your TAO across the highest-performing subnets, maximizing your daily yield without manual intervention.'),
                              const SizedBox(height: 24),
                              _buildFeatureRow(Icons.hub_rounded, 'Decentralized Genealogy Network',
                                  'Build and grow a referral tree with transparent on-chain tracking. Earn passive income from your network\'s staking activity across multiple levels.'),
                              const SizedBox(height: 24),
                              _buildFeatureRow(Icons.shield_outlined, 'Secure Institutional Custody',
                                  'Multi-signature wallet architecture and cold storage integration ensure your TAO assets are protected by institutional-grade security protocols at all times.'),
                              const SizedBox(height: 24),
                              _buildFeatureRow(Icons.analytics_outlined, 'Real-Time Analytics',
                                  'Monitor your staking performance, referral earnings, and network growth through a comprehensive dashboard with live data feeds from the Bittensor network.'),
                            ]),
                            const SizedBox(height: 60),

                            // ── TOKENOMICS ──
                            _sectionLabel('TOKENOMICS'),
                            const SizedBox(height: 20),
                            isDesktop
                                ? Row(children: [
                                    Expanded(child: _buildTokenCard('40%', 'Staking Rewards', neonGreen)),
                                    const SizedBox(width: 16),
                                    Expanded(child: _buildTokenCard('25%', 'Ecosystem Fund', neonCyan)),
                                    const SizedBox(width: 16),
                                    Expanded(child: _buildTokenCard('20%', 'Team & Advisors', const Color(0xFF7C3AED))),
                                    const SizedBox(width: 16),
                                    Expanded(child: _buildTokenCard('15%', 'Reserve', const Color(0xFFF59E0B))),
                                  ])
                                : Column(children: [
                                    Row(children: [
                                      Expanded(child: _buildTokenCard('40%', 'Staking Rewards', neonGreen)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildTokenCard('25%', 'Ecosystem Fund', neonCyan)),
                                    ]),
                                    const SizedBox(height: 12),
                                    Row(children: [
                                      Expanded(child: _buildTokenCard('20%', 'Team & Advisors', const Color(0xFF7C3AED))),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildTokenCard('15%', 'Reserve', const Color(0xFFF59E0B))),
                                    ]),
                                  ]),
                            const SizedBox(height: 60),

                            // ── HOW IT WORKS ──
                            _sectionLabel('HOW IT WORKS'),
                            const SizedBox(height: 24),
                            isDesktop
                                ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: _buildStepCard('01', 'Connect Wallet', 'Link your TAO wallet securely to the TAO Boost platform using our non-custodial connection.')),
                                      const SizedBox(width: 16),
                                      Expanded(child: _buildStepCard('02', 'Choose Package', 'Select a staking package that matches your investment goals and risk appetite.')),
                                      const SizedBox(width: 16),
                                      Expanded(child: _buildStepCard('03', 'Earn Rewards', 'Watch your TAO grow daily through automated compounding and referral bonuses.')),
                                    ],
                                  )
                                : Column(children: [
                                    _buildStepCard('01', 'Connect Wallet', 'Link your TAO wallet securely to the TAO Boost platform using our non-custodial connection.'),
                                    const SizedBox(height: 16),
                                    _buildStepCard('02', 'Choose Package', 'Select a staking package that matches your investment goals and risk appetite.'),
                                    const SizedBox(height: 16),
                                    _buildStepCard('03', 'Earn Rewards', 'Watch your TAO grow daily through automated compounding and referral bonuses.'),
                                  ]),
                            const SizedBox(height: 60),

                            // ── DISCLAIMER ──
                            _sectionLabel('DISCLAIMER'),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A0A0A),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFF7F1D1D).withOpacity(0.5), width: 1),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    const Icon(Icons.warning_amber_rounded, color: Color(0xFFFBBF24), size: 20),
                                    const SizedBox(width: 10),
                                    const Text('Risk Warning', style: TextStyle(color: Color(0xFFFBBF24), fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                                  ]),
                                  const SizedBox(height: 14),
                                  const Text(
                                    'Cryptocurrency staking and digital asset investments carry significant risk. The value of TAO and other digital assets can fluctuate dramatically and you may lose some or all of your investment. Past performance is not indicative of future results. TAO Boost does not provide financial, legal, or investment advice. Please conduct your own due diligence and consult a qualified financial advisor before participating. This platform is not available in jurisdictions where such activities are restricted or prohibited by law. By using this platform, you acknowledge and accept all associated risks.',
                                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, height: 1.8),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),

                            // ── FOOTER ──
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 4),
                              decoration: BoxDecoration(
                                border: Border(top: BorderSide(color: borderTextColor, width: 1)),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset('assets/images/logo.svg', height: 36, width: 36),
                                      const SizedBox(width: 8),
                                      const Text('TAO BOOST', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1.5)),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 24,
                                    runSpacing: 8,
                                    children: ['About', 'Features', 'Tokenomics', 'Support', 'Privacy Policy', 'Terms of Use']
                                        .map((item) => Text(item,
                                            style: const TextStyle(color: Color(0xFF475569), fontSize: 12, fontWeight: FontWeight.w500)))
                                        .toList(),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    '© 2026 TAO BOOST. Built for the Decentralized Future.\nAll rights reserved. Not financial advice.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Color(0xFF334155), fontSize: 11, height: 1.6),
                                  ),
                                ],
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

            // 🌑 BACKDROP
            if (_drawerOpen)
              AnimatedBuilder(
                animation: _backdropFade,
                builder: (_, __) => GestureDetector(
                  onTap: _closeDrawer,
                  child: Container(
                    color: Colors.black.withOpacity(0.55 * _backdropFade.value),
                  ),
                ),
              ),

            // 🗂️ DRAWER PANEL
            if (_drawerOpen)
              Positioned(
                top: 0, right: 0, bottom: 0,
                width: math.min(screenWidth * 0.78, 300),
                child: SlideTransition(
                  position: _drawerSlide,
                  child: _buildDrawer(context),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── DRAWER WIDGET ──
  Widget _buildDrawer(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0A1220).withOpacity(0.97),
            border: Border(left: BorderSide(color: borderTextColor, width: 1.5)),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drawer Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 16, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset('assets/images/logo.svg', height: 44, width: 44),
                      GestureDetector(
                        onTap: _closeDrawer,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.close_rounded, color: Colors.white54, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(color: borderTextColor, height: 1),
                const SizedBox(height: 12),

                // Menu Items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _drawerItems.length,
                    itemBuilder: (context, index) {
                      final item = _drawerItems[index];
                      final isLogin = item['label'] == 'Login';
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              _closeDrawer();
                              if (isLogin) context.go('/login');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: isLogin
                                    ? neonGreen.withOpacity(0.08)
                                    : Colors.white.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isLogin
                                      ? neonGreen.withOpacity(0.25)
                                      : borderTextColor,
                                  width: 1,
                                ),
                              ),
                              child: Row(children: [
                                Icon(item['icon'] as IconData,
                                    color: isLogin ? neonGreen : neonCyan,
                                    size: 20),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(item['label'] as String,
                                    style: TextStyle(
                                      color: isLogin ? neonGreen : Colors.white,
                                      fontSize: 14,
                                      fontWeight: isLogin ? FontWeight.bold : FontWeight.w500,
                                    )),
                                ),
                              ]),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Drawer Footer
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    Divider(color: borderTextColor, height: 1),
                    const SizedBox(height: 16),
                    const Text('© 2026',
                      style: TextStyle(color: Color(0xFF334155), fontSize: 11)),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── HELPERS ──
  Widget _hamburgerLine({required double width}) {
    return Container(
      width: width, height: 2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(text,
      style: const TextStyle(color: neonCyan, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5));
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBackground.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderTextColor, width: 1.2),
      ),
      child: child,
    );
  }

  Widget _buildSliderCard(String imagePath) {
    final bool hasImage = imagePath.isNotEmpty;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: cardBackground.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderTextColor, width: 1.5),
        boxShadow: [BoxShadow(color: neonCyan.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: hasImage
            ? Container(
                color: const Color(0xFF070B14),
                child: Image.asset(imagePath, fit: BoxFit.contain, alignment: Alignment.center),
              )
            : const SizedBox.expand(),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: cardBackground.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderTextColor, width: 1.2),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: Color(0xFF475569), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        const SizedBox(height: 10),
        Text(value, style: const TextStyle(color: neonCyan, fontSize: 24, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Widget _buildTokenCard(String percent, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBackground.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25), width: 1.2),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(percent, style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.w900)),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w500)),
      ]),
    );
  }

  Widget _buildStepCard(String step, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBackground.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderTextColor, width: 1.2),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(step, style: TextStyle(color: neonCyan.withOpacity(0.4), fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1)),
        const SizedBox(height: 12),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(desc, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, height: 1.5)),
      ]),
    );
  }

  Widget _buildFeatureRow(IconData icon, String title, String desc) {
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
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(desc, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, height: 1.4)),
          ]),
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
        if ((points[i] - points[j]).distance < size.width * 0.5) {
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
