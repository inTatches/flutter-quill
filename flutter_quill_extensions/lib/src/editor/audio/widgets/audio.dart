import 'package:flutter/material.dart';

import '../../../../flutter_quill_extensions.dart';

class AudioTapWrapper extends StatelessWidget {
  const AudioTapWrapper({
    required this.audioUrl,
    required this.config,
    super.key,
  });

  final String audioUrl;
  final QuillEditorAudioEmbedConfig config;

  @override
  Widget build(BuildContext context) {
    if (config.audioProviderBuilder != null) {
      return Container(
        child: config.audioProviderBuilder!(context, audioUrl),
      );
    }
    return const Text('ERR: No audioProvider');
  }
}
