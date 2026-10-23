import 'package:flutter/material.dart';
import '../models/mandi_record.dart';
import '../core/constants/app_colors.dart';

class MandiCard extends StatelessWidget {
  final MandiRecord record;
  final VoidCallback? onTap;

  const MandiCard({
    super.key,
    required this.record,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUp = record.trend == 'up';
    final isDown = record.trend == 'down';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 3,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    record.commodity,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isUp
                        ? AppColors.success.withOpacity(0.12)
                        : (isDown ? AppColors.danger.withOpacity(0.12) : Colors.grey.withOpacity(0.12)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isUp ? Icons.arrow_upward : (isDown ? Icons.arrow_downward : Icons.remove),
                        color: isUp ? AppColors.success : (isDown ? AppColors.danger : Colors.grey),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isUp ? 'तेज़' : (isDown ? 'मंदा' : 'स्थिर'),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isUp ? AppColors.success : (isDown ? AppColors.danger : Colors.grey[700]),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${record.market}, ${record.district} (${record.state})',
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('मॉडल भाव', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      Text(
                        '₹${record.modalPrice.toInt()}/क्विंटल',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('सीमा (न्यूनतम - अधिकतम)', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      Text(
                        '₹${record.minPrice.toInt()} - ₹${record.maxPrice.toInt()}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('किस्म: ${record.variety}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                Text('दिनांक: ${record.arrivalDate}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
