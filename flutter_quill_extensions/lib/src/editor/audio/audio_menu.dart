import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart'
    show QuillController, getEmbedNode;
import 'package:flutter_quill/internal.dart';

import 'config/audio_config.dart';

class AudioOptionsMenu extends StatelessWidget {
  const AudioOptionsMenu({
    required this.controller,
    required this.config,
    required this.audioSource,
    required this.readOnly,
    super.key,
  });

  final QuillController controller;
  final QuillEditorAudioEmbedConfig config;
  final String audioSource;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final materialTheme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
      child: SimpleDialog(
        title: const Text('Audio'),
        children: [
          if (!readOnly)
            ListTile(
              leading: Icon(
                Icons.delete_forever_outlined,
                color: materialTheme.colorScheme.error,
              ),
              title: Text(context.loc.remove),
              onTap: () async {
                Navigator.of(context).pop();

                // Call the remove check callback if set
                if (await config.shouldRemoveAudioCallback?.call(audioSource) ==
                    false) {
                  return;
                }

                final offset = getEmbedNode(
                  controller,
                  controller.selection.start,
                ).offset;
                controller.replaceText(
                  offset,
                  1,
                  '',
                  TextSelection.collapsed(offset: offset),
                );
                // Call the post remove callback if set
                await config.onAudioRemovedCallback.call(audioSource);
              },
            ),
          /*ListTile(
            leading: const Icon(Icons.save),
            title: Text(context.loc.save),
            onTap: () async {
              final messenger = ScaffoldMessenger.of(context);
              final localizations = context.loc;
              Navigator.of(context).pop();

              SaveAudioResult? result;
              try {
                result = await AudioSaver.instance.saveAudio(
                  audioUrl: audioSource,
                  audioProvider: audioProvider,
                  prefersGallerySave: prefersGallerySave,
                );
              } on GalleryAudioSaveAccessDeniedException {
                messenger.showSnackBar(SnackBar(
                    content: Text(
                  localizations.saveAudioPermissionDenied,
                )));
                return;
              }

              if (result == null) {
                messenger.showSnackBar(SnackBar(
                    content: Text(
                  localizations.errorUnexpectedSavingAudio,
                )));
                return;
              }

              if (kIsWeb) {
                messenger.showSnackBar(SnackBar(
                    content: Text(localizations.successAudioDownloaded)));
                return;
              }

              if (result.isGallerySave) {
                messenger.showSnackBar(SnackBar(
                  content: Text(localizations.successAudioSavedGallery),
                  action: SnackBarAction(
                    label: localizations.openGallery,
                    onPressed: () =>
                        QuillNativeProvider.instance.openGalleryApp(),
                  ),
                ));
                return;
              }

              if (isDesktopApp) {
                final audioFilePath = result.audioFilePath;
                if (audioFilePath == null) {
                  // User canceled the system save dialog.
                  return;
                }

                messenger.showSnackBar(
                  SnackBar(
                    content: Text(localizations.successAudioSaved),
                    // On macOS the app only has access to the picked file from the system save
                    // dialog and not the directory where it was saved.
                    // Opening the directory of that file requires entitlements on macOS
                    // See https://pub.dev/packages/url_launcher#macos-file-access-configuration
                    // Open the saved audio file instead of the directory
                    action: defaultTargetPlatform == TargetPlatform.macOS
                        ? SnackBarAction(
                            label: localizations.openFile,
                            onPressed: () => launchUrl(Uri.file(audioFilePath)),
                          )
                        : SnackBarAction(
                            label: localizations.openFileLocation,
                            onPressed: () => launchUrl(
                                Uri.directory(p.dirname(audioFilePath))),
                          ),
                  ),
                );

                return;
              }

              throw StateError(
                  'Audio save result is not handled on $defaultTargetPlatform');
            },
          ),*/
        ],
      ),
    );
  }
}
