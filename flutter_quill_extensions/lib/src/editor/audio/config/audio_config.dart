import 'dart:io' show File;

import 'package:flutter/foundation.dart';
import 'package:flutter_quill/internal.dart';

import '../audio_embed_types.dart';

/// [QuillEditorAudioEmbedConfig] for desktop, mobile and
///  other platforms
/// excluding web, it's configurations that is needed for the editor
///
@immutable
class QuillEditorAudioEmbedConfig {
  const QuillEditorAudioEmbedConfig({
    AudioEmbedBuilderOnRemovedCallback? onAudioRemovedCallback,
    this.shouldRemoveAudioCallback,
    this.audioProviderBuilder,
    this.onAudioClicked,
  }) : _onAudioRemovedCallback = onAudioRemovedCallback;

  /// [onAudioRemovedCallback] is called when an audio is
  ///  removed from the editor.
  /// By default, [onAudioRemovedCallback] deletes the
  ///  temporary audio file if
  /// the platform is mobile and if it still exists. You
  ///  can customize this behavior
  /// by passing your own function that handles the removal process.
  ///
  /// Example of [onAudioRemovedCallback] customization:
  /// ```dart
  /// afterRemoveAudioFromEditor: (audioFile) async {
  ///   // Your custom logic here
  ///   // or leave it empty to do nothing
  /// }
  /// ```
  ///
  /// Default value if the passed value is null:
  /// [QuillEditorAudioEmbedConfig.defaultOnAudioRemovedCallback]
  ///
  /// so if you want to do nothing make sure to pass a empty callback
  /// instead of passing null as value
  final AudioEmbedBuilderOnRemovedCallback? _onAudioRemovedCallback;

  AudioEmbedBuilderOnRemovedCallback get onAudioRemovedCallback {
    return _onAudioRemovedCallback ??
        QuillEditorAudioEmbedConfig.defaultOnAudioRemovedCallback;
  }

  /// [shouldRemoveAudioCallback] is a callback
  ///  function that is invoked when the
  /// user attempts to remove an audio from the editor. It allows you to control
  /// whether the audio should be removed based on your custom logic.
  ///
  /// Example of [shouldRemoveAudioCallback] customization:
  /// ```dart
  /// shouldRemoveAudioFromEditor: (audioFile) async {
  ///   // Show a confirmation dialog before removing the audio
  ///   final isShouldRemove = await showYesCancelDialog(
  ///     context: context,
  ///     options: const YesOrCancelDialogOptions(
  ///       title: 'Deleting an audio',
  ///       message: 'Are you sure you want' ' to delete this
  ///      audio from the editor?',
  ///     ),
  ///   );
  ///
  ///   // Return `true` to allow audio removal if the user confirms, otherwise
  ///  `false`
  ///   return isShouldRemove;
  /// }
  /// ```
  ///
  final AudioEmbedBuilderWillRemoveCallback? shouldRemoveAudioCallback;

  /// Allows to override the default handling and fallback to the default if `null` was returned.
  ///
  /// Example of [audioProviderBuilder] customization:
  /// ```dart
  /// audioProviderBuilder: (audioUrl) async {
  /// if (audioUrl.startsWith('assets/')) {
  ///   // Supports Audio assets
  ///   return AssetAudio(audioUrl);
  /// }
  /// if (audioUrl.startsWith('http')) {
  ///   // Use https://pub.dev/packages/cached_network_audio
  ///   // for network audios to cache them.
  ///   return CachedNetworkAudioProvider(audioUrl);
  /// }
  ///
  /// // Return null to fallback to default handling
  /// return null;
  /// }
  /// ```
  ///
  final AudioEmbedBuilderProviderBuilder? audioProviderBuilder;

  /// What should happen when the audio is pressed?
  ///
  /// By default will show `AudioOptionsMenu` dialog. If you want to handle what happens
  /// to the audio when it's clicked, you can pass a callback to this property.
  final void Function(String audioSource)? onAudioClicked;

  static AudioEmbedBuilderOnRemovedCallback get defaultOnAudioRemovedCallback {
    return (audioUrl) async {
      if (kIsWeb) {
        return;
      }

      final mobile = isMobileApp;
      // If the platform is not mobile, return void;
      // Since the mobile OS gives us a copy of the audio

      // Note: We should remove the audio on Flutter web
      // since the behavior is similar to how it is on mobile,
      // but since this builder is not for web, we will ignore it
      if (!mobile) {
        return;
      }

      // On mobile OS (Android, iOS), the system will not give us
      // direct access to the audio; instead,
      // it will give us the audio
      // in the temp directory of the application. So, we want to
      // remove it when we no longer need it.

      // but on desktop we don't want to touch user files
      // especially on macOS, where we can't even delete
      // it without
      // permission

      final dartIoAudioFile = File(audioUrl);

      final isFileExists = await dartIoAudioFile.exists();
      if (isFileExists) {
        await dartIoAudioFile.delete();
      }
    };
  }

  QuillEditorAudioEmbedConfig copyWith({
    AudioEmbedBuilderOnRemovedCallback? onAudioRemovedCallback,
    AudioEmbedBuilderWillRemoveCallback? shouldRemoveAudioCallback,
    bool? forceUseMobileOptionMenuForAudioClick,
  }) {
    return QuillEditorAudioEmbedConfig(
      onAudioRemovedCallback: onAudioRemovedCallback ?? _onAudioRemovedCallback,
      shouldRemoveAudioCallback:
          shouldRemoveAudioCallback ?? this.shouldRemoveAudioCallback,
    );
  }
}
