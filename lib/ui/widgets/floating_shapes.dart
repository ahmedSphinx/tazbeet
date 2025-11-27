import 'package:flutter/material.dart';
import 'dart:math' as math;

class FloatingShapes extends StatefulWidget {
  final Color color;
  final int numberOfShapes;

  const FloatingShapes({super.key, required this.color, this.numberOfShapes = 5});

  @override
  State<FloatingShapes> createState() => _FloatingShapesState();
}

class _FloatingShapesState extends State<FloatingShapes> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  late List<Offset> _positions;
  late List<double> _sizes;
  late List<ShapeType> _shapes;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    final random = math.Random();
    _controllers = List.generate(
      widget.numberOfShapes,
      (index) => AnimationController(
        duration: Duration(seconds: random.nextInt(10) + 10),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    }).toList();

    _positions = List.generate(widget.numberOfShapes, (index) => Offset(random.nextDouble() * 300 - 150, random.nextDouble() * 300 - 150));

    _sizes = List.generate(widget.numberOfShapes, (index) => random.nextDouble() * 30 + 20);

    _shapes = List.generate(widget.numberOfShapes, (index) => ShapeType.values[random.nextInt(ShapeType.values.length)]);

    for (var controller in _controllers) {
      controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(widget.numberOfShapes, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            final position = _positions[index];
            final size = _sizes[index];
            final shape = _shapes[index];

            return Positioned(
              left: position.dx + (math.sin(_animations[index].value * math.pi * 2) * 20),
              top: position.dy + (math.cos(_animations[index].value * math.pi * 2) * 20),
              child: Transform.rotate(angle: _animations[index].value * math.pi * 2, child: _buildShape(shape, size)),
            );
          },
        );
      }),
    );
  }

  Widget _buildShape(ShapeType shape, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: widget.color.withOpacity(0.1), shape: shape == ShapeType.circle ? BoxShape.circle : BoxShape.rectangle, borderRadius: shape == ShapeType.circle ? null : BorderRadius.circular(4)),
    );
  }
}

enum ShapeType { circle, square }
