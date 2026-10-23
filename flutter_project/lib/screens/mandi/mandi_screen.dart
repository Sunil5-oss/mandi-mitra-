import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/mandi_card.dart';

class MandiScreen extends StatefulWidget {
  const MandiScreen({super.key});

  @override
  State<MandiScreen> createState() => _MandiScreenState();
}

class _MandiScreenState extends State<MandiScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedState = 'Madhya Pradesh';
  String _selectedCommodity = 'All';

  final List<String> _states = [
    'Madhya Pradesh',
    'Punjab',
    'Haryana',
    'Rajasthan',
    'Uttar Pradesh',
    'Maharashtra',
    'Gujarat',
  ];

  final List<String> _commodities = [
    'All',
    'Wheat (गेहूँ)',
    'Paddy (धान)',
    'Soybean (सोयाबीन)',
    'Mustard (सरसों)',
    'Cotton (कपास)',
    'Gram (चना)',
    'Onion (प्याज़)',
    'Potato (आलू)',
    'Tomato (टमाटर)',
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final isHindi = state.currentLanguage == 'hi';

    final filteredRecords = state.mandiRecords.where((r) {
      final query = _searchController.text.toLowerCase();
      final matchQuery = query.isEmpty ||
          r.commodity.toLowerCase().contains(query) ||
          r.market.toLowerCase().contains(query) ||
          r.district.toLowerCase().contains(query);
      return matchQuery;
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          // Filter Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Search Input
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: isHindi ? 'फसल, मंडी या जिला खोजें...' : 'Search crop, mandi or district...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 12),

                // State & Commodity Dropdowns
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedState,
                        decoration: InputDecoration(
                          labelText: isHindi ? 'राज्य' : 'State',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: _states.map((s) => DropdownMenuItem(value: s, child: Text(s, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedState = val);
                            state.fetchMandiData(state: val, commodity: _selectedCommodity);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCommodity,
                        decoration: InputDecoration(
                          labelText: isHindi ? 'फसल' : 'Crop',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: _commodities.map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedCommodity = val);
                            state.fetchMandiData(state: _selectedState, commodity: val);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),

          // Mandi List
          Expanded(
            child: state.isLoadingMandi
                ? const Center(child: CircularProgressIndicator())
                : filteredRecords.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.store_mall_directory_outlined, size: 56, color: AppColors.textMuted),
                            const SizedBox(height: 12),
                            Text(
                              isHindi ? 'कोई मंडी भाव नहीं मिला' : 'No mandi records found',
                              style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => state.fetchMandiData(),
                              child: Text(isHindi ? 'रिफ्रेश करें' : 'Refresh'),
                            )
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => state.fetchMandiData(state: _selectedState, commodity: _selectedCommodity),
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredRecords.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return MandiCard(record: filteredRecords[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
