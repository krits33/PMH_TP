import 'package:fingerprint_auth/secret_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fingerprint Authentication',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalAuthentication auth = LocalAuthentication();

    Future authenticate() async {
      final bool isBiometricsAvailable = await auth.isDeviceSupported();

      if (!isBiometricsAvailable) return false;

      try {
        return await auth.authenticate(
          localizedReason: 'Scan Fingerprint To Enter Vault',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );
      } on PlatformException {
        return;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fingerprint Auth'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            bool isAuthenticated = await authenticate();

            if (isAuthenticated) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SecretPage();
                  },
                ),
              );
            } else {
              Container();
            }
          },
          child: const Text(' Click me'),
        ),
      ),
    );
  }
}
