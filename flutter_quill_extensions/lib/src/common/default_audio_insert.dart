import 'package:flutter_quill/flutter_quill.dart';
import 'package:meta/meta.dart';

import '../editor/audio/audio_embed_types.dart';
import 'extensions/controller_ext.dart';

OnAudioInsertCallback _defaultAudioInsert() {
  return (audioUrl, controller) async {
    controller
      ..skipRequestKeyboard = true
      // ignore: deprecated_member_use_from_same_package
      ..insertAudioBlock(audioSource: audioUrl);
  };
}

@internal
Future<void> handleAudioInsert(
  String audioUrl, {
  required QuillController controller,
  required OnAudioInsertCallback? onAudioInsertCallback,
  required OnAudioInsertedCallback? onAudioInsertedCallback,
}) async {
  final customOnAudioInsert = onAudioInsertCallback;
  if (customOnAudioInsert != null) {
    await customOnAudioInsert.call(audioUrl, controller);
  } else {
    await _defaultAudioInsert().call(audioUrl, controller);
  }
  await onAudioInsertedCallback?.call(audioUrl);
}
