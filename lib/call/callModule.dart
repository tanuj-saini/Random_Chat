// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CallModule {
  final String callerId;
  final String callerName;

  final String reciverUserId;
  final String reciverName;
  final String callId;
  final bool haDialled;
  CallModule({
    required this.callerId,
    required this.callerName,
    required this.reciverUserId,
    required this.reciverName,
    required this.callId,
    required this.haDialled,
  });

  CallModule copyWith({
    String? callerId,
    String? callerName,
    String? reciverUserId,
    String? reciverName,
    String? callId,
    bool? haDialled,
  }) {
    return CallModule(
      callerId: callerId ?? this.callerId,
      callerName: callerName ?? this.callerName,
      reciverUserId: reciverUserId ?? this.reciverUserId,
      reciverName: reciverName ?? this.reciverName,
      callId: callId ?? this.callId,
      haDialled: haDialled ?? this.haDialled,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'callerId': callerId,
      'callerName': callerName,
      'reciverUserId': reciverUserId,
      'reciverName': reciverName,
      'callId': callId,
      'haDialled': haDialled,
    };
  }

  factory CallModule.fromMap(Map<String, dynamic> map) {
    return CallModule(
      callerId: map['callerId'] as String,
      callerName: map['callerName'] as String,
      reciverUserId: map['reciverUserId'] as String,
      reciverName: map['reciverName'] as String,
      callId: map['callId'] as String,
      haDialled: map['haDialled'] as bool,
    );
  }

  @override
  String toString() {
    return 'CallModule(callerId: $callerId, callerName: $callerName, reciverUserId: $reciverUserId, reciverName: $reciverName, callId: $callId, haDialled: $haDialled)';
  }

  @override
  bool operator ==(covariant CallModule other) {
    if (identical(this, other)) return true;

    return other.callerId == callerId &&
        other.callerName == callerName &&
        other.reciverUserId == reciverUserId &&
        other.reciverName == reciverName &&
        other.callId == callId &&
        other.haDialled == haDialled;
  }

  @override
  int get hashCode {
    return callerId.hashCode ^
        callerName.hashCode ^
        reciverUserId.hashCode ^
        reciverName.hashCode ^
        callId.hashCode ^
        haDialled.hashCode;
  }
}
