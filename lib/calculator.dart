import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> with TickerProviderStateMixin {
  String _userInput = "";
  String _result = "0";
  bool _showResult = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<List<String>> _buttonGrid = [
    ['AC', '(', ')', '/'],
    ['7', '8', '9', '*'],
    ['4', '5', '6', '+'],
    ['1', '2', '3', '-'],
    ['C', '0', '.', '=']
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            _buildDisplay(),
            _buildButtonGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplay() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A0A0A),
            Color(0xFF1A1A1A),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Input expression
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Text(
                _userInput.isEmpty ? "0" : _userInput,
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Result
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _result,
                  key: ValueKey(_result),
                  style: const TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.w200,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonGrid() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: _buttonGrid.map((row) {
            return Expanded(
              child: Row(
                children: row.map((buttonText) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      child: _buildButton(buttonText),
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildButton(String text) {
    final buttonType = _getButtonType(text);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleButtonPress(text),
        borderRadius: BorderRadius.circular(20),
        splashColor: _getButtonColor(buttonType).withOpacity(0.3),
        highlightColor: _getButtonColor(buttonType).withOpacity(0.1),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getButtonColor(buttonType),
                _getButtonColor(buttonType).withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _getButtonColor(buttonType).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: _getFontSize(text),
                fontWeight: FontWeight.w600,
                color: _getTextColor(buttonType),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  ButtonType _getButtonType(String text) {
    switch (text) {
      case 'AC':
        return ButtonType.clear;
      case '=':
        return ButtonType.equals;
      case '+':
      case '-':
      case '*':
      case '/':
      case '(':
      case ')':
        return ButtonType.operator;
      case 'C':
        return ButtonType.backspace;
      default:
        return ButtonType.number;
    }
  }

  Color _getButtonColor(ButtonType type) {
    switch (type) {
      case ButtonType.clear:
        return const Color(0xFFFF6B6B);
      case ButtonType.equals:
        return const Color(0xFF4ECDC4);
      case ButtonType.operator:
        return const Color(0xFF45B7D1);
      case ButtonType.backspace:
        return const Color(0xFFFF8C42);
      case ButtonType.number:
        return const Color(0xFF2A2A2A);
    }
  }

  Color _getTextColor(ButtonType type) {
    switch (type) {
      case ButtonType.number:
        return Colors.white;
      default:
        return Colors.white;
    }
  }

  double _getFontSize(String text) {
    if (text == 'AC') return 20;
    if (text.length > 1) return 24;
    return 28;
  }

  void _handleButtonPress(String text) {
    HapticFeedback.lightImpact();
    
    setState(() {
      switch (text) {
        case "AC":
          _userInput = "";
          _result = "0";
          _showResult = false;
          break;
        case "C":
          _handleBackspace();
          break;
        case "=":
          _handleEquals();
          break;
        default:
          _handleInput(text);
          break;
      }
    });
  }

  void _handleBackspace() {
    if (_userInput.isNotEmpty) {
      _userInput = _userInput.substring(0, _userInput.length - 1);
      if (_userInput.isEmpty) {
        _result = "0";
      } else {
        _result = _calculate(_userInput);
      }
    }
  }

  void _handleEquals() {
    if (_userInput.isNotEmpty) {
      final calculatedResult = _calculate(_userInput);
      _result = calculatedResult;
      _userInput = calculatedResult;
      _showResult = true;
      
      // Clean up decimal display
      if (_userInput.endsWith(".0")) {
        _userInput = _userInput.replaceAll(".0", "");
      }
      if (_result.endsWith(".0")) {
        _result = _result.replaceAll(".0", "");
      }
    }
  }

  void _handleInput(String text) {
    // If we just showed a result, start fresh with operators or replace with numbers
    if (_showResult) {
      if (_isOperator(text)) {
        _userInput = _result + text;
      } else {
        _userInput = text;
      }
      _showResult = false;
    } else {
      _userInput += text;
    }
    
    // Live calculation for preview
    if (_userInput.isNotEmpty && !_userInput.endsWith(text) || !_isOperator(text)) {
      _result = _calculate(_userInput);
    }
  }

  bool _isOperator(String text) {
    return ['+', '-', '*', '/', '(', ')'].contains(text);
  }

  String _calculate(String expression) {
    try {
      if (expression.isEmpty) return "0";
      
      // Handle edge cases
      if (expression.endsWith('+') || 
          expression.endsWith('-') || 
          expression.endsWith('*') || 
          expression.endsWith('/')) {
        return _result; // Return previous result if expression ends with operator
      }
      
      final exp = Parser().parse(expression);
      final evaluation = exp.evaluate(EvaluationType.REAL, ContextModel());
      
      // Format the result
      if (evaluation == evaluation.toInt()) {
        return evaluation.toInt().toString();
      } else {
        return evaluation.toStringAsFixed(8).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
      }
    } catch (e) {
      return "Error";
    }
  }
}

enum ButtonType {
  number,
  operator,
  equals,
  clear,
  backspace,
}