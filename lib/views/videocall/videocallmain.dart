import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:dayush_clinic/controller/book_appointment_controller/book_appointment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer' as developer;

class Videocallmain extends StatefulWidget {
  final dynamic arguments;
  Videocallmain({super.key}) : arguments = Get.arguments;

  @override
  State<Videocallmain> createState() => _VideocallmainState();
}

class _VideocallmainState extends State<Videocallmain> {
  final BookAppointmentController bookAppointmentController =
      Get.find<BookAppointmentController>();
  int? _remoteUid;
  bool _localUserJoined = false;
  RtcEngine? _engine;
  bool _isMuted = false;
  bool _isVideoDisabled = false;
  bool _isLoading = true;
  String? _errorMessage;
  String? _channelName;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final data = widget.arguments as Map<String, dynamic>;
      final consultationId = data['consultationId'];
      final success = await bookAppointmentController.getAgoraToken(
          consultaionId: consultationId);
      if (success && bookAppointmentController.agoraTokenResponse.isNotEmpty) {
        final agoraData = bookAppointmentController.agoraTokenResponse;
        _channelName = agoraData['channel_name'];
        await initAgora(
          appId: agoraData['app_id'],
          token: agoraData['token'],
          channelName: _channelName!,
          uid: agoraData['uid'],
        );
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to fetch Agora token';
        });
      }
    } catch (e) {
      developer.log("Initialization error: $e");
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error initializing video call';
      });
    }
  }

  Future<void> initAgora({
    required String appId,
    required String token,
    required String channelName,
    required int uid,
  }) async {
    await [Permission.microphone, Permission.camera].request();
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));
    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          developer.log('Local user ${connection.localUid} joined');
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          developer.log("Remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          developer.log("Remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );
    await _engine!.enableVideo();
    await _engine!.startPreview();
    await _engine!.joinChannel(
      token: token,
      channelId: channelName,
      options: const ChannelMediaOptions(
        autoSubscribeVideo: true,
        autoSubscribeAudio: true,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
      uid: uid,
    );
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  Future<void> _dispose() async {
    if (_engine != null) {
      await _engine!.leaveChannel();
      await _engine!.release();
      _engine = null;
    }
  }

  void _toggleMute() {
    if (_engine == null) return;
    setState(() {
      _isMuted = !_isMuted;
    });
    _engine!.muteLocalAudioStream(_isMuted);
  }

  void _toggleVideo() {
    if (_engine == null) return;
    setState(() {
      _isVideoDisabled = !_isVideoDisabled;
    });
    _engine!.muteLocalVideoStream(_isVideoDisabled);
  }

  void _switchCamera() {
    if (_engine == null) return;
    _engine!.switchCamera();
  }

  Future<void> _endCall() async {
    await _dispose();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Text(_errorMessage!,
                        style: const TextStyle(color: Colors.red)))
                : Stack(
                    children: [
                      Center(
                        child: _remoteVideo(),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          width: 100,
                          height: 150,
                          child: Center(
                            child: _localUserJoined && _engine != null
                                ? AgoraVideoView(
                                    controller: VideoViewController(
                                      rtcEngine: _engine!,
                                      canvas: const VideoCanvas(uid: 0),
                                    ),
                                  )
                                : const CircularProgressIndicator(),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: _toggleMute,
                              icon: Icon(
                                _isMuted ? Icons.mic_off : Icons.mic,
                                color: Colors.blue,
                              ),
                              iconSize: 36,
                            ),
                            IconButton(
                              onPressed: _toggleVideo,
                              icon: Icon(
                                _isVideoDisabled
                                    ? Icons.videocam_off
                                    : Icons.videocam,
                                color: Colors.blue,
                              ),
                              iconSize: 36,
                            ),
                            IconButton(
                              onPressed: _endCall,
                              icon:
                                  const Icon(Icons.call_end, color: Colors.red),
                              iconSize: 36,
                            ),
                            IconButton(
                              onPressed: _switchCamera,
                              icon: const Icon(Icons.switch_camera,
                                  color: Colors.blue),
                              iconSize: 36,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _remoteVideo() {
    if (_remoteUid != null && _engine != null && _channelName != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine!,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: _channelName!),
        ),
      );
    } else {
      return const Text(
        'Please wait for user to join...',
        textAlign: TextAlign.center,
      );
    }
  }
}
