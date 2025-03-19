import 'package:practice_app/features/counter/domain/entities/counter.dart';

class CounterModel extends Counter {
  const CounterModel({required super.count});

  factory CounterModel.fromJson(Map<String, dynamic> json) {
    return CounterModel(count: convertToInt(json['count']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    return data;
  }

  /// Convert a domain Counter to CounterModel
  factory CounterModel.fromEntity(Counter counter) {
    return CounterModel(count: counter.count);
  }

  /// Convert a CounterModel to domain Counter
  Counter toEntity() {
    return Counter(count: count);
  }

  static int convertToInt(dynamic value) {
    if (value is int) {
      return value;
    } else if (value is double) {
      return value.toInt();
    } else if (value is String) {
      final parsedValue = int.tryParse(value);
      if (parsedValue != null) {
        return parsedValue;
      }
    }

    throw FormatException("Invalid value for integer conversion: $value");
  }
}
