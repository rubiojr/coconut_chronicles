import 'package:coconut_chronicles/core/storage/encryption.dart';
import 'package:coconut_chronicles/widgets/dialogues/confirmation_dialogue_builder.dart';
import 'package:coconut_chronicles/widgets/dialogues/password_entry_dialogue.dart';
import 'package:flutter/material.dart';

class EncryptionOptions extends StatefulWidget {
  const EncryptionOptions({Key? key}) : super(key: key);

  @override
  State<EncryptionOptions> createState() => _EncryptionOptionsState();
}

class _EncryptionOptionsState extends State<EncryptionOptions> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: Encryption.isEncryptionEnabled(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!;
            return ListTile(
              title: const Text('Encrypted data'),
              enabled: Encryption.supportedPlatform,
              trailing: Switch(
                value: data,
                onChanged: (value) => value ? _trySetEncryptionKey() : _tryClearEncryptionKey(),
              ),
            );
          }

          return Container();
        });
  }

  _trySetEncryptionKey() async {
    var key = await showDialog<String?>(
      context: context,
      builder: (context) => const PasswordEntryDialogue(),
    );

    if (key == null) {
      return false;
    }

    await Encryption.setEncryptionKey(key);
    setState(() {});
  }

  _tryClearEncryptionKey() async {
    ConfirmationDialogueBuilder.showConfirmToClearEncryptionKeyDialogue(context, onConfirm: () async {
      await Encryption.clearEncryptionKey();
      setState(() {});
    });
  }
}