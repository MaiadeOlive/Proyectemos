import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayAudioProvider extends ChangeNotifier {
  final _justAudioPlayer = AudioPlayer();
  double _currAudioPlaying = 0;
  bool _isSongPlaying = false;
  String _audioFilePath = '';

  bool get isSongPlaying => _isSongPlaying;

  String get currSongPath => _audioFilePath;

  void setAudioFilePath(String filePath) {
    _audioFilePath = filePath;
    notifyListeners();
  }

  void clearCurrAudioPath() {
    _audioFilePath = '';
    notifyListeners();
  }

  playAssetAudio(String assetPath, {bool update = true}) async {
    try {
      _justAudioPlayer.positionStream.listen((event) {
        _currAudioPlaying = event.inMicroseconds.ceilToDouble();
        if (update) notifyListeners();
      });

      _justAudioPlayer.playerStateStream.listen((event) {
        if (event.processingState == ProcessingState.completed) {
          _justAudioPlayer.stop();
          _reset();
        }
      });

      if (_audioFilePath != assetPath) {
        setAudioFilePath(assetPath);

        await _justAudioPlayer.setAsset(assetPath); // Modificado para setAsset
        updateSongPlayingStatus(true);
        await _justAudioPlayer.play();
      }

      if (_justAudioPlayer.processingState == ProcessingState.idle) {
        await _justAudioPlayer.setAsset(assetPath); // Modificado para setAsset
        updateSongPlayingStatus(true);

        await _justAudioPlayer.play();
      } else if (_justAudioPlayer.playing) {
        updateSongPlayingStatus(false);

        await _justAudioPlayer.pause();
      } else if (_justAudioPlayer.processingState == ProcessingState.ready) {
        updateSongPlayingStatus(true);

        await _justAudioPlayer.play();
      } else if (_justAudioPlayer.processingState ==
          ProcessingState.completed) {
        _reset();
      }
    } catch (e) {
      return e.toString();
    }
  }

  playAudio(File incomingAudioFile, {bool update = true}) async {
    try {
      _justAudioPlayer.positionStream.listen((event) {
        _currAudioPlaying = event.inMicroseconds.ceilToDouble();
        if (update) notifyListeners();
      });

      _justAudioPlayer.playerStateStream.listen((event) {
        if (event.processingState == ProcessingState.completed) {
          _justAudioPlayer.stop();
          _reset();
        }
      });

      if (_audioFilePath != incomingAudioFile.path) {
        setAudioFilePath(incomingAudioFile.path);

        await _justAudioPlayer.setFilePath(incomingAudioFile.path);
        updateSongPlayingStatus(true);
        await _justAudioPlayer.play();
      }

      if (_justAudioPlayer.processingState == ProcessingState.idle) {
        await _justAudioPlayer.setFilePath(incomingAudioFile.path);
        updateSongPlayingStatus(true);

        await _justAudioPlayer.play();
      } else if (_justAudioPlayer.playing) {
        updateSongPlayingStatus(false);

        await _justAudioPlayer.pause();
      } else if (_justAudioPlayer.processingState == ProcessingState.ready) {
        updateSongPlayingStatus(true);

        await _justAudioPlayer.play();
      } else if (_justAudioPlayer.processingState ==
          ProcessingState.completed) {
        _reset();
      }
    } catch (e) {
      return e.toString();
    }
  }

  void _reset() {
    _currAudioPlaying = 0.0;
    notifyListeners();

    updateSongPlayingStatus(false);
  }

  void updateSongPlayingStatus(bool update) {
    _isSongPlaying = update;
    notifyListeners();
  }

  double get currLoadingStatus {
    final currTime = _currAudioPlaying /
        (_justAudioPlayer.duration?.inMicroseconds.ceilToDouble() ?? 1.0);

    return currTime > 1.0 ? 1.0 : currTime;
  }
}
