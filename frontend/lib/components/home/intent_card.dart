import 'package:flutter/material.dart';
import '../../core/services/access_summaryFuture.dart';

class IntentraDashboard extends StatefulWidget {
  const IntentraDashboard({super.key});

  @override
  State<IntentraDashboard> createState() => _IntentraDashboardState();
}

class _IntentraDashboardState extends State<IntentraDashboard> {
  Map<String, dynamic>? summary;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    final result = await SummmeryFetch().GETMySummary();
    if (!mounted) return;

    setState(() {
      summary = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (summary == null) {
      return const Center(child: Text("No data available"));
    }

    final total = summary!["total_records"] ?? 0;
    final List packages = summary!["usage_by_package"] ?? [];
    final List intents = summary!["usage_by_intent"] ?? [];

    final topPackage =
        packages.isNotEmpty ? packages.first["package"] : "—";
    final topIntent =
        intents.isNotEmpty ? intents.first["intent"] : "—";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "INTENTRA",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          /// TOP METRICS
          Row(
            children: [
              Expanded(
                child: _metricCard("Total Intents", total.toString()),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _metricCard("Top Intent", topIntent),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _metricCard("Most Used App", topPackage),

          const SizedBox(height: 24),

          const Text(
            "App Usage Breakdown",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          /// USAGE CARDS
          if (packages.isEmpty)
            const Text("No usage detected yet")
          else
            ...packages.map((item) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.apps),
                  title: Text(item["package"] ?? "Unknown"),
                  trailing: Text(
                    item["total_usage"].toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _metricCard(String title, String value) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
