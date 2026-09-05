import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';

class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  Room? room;
  LocalVideoTrack? camera;
  String status = 'Connecting...';
  bool frontCamera = false;
  bool microphoneEnabled = true;

  @override
  void initState() {
    super.initState();
    startLive();
  }

  Future<void> startLive() async {
    try {
      final source = DevelopmentTokenSource(id: 'socialbooklive-1lll3n');
      final details = await source.fetch(
        const TokenRequestOptions(
          roomName: 'socialbook-live',
          participantName: 'Socialbook User',
        ),
      );

      final liveRoom = Room();
      await liveRoom.connect(details.serverUrl, details.participantToken);
      await liveRoom.localParticipant?.setCameraEnabled(true);
      await liveRoom.localParticipant?.setMicrophoneEnabled(true);

      LocalVideoTrack? track;
      for (final publication
          in liveRoom.localParticipant?.videoTrackPublications ?? []) {
        if (publication.track is LocalVideoTrack) {
          track = publication.track as LocalVideoTrack;
          break;
        }
      }

      if (!mounted) return;
      setState(() {
        room = liveRoom;
        camera = track;
        status = 'LIVE';
      });
    } catch (error) {
      if (mounted) setState(() => status = 'Live error: $error');
    }
  }

  Future<void> switchCamera() async {
    if (camera == null) return;
    frontCamera = !frontCamera;
    await camera!.setCameraPosition(
      frontCamera ? CameraPosition.front : CameraPosition.back,
    );
    if (mounted) setState(() {});
  }

  Future<void> toggleMicrophone() async {
    microphoneEnabled = microphoneEnabled == false;
    await room?.localParticipant?.setMicrophoneEnabled(microphoneEnabled);
    if (mounted) setState(() {});
  }

  Future<void> endLive() async {
    await room?.disconnect();
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    room?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        title: Text(status),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (camera != null)
            VideoTrackRenderer(camera!)
          else
            Center(
              child: Text(
                status,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          Positioned(
            top: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: switchCamera,
              backgroundColor: Colors.black54,
              foregroundColor: Colors.white,
              child: const Icon(Icons.cameraswitch),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            child: FloatingActionButton(
              onPressed: toggleMicrophone,
              backgroundColor: Colors.black54,
              foregroundColor: Colors.white,
              child: Icon(microphoneEnabled ? Icons.mic : Icons.mic_off),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 100,
            right: 100,
            child: ElevatedButton.icon(
              onPressed: endLive,
              icon: const Icon(Icons.stop),
              label: const Text('End Live'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
