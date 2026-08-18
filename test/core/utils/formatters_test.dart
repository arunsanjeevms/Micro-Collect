import 'package:flutter_test/flutter_test.dart';
import 'package:microcollect/core/utils/formatters.dart';

void main() {
  group('currency', () {
    test('prefixes the rupee symbol and drops decimals', () {
      expect(AppFormatters.currency(24850), '₹24,850');
    });

    test('groups lakhs the Indian way, not in thousands', () {
      expect(AppFormatters.currency(124850), '₹1,24,850');
    });

    test('formats zero', () {
      expect(AppFormatters.currency(0), '₹0');
    });
  });

  group('currencyWithDecimals', () {
    test('keeps two decimal places', () {
      expect(AppFormatters.currencyWithDecimals(2200.5), '₹2,200.50');
    });
  });

  group('number', () {
    test('groups lakhs without a currency symbol', () {
      expect(AppFormatters.number(123456), '1,23,456');
    });
  });

  group('date formatting', () {
    final sample = DateTime(2026, 8, 17, 12, 30);

    test('date renders as dd MMM yyyy', () {
      expect(AppFormatters.date(sample), '17 Aug 2026');
    });

    test('shortDate renders as dd/MM/yyyy', () {
      expect(AppFormatters.shortDate(sample), '17/08/2026');
    });

    test('dateTime appends a 12-hour clock time', () {
      expect(AppFormatters.dateTime(sample), '17 Aug 2026, 12:30 PM');
    });

    test('time renders just the clock time', () {
      expect(AppFormatters.time(sample), '12:30 PM');
    });

    test('monthYear renders the full month name', () {
      expect(AppFormatters.monthYear(sample), 'August 2026');
    });
  });

  group('phone', () {
    test('splits a ten digit number into 5 + 5', () {
      expect(AppFormatters.phone('9876543210'), '98765 43210');
    });

    test('strips existing separators before splitting', () {
      expect(AppFormatters.phone('98765-43210'), '98765 43210');
    });

    test('returns the input untouched when it is not ten digits', () {
      expect(AppFormatters.phone('12345'), '12345');
    });
  });

  group('aadhaar', () {
    test('splits twelve digits into three groups of four', () {
      expect(AppFormatters.aadhaar('234567891234'), '2345 6789 1234');
    });

    test('returns the input untouched when it is not twelve digits', () {
      expect(AppFormatters.aadhaar('2345'), '2345');
    });
  });

  group('maskAadhaar', () {
    test('reveals only the last four digits', () {
      expect(AppFormatters.maskAadhaar('234567891234'), 'XXXX XXXX 1234');
    });

    test('returns the input untouched when it is not twelve digits', () {
      expect(AppFormatters.maskAadhaar('1234'), '1234');
    });
  });

  group('percentage', () {
    test('defaults to one decimal place', () {
      expect(AppFormatters.percentage(82.75), '82.8%');
    });

    test('honours an explicit decimal count', () {
      expect(AppFormatters.percentage(82.75, decimals: 0), '83%');
    });
  });

  group('relativeTime', () {
    test('describes the last minute as just now', () {
      expect(
        AppFormatters.relativeTime(
          DateTime.now().subtract(const Duration(seconds: 30)),
        ),
        'Just now',
      );
    });

    test('describes minutes within the hour', () {
      expect(
        AppFormatters.relativeTime(
          DateTime.now().subtract(const Duration(minutes: 5)),
        ),
        '5m ago',
      );
    });

    test('describes hours within the day', () {
      expect(
        AppFormatters.relativeTime(
          DateTime.now().subtract(const Duration(hours: 3)),
        ),
        '3h ago',
      );
    });

    test('describes the previous day as yesterday', () {
      expect(
        AppFormatters.relativeTime(
          DateTime.now().subtract(const Duration(days: 1)),
        ),
        'Yesterday',
      );
    });

    test('describes days within the week', () {
      expect(
        AppFormatters.relativeTime(
          DateTime.now().subtract(const Duration(days: 3)),
        ),
        '3d ago',
      );
    });

    test('falls back to an absolute date beyond a week', () {
      final old = DateTime(2020, 1, 15);
      expect(AppFormatters.relativeTime(old), '15 Jan 2020');
    });
  });
}
