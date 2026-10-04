class MessageModel {
  String message;
  String senderEmail;
  String receiverEmail;
  DateTime dateTime;
  MessageModel({
    required this.message,
    required this.senderEmail,
    required this.receiverEmail,
    required this.dateTime,
  });

  factory MessageModel.fromJson( json) {
    return MessageModel(
      message: json['message'],
      senderEmail: json['senderEmail'],
      receiverEmail: json['receiverEmail'],
      dateTime: json['dateTime'].toDate(),
    );
  }

  tojson() {
    return {
      'message': message,
      'senderEmail': senderEmail,
      'receiverEmail': receiverEmail,
      'dateTime': dateTime,
    };
  }
}
