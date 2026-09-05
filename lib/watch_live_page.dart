import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';

class WatchLivePage extends StatefulWidget {
  const WatchLivePage({super.key});

  @override
  State<WatchLivePage> createState() => _WatchLivePageState();
}

class _WatchLivePageState extends State<WatchLivePage> {
  Room? room;
  VideoTrack? remoteVideo;
  String status = 'Joining live...';

  @override
  void initState() {
    super.initState();
    joinLive();
  }

  Future<void> joinLive() async {
    try {
      final source = DevelopmentTokenSource(id: 'socialbooklive-1lll3n');
      final details = await source.fetch(
        TokenRequestOptions(
          roomName: 'socialbook-live',
          participantName: 'Viewer',
          participantIdentity:
              'viewer-${DateTime.now().millisecondsSinceEpoch}',
        ),
      );

      final liveRoom = Room();
      room = liveRoom;
      liveRoom.addListener(findVideo);
      await liveRoom.connect(details.serverUrl, details.participantToken);
      findVideo();
    } catch (error) {
      if (mounted) setState(() => status = 'Unable to watch: $error');
    }
  }

  void findVideo() {
    VideoTrack? found;
    final currentRoom = room;
    if (currentRoom == null) return;

    for (final participant in currentRoom.remoteParticipants.values) {
      for (final publication in participant.videoTrackPublications) {
        if (publication.track is VideoTrack) {
          found = publication.track as VideoTrack;
          break;
        }
      }
      if (found != null) break;
    }

    if (mounted) {
      setState(() {
        remoteVideo = found;
        status = found == null ? 'Waiting for host...' : 'LIVE';
      });
    }
  }

  Future<void> leaveLive() async {
    await room?.disconnect();
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    room?.removeListener(findVideo);
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
          if (remoteVideo != null)
            VideoTrackRenderer(remoteVideo!)
          else
            Center(
              child: Text(
                status,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          Positioned(
            bottom: 30,
            left: 100,
            right: 100,
            child: ElevatedButton.icon(
              onPressed: leaveLive,
              icon: const Icon(Icons.close),
              label: const Text('Leave Live'),
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
