import 'package:drift/drift.dart';

class LocalCheckIns extends Table {
  TextColumn get id => text()();
  TextColumn get superviseeId => text()();
  DateTimeColumn get checkinTimestamp => dateTime()();
  TextColumn get checkinType => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get accuracyMeters => real().nullable()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get receiptCode => text()();
  TextColumn get syncStatus => text().withDefault(const Constant('PENDING'))(); // PENDING, SYNCED

  Set<Column> get primaryKeys => {id};
}
