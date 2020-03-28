import 'package:flutter/material.dart';


class InputField extends StatelessWidget {

  final IconData icon;
  final String hint;
  final bool obscure;
  final Stream<String> stream;
  final Function(String) onChengad;

  InputField({this.icon, this.hint, this.obscure, this.stream,this.onChengad});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: stream,
      builder: (context, snapshot) {
        return TextField(
          onChanged: onChengad,
            decoration: InputDecoration(
              hasFloatingPlaceholder: true,
              fillColor: Colors.cyanAccent.withAlpha(170),
              icon: Icon(icon, color: Colors.cyanAccent.withAlpha(170)),
              hintText: hint,
              hintStyle: TextStyle(color: Colors.cyanAccent.withAlpha(170)),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.cyanAccent.withAlpha(170)),
              ),
              contentPadding: EdgeInsets.only(
                top: 10,
                bottom: 8,
                left: 30,
                right: 30
              ),
              errorText: snapshot.hasError ? snapshot.error : null,
            ),
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(color: Colors.white.withAlpha(200),
          fontSize: 18),
          obscureText: obscure,
        );
      }
    );
  }
}
