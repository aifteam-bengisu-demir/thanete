import 'package:flutter/material.dart';
import 'package:thanette/src/models/drawing.dart';

class DrawingCanvas extends StatefulWidget {
  final DrawingData drawingData;
  final DrawingSettings settings;
  final Function(DrawingData) onDrawingChanged;
  final bool isEnabled;

  const DrawingCanvas({
    super.key,
    required this.drawingData,
    required this.settings,
    required this.onDrawingChanged,
    this.isEnabled = true,
  });

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  DrawingPath? _currentPath;
  late DrawingData _drawingData;

  @override
  void initState() {
    super.initState();
    _drawingData = widget.drawingData;
  }

  @override
  void didUpdateWidget(DrawingCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.drawingData != widget.drawingData) {
      _drawingData = widget.drawingData;
    }
  }

  void _onPanStart(DragStartDetails details) {
    if (!widget.isEnabled) return;

    final point = DrawingPoint(
      offset: details.localPosition,
      paint: widget.settings.paint,
    );

    _currentPath = DrawingPath(
      points: [point],
      paint: widget.settings.paint,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    setState(() {});
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.isEnabled || _currentPath == null) return;

    final point = DrawingPoint(
      offset: details.localPosition,
      paint: widget.settings.paint,
    );

    _currentPath = _currentPath!.copyWith(
      points: [..._currentPath!.points, point],
    );

    setState(() {});
  }

  void _onPanEnd(DragEndDetails details) {
    if (!widget.isEnabled || _currentPath == null) return;

    final updatedPaths = [..._drawingData.paths, _currentPath!];
    _drawingData = _drawingData.copyWith(paths: updatedPaths);

    widget.onDrawingChanged(_drawingData);

    _currentPath = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isEnabled
              ? const Color(0xFFEC60FF).withOpacity(0.3)
              : const Color(0xFFE5E7EB),
          width: widget.isEnabled ? 2 : 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: CustomPaint(
            painter: DrawingPainter(
              drawingData: _drawingData,
              currentPath: _currentPath,
            ),
            size: Size.infinite,
            child: Container(),
          ),
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final DrawingData drawingData;
  final DrawingPath? currentPath;

  DrawingPainter({required this.drawingData, this.currentPath});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw all completed paths
    for (final path in drawingData.paths) {
      _drawPath(canvas, path);
    }

    // Draw current path being drawn
    if (currentPath != null) {
      _drawPath(canvas, currentPath!);
    }
  }

  void _drawPath(Canvas canvas, DrawingPath drawingPath) {
    if (drawingPath.points.isEmpty) return;

    final path = Path();
    final paint = drawingPath.paint;

    // Move to first point
    path.moveTo(
      drawingPath.points.first.offset.dx,
      drawingPath.points.first.offset.dy,
    );

    // Draw lines to subsequent points
    for (int i = 1; i < drawingPath.points.length; i++) {
      final point = drawingPath.points[i];
      path.lineTo(point.offset.dx, point.offset.dy);
    }

    canvas.drawPath(path, paint);

    // Draw individual points for better line quality
    for (final point in drawingPath.points) {
      canvas.drawCircle(
        point.offset,
        paint.strokeWidth / 2,
        Paint()
          ..color = paint.color
          ..style = PaintingStyle.fill
          ..blendMode = paint.blendMode,
      );
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    return oldDelegate.drawingData != drawingData ||
        oldDelegate.currentPath != currentPath;
  }
}


