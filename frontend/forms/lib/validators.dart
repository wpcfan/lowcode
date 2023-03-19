typedef Validator = String? Function(String?);

/// 表单验证器
/// [required] 必填
/// [minLength] 最小长度
/// [maxLength] 最大长度
/// [isInteger] 是否是整数
/// [isDouble] 是否是浮点数
/// [min] 最小值
/// [max] 最大值
/// [regexp] 正则表达式
class Validators {
  static Validator required({String? label, String? message}) {
    return (value) {
      if (value == null || value.isEmpty) {
        return message ?? '$label不能为空';
      }
      return null;
    };
  }

  static Validator minLength(
      {int minLength = 6, String? label, String? message}) {
    return (value) {
      if (value == null || value.isEmpty) {
        return null;
      }
      if (value.length < minLength) {
        return message ?? '$label长度不能小于$minLength';
      }
      return null;
    };
  }

  static Validator maxLength(
      {int maxLength = 255, String? label, String? message}) {
    return (value) {
      if (value == null || value.isEmpty) {
        return null;
      }
      if (value.length > maxLength) {
        return message ?? '$label长度不能大于$maxLength';
      }
      return null;
    };
  }

  static Validator isInteger({String? label, String? message}) {
    return (value) {
      if (value == null || value.isEmpty) {
        return null;
      }
      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        return message ?? '$label必须是数字';
      }
      return null;
    };
  }

  static Validator isDouble({String? label, String? message}) {
    return (value) {
      if (value == null || value.isEmpty) {
        return null;
      }
      if (!RegExp(r'^[0-9]+(\.[0-9]+)?$').hasMatch(value)) {
        return message ?? '$label必须是数字';
      }
      return null;
    };
  }

  static Validator min({int min = 0, String? label, String? message}) {
    return (value) {
      if (value == null || value.isEmpty) {
        return null;
      }
      if (int.parse(value) < min) {
        return message ?? '$label不能小于$min';
      }
      return null;
    };
  }

  static Validator max({int max = 1000, String? label, String? message}) {
    return (value) {
      if (value == null || value.isEmpty) {
        return null;
      }
      if (int.parse(value) > max) {
        return message ?? '$label不能大于$max';
      }
      return null;
    };
  }

  static Validator regexp(String pattern, String? message) {
    return (value) {
      if (value == null || value.isEmpty) {
        return null;
      }
      if (!RegExp(pattern).hasMatch(value)) {
        return message ?? '格式不正确';
      }
      return null;
    };
  }
}
