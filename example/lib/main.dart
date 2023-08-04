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
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Disposable Email Example',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 30),
            Visibility(
              visible: emailMessage().isNotEmpty,
              child: Icon(
                isValidEmail ?? false
                    ? Icons.check_circle_outline
                    : Icons.cancel_outlined,
                size: 80,
                color: isValidEmail ?? false ? Colors.green : Colors.red,
              ),
            ),
            Center(
              child: Container(
                width: 300,
                height: 100,
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: isValidEmail != null
                      ? isValidEmail!
                          ? Colors.green
                          : Colors.red
                      : Colors.white,
                ),
                child: Visibility(
                  visible: emailMessage().isNotEmpty,
                  child: Text(
                    emailMessage(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: "Enter Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 15.0),
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: checkIsValidEmail,
                  child: const Text(
                    "Check Email",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Is Valid:- ${isValidEmail != null ? "$isValidEmail" : ""}",
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String emailMessage() {
    if (isValidEmail == null) return "";
    if (isValidEmail!) {
      return "Your Email Address is valid";
    } else {
      return "Your Email Address\nis Not valid or Temporary";
    }
  }

  void checkIsValidEmail() {
    if (mounted) {
      setState(() {
        FocusScope.of(context).unfocus();
        isValidEmail = Disposable.instance.hasValidEmail(controller.text);
      });
    }
  }
}
