import 'package:flutter/material.dart';

class DataInputForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;
  final List<String> fields;

  const DataInputForm({
    super.key,
    required this.onSubmit,
    required this.fields,
  });

  @override
  State<DataInputForm> createState() => _DataInputFormState();
}

class _DataInputFormState extends State<DataInputForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (var field in widget.fields) {
      _controllers[field] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final data = <String, dynamic>{};
      _controllers.forEach((key, controller) {
        data[key] = controller.text;
      });
      widget.onSubmit(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ...widget.fields.map((field) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _controllers[field],
                  decoration: InputDecoration(labelText: field),
                  validator: (value) => value!.isEmpty ? 'Enter $field' : null,
                ),
              )),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _submit, child: const Text('Submit')),
        ],
      ),
    );
  }
}