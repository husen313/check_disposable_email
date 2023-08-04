import 'package:check_disposable_email/check_disposable_email.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Disposable Email',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final controller = TextEditingController();
bool? isValidEmail;

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isValidEmail != null
          ? isValidEmail!
              ? Colors.green
              : Colors.red
          : Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Disposable Email Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 50,
              width: 250,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(border: Border.all()),
              child: TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Email",
                  border: InputBorder.none,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    isValidEmail =
                        Disposable.instance.hasValidEmail(controller.text);
                    setState(() {});
                  },
                  child: const Text("Check Email")),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Is Valid:- ${isValidEmail != null ? "$isValidEmail" : ""}",
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
