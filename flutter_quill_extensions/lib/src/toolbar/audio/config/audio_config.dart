import 'package:flutter_quill/flutter_quill.dart';
import 'package:meta/meta.dart' show immutable;

import '../../../editor/audio/audio_embed_types.dart';

class QuillToolbarAudioButtonExtraOptions
    extends QuillToolbarBaseButtonExtraOptions {
  const QuillToolbarAudioButtonExtraOptions({
    required super.controller,
    required super.context,
    required super.onPressed,
  });
}

@immutable
class QuillToolbarAudioButtonOptions extends QuillToolbarBaseButtonOptions<
    QuillToolbarAudioButtonOptions, QuillToolbarAudioButtonExtraOptions> {
  const QuillToolbarAudioButtonOptions({
    super.iconData,
    super.iconSize,
    super.iconButtonFactor,

    /// specifies the tooltip text for the audio button.
    super.tooltip,
    super.afterButtonPressed,
    super.childBuilder,
    super.iconTheme,
    this.dialogTheme,
    this.linkRegExp,
    this.audioButtonConfig = const QuillToolbarAudioConfig(),
  });

  final QuillDialogTheme? dialogTheme;

  /// [audioLinkRegExp] is a regular expression to identify audio links.
  final RegExp? linkRegExp;

  final QuillToolbarAudioConfig? audioButtonConfig;
}
