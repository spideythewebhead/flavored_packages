import 'dart:convert';

class Json2YamlEncoder extends Converter<Object?, String> {
  Json2YamlEncoder({
    this.indent = '  ',
  });

  final String indent;
  final _buffer = StringBuffer();

  @override
  String convert(Object? input) {
    _parse(input);
    final output = _buffer.toString();
    _buffer.clear();
    return output;
  }

  void _parse(Object? input, {int indentLevel = 0}) {
    if (input is Map) {
      for (final key in input.keys) {
        final value = input[key];

        _buffer.write(indent * indentLevel);

        if (value is Map) {
          _buffer.writeln('$key:');
          _parse(value, indentLevel: 1 + indentLevel);
        } else if (value is List) {
          _buffer.writeln('$key:');
          _parse(value, indentLevel: 1 + indentLevel);
        } else if (value is String) {
          _buffer.writeln("$key: '$value'");
        } else {
          _buffer.writeln('$key: $value');
        }
      }
    } else if (input is List) {
      for (final value in input) {
        if (value is Map) {
          _parse(value, indentLevel: indentLevel);
        } else if (value is List) {
          _parse(value, indentLevel: indentLevel);
        }
      }
    } else if (input is String) {
      _buffer
        ..write(indent * indentLevel)
        ..writeln("'$input'");
    } else {
      _buffer
        ..write(indent * indentLevel)
        ..writeln(input);
    }
  }
}
