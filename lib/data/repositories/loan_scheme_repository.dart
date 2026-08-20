import '../../core/models/loan_scheme.dart';

class LoanSchemeDraft {
  const LoanSchemeDraft({
    required this.code,
    required this.name,
    this.active = true,
    required this.principalMin,
    required this.principalMax,
    required this.tenureMin,
    required this.tenureMax,
    required this.tenureUnit,
    required this.frequency,
  });

  final String code;
  final String name;
  final bool active;
  final double principalMin;
  final double principalMax;
  final int tenureMin;
  final int tenureMax;
  final String tenureUnit;
  final String frequency;
}

abstract interface class LoanSchemeRepository {
  Future<List<LoanScheme>> fetchAll();

  Future<LoanScheme> create(LoanSchemeDraft draft);

  Future<LoanScheme> setActive(String id, bool active);

  Future<void> delete(String id);
}
