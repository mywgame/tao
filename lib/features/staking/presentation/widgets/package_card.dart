import 'package:flutter/material.dart';

class PackageCard extends StatelessWidget {
  final String name;
  final int minAmount;
  final double dailyRoi;
  final bool isSelected;
  final VoidCallback onTap;

  const PackageCard({
    super.key,
    required this.name,
    required this.minAmount,
    required this.dailyRoi,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E293B) : const Color(0xFF111827),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF00E5FF) : const Color(0xFF334155),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("Min: \$$minAmount", style: const TextStyle(color: Colors.white60, fontSize: 13)),
              ],
            ),
            Text("$dailyRoi% Daily", style: const TextStyle(color: Color(0xFF00FF9F), fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}