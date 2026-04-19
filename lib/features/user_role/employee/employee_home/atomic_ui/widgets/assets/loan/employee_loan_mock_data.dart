import 'employee_loan_models.dart';

const Map<String, dynamic> _mockLoanResponse = <String, dynamic>{
  'value': <Map<String, dynamic>>[
    <String, dynamic>{
      'id': '019d81a3-cff4-7359-af71-717085161c4c',
      'code': 'LRQ-20260412-2334',
      'installementsType': <String, dynamic>{
        'code': 'IT-001',
        'name': 'قرض سكني',
        'description': 'قرض مخصص لشراء أو بناء أو تجديد مسكن',
        'percentage': 29,
        'id': '019d81a3-cf68-769b-b34f-5cb80ec42490',
      },
      'amount': 45148,
      'period': <String, dynamic>{
        'startDate': '2026-03-12',
        'endDate': '2029-06-12',
      },
      'status': 0,
      'loanRequester': <String, dynamic>{
        'requesterId': '019d81a3-c43a-703c-861f-b5c8c5c70615',
        'requesterName': 'Yasmin Ahmed',
      },
    },
    <String, dynamic>{
      'id': '019d81a3-d033-702a-b6be-62fb19f7238a',
      'code': 'LRQ-20260412-7167',
      'installementsType': <String, dynamic>{
        'code': 'IT-003',
        'name': 'قرض سيارة',
        'description': 'قرض لشراء مركبة جديدة أو مستعملة',
        'percentage': 13,
        'id': '019d81a3-cf82-72ac-974d-75e4a06ee56e',
      },
      'amount': 51794,
      'period': <String, dynamic>{
        'startDate': '2026-01-12',
        'endDate': '2028-04-12',
      },
      'status': 0,
      'loanRequester': <String, dynamic>{
        'requesterId': '019d81a3-c751-7799-9bec-7614b23bffca',
        'requesterName': 'Hana Hassan',
      },
    },
    <String, dynamic>{
      'id': '019d81a3-d036-738a-aed8-b9effb4936a5',
      'code': 'LRQ-20260412-9858',
      'installementsType': <String, dynamic>{
        'code': 'IT-004',
        'name': 'قرض تعليمي',
        'description': 'قرض لتمويل الدراسة الجامعية أو الدورات التدريبية',
        'percentage': 14,
        'id': '019d81a3-cf85-732d-9de0-996934d3f523',
      },
      'amount': 12563,
      'period': <String, dynamic>{
        'startDate': '2026-02-12',
        'endDate': '2029-03-12',
      },
      'status': 1,
      'loanRequester': <String, dynamic>{
        'requesterId': '019d81a3-c6dd-79b2-973a-82877096da9b',
        'requesterName': 'Yasmin Hassan',
      },
    },
    <String, dynamic>{
      'id': '019d81a3-d039-742c-81c3-9b6169269ee0',
      'code': 'LRQ-20260412-3293',
      'installementsType': <String, dynamic>{
        'code': 'IT-005',
        'name': 'قرض طبي',
        'description': 'قرض لتغطية النفقات الطبية والعلاجية',
        'percentage': 18,
        'id': '019d81a3-cf87-71e3-af64-8f2df880a667',
      },
      'amount': 34839,
      'period': <String, dynamic>{
        'startDate': '2026-01-12',
        'endDate': '2028-03-12',
      },
      'status': 0,
      'loanRequester': <String, dynamic>{
        'requesterId': '019d81a3-ca56-75f4-9035-9d37d973365c',
        'requesterName': 'Fatma Abdallah',
      },
    },
    <String, dynamic>{
      'id': '019d81a3-d03c-79ce-9125-32badc616754',
      'code': 'LRQ-20260412-7648',
      'installementsType': <String, dynamic>{
        'code': 'IT-006',
        'name': 'قرض زواج',
        'description': 'قرض لتمويل تكاليف حفل الزفاف والمتعلقات',
        'percentage': 13,
        'id': '019d81a3-cf89-7a2b-9de3-c86649d772d9',
      },
      'amount': 51619,
      'period': <String, dynamic>{
        'startDate': '2025-12-12',
        'endDate': '2030-11-12',
      },
      'status': 1,
      'loanRequester': <String, dynamic>{
        'requesterId': '019d81a3-ca56-75f4-9035-9d37d973365c',
        'requesterName': 'Fatma Abdallah',
      },
    },
    <String, dynamic>{
      'id': '019d81a3-d03f-75d8-ad73-cdcefff9b215',
      'code': 'LRQ-20260412-9247',
      'installementsType': <String, dynamic>{
        'code': 'IT-007',
        'name': 'قرض سفر',
        'description': 'قرض لتمويل رحلة سياحية أو علاجية',
        'percentage': 12,
        'id': '019d81a3-cf8b-7e77-b82b-7cdcdf897df2',
      },
      'amount': 53751,
      'period': <String, dynamic>{
        'startDate': '2026-02-12',
        'endDate': '2029-10-12',
      },
      'status': 1,
      'loanRequester': <String, dynamic>{
        'requesterId': '019d81a3-c945-747f-b34d-6be1bf2ccfae',
        'requesterName': 'Ali Hussein',
      },
    },
    <String, dynamic>{
      'id': '019d81a3-d043-7883-849a-bda70958e77b',
      'code': 'LRQ-20260412-3653',
      'installementsType': <String, dynamic>{
        'code': 'IT-008',
        'name': 'قرض تجاري',
        'description': 'قرض لتمويل مشروع تجاري أو نشاط اقتصادي',
        'percentage': 9,
        'id': '019d81a3-cf8d-771c-a8d2-96875e93c52c',
      },
      'amount': 74649,
      'period': <String, dynamic>{
        'startDate': '2025-12-12',
        'endDate': '2029-02-12',
      },
      'status': 2,
      'loanRequester': <String, dynamic>{
        'requesterId': '019d81a3-c5fb-7520-a00d-f28c26c804d5',
        'requesterName': 'Tarek Sherif',
      },
    },
    <String, dynamic>{
      'id': '019d81a3-d046-7fe0-87a1-00be11315426',
      'code': 'LRQ-20260412-4644',
      'installementsType': <String, dynamic>{
        'code': 'IT-009',
        'name': 'قرض عائلي',
        'description': 'قرض لمساعدة أفراد العائلة في احتياجاتهم',
        'percentage': 6,
        'id': '019d81a3-cf8e-7d4b-9693-b58c2aec6866',
      },
      'amount': 12926,
      'period': <String, dynamic>{
        'startDate': '2025-11-12',
        'endDate': '2027-12-12',
      },
      'status': 1,
      'loanRequester': <String, dynamic>{
        'requesterId': '019d81a3-c801-78c0-915f-e55fcfc8d71d',
        'requesterName': 'Yasmin ElDawy',
      },
    },
    <String, dynamic>{
      'id': '019d81a3-d049-7bba-bd7f-934f8720f038',
      'code': 'LRQ-20260412-3306',
      'installementsType': <String, dynamic>{
        'code': 'IT-010',
        'name': 'قرض سيولة',
        'description': 'قرض لتوفير سيولة مالية مؤقتة',
        'percentage': 29,
        'id': '019d81a3-cf90-7251-8efc-cd297d4e3016',
      },
      'amount': 83410,
      'period': <String, dynamic>{
        'startDate': '2026-01-12',
        'endDate': '2028-02-12',
      },
      'status': 0,
      'loanRequester': <String, dynamic>{
        'requesterId': '019d81a3-c740-7975-8f32-7d038fb73b0d',
        'requesterName': 'Mahmoud Ahmed',
      },
    },
    <String, dynamic>{
      'id': '019d81a3-d04c-78bc-8048-091496dbbe8e',
      'code': 'LRQ-20260412-1673',
      'installementsType': <String, dynamic>{
        'code': 'IT-011',
        'name': 'قرض استثماري',
        'description': 'قرض لتمويل مشاريع استثمارية مربحة',
        'percentage': 11,
        'id': '019d81a3-cf91-715f-a7ff-68d4ebe814ad',
      },
      'amount': 90361,
      'period': <String, dynamic>{
        'startDate': '2025-11-12',
        'endDate': '2030-04-12',
      },
      'status': 1,
      'loanRequester': <String, dynamic>{
        'requesterId': '019d81a3-ca33-7ec1-a1a8-e3fb004c14bb',
        'requesterName': 'Sara Ibrahim',
      },
    },
    <String, dynamic>{
      'id': '019d81a3-d04f-7f6c-b552-14fc5c00ed8c',
      'code': 'LRQ-20260412-5131',
      'installementsType': <String, dynamic>{
        'code': 'IT-012',
        'name': 'قرض إنشائي',
        'description': 'قرض لتمويل أعمال البناء والتشييد',
        'percentage': 18,
        'id': '019d81a3-cf94-77fc-9037-87fb6134eb35',
      },
      'amount': 71619,
      'period': <String, dynamic>{
        'startDate': '2025-12-12',
        'endDate': '2030-11-12',
      },
      'status': 0,
      'loanRequester': <String, dynamic>{
        'requesterId': '019d81a3-ca43-7860-b39f-23b2b25b5ff0',
        'requesterName': 'Ali Sherif',
      },
    },
    <String, dynamic>{
      'id': '019d81a3-d053-71fc-bdf7-0f48411e684c',
      'code': 'LRQ-20260412-6108',
      'installementsType': <String, dynamic>{
        'code': 'IT-013',
        'name': 'قرض تأهيل',
        'description': 'قرض لتمويل برامج التأهيل والتدريب',
        'percentage': 7,
        'id': '019d81a3-cf96-72cc-85d2-332e942b3975',
      },
      'amount': 52414,
      'period': <String, dynamic>{
        'startDate': '2025-12-12',
        'endDate': '2027-12-12',
      },
      'status': 0,
      'loanRequester': <String, dynamic>{
        'requesterId': '019d81a3-c62d-79fc-8f9e-e8d723c8f711',
        'requesterName': 'Asmaa Farouk',
      },
    },
    <String, dynamic>{
      'id': '019d81a3-d057-7f0f-909f-d9e8d8338c3c',
      'code': 'LRQ-20260412-5118',
      'installementsType': <String, dynamic>{
        'code': 'IT-014',
        'name': 'قرض سياحة',
        'description': 'قرض مخصص للرحلات والأنشطة السياحية',
        'percentage': 29,
        'id': '019d81a3-cf98-7a65-a392-7cb30a3a7e8e',
      },
      'amount': 36472,
      'period': <String, dynamic>{
        'startDate': '2025-11-12',
        'endDate': '2028-08-12',
      },
      'status': 0,
      'loanRequester': <String, dynamic>{
        'requesterId': '019d81a3-c40e-7aeb-ae52-63c6f39ffa9d',
        'requesterName': 'Rahma ElSharkawy',
      },
    },
    <String, dynamic>{
      'id': '019d81a3-d05a-768c-a48b-f3e9c54c579e',
      'code': 'LRQ-20260412-6285',
      'installementsType': <String, dynamic>{
        'code': 'IT-015',
        'name': 'قرض تقاعد',
        'description': 'قرض مخصص للموظفين المقبلين على التقاعد',
        'percentage': 24,
        'id': '019d81a3-cf9a-760c-b7f3-805ab05eea6a',
      },
      'amount': 56074,
      'period': <String, dynamic>{
        'startDate': '2026-02-12',
        'endDate': '2029-09-12',
      },
      'status': 2,
      'loanRequester': <String, dynamic>{
        'requesterId': '019d81a3-c970-7408-bf22-d9f0128499ca',
        'requesterName': 'Mostafa Rashad',
      },
    },
    <String, dynamic>{
      'id': '019d90f9-2c4d-7bd0-ade5-3c339e81f793',
      'code': 'LoanReq-0016',
      'installementsType': <String, dynamic>{
        'code': 'IT-002',
        'name': 'قرض شخصي',
        'description': 'قرض لتغطية الاحتياجات الشخصية والمصاريف اليومية',
        'percentage': 24,
        'id': '019d81a3-cf7f-7c17-b580-460489255fbb',
      },
      'amount': 1000,
      'period': <String, dynamic>{
        'startDate': '2026-04-15',
        'endDate': '2026-05-20',
      },
      'status': 0,
      'loanRequester': <String, dynamic>{
        'requesterId': '019d71d0-6db2-7cd4-b20b-d7d97e747e5f',
        'requesterName': 'test test',
      },
    },
  ],
  'status': 200,
  'isSuccess': true,
};

final List<EmployeeLoanItem> kEmployeeLoanMockItems =
    ((_mockLoanResponse['value'] as List<dynamic>? ?? <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .map(EmployeeLoanItem.fromJson)
            .toList())
        .cast<EmployeeLoanItem>();

