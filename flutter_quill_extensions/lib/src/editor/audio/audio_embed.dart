import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'audio_menu.dart';
import 'config/audio_config.dart';
import 'widgets/audio.dart';

class QuillEditorAudioEmbedBuilder extends EmbedBuilder {
  QuillEditorAudioEmbedBuilder({
    required this.config,
  });

  final QuillEditorAudioEmbedConfig config;

  @override
  String get key => BlockEmbed.audioType;

  @override
  bool get expanded => false;

  @override
  Widget build(
    BuildContext context,
    EmbedContext embedContext,
  ) {
    final audioSource = embedContext.node.value.data;

    return GestureDetector(
      onTap: () {
        final onAudioClicked = config.onAudioClicked;
        if (onAudioClicked != null) {
          onAudioClicked(audioSource);
          return;
        }
        showDialog(
          context: context,
          builder: (_) => AudioOptionsMenu(
              controller: embedContext.controller,
              config: config,
              audioSource: audioSource,
              readOnly: embedContext.readOnly),
        );
      },
      child: Builder(
        builder: (context) {
          return AudioTapWrapper(
            audioUrl: audioSource,
            config: config,
          );
        },
      ),
    );
  }
}
