import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CaloriePage extends StatefulWidget {
  @override
  _CaloriePageState createState() => _CaloriePageState();
}

class _CaloriePageState extends State<CaloriePage> {
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _result = "";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void calculateCalories() async {
    String food = _foodController.text;
    double? amount = double.tryParse(_amountController.text);
    if (amount != null && food.isNotEmpty) {
      var foodData = await _firestore.collection('foods').doc(food).get();
      if (foodData.exists) {
        double caloriesPerUnit = foodData.data()?['calories_per_unit'] ?? 0;
        double totalCalories = amount * caloriesPerUnit;
        setState(() {
          _result = 'Toplam Kalori: $totalCalories';
        });
      } else {
        setState(() {
          _result = 'Yiyecek bulunamadı.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalori Hesaplama'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _foodController,
              decoration: InputDecoration(labelText: 'Yiyecek Adı'),
            ),
            TextField(
              controller: _amountController,
              decoration:
                  InputDecoration(labelText: 'Miktar (örn. gram cinsinden)'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: calculateCalories,
              child: Text('Hesapla'),
            ),
            Text(_result),
          ],
        ),
      ),
    );
  }
}
