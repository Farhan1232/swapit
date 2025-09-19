import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swapit/provider/body_enhancement_provider.dart';


class BodyEnhancementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BodyEnhancementProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Body Enhancement"),
          backgroundColor: Colors.teal,
        ),
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[300],
                  ),
                  child: Consumer<BodyEnhancementProvider>(
                    builder: (context, provider, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/sample_image.jpg', // Replace with user-uploaded image
                            fit: BoxFit.contain,
                          ),
                          Positioned(
                            bottom: 20,
                            child: Text(
                              "Preview with Real-Time Updates",
                              style: TextStyle(
                                color: Colors.white,
                                backgroundColor: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    blurRadius: 8.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSlider(
                    context,
                    label: "Height Adjustment",
                    value: context.watch<BodyEnhancementProvider>().heightScale,
                    onChanged: context.read<BodyEnhancementProvider>().updateHeightScale,
                  ),
                  _buildSlider(
                    context,
                    label: "Waist Adjustment",
                    value: context.watch<BodyEnhancementProvider>().waistScale,
                    onChanged: context.read<BodyEnhancementProvider>().updateWaistScale,
                  ),
                  _buildSlider(
                    context,
                    label: "Muscle Tone",
                    value: context.watch<BodyEnhancementProvider>().muscleTone,
                    onChanged: context.read<BodyEnhancementProvider>().updateMuscleTone,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Save or process enhanced image
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Enhancements applied!")),
                      );
                    },
                    child: const Text("Apply Enhancements"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(BuildContext context, {
    required String label,
    required double value,
    required Function(double) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Slider(
          value: value,
          min: 0.5,
          max: 1.5,
          divisions: 20,
          onChanged: onChanged,
          activeColor: Colors.teal,
          label: value.toStringAsFixed(2),
        ),
      ],
    );
  }
}
