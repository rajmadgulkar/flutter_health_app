import 'package:flutter/material.dart';
import 'package:flutter_task/services/firestore_service.dart';

class BookAssessmentPage extends StatefulWidget {
  @override
  _BookAssessmentPageState createState() => _BookAssessmentPageState();
}

class _BookAssessmentPageState extends State<BookAssessmentPage> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book Assessment")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Title"),
                validator:
                    (val) => val == null || val.isEmpty ? "Enter title" : null,
                onSaved: (val) => _title = val,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Description"),
                onSaved: (val) => _description = val,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text("Save Assessment"),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await FirestoreService().addAssessment({
                      'title': _title,
                      'description': _description,
                      'isFavourite': false,
                    });
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
