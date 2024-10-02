import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Member {
  String id;
  String name;
  String phone;
  String? email;
  String ward;
  String shares;
  String? noteDescription;
  Color color; 

  Member({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.ward,
    required this.shares,
    this.noteDescription,
    required this.color, 
  });

  factory Member.fromMap(Map<dynamic, dynamic> map, String id) {
    return Member(
      id: id, // Use the passed ID
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'],
      ward: map['ward'] ?? '',
      shares: map['shares'] ?? '',
      noteDescription: map['noteDescription'],
      color: Color(map['color'] ?? Colors.blue.value), // Ensure default color
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'ward': ward,
      'shares': shares,
      'noteDescription': noteDescription,
      'color': color.value, 
    };
  }

  Future<void> update() async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref('members/$id');
    await dbRef.update(toMap());
  }
}
