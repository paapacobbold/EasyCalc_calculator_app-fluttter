import 'package:calculator_app/calculator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}
class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp( 
     debugShowCheckedModeBanner: false,
     home: Calculator(),
    );
  }
}