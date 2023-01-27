import 'package:algorand_json/src/big_int_json_reader.dart';
import 'package:dio/dio.dart';
import 'package:jsontool/jsontool.dart';

/// [Transformer] that allows changes to the request/response data before it
/// is sent/received to/from the server.
class BigIntJsonTransformer extends DefaultTransformer {
  BigIntJsonTransformer._({
    required JsonDecodeCallback jsonDecodeCallback,
  }) : super(jsonDecodeCallback: jsonDecodeCallback);

  /// [BigIntJsonTransformer] transforms numeric types to BigInt, only if they
  /// are registered in the keys array.
  ///
  /// This enables >2**63 numeric JSON values to be represented as a BigInt and
  /// solves the way `jsonDecode` deserializes big integer values.
  ///
  /// [Keys] - Specify the keys that you want to be transformed to a [BigInt].
  factory BigIntJsonTransformer({
    List<String>? keys,
  }) {
    return BigIntJsonTransformer._(
      jsonDecodeCallback: (responseBody) {
        Object? value;
        final reader = BigIntJsonReader(keys ?? [], (result) {
          value = result;
        });

        reader.processValue(JsonReader.fromString(responseBody));

        return value;
      },
    );
  }
}
