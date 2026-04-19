class EmployeeLoanInstallementsType {
  const EmployeeLoanInstallementsType({
    required this.code,
    required this.name,
    required this.description,
    required this.percentage,
    required this.id,
  });

  final String code;
  final String name;
  final String description;
  final double percentage;
  final String id;

  factory EmployeeLoanInstallementsType.fromJson(Map<String, dynamic> json) {
    return EmployeeLoanInstallementsType(
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
      id: json['id'] as String? ?? '',
    );
  }
}

class EmployeeLoanPeriod {
  const EmployeeLoanPeriod({
    required this.startDate,
    required this.endDate,
  });

  final String startDate;
  final String endDate;

  factory EmployeeLoanPeriod.fromJson(Map<String, dynamic> json) {
    return EmployeeLoanPeriod(
      startDate: json['startDate'] as String? ?? '',
      endDate: json['endDate'] as String? ?? '',
    );
  }
}

class EmployeeLoanRequester {
  const EmployeeLoanRequester({
    required this.requesterId,
    required this.requesterName,
  });

  final String requesterId;
  final String requesterName;

  factory EmployeeLoanRequester.fromJson(Map<String, dynamic> json) {
    return EmployeeLoanRequester(
      requesterId: json['requesterId'] as String? ?? '',
      requesterName: json['requesterName'] as String? ?? '',
    );
  }
}

class EmployeeLoanItem {
  const EmployeeLoanItem({
    required this.id,
    required this.code,
    required this.installementsType,
    required this.amount,
    required this.period,
    required this.status,
    required this.loanRequester,
  });

  final String id;
  final String code;
  final EmployeeLoanInstallementsType installementsType;
  final double amount;
  final EmployeeLoanPeriod period;
  final int status;
  final EmployeeLoanRequester loanRequester;

  factory EmployeeLoanItem.fromJson(Map<String, dynamic> json) {
    return EmployeeLoanItem(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      installementsType: EmployeeLoanInstallementsType.fromJson(
        (json['installementsType'] as Map<String, dynamic>?) ??
            <String, dynamic>{},
      ),
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      period: EmployeeLoanPeriod.fromJson(
        (json['period'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
      status: (json['status'] as num?)?.toInt() ?? 0,
      loanRequester: EmployeeLoanRequester.fromJson(
        (json['loanRequester'] as Map<String, dynamic>?) ??
            <String, dynamic>{},
      ),
    );
  }
}

