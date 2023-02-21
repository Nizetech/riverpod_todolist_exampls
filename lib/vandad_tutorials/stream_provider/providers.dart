import 'package:hooks_riverpod/hooks_riverpod.dart';

const names = [
  'Vandad',
  'John',
  'Jane',
  'Doe',
  'Smith',
  'Doe',
  'emeka',
  'Merit',
  'Chuks',
  'Chukwudi',
  'Chukwuma',
  'Chukwunonso',
  'Sarah',
  'Sandra',
  'Samantha',
  'Samuel',
  'Sam',
  'Samson',
  'Jude',
  'Judith',
  'Judah',
];

final tickerProvider = StreamProvider(
  (ref) => Stream.periodic(const Duration(seconds: 1), (i) => i + 1),
);

final nameProvider = StreamProvider(
  (ref) => ref.watch(tickerProvider.stream).map(
        (count) => names.getRange(0, count),
      ),
);
