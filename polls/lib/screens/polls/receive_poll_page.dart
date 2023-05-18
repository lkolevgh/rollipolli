import 'package:flutter/material.dart';
import 'package:polls/widgets/dataVisualization/bar_graph.dart';

class ReceivePollPage extends StatelessWidget {
  const ReceivePollPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: const [
          Positioned(
            bottom: 200,
            child: Center(
              child: BarGraph(
                numBars: 5,
                height: 200,
                width: 200,
                spacing: 20,
                counters: [35, 70, 100, 70, 35],
                circleBorder: 30,
                initalDisplayData: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
