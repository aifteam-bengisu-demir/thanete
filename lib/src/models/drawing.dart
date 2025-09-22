import 'package:flutter/material.dart';

class DrawingPoint {
  final Offset offset;
  final Paint paint;

  DrawingPoint({required this.offset, required this.paint});

  DrawingPoint copyWith({Offset? offset, Paint? paint}) {
    return DrawingPoint(
      offset: offset ?? this.offset,
      paint: paint ?? this.paint,
    );
  }
}

class DrawingPath {
  final List<DrawingPoint> points;
  final Paint paint;
  final String id;

  DrawingPath({required this.points, required this.paint, required this.id});

  DrawingPath copyWith({List<DrawingPoint>? points, Paint? paint, String? id}) {
    return DrawingPath(
      points: points ?? this.points,
      paint: paint ?? this.paint,
      id: id ?? this.id,
    );
  }
}

class DrawingData {
  final List<DrawingPath> paths;
  final Size canvasSize;

  DrawingData({required this.paths, required this.canvasSize});

  DrawingData copyWith({List<DrawingPath>? paths, Size? canvasSize}) {
    return DrawingData(
      paths: paths ?? this.paths,
      canvasSize: canvasSize ?? this.canvasSize,
    );
  }

  bool get isEmpty => paths.isEmpty;
  bool get isNotEmpty => paths.isNotEmpty;
}

enum DrawingTool { pen, highlighter, eraser }

class DrawingSettings {
  final DrawingTool tool;
  final Color color;
  final double strokeWidth;
  final double opacity;

  DrawingSettings({
    this.tool = DrawingTool.pen,
    this.color = Colors.black,
    this.strokeWidth = 2.0,
    this.opacity = 1.0,
  });

  DrawingSettings copyWith({
    DrawingTool? tool,
    Color? color,
    double? strokeWidth,
    double? opacity,
  }) {
    return DrawingSettings(
      tool: tool ?? this.tool,
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      opacity: opacity ?? this.opacity,
    );
  }

  Paint get paint {
    return Paint()
      ..color = color.withOpacity(opacity)
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..blendMode = tool == DrawingTool.eraser
          ? BlendMode.clear
          : BlendMode.srcOver;
  }
}


