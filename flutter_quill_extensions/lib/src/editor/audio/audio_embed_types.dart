import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// When request picking an image, for example when the image button toolbar
/// clicked, it should be null in case the user didn't choose any image or
/// any other reasons, and it should be the image file path as string that is
/// exists in case the user picked the image successfully
///
/// by default we already have a default implementation that show a dialog
/// request the source for picking the image, from gallery, link or camera
typedef OnRequestPickAudio = Future<String?> Function(
  BuildContext context,
);

/// A callback will called when inserting a image in the editor
/// it have the logic that will insert the image block using the controller
typedef OnAudioInsertCallback = Future<void> Function(
  String image,
  QuillController controller,
);

/// When a new image picked this callback will called and you might want to
/// do some logic depending on your use case
typedef OnAudioInsertedCallback = Future<void> Function(
  String image,
);

typedef OnRequestRecordAudio = Future<String?> Function();

enum InsertAudioSource {
  microphone,
  files,
}

/// Configurations for dealing with images, on insert a image
/// on request picking a image
@immutable
class QuillToolbarAudioConfig {
  const QuillToolbarAudioConfig({
    this.onRequestPickAudio,
    this.onAudioInsertedCallback,
    this.onAudioInsertCallback,
    this.onRequestRecordAudio,
  });

  final OnRequestPickAudio? onRequestPickAudio;

  final OnAudioInsertedCallback? onAudioInsertedCallback;

  final OnAudioInsertCallback? onAudioInsertCallback;

  final OnRequestRecordAudio? onRequestRecordAudio;
}

typedef AudioEmbedBuilderWillRemoveCallback = Future<bool> Function(
  String imageUrl,
);

typedef AudioEmbedBuilderOnRemovedCallback = Future<void> Function(
  String imageUrl,
);

typedef AudioEmbedBuilderProviderBuilder = Widget? Function(
  BuildContext context,
  String imageUrl,
);
