// GENERATED MANUALLY: do not edit without updating typeId
part of 'pending_action.dart';

class PendingActionAdapter extends TypeAdapter<PendingAction> {
  @override
  final int typeId = 1;

  @override
  PendingAction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return PendingAction(
      id: fields[0] as String,
      type: PendingActionType.values[fields[1] as int],
      payload: Map<String, dynamic>.from(fields[2] as Map),
      createdAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PendingAction obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type.index)
      ..writeByte(2)
      ..write(obj.payload)
      ..writeByte(3)
      ..write(obj.createdAt);
  }
}
