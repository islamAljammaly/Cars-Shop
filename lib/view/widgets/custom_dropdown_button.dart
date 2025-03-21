import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  final String value;
  final void Function(String?)? onChange;
  final List<DropdownMenuItem<String>>? listDrop;
CustomDropdownButton(this.value, this.onChange, this.listDrop);

@override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton<String>(
                   value: value,
                   alignment: Alignment.center,
                   icon: const Icon(Icons.arrow_downward),
                   style: const TextStyle(color: Colors.black),
                   underline: Container(
                         height: 2,
                         color: Colors.black,
                        ),
                   onChanged: onChange,
                        items: listDrop,
                                ),
    );
  }
}
 