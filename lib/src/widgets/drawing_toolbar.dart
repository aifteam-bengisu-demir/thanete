import 'package:flutter/material.dart';
import 'package:thanette/src/models/drawing.dart';

class DrawingToolbar extends StatelessWidget {
  final DrawingSettings settings;
  final Function(DrawingSettings) onSettingsChanged;
  final VoidCallback onUndo;
  final VoidCallback onClear;
  final bool canUndo;

  const DrawingToolbar({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
    required this.onUndo,
    required this.onClear,
    required this.canUndo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tools row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildToolButton(
                icon: Icons.edit,
                isSelected: settings.tool == DrawingTool.pen,
                onTap: () => _changeTool(DrawingTool.pen),
                tooltip: 'Kalem',
              ),
              _buildToolButton(
                icon: Icons.highlight,
                isSelected: settings.tool == DrawingTool.highlighter,
                onTap: () => _changeTool(DrawingTool.highlighter),
                tooltip: 'İşaretleyici',
              ),
              _buildToolButton(
                icon: Icons.cleaning_services,
                isSelected: settings.tool == DrawingTool.eraser,
                onTap: () => _changeTool(DrawingTool.eraser),
                tooltip: 'Silgi',
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                icon: Icons.undo,
                onTap: canUndo ? onUndo : null,
                tooltip: 'Geri Al',
              ),
              _buildActionButton(
                icon: Icons.clear_all,
                onTap: onClear,
                tooltip: 'Temizle',
                color: Colors.red[400],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Color palette
          if (settings.tool != DrawingTool.eraser) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildColorButton(Colors.black),
                _buildColorButton(const Color(0xFFEC60FF)),
                _buildColorButton(const Color(0xFFFF4D79)),
                _buildColorButton(Colors.blue),
                _buildColorButton(Colors.green),
                _buildColorButton(Colors.orange),
                _buildColorButton(Colors.red),
                _buildColorButton(Colors.purple),
              ],
            ),

            const SizedBox(height: 12),

            // Stroke width slider
            Row(
              children: [
                const Icon(
                  Icons.line_weight,
                  size: 16,
                  color: Color(0xFF6B7280),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFFEC60FF),
                      inactiveTrackColor: const Color(0xFFE5E7EB),
                      thumbColor: const Color(0xFFEC60FF),
                      overlayColor: const Color(0xFFEC60FF).withOpacity(0.2),
                      trackHeight: 3,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 8,
                      ),
                    ),
                    child: Slider(
                      value: settings.strokeWidth,
                      min: settings.tool == DrawingTool.highlighter ? 8.0 : 1.0,
                      max: settings.tool == DrawingTool.highlighter
                          ? 20.0
                          : 10.0,
                      divisions: settings.tool == DrawingTool.highlighter
                          ? 12
                          : 18,
                      onChanged: (value) {
                        onSettingsChanged(
                          settings.copyWith(strokeWidth: value),
                        );
                      },
                    ),
                  ),
                ),
                Text(
                  '${settings.strokeWidth.round()}px',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFFEC60FF), Color(0xFFFF4D79)],
                  )
                : null,
            color: isSelected ? null : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Colors.transparent : const Color(0xFFE5E7EB),
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isSelected ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback? onTap,
    required String tooltip,
    Color? color,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: onTap != null
                ? const Color(0xFFF9FAFB)
                : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Icon(
            icon,
            size: 20,
            color: onTap != null
                ? (color ?? const Color(0xFF6B7280))
                : const Color(0xFF9CA3AF),
          ),
        ),
      ),
    );
  }

  Widget _buildColorButton(Color color) {
    final isSelected = settings.color == color;

    return GestureDetector(
      onTap: () {
        onSettingsChanged(settings.copyWith(color: color));
      },
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: isSelected
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : null,
      ),
    );
  }

  void _changeTool(DrawingTool tool) {
    DrawingSettings newSettings = settings.copyWith(tool: tool);

    // Adjust default settings for each tool
    switch (tool) {
      case DrawingTool.pen:
        newSettings = newSettings.copyWith(strokeWidth: 2.0, opacity: 1.0);
        break;
      case DrawingTool.highlighter:
        newSettings = newSettings.copyWith(strokeWidth: 12.0, opacity: 0.6);
        break;
      case DrawingTool.eraser:
        newSettings = newSettings.copyWith(strokeWidth: 8.0, opacity: 1.0);
        break;
    }

    onSettingsChanged(newSettings);
  }
}


