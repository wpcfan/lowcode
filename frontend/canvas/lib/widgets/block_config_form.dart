import 'package:canvas/forms/form_model.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:models/models.dart';

import '../../blocs/canvas_state.dart';
import '../forms/validators.dart';

class BlockConfigForm extends StatefulWidget {
  const BlockConfigForm({
    super.key,
    required this.state,
    this.onSave,
    this.onDelete,
  });
  final CanvasState state;
  final void Function(PageBlock)? onSave;
  final void Function(int)? onDelete;

  @override
  State<BlockConfigForm> createState() => _BlockConfigFormState();
}

class _BlockConfigFormState extends State<BlockConfigForm> {
  final _titleController = TextEditingController();
  final _sortController = TextEditingController();
  final _horizontalPaddingController = TextEditingController();
  final _verticalPaddingController = TextEditingController();
  final _horizontalSpacingController = TextEditingController();
  final _verticalSpacingController = TextEditingController();
  final _blockWidthController = TextEditingController();
  final _blockHeightController = TextEditingController();
  final _backgroundColorController = TextEditingController();
  final _borderColorController = TextEditingController();
  final _borderWidthController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late PageBlock _formValue;

  @override
  Widget build(BuildContext context) {
    _formValue = widget.state.selectedBlock!;
    _titleController.text = _formValue.title;
    _sortController.text = '${_formValue.sort}';
    _horizontalPaddingController.text =
        '${_formValue.config.horizontalPadding}';
    _verticalPaddingController.text = '${_formValue.config.verticalPadding}';
    _horizontalSpacingController.text =
        '${_formValue.config.horizontalSpacing}';
    _verticalSpacingController.text = '${_formValue.config.verticalSpacing}';
    _blockWidthController.text = _formValue.config.blockWidth.toString();
    _blockHeightController.text = _formValue.config.blockHeight.toString();
    _backgroundColorController.text = _formValue.config.backgroundColor != null
        ? _formValue.config.backgroundColor!.value.toRadixString(16)
        : '';
    _borderColorController.text = _formValue.config.borderColor != null
        ? _formValue.config.borderColor!.value.toRadixString(16)
        : '';
    _borderWidthController.text = _formValue.config.borderWidth != null
        ? _formValue.config.borderWidth!.toString()
        : '0';
    const labels = [
      '标题',
      '排序',
      '水平内边距',
      '垂直内边距',
      '水平间距',
      '垂直间距',
      '区块宽度',
      '区块高度',
      '背景颜色',
      '边框颜色',
      '边框宽度',
    ];

    final fields = labels.map((label) {
      switch (label) {
        case '标题':
          return FormTextInput(
            label: label,
            hint: '请输入标题',
            validators: [
              Validators.required(label: label),
              Validators.maxLength(label: label, maxLength: 100),
              Validators.minLength(label: label, minLength: 2),
            ],
            onChanged: (value) {
              _formValue = _formValue.copyWith(title: value!);
            },
          );
        case '排序':
          return FormTextInput(
            label: label,
            hint: '请输入排序',
            validators: [
              Validators.required(label: label),
              Validators.isInteger(label: label),
              Validators.min(label: label, min: 0),
              Validators.max(label: label, max: 1000),
            ],
            onChanged: (value) {
              _formValue = _formValue.copyWith(sort: int.parse(value!));
            },
          );
        case '水平内边距':
          return FormTextInput(
            label: label,
            hint: '请输入水平内边距',
            validators: [
              Validators.required(label: label),
              Validators.isDouble(label: label),
              Validators.min(label: label, min: 0),
              Validators.max(label: label, max: 100),
            ],
            onChanged: (value) {
              _formValue = _formValue.copyWith(
                  config: _formValue.config.copyWith(
                      horizontalPadding: double.parse(value!)));
            },
          );
        case '垂直内边距':
          return FormTextInput(
            label: label,
            hint: '请输入垂直内边距',
            validators: [
              Validators.required(label: label),
              Validators.isDouble(label: label),
              Validators.min(label: label, min: 0),
              Validators.max(label: label, max: 100),
            ],
            onChanged: (value) {
              _formValue = _formValue.copyWith(
                  config: _formValue.config.copyWith(
                      verticalPadding: double.parse(value!)));
            },
          );
        case '水平间距':
          return FormTextInput(
            label: label,
            hint: '请输入水平间距',
            validators: [
              Validators.required(label: label),
              Validators.isDouble(label: label),
              Validators.min(label: label, min: 0),
              Validators.max(label: label, max: 100),
            ],
            onChanged: (value) {
              _formValue = _formValue.copyWith(
                  config: _formValue.config.copyWith(
                      horizontalSpacing: double.parse(value!)));
            },
          );
        case '垂直间距':
          return FormTextInput(
            label: label,
            hint: '请输入垂直间距',
            validators: [
              Validators.required(label: label),
              Validators.isDouble(label: label),
              Validators.min(label: label, min: 0),
              Validators.max(label: label, max: 100),
            ],
            onChanged: (value) {
              _formValue = _formValue.copyWith(
                  config: _formValue.config.copyWith(
                      verticalSpacing: double.parse(value!)));
            },
          );
        case '区块宽度':
          return FormTextInput(
            label: label,
            hint: '请输入区块宽度',
            validators: [
              Validators.required(label: label),
              Validators.isDouble(label: label),
              Validators.min(label: label, min: 0),
              Validators.max(label: label, max: 100),
            ],
            onChanged: (value) {
              _formValue = _formValue.copyWith(
                  config: _formValue.config.copyWith(
                      blockWidth: double.parse(value!)));
            },
          );
        case '区块高度':
          return FormTextInput(
            label: label,
            hint: '请输入区块高度',
            validators: [
              Validators.required(label: label),
              Validators.isDouble(label: label),
              Validators.min(label: label, min: 0),
              Validators.max(label: label, max: 100),
            ],
            onChanged: (value) {
              _formValue = _formValue.copyWith(
                  config: _formValue.config.copyWith(
                      blockHeight: double.parse(value!)));
            },
          );
        
      }
    })

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text('区块属性'),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '标题',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '标题不能为空';
                }
                if (value.length > 100) {
                  return '标题不能超过100个字符';
                }
                if (value.length < 2) {
                  return '标题不能少于2个字符';
                }
                return null;
              },
              onSaved: (value) {
                _formValue = _formValue.copyWith(title: value!);
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: _sortController,
              decoration: const InputDecoration(
                labelText: '排序',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '排序不能为空';
                }
                if (int.tryParse(value) == null) {
                  return '排序必须是数字';
                }
                if (int.parse(value) < 0) {
                  return '排序不能小于0';
                }
                if (int.parse(value) > 1000) {
                  return '排序不能大于100';
                }
                return null;
              },
              onSaved: (value) {
                _formValue = _formValue.copyWith(sort: int.parse(value!));
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: _horizontalPaddingController,
              decoration: const InputDecoration(
                labelText: '水平内边距',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '水平内边距不能为空';
                }
                if (double.tryParse(value) == null) {
                  return '水平内边距必须是数字';
                }
                if (double.parse(value) < 0) {
                  return '水平内边距不能小于0';
                }
                if (double.parse(value) > 100) {
                  return '水平内边距不能大于100';
                }
                return null;
              },
              onSaved: (newValue) {
                setState(() {
                  _formValue = _formValue.copyWith(
                      config: _formValue.config.copyWith(
                          horizontalPadding: double.parse(newValue!)));
                });
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: _verticalPaddingController,
              decoration: const InputDecoration(
                labelText: '垂直内边距',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '垂直内边距不能为空';
                }
                if (double.tryParse(value) == null) {
                  return '垂直内边距必须是数字';
                }
                if (double.parse(value) < 0) {
                  return '垂直内边距不能小于0';
                }
                if (double.parse(value) > 100) {
                  return '垂直内边距不能大于100';
                }
                return null;
              },
              onSaved: (newValue) {
                setState(() {
                  _formValue = _formValue.copyWith(
                      config: _formValue.config
                          .copyWith(verticalPadding: double.parse(newValue!)));
                });
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: _horizontalSpacingController,
              decoration: const InputDecoration(
                labelText: '水平间距',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '水平间距不能为空';
                }
                if (double.tryParse(value) == null) {
                  return '水平间距必须是数字';
                }
                if (double.parse(value) < 0) {
                  return '水平间距不能小于0';
                }
                if (double.parse(value) > 100) {
                  return '水平间距不能大于100';
                }
                return null;
              },
              onSaved: (newValue) {
                setState(() {
                  _formValue = _formValue.copyWith(
                      config: _formValue.config.copyWith(
                          horizontalSpacing: double.parse(newValue!)));
                });
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: _verticalSpacingController,
              decoration: const InputDecoration(
                labelText: '垂直间距',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '垂直间距不能为空';
                }
                if (double.tryParse(value) == null) {
                  return '垂直间距必须是数字';
                }
                if (double.parse(value) < 0) {
                  return '垂直间距不能小于0';
                }
                if (double.parse(value) > 100) {
                  return '垂直间距不能大于100';
                }
                return null;
              },
              onSaved: (newValue) {
                setState(() {
                  _formValue = _formValue.copyWith(
                      config: _formValue.config
                          .copyWith(verticalSpacing: double.parse(newValue!)));
                });
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: _blockWidthController,
              decoration: const InputDecoration(
                labelText: '区块宽度',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '区块宽度不能为空';
                }
                if (double.tryParse(value) == null) {
                  return '区块宽度必须是数字';
                }
                if (double.parse(value) < 0) {
                  return '区块宽度不能小于0';
                }
                if (double.parse(value) > 1000) {
                  return '区块宽度不能大于1000';
                }
                return null;
              },
              onSaved: (newValue) {
                setState(() {
                  _formValue = _formValue.copyWith(
                      config: _formValue.config
                          .copyWith(blockWidth: double.parse(newValue!)));
                });
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: _blockHeightController,
              decoration: const InputDecoration(
                labelText: '区块高度',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null;
                }
                if (double.tryParse(value) == null) {
                  return '区块高度必须是数字';
                }
                if (double.parse(value) < 0) {
                  return '区块高度不能小于0';
                }
                if (double.parse(value) > 1000) {
                  return '区块高度不能大于1000';
                }
                return null;
              },
              onSaved: (newValue) {
                setState(() {
                  _formValue = _formValue.copyWith(
                      config: _formValue.config
                          .copyWith(blockHeight: double.parse(newValue!)));
                });
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: _backgroundColorController,
              decoration: const InputDecoration(
                labelText: '背景颜色',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null;
                }
                if (value.length != 7 && value.length != 9) {
                  return '背景颜色格式不正确';
                }
                if (!value.startsWith('#')) {
                  return '背景颜色格式不正确';
                }
                return null;
              },
              onSaved: (newValue) {
                setState(() {
                  if (newValue == null || newValue.isEmpty) {
                    return;
                  }
                  _formValue = _formValue.copyWith(
                      config: _formValue.config
                          .copyWith(backgroundColor: HexColor(newValue)));
                });
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: _borderColorController,
              decoration: const InputDecoration(
                labelText: '边框颜色',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null;
                }
                if (value.length != 7 && value.length != 9) {
                  return '边框颜色格式不正确';
                }
                if (!value.startsWith('#')) {
                  return '边框颜色格式不正确';
                }
                return null;
              },
              onSaved: (newValue) {
                setState(() {
                  if (newValue == null || newValue.isEmpty) {
                    return;
                  }
                  _formValue = _formValue.copyWith(
                      config: _formValue.config
                          .copyWith(borderColor: HexColor(newValue)));
                });
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: _borderWidthController,
              decoration: const InputDecoration(
                labelText: '边框宽度',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '边框宽度不能为空';
                }
                if (double.tryParse(value) == null) {
                  return '边框宽度必须是数字';
                }
                if (double.parse(value) < 0) {
                  return '边框宽度不能小于0';
                }
                if (double.parse(value) > 10) {
                  return '边框宽度不能大于100';
                }
                return null;
              },
              onSaved: (newValue) {
                setState(() {
                  _formValue = _formValue.copyWith(
                      config: _formValue.config
                          .copyWith(borderWidth: double.parse(newValue!)));
                });
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      widget.onSave?.call(_formValue);
                    }
                  },
                  child: const Text('保存'),
                ),
                TextButton(
                    onPressed: () {
                      widget.onDelete?.call(_formValue.id!);
                    },
                    child: const Text(
                      '删除',
                      style: TextStyle(color: Colors.redAccent),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
