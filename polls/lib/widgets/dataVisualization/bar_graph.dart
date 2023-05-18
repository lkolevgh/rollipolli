import 'dart:math';

import 'package:flutter/material.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({
    super.key,
    required this.height,
    required this.width,
    required this.counters,
    required this.numBars,
    required this.spacing,
    required this.circleBorder,
    this.initalDisplayData = true,
    this.minHeight = 10,
  });

  final double height;
  final double width;
  final int numBars;
  final double minHeight;
  final double spacing;
  final List<int> counters;
  final double circleBorder;
  final bool initalDisplayData;

  @override
  State<BarGraph> createState() => BarGraphState();
}

class BarGraphState extends State<BarGraph> {
  int largest = 1;
  bool displayData = true;
  void setHighest() {
    for (int i = 0; i < widget.counters.length; i++) {
      if (widget.counters[i] > largest) {
        largest = widget.counters[i];
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setHighest();
    displayData = widget.initalDisplayData;
  }

  @override
  void didUpdateWidget(BarGraph oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initalDisplayData != widget.initalDisplayData) {
      setState(() => displayData = widget.initalDisplayData);
    }
  }

  static const _colors = [
    Colors.red,
    Colors.blue,
    Colors.orange,
    Colors.green,
    Colors.deepPurple,
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => displayData = !displayData),
      child: SizedBox(
        height: widget.height,
        child: Wrap(
          runAlignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: widget.spacing,
          children: [
            for (int i = 0; i < widget.numBars; i++)
              AnimatedContainer(
                height: displayData
                    ? widget.counters[i].toDouble() == 0
                        ? widget.minHeight
                        : (widget.counters[i].toDouble() /
                                widget.counters.reduce(max)) *
                            widget.height
                    : widget.minHeight,
                width: (widget.width - 4 * widget.spacing) / widget.numBars,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.circleBorder),
                  color: _colors[i],
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      spreadRadius: 0,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                duration: const Duration(milliseconds: 300),
              ),
          ],
        ),
      ),
    );
  }
}
