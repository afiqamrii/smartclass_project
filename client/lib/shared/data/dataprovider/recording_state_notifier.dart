import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/shared/data/services/favoriotApi.dart';

/// This class holds the state for recording status.
/// It contains:
/// - isRecording: whether the recording is ON or OFF
/// - micIcon: the icon shown for mic (on/off)
/// - recordingText: the text message shown to user
/// - micColor: the color of the mic container
class RecordingState {
  final bool isRecording;
  final Icon micIcon;
  final Text recordingText;
  final Color micColor;

  RecordingState({
    required this.isRecording,
    required this.micIcon,
    required this.recordingText,
    required this.micColor,
  });

  /// Copy current state and update specific properties.
  /// Helpful for changing only a few fields while keeping others the same.
  RecordingState copyWith({
    bool? isRecording,
    Icon? micIcon,
    Text? recordingText,
    Color? micColor,
  }) {
    return RecordingState(
      isRecording: isRecording ?? this.isRecording,
      micIcon: micIcon ?? this.micIcon,
      recordingText: recordingText ?? this.recordingText,
      micColor: micColor ?? this.micColor,
    );
  }
}

/// This class manages the recording state for multiple classes using StateNotifier.
/// The key is the classId, so each class can have its own recording status.
class RecordingStateNotifier extends StateNotifier<Map<int, RecordingState>> {
  RecordingStateNotifier() : super({}); // Initialize with empty state.

  /// This function toggles recording ON or OFF for a specific class.
  /// If recording is ON, it will stop recording and update UI.
  /// If recording is OFF, it will start recording and update UI.
  Future<void> toggleRecording(int classId) async {
    // Get the current state for the class, or set default values if not set yet.
    final currentState = state[classId] ??
        RecordingState(
          isRecording: false,
          micIcon: const Icon(
            Icons.mic_off_rounded,
            color: Colors.white,
            size: 20,
          ),
          recordingText: const Text(
            "Recording Not Started",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          micColor: const Color.fromARGB(255, 255, 61, 61),
        );

    if (currentState.isRecording) {
      // If recording is currently ON, send "stop" command to Favoriot API.
      await FavoriotApi.publishData("stop", classId);

      // Update the state: set recording OFF, mic icon to OFF, update text and color.
      state = {
        ...state, // Keep existing states for other classes.
        classId: currentState.copyWith(
          isRecording: false,
          micIcon: const Icon(
            Icons.mic_off_rounded,
            color: Colors.white,
            size: 20,
          ),
          recordingText: const Text(
            "Recording Not Started",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          micColor: const Color.fromARGB(255, 255, 61, 61),
        ),
      };
    } else {
      // If recording is currently OFF, send "start" command to Favoriot API.
      await FavoriotApi.publishData("start", classId);

      // Update the state: set recording ON, mic icon to ON, update text and color.
      state = {
        ...state, // Keep existing states for other classes.
        classId: currentState.copyWith(
          isRecording: true,
          micIcon: const Icon(
            Icons.mic,
            color: Colors.white,
            size: 20,
          ),
          recordingText: const Text(
            "Recording Started!",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          micColor: Colors.green,
        ),
      };
    }
  }
}

/// Riverpod provider to access and control the recording state.
/// It holds a map of classId -> RecordingState.
final recordingStateProvider =
    StateNotifierProvider<RecordingStateNotifier, Map<int, RecordingState>>(
  (ref) => RecordingStateNotifier(),
);
