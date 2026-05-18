import 'package:flutter/material.dart';

class CustomNotification {
  static void show({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    // 🔔 ओवरले स्टेट निकालना
    final overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    // एनीमेशन कंट्रोलर को मैन्युअली मैनेज करने के लिए एक विजेट
    overlayEntry = OverlayEntry(
      builder: (context) => _NotificationToast(
        title: title,
        message: message,
        onDismiss: () {
          overlayEntry.remove();
        },
      ),
    );

    // स्क्रीन पर पॉप-अप चिपका देना
    overlayState.insert(overlayEntry);
  }
}

class _NotificationToast extends StatefulWidget {
  final String title;
  final String message;
  final VoidCallback onDismiss;

  const _NotificationToast({
    required this.title,
    required this.message,
    required this.onDismiss,
  });

  @override
  State<_NotificationToast> createState() => _NotificationToastState();
}

class _NotificationToastState extends State<_NotificationToast> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.5), // ऊपर छुपा रहेगा
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    // 💡 3.5 सेकंड बाद अपने आप बंद हो जाएगा
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        _controller.reverse().then((_) => widget.onDismiss());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // पीसी/वेब स्क्रीन के हिसाब से चौड़ाई सेट करना
    double screenWidth = MediaQuery.of(context).size.width;
    double toastWidth = screenWidth > 600 ? 400 : screenWidth - 40;

    return Positioned(
      top: 24,
      right: screenWidth > 600 ? 24 : 20, // पीसी पर राइट साइड में दिखेगा, मोबाइल पर बीच में
      left: screenWidth > 600 ? null : 20,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: toastWidth,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B), // प्रीमियम डार्क ब्लू
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.5), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.notifications_active_rounded, color: Color(0xFF38BDF8), size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, decoration: TextDecoration.none),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.message,
                        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, decoration: TextDecoration.none),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B), size: 18),
                  onPressed: () {
                    _controller.reverse().then((_) => widget.onDismiss());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}