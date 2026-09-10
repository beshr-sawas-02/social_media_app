String formatRelativeTime(String raw) {
  if (raw.isEmpty || raw.contains('FieldValue')) return 'just now';

  DateTime? date = DateTime.tryParse(raw);
  date ??= DateTime.tryParse(raw.replaceFirst(' at ', ' '));
  if (date == null) return 'just now';
  return formatRelativeDateTime(date);
}

String formatRelativeDateTime(DateTime date) {
  final diff = DateTime.now().difference(date);
  if (diff.isNegative || diff.inSeconds < 60) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  return '${date.day}/${date.month}/${date.year}';
}
