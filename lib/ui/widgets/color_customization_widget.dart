import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../services/color_customization_service.dart';

class ColorCustomizationWidget extends StatelessWidget {
  final ColorCustomizationService colorService;

  const ColorCustomizationWidget({
    super.key,
    required this.colorService,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text('Custom Colors'),
            subtitle: const Text('Personalize your app theme'),
            trailing: Switch(
              value: colorService.useCustomColors,
              onChanged: (value) {
                colorService.enableCustomColors(value);
              },
            ),
          ),
          if (colorService.useCustomColors) ...[
            ListTile(
              title: const Text('Primary Color'),
              subtitle: const Text('Choose your primary color'),
              trailing: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorService.customPrimaryColor ?? Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                ),
              ),
              onTap: () => _showColorPicker(context),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildColorPresetButton(Colors.blue, 'Blue'),
                  _buildColorPresetButton(Colors.purple, 'Purple'),
                  _buildColorPresetButton(Colors.pink, 'Pink'),
                  _buildColorPresetButton(Colors.green, 'Green'),
                  _buildColorPresetButton(Colors.orange, 'Orange'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildColorPresetButton(Color color, String name) {
    return InkWell(
      onTap: () => colorService.setCustomPrimaryColor(color),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: colorService.customPrimaryColor == color ? Colors.black : Colors.grey.shade300,
                width: colorService.customPrimaryColor == color ? 3 : 1,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    Color selectedColor = colorService.customPrimaryColor ?? Colors.blue;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a Color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: selectedColor,
            onColorChanged: (color) {
              selectedColor = color;
            },
            pickerAreaHeightPercent: 0.8,
            enableAlpha: false,
            displayThumbColor: true,
            paletteType: PaletteType.hsvWithHue,
            labelTypes: const [],
            pickerAreaBorderRadius: const BorderRadius.only(
              topLeft: Radius.circular(2),
              topRight: Radius.circular(2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              colorService.setCustomPrimaryColor(selectedColor);
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
