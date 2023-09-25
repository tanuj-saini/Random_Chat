// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatModule {
  final String currUserName;
  final String ReciverUserName;
  final String cuuUId;
  final String reciverUserId;
  final String MessageText;
  final String isMe;
  final DateTime createdAt;

  final String type;
  const ChatModule({
    required this.currUserName,
    required this.ReciverUserName,
    required this.cuuUId,
    required this.reciverUserId,
    required this.MessageText,
    required this.isMe,
    required this.createdAt,
    required this.type,
  });

  ChatModule copyWith({
    String? currUserName,
    String? ReciverUserName,
    String? cuuUId,
    String? reciverUserId,
    String? MessageText,
    String? isMe,
    DateTime? createdAt,
    String? type,
  }) {
    return ChatModule(
      currUserName: currUserName ?? this.currUserName,
      ReciverUserName: ReciverUserName ?? this.ReciverUserName,
      cuuUId: cuuUId ?? this.cuuUId,
      reciverUserId: reciverUserId ?? this.reciverUserId,
      MessageText: MessageText ?? this.MessageText,
      isMe: isMe ?? this.isMe,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'currUserName': currUserName,
      'ReciverUserName': ReciverUserName,
      'cuuUId': cuuUId,
      'reciverUserId': reciverUserId,
      'MessageText': MessageText,
      'isMe': isMe,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'type': type,
    };
  }

  factory ChatModule.fromMap(Map<String, dynamic> map) {
    return ChatModule(
      currUserName: (map["currUserName"] ?? '') as String,
      ReciverUserName: (map["ReciverUserName"] ?? '') as String,
      cuuUId: (map["cuuUId"] ?? '') as String,
      reciverUserId: (map["reciverUserId"] ?? '') as String,
      MessageText: (map["MessageText"] ?? '') as String,
      isMe: (map["isMe"] ?? '') as String,
      createdAt:
          DateTime.fromMillisecondsSinceEpoch((map["createdAt"] ?? 0) as int),
      type: (map["type"] ?? '') as String,
    );
  }

  @override
  String toString() {
    return 'ChatModule(currUserName: $currUserName, ReciverUserName: $ReciverUserName, cuuUId: $cuuUId, reciverUserId: $reciverUserId, MessageText: $MessageText, isMe: $isMe, createdAt: $createdAt, type: $type)';
  }

  @override
  bool operator ==(covariant ChatModule other) {
    if (identical(this, other)) return true;

    return other.currUserName == currUserName &&
        other.ReciverUserName == ReciverUserName &&
        other.cuuUId == cuuUId &&
        other.reciverUserId == reciverUserId &&
        other.MessageText == MessageText &&
        other.isMe == isMe &&
        other.createdAt == createdAt &&
        other.type == type;
  }

  @override
  int get hashCode {
    return currUserName.hashCode ^
        ReciverUserName.hashCode ^
        cuuUId.hashCode ^
        reciverUserId.hashCode ^
        MessageText.hashCode ^
        isMe.hashCode ^
        createdAt.hashCode ^
        type.hashCode;
  }
}
