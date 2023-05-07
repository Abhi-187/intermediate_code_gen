import 'package:flutter/material.dart';

void main() {
  runApp(IntermediateCodeGeneratorApp());
}

class IntermediateCodeGeneratorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intermediate Code Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IntermediateCodeGeneratorScreen(),
    );
  }
}

class IntermediateCodeGeneratorScreen extends StatefulWidget {
  @override
  _IntermediateCodeGeneratorScreenState createState() =>
      _IntermediateCodeGeneratorScreenState();
}

class _IntermediateCodeGeneratorScreenState
    extends State<IntermediateCodeGeneratorScreen> {
  final TextEditingController inputController = TextEditingController();
  String intermediateCode = '';

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  static const Set<String> OPERATORS = {'+', '-', '*', '/', '(', ')'};
  static const Map<String, int> PRI = {
    '+': 1,
    '-': 1,
    '*': 2,
    '/': 2,
  };

  void generateIntermediateCode() {
    String expression = inputController.text.trim();

    // Call the necessary functions (infixToPrefix, infixToPostfix, generate3AC) to generate the intermediate code
    String pre = infixToPrefix(expression);
    String pos = infixToPostfix(expression);
    String generatedIntermediateCode = generate3AC(pos);

    setState(() {
      intermediateCode = generatedIntermediateCode;
    });
  }

  String infixToPostfix(String formula) {
    final Set<String> operators = {'+', '-', '*', '/', '(', ')'};
    final Map<String, int> pri = PRI;

    final stack = <String>[];
    String output = '';

    for (String ch in formula.split('')) {
      if (!operators.contains(ch)) {
        output += ch;
      } else if (ch == '(') {
        stack.add('(');
      } else if (ch == ')') {
        while (stack.isNotEmpty && stack.last != '(') {
          output += stack.removeLast();
        }
        stack.removeLast(); // Pop '('
      } else {
        while (stack.isNotEmpty &&
            stack.last != '(' &&
            pri[ch]! <= pri[stack.last]!) {
          output += stack.removeLast();
        }
        stack.add(ch);
      }
    }

    while (stack.isNotEmpty) {
      output += stack.removeLast();
    }

    return output;
  }

  String infixToPrefix(String formula) {
    final Set<String> operators = {'+', '-', '*', '/', '(', ')'};
    final Map<String, int> pri = PRI;

    final opStack = <String>[];
    final expStack = <String>[];

    for (String ch in formula.split('')) {
      if (!operators.contains(ch)) {
        expStack.add(ch);
      } else if (ch == '(') {
        opStack.add(ch);
      } else if (ch == ')') {
        while (opStack.last != '(') {
          final op = opStack.removeLast();
          final a = expStack.removeLast();
          final b = expStack.removeLast();
          expStack.add('$op$b$a');
        }
        opStack.removeLast(); // Pop '('
      } else {
        while (opStack.isNotEmpty &&
            opStack.last != '(' &&
            pri[ch]! <= pri[opStack.last]!) {
          final op = opStack.removeLast();
          final a = expStack.removeLast();
          final b = expStack.removeLast();
          expStack.add('$op$b$a');
        }
        opStack.add(ch);
      }
    }

    while (opStack.isNotEmpty) {
      final op = opStack.removeLast();
      final a = expStack.removeLast();
      final b = expStack.removeLast();
      expStack.add('$op$b$a');
    }

    return expStack.last;
  }

  String generate3AC(String pos) {
    String result = '### THREE ADDRESS CODE GENERATION ###\n';
    final expStack = <String>[];
    int t = 1;

    for (String i in pos.split('')) {
      if (!OPERATORS.contains(i)) {
        expStack.add(i);
      } else {
        if (expStack.length >= 2) {
          final a = expStack.removeLast();
          final b = expStack.removeLast();
          result += 't$t := $b $i $a\n';
          expStack.add('t$t');
          t += 1;
        } else {
          // Handle error or invalid expression
        }
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Intermediate Code Generator'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: inputController,
              decoration: InputDecoration(
                labelText: 'Enter Expression',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: generateIntermediateCode,
              child: Text('Generate Intermediate Code'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Intermediate Code:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: SingleChildScrollView(
                child: Text(intermediateCode),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
