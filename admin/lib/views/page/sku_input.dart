import 'package:flutter/material.dart';

class SkuInput extends StatefulWidget {
  final Function(String) onSkuChanged;

  const SkuInput({super.key, required this.onSkuChanged});

  @override
  State<SkuInput> createState() => _SkuInputState();
}

class _SkuInputState extends State<SkuInput> {
  final _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textEditingController,
      decoration: InputDecoration(
        labelText: '输入SKU',
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _textEditingController.clear();
            widget.onSkuChanged('');
          },
        ),
      ),
      onChanged: (value) {
        widget.onSkuChanged(value);
      },
    );
  }
}
