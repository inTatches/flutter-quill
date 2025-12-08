import 'package:flutter/material.dart';

import '../../editor/audio/audio_embed_types.dart';

class SelectAudioSourceDialog extends StatelessWidget {
  const SelectAudioSourceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 200),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: const Text('Aufnehmen'),
              subtitle: const Text(
                'Nimm eine neue Sprachnachricht auf',
              ),
              leading: const Icon(Icons.mic),
              onTap: () =>
                  Navigator.of(context).pop(InsertAudioSource.microphone),
            ),
            ListTile(
              title: const Text('Dateien'),
              subtitle: const Text(
                'Wählen Sie eine Audio aus Ihren Dateien',
              ),
              leading: const Icon(Icons.audio_file),
              onTap: () => Navigator.of(context).pop(InsertAudioSource.files),
            ),
            const SizedBox(
              height: 64,
            )
          ],
        ),
      ),
    );
  }
}

Future<InsertAudioSource?> showSelectAudioSourceDialog({
  required BuildContext context,
}) async {
  final audioSource = await showModalBottomSheet<InsertAudioSource>(
    showDragHandle: true,
    context: context,
    constraints: const BoxConstraints(maxWidth: 640),
    builder: (_) => const SelectAudioSourceDialog(),
  );
  return audioSource;
}
