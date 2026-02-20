import 'package:flutter/material.dart';
import '../../core/services/access_summaryFuture.dart';
import '../../core/services/delete_featureby_packagename.dart';

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
  Future<void> _deleteRequested(String packageName ) async{
    final result=await DeleteFeatureByPackage().deletePackage(packageName);
     if (!result) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Failed to delete")),
    );
    return;
  }

  // Reload summary after delete
  setState(() {
    loading = true;
  });

  await _loadSummary();
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (summary == null) {
      return const Scaffold(
        body: Center(child: Text("No data available")),
      );
    }

    final total = summary!["total_records"] ?? 0;
    final List packages = summary!["usage_by_package"] ?? [];
    final List intents = summary!["usage_by_intent"] ?? [];

    final topPackage =
        packages.isNotEmpty ? packages.first["package"] : "—";
    final topIntent =
        intents.isNotEmpty ? intents.first["intent"] : "—";

    return Scaffold(
      body: SingleChildScrollView(
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

            /// USAGE LIST
            if (packages.isEmpty)
              const Text("No usage detected yet")
            else
              ...packages.map((item) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.apps),
                    title: Text(item["package"] ?? "Unknown"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item["total_usage"].toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // delete logic
                            _deleteRequested(item['package']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _metricCard(String title, String value) {
    return Card(
      elevation: 3,
      child: SizedBox(
        height: 90,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}