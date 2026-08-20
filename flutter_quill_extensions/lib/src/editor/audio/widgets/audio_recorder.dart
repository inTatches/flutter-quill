import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String?> audioRecorder(BuildContext context) {
  var isRecorderReady = false;

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds.remainder(60);

    return '${twoDigits(minutes)}:${twoDigits(remainingSeconds)}';
  }

  final recorder = FlutterSoundRecorder();
  final audioPlayer = AudioPlayer();

  Future initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      return null;
    }

    await recorder.openRecorder();
    isRecorderReady = true;

    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future startRecording() async {
    if (!isRecorderReady) return;

    await recorder.startRecorder(toFile: 'audio');
  }

  Future stopRecording() async {
    if (!isRecorderReady) return;

    final recordingFilePath = await recorder.stopRecorder();
    recorder.closeRecorder();

    await Future.delayed(const Duration(seconds: 1));

    audioPlayer.dispose();

    Navigator.of(context).pop(recordingFilePath);
  }

  initRecorder();

  return showGeneralDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    pageBuilder: (context, anim1, anim2) {
      return Material(
        child: StatefulBuilder(builder: (context, setState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox.shrink(),
              StreamBuilder<RecordingDisposition>(
                  stream: recorder.onProgress,
                  builder: (builder, snapshot) {
                    final duration = snapshot.hasData
                        ? snapshot.data!.duration
                        : Duration.zero;

                    return Container(
                      height: 150,
                      width: 150,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            150), // Adjust the radius as needed
                        border: Border.all(),
                      ),
                      child: Center(
                        child: Text(
                          formatTime(duration),
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),
                    );
                  }),
              Container(
                margin: const EdgeInsets.only(bottom: 60),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () async {
                      if (recorder.isRecording) {
                        await stopRecording();
                        setState(() {});
                      } else {
                        await startRecording();
                        setState(() {});
                      }
                    },
                    child: Container(
                      height: 80,
                      width: 80,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            50), // Adjust the radius as needed
                        border: Border.all(),
                      ),
                      child: Icon(
                        recorder.isRecording ? Icons.stop : Icons.mic,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      );
    },
  );
}
