import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FormEx(),
    );
  }
}

class FormEx extends StatefulWidget {
  const FormEx({super.key});

  @override
  State<FormEx> createState() => _FormExState();
}

class _FormExState extends State<FormEx> {
  final _formKey = GlobalKey<FormState>();
  late int _code;
  late String _libelle;
  late int _quatitie;
   bool isSurPlace = false;
  bool isEnLigne = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                onSaved: (value) {
                  _code = int.parse(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a value";
                  }
                  final code = int.tryParse(value);
                  if (code! < 100 || code > 1000) {
                    return " code incorect";
                  }
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Enter article code",
                  labelText: "Code article",
                  prefixIcon: Icon(Icons.production_quantity_limits),
                ),
              ),
              TextFormField(
                onSaved: (value) {
                  _libelle = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a value";
                  }
                  final l = value.length;
                  if (l > 15) {
                    return " so long";
                  }
                },
                // keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Enter Libelle",
                  labelText: "Libelle",
                  prefixIcon: Icon(Icons.label),
                ),
              ),
              TextFormField(
                onSaved: (value) {
                  _quatitie = int.parse(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a value";
                  }
                  final code = int.tryParse(value);
                  if (code! < 0) {
                    return " quantite incorect";
                  }
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Enter quantite",
                  label: Text("quantite"),
                  prefixIcon: Icon(Icons.numbers),
                ),
              ),
             
              FormField<bool>(
                
                initialValue: false,
                builder: (FormFieldState<bool> field) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        
                        value: isSurPlace,
                        onChanged: (bool? value) {
                          setState(() {
                        isSurPlace = value! ;
                        isEnLigne=!isSurPlace;
                        
                      });
                        },
                      ),
                      const Text('sur place'), 
                      Checkbox(
                        value: isEnLigne,
                        onChanged: (bool? value) {
                           setState(() {
                        isEnLigne = value!;
                       isSurPlace=!isEnLigne;
                      });
                        },
                      ),
                      const Text('en ligne'), 

                    ],
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                      }
                      print('$_code $_libelle $_quatitie');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      textStyle: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    child: const Text(
                      "Ajouter un Article",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      textStyle: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    child: const Text(
                      "Initialiser le formulaire",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
