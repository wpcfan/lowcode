import 'package:admin/blocs/layout_bloc.dart';
import 'package:admin/blocs/layout_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

import '../../blocs/layout_state.dart';

class PageUpdateDialog extends StatefulWidget {
  const PageUpdateDialog(
      {super.key, required this.bloc, this.layout, this.onConfirm});
  final PageLayout? layout;
  final LayoutBloc bloc;
  final void Function(PageLayout layout)? onConfirm;

  @override
  State<PageUpdateDialog> createState() => _PageUpdateDialogState();
}

class _PageUpdateDialogState extends State<PageUpdateDialog> {
  late PageLayout formValue;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    formValue = widget.layout ?? PageLayout.empty();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LayoutBloc, LayoutState>(
      bloc: widget.bloc,
      listener: (context, state) {
        if (state.loading) {
          return;
        }
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error ?? '未知错误'),
            ),
          );
        } else {
          Navigator.of(context).pop();
        }
      },
      child: AlertDialog(
        title: const Text('更新页面布局'),
        content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: widget.layout?.title,
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
                    setState(() {
                      formValue = formValue.copyWith(title: value);
                    });
                  },
                ),
                DropdownButtonFormField<Platform>(
                  value: widget.layout?.platform,
                  decoration: const InputDecoration(
                    labelText: '平台',
                  ),
                  items: [
                    DropdownMenuItem(
                      value: Platform.app,
                      child: Text(Platform.app.value),
                    ),
                    DropdownMenuItem(
                      value: Platform.web,
                      child: Text(Platform.web.value),
                    ),
                  ],
                  onChanged: (value) {},
                  onSaved: (newValue) {
                    setState(() {
                      formValue = formValue.copyWith(platform: newValue);
                    });
                  },
                ),
                DropdownButtonFormField<PageType>(
                  value: widget.layout?.pageType,
                  decoration: const InputDecoration(
                    labelText: '类型',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: PageType.home,
                      child: Text('首页'),
                    ),
                    DropdownMenuItem(
                      value: PageType.category,
                      child: Text('列表'),
                    ),
                    DropdownMenuItem(
                      value: PageType.about,
                      child: Text('关于'),
                    ),
                  ],
                  onChanged: (value) {},
                  onSaved: (newValue) => setState(() {
                    formValue = formValue.copyWith(pageType: newValue);
                  }),
                ),
                TextFormField(
                  initialValue:
                      widget.layout?.config.horizontalPadding?.toString(),
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
                      formValue = formValue.copyWith(
                          config: formValue.config.copyWith(
                              horizontalPadding: double.parse(newValue!)));
                    });
                  },
                ),
                TextFormField(
                  initialValue:
                      widget.layout?.config.verticalPadding?.toString(),
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
                      formValue = formValue.copyWith(
                          config: formValue.config.copyWith(
                              verticalPadding: double.parse(newValue!)));
                    });
                  },
                ),
                TextFormField(
                  initialValue:
                      widget.layout?.config.baselineScreenWidth?.toString(),
                  decoration: const InputDecoration(
                    labelText: '基线屏幕宽度',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '基线屏幕宽度不能为空';
                    }
                    if (double.tryParse(value) == null) {
                      return '基线屏幕宽度必须是数字';
                    }
                    if (double.parse(value) < 300) {
                      return '基线屏幕宽度不能小于0';
                    }
                    if (double.parse(value) > 1800) {
                      return '基线屏幕宽度不能大于1800';
                    }
                    return null;
                  },
                  onSaved: (newValue) => setState(() {
                    formValue = formValue.copyWith(
                        config: formValue.config.copyWith(
                            baselineScreenWidth: double.parse(newValue!)));
                  }),
                ),
              ],
            )),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                formKey.currentState?.save();
                widget.bloc
                    .add(LayoutEventUpdate(widget.layout!.id!, formValue));
              }
            },
            child: const Text('更新'),
          ),
        ],
      ),
    );
  }
}
