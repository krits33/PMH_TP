import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Language Translator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final translator = GoogleTranslator();
  String _inputText = '';
  String _translatedText = '';
  String _selectedSourceLanguage = 'es'; // Default source language is Spanish
  String _selectedTargetLanguage = 'en'; // Default target language is English

  Map<String, String> languageMap = {
    'es': 'Spanish',
    'fr': 'French',
    'de': 'German',
    'zh': 'Chinese',
    'ar': 'Arabic',
    'ja': 'Japanese',
    'ko': 'Korean',
    'it': 'Italian',
    'hi': 'Hindi',
    'en': 'English', // Added English as a target language
    // Add more languages here if needed
  };

  void _translateText() {
    translator
        .translate(_inputText, from: _selectedSourceLanguage, to: _selectedTargetLanguage)
        .then((result) {
      setState(() {
        _translatedText = result.text;
      });
    }).catchError((error) {
      print("Translation error: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Translator'),
      ),
      backgroundColor: Colors.white,

      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                onChanged: (text) {
                  setState(() {
                    _inputText = text;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter text to translate',
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<String>(
                    value: _selectedSourceLanguage,
                    items: languageMap.keys
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(languageMap[value]!),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedSourceLanguage = newValue ?? 'es';
                      });
                    },
                  ),
                  Text('to'),
                  DropdownButton<String>(
                    value: _selectedTargetLanguage,
                    items: languageMap.keys
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(languageMap[value]!),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedTargetLanguage = newValue ?? 'en';
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _translateText,
                child: Text('Translate'),
              ),
              SizedBox(height: 20),
              Text(
                'Translated Text:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                _translatedText,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
