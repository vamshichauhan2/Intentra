import 'package:flutter/material.dart';
import '../../core/services/usage_service.dart';

class IntentCard extends StatefulWidget {
  const IntentCard({super.key});

  @override
  State<IntentCard> createState() => _IntentCardState();
}

class _IntentCardState extends State<IntentCard> {
  List<Map<String, dynamic>> logs = [];

  Future<void> loadLogs() async {
    final data = await UsageService.getLogs();
    setState(() => logs = data.reversed.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "WELCOME TO INTENTRA",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),

        /// 🔥 ONE-TIME ACTION
        ElevatedButton(
          onPressed: () async {
            await UsageService.startTracking();
            await loadLogs();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Intentra is now tracking app usage",
                ),
              ),
            );
          },
          child: const Text("Enable & Start Tracking"),
        ),

        const SizedBox(height: 16),

        const Text(
          "Detected Apps",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        Expanded(
          child: ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];

              return ListTile(
                title: Text(log['package']),
                subtitle: Text(
                  "${log['intent']} • "
                  "${DateTime.fromMillisecondsSinceEpoch(log['timestamp']).toLocal()}",
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
