import 'package:flutter/material.dart';

class NoteFormWidgets extends StatelessWidget{
  const NoteFormWidgets({
    super.key,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.onChangedImportant,
    required this.onChangedNumber,
    required this.onChangedTitle,
    required this.onChangedDescription });
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<int> onChangedNumber;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;

  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(
            children: [
              Switch( value: isImportant, onChanged: onChangedImportant ),
              Expanded(
                  child: Slider(
                      value: number.toDouble(),
                      min: 0,
                      max: 5,
                      divisions: 5,
                      label: number.toString(),
                      onChanged: (value) => onChangedNumber(value.toInt())
                  ))
            ],
          ),
          buildTitleFields(),
          const SizedBox(
            height: 8,
          ),
          buildDescriptionField()
        ]),
      ),
    );
  }

  buildTitleFields() {
    return TextFormField(
      maxLines: 1,
      initialValue: title,
      style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold
      ),
      decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Title",
          hintStyle: TextStyle(
              color: Colors.grey
          )
      ),
      validator: (titleValue) {
        if (titleValue == null || titleValue.isEmpty) {
          return "The title cannot be empty";
        }
        return null;
      },
      onChanged: onChangedTitle,
    );
  }
  
  buildDescriptionField() {
    return TextFormField(
      maxLines: null,
      initialValue: description,
      style: const TextStyle(
          fontSize: 18,
      ),
      decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Type something...",
          hintStyle: TextStyle(
              color: Colors.grey
          )
      ),
      validator: (descriptionValue) {
        if (descriptionValue == null || descriptionValue.isEmpty) {
          return "The description cannot be empty";
        }
        return null;
      },
      onChanged: onChangedDescription,
    );
  }
}