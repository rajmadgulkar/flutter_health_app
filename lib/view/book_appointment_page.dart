import 'package:flutter/material.dart';
import 'package:flutter_task/services/firestore_service.dart';

class BookAppointmentPage extends StatefulWidget {
  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _type;
  DateTime? _date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book Appointment")),
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
                decoration: InputDecoration(labelText: "Type"),
                onSaved: (val) => _type = val,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text("Pick Date"),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    initialDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _date = picked);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text("Save Appointment"),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await FirestoreService().addAppointment({
                      'title': _title,
                      'type': _type ?? '',
                      'status': 'booked',
                      'date': _date?.toIso8601String(),
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
