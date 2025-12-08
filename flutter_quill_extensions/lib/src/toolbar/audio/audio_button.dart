import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../../../flutter_quill_extensions.dart';
import '../../common/default_audio_insert.dart';
import '../quill_simple_toolbar_api.dart';
import 'select_audio_source.dart';

// ignore: invalid_use_of_internal_member
class QuillToolbarAudioButton extends QuillToolbarBaseButtonStateless {
  const QuillToolbarAudioButton({
    required super.controller,
    QuillToolbarAudioButtonOptions? options,

    /// Shares common options between all buttons, prefer the [options]
    /// over the [baseOptions].
    super.baseOptions,
    super.key,
  })  : _options = options,
        super(options: options);

  final QuillToolbarAudioButtonOptions? _options;

  @override
  QuillToolbarAudioButtonOptions? get options => _options;

  void _sharedOnPressed(BuildContext context) {
    _onPressedHandler(context);
    afterButtonPressed(context);
  }

  Future<void> _handleAudioInsert(String audioUrl) async {
    await handleAudioInsert(
      audioUrl,
      controller: controller,
      onAudioInsertCallback: options?.audioButtonConfig?.onAudioInsertCallback,
      onAudioInsertedCallback:
          options?.audioButtonConfig?.onAudioInsertedCallback,
    );
  }

  Future<void> _onPressedHandler(BuildContext context) async {
    final onRequestPickAudio = options?.audioButtonConfig?.onRequestPickAudio;
    if (onRequestPickAudio != null) {
      final audioUrl = await onRequestPickAudio(
        context,
      );
      if (audioUrl != null) {
        await _handleAudioInsert(audioUrl);
      }
      return;
    }
    final source = await showSelectAudioSourceDialog(
      context: context,
    );

    if (source == null) {
      return;
    }
    String? audioUrl;

    switch (source) {
      case InsertAudioSource.microphone:
        final onRequestRecordAudio =
            options?.audioButtonConfig?.onRequestRecordAudio;
        if (onRequestRecordAudio != null) {
          audioUrl = await onRequestRecordAudio();
        }
        break;
      case InsertAudioSource.files:
        final result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.custom,
          allowedExtensions: ['wav', 'mp3'],
        );

        if (result != null) {
          audioUrl = result.files.first.path;
        }
        break;
    }

    if (audioUrl == null) {
      return;
    }

    if (audioUrl.trim().isNotEmpty) {
      await _handleAudioInsert(audioUrl);
    }
  }

  @override
  Widget buildButton(BuildContext context) {
    return QuillToolbarIconButton(
      icon: Icon(
        iconData(context),
        size: iconButtonFactor(context) * iconSize(context),
      ),
      tooltip: tooltip(context),
      isSelected: false,
      onPressed: () => _sharedOnPressed(context),
      iconTheme: iconTheme(context),
    );
  }

  @override
  Widget? buildCustomChildBuilder(BuildContext context) {
    return childBuilder?.call(
      QuillToolbarAudioButtonOptions(
        afterButtonPressed: afterButtonPressed(context),
        iconData: iconData(context),
        iconSize: iconSize(context),
        iconButtonFactor: iconButtonFactor(context),
        dialogTheme: options?.dialogTheme,
        iconTheme: options?.iconTheme,
        tooltip: tooltip(context),
        audioButtonConfig: options?.audioButtonConfig,
      ),
      QuillToolbarAudioButtonExtraOptions(
        context: context,
        controller: controller,
        onPressed: () => _sharedOnPressed(context),
      ),
    );
  }

  @override
  IconData Function(BuildContext context) get getDefaultIconData =>
      (context) => Icons.mic;

  @override
  String Function(BuildContext context) get getDefaultTooltip =>
      (context) => 'Audio einfügen';
}
