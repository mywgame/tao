import 'package:flutter/material.dart';
import '../../../../core/widgets/shimmer_loading.dart';

Widget buildDashboardShimmer(BuildContext context) {
  return SafeArea(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ShimmerLoading(width: 150, height: 28),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: const ShimmerLoading(width: 35, height: 35),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ShimmerLoading(width: 220, height: 24),
          const SizedBox(height: 8),
          const ShimmerLoading(width: 300, height: 14),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              double cardWidth = constraints.maxWidth > 600 ? (constraints.maxWidth - 40) / 3 : constraints.maxWidth;
              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  ShimmerLoading(width: cardWidth, height: 110, borderRadius: BorderRadius.circular(16)),
                  ShimmerLoading(width: cardWidth, height: 110, borderRadius: BorderRadius.circular(16)),
                  ShimmerLoading(width: cardWidth, height: 110, borderRadius: BorderRadius.circular(16)),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
          const ShimmerLoading(width: 180, height: 20),
          const SizedBox(height: 16),
          ShimmerLoading(width: double.infinity, height: 260, borderRadius: BorderRadius.circular(16)),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(child: ShimmerLoading(width: double.infinity, height: 50, borderRadius: BorderRadius.circular(12))),
              const SizedBox(width: 16),
              Expanded(child: ShimmerLoading(width: double.infinity, height: 50, borderRadius: BorderRadius.circular(12))),
            ],
          ),
        ],
      ),
    ),
  );
}