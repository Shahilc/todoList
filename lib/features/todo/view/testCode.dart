import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreTestPage extends StatelessWidget {
  const FirestoreTestPage({super.key});

  void testWrite() async {
    try {
      await FirebaseFirestore.instance
          .collection('todos')
          .add({
        'name': 'Test Todo',
        'priority': 'High',
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('✅ Firestore write successful!');
    } catch (e) {
      print('❌ Firestore error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firestore Test')),
      body: Center(
        child: ElevatedButton(
          child: Text('Test Firestore Write'),
          onPressed: testWrite,
        ),
      ),
    );
  }
}
