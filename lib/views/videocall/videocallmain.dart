import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

const appId = "77022c24fc4048ecb34131448fd7dbc9";
const token =
    "007eJxTYEjg1pq7I+XkzL3HfypNfnT7jLDDu5+Vd0PXzn/1ivvt8b9HFRjMzQ2MjJKNTNKSTQxMLFKTk4xNDI0NTUws0lLMU5KSLcue3k9vCGRkOP3EmImRAQJBfHaGktTiksy8dAYGABWGJfE=";
const channel = "testing";

class Videocallmain extends StatefulWidget {
  const Videocallmain({super.key});

  @override
  State<Videocallmain> createState() => _VideocallmainState();
}

class _VideocallmainState extends State<Videocallmain> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool _isMuted = false; // Microphone mute status
  bool _isVideoDisabled = false; // Video disable status

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();
    _engine = await createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint(
              'local user ' + connection.localUid.toString() + ' joined');
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );
    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.joinChannel(
      token: token,
      channelId: channel,
      options: const ChannelMediaOptions(
          autoSubscribeVideo: true,
          autoSubscribeAudio: true,
          publishCameraTrack: true,
          publishMicrophoneTrack: true,
          clientRoleType: ClientRoleType.clientRoleBroadcaster),
      uid: 0,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    _engine.muteLocalAudioStream(_isMuted);
  }

  void _toggleVideo() {
    setState(() {
      _isVideoDisabled = !_isVideoDisabled;
    });
    _engine.muteLocalVideoStream(_isVideoDisabled);
  }

  void _switchCamera() {
    _engine.switchCamera();
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
        body: Stack(
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
                  child: _localUserJoined
                      ? AgoraVideoView(
                          controller: VideoViewController(
                            rtcEngine: _engine,
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
                    color: Colors.blue,
                    iconSize: 36,
                  ),
                  IconButton(
                    onPressed: _toggleVideo,
                    icon: Icon(
                      _isVideoDisabled ? Icons.videocam_off : Icons.videocam,
                      color: Colors.blue,
                    ),
                    color: Colors.blue,
                    iconSize: 36,
                  ),
                  IconButton(
                    onPressed: _endCall,
                    icon: const Icon(Icons.call_end, color: Colors.red),
                    color: Colors.red,
                    iconSize: 36,
                  ),
                  IconButton(
                    onPressed: _switchCamera,
                    icon: const Icon(Icons.switch_camera, color: Colors.blue),
                    color: Colors.blue,
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
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: channel),
        ),
      );
    } else {
      return const Text(
        'Please wait user to join..',
        textAlign: TextAlign.center,
      );
    }
  }
}
