import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String message;
  final Timestamp date;
  final bool isSender;

  MessageModel(
      {required this.message,
        required this.date,
        required this.isSender
      });

  factory MessageModel.fromJson(Map<String,dynamic> json){
    return MessageModel(
        message: json['message'],
        date: json['date'],
        isSender: json['isSender']
    );
  }

  Map<String,dynamic>toJson(){
    return {
      'message':message,
      'date':date,
      'isSender':isSender,
    };
  }
}
