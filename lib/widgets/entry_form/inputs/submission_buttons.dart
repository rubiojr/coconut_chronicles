import 'package:coconut_chronicles/core/models/selected_entry_model.dart';
import 'package:coconut_chronicles/core/storage/entry_storage.dart';
import 'package:coconut_chronicles/widgets/dialogues/confirmation_dialogue_builder.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class SubmissionButtons extends StatefulWidget {
  const SubmissionButtons({Key? key}) : super(key: key);

  @override
  State<SubmissionButtons> createState() => _SubmissionButtonsState();
}

class _SubmissionButtonsState extends State<SubmissionButtons> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SelectedEntryModel>(builder: (context, child, model) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => _clearData(),
            child: Text(model.isNewEntry ? 'Clear' : 'Undo changes'),
          ),
          const SizedBox(
            width: 8,
          ),
          TextButton(
            onPressed: () {
              if (model.entryFormKey.currentState!.validate()) {
                _saveEntry();
              }
            },
            child: Text(model.isNewEntry ? 'Save entry' : 'Update entry'),
          ),
          const SizedBox(
            width: 8,
          ),
        ],
      );
    });
  }

  _saveEntry() async {
    var snackContext = ScaffoldMessenger.of(context);
    bool success = await EntryStorage.saveEntry(SelectedEntryModel.getSelectedEntry(context));
    if (success) {
      _clearData();
      snackContext.showSnackBar(
        const SnackBar(content: Text('Saved chronicle entry')),
      );
    } else {
      snackContext.showSnackBar(
        const SnackBar(content: Text('Error saving chronicle entry')),
      );
    }
  }

  _clearData() async {
    var selectedModel = SelectedEntryModel.of(context);
    var clearDialogue = selectedModel.isNewEntry
        ? ConfirmationDialogueBuilder.showClearEntryForm(context)
        : ConfirmationDialogueBuilder.showConfirmUndoChanges(context);

    var result = await clearDialogue;
    if (result) {
      selectedModel.resetEntryForm();
    }
  }
}
