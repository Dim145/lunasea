/// JSON converters that tolerate Tracearr's API quirks: large integers
/// (e.g. durations in ms) are sometimes serialized as JSON strings rather
/// than numbers depending on the underlying DB/driver. These helpers accept
/// either form and never throw.

int? intFromJson(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

dynamic intToJson(int? v) => v;
