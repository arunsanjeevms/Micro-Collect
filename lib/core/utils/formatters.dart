import 'package:intl/intl.dart';

/// Currency, date, phone, and ID formatting utilities
class AppFormatters {
  AppFormatters._();

  static final _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final _currencyFormatWithDecimals = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static final _numberFormat = NumberFormat('#,##,###', 'en_IN');

  static final _dateFormat = DateFormat('dd MMM yyyy');
  static final _dateTimeFormat = DateFormat('dd MMM yyyy, hh:mm a');
  static final _shortDateFormat = DateFormat('dd/MM/yyyy');
  static final _timeFormat = DateFormat('hh:mm a');
  static final _monthYearFormat = DateFormat('MMMM yyyy');

  /// Format as ₹24,850
  static String currency(num amount) => _currencyFormat.format(amount);

  /// Format as ₹24,850.00
  static String currencyWithDecimals(num amount) =>
      _currencyFormatWithDecimals.format(amount);

  /// Format number with Indian grouping: 1,23,456
  static String number(num value) => _numberFormat.format(value);

  /// Format as "17 Aug 2026"
  static String date(DateTime date) => _dateFormat.format(date);

  /// Format as "17 Aug 2026, 12:30 PM"
  static String dateTime(DateTime date) => _dateTimeFormat.format(date);

  /// Format as "17/08/2026"
  static String shortDate(DateTime date) => _shortDateFormat.format(date);

  /// Format as "12:30 PM"
  static String time(DateTime date) => _timeFormat.format(date);

  /// Format as "August 2026"
  static String monthYear(DateTime date) => _monthYearFormat.format(date);

  /// Format phone: 98765 43210
  static String phone(String number) {
    final clean = number.replaceAll(RegExp(r'\D'), '');
    if (clean.length == 10) {
      return '${clean.substring(0, 5)} ${clean.substring(5)}';
    }
    return number;
  }

  /// Format Aadhaar: 1234 5678 9012
  static String aadhaar(String number) {
    final clean = number.replaceAll(RegExp(r'\D'), '');
    if (clean.length == 12) {
      return '${clean.substring(0, 4)} ${clean.substring(4, 8)} ${clean.substring(8)}';
    }
    return number;
  }

  /// Format percentage: 82.8%
  static String percentage(double value, {int decimals = 1}) {
    return '${value.toStringAsFixed(decimals)}%';
  }

  /// Relative time: "2 hours ago", "Just now", "Yesterday"
  static String relativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return date(dateTime);
  }

  /// Mask aadhaar: XXXX XXXX 9012
  static String maskAadhaar(String number) {
    final clean = number.replaceAll(RegExp(r'\D'), '');
    if (clean.length == 12) {
      return 'XXXX XXXX ${clean.substring(8)}';
    }
    return number;
  }
}
