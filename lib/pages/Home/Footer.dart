import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset("assets/videos/rua.mp4")
      ..initialize().then((_) {
        setState(() {});
        _videoController.setLooping(true);
        _videoController.setVolume(0);
        _videoController.play();
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  Widget buildFooterList(String title, List<String> items) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                const Icon(Icons.chevron_right, size: 16),
                const SizedBox(width: 6),
                Text(item),
              ],
            ),
          ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Video
        if (_videoController.value.isInitialized)
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController.value.size.width,
                height: _videoController.value.size.height,
                child: VideoPlayer(_videoController),
              ),
            ),
          ),
        // Overlay content
        Container(
          color: Colors.black.withOpacity(0.6),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Contact
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('KEEP IN TOUCH',
                          style: TextStyle(color: Colors.white70)),
                      SizedBox(height: 6),
                      Text('Travel with us',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 200,
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Enter your address",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.send),
                        label: const Text("SEND"),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Footer Content
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Intro
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.travel_explore, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'GlobleTrip.',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Let's discover the world together. Explore, dream, and travel with us for unforgettable experiences.",
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: const [
                            Icon(FontAwesomeIcons.twitter, color: Colors.white),
                            SizedBox(width: 12),
                            Icon(FontAwesomeIcons.youtube, color: Colors.white),
                            SizedBox(width: 12),
                            Icon(FontAwesomeIcons.instagram, color: Colors.white),
                            SizedBox(width: 12),
                            Icon(FontAwesomeIcons.triangleExclamation, color: Colors.white),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Footer Links
                  buildFooterList("OUR AGENCY", [
                    "Service",
                    "Insurance",
                    "Agency",
                    "Tourism",
                  ]),
                  buildFooterList("PARTNERS", [
                    "Bookings",
                    "Trivago",
                    "Service",
                    "Service",
                  ]),
                  buildFooterList("LAST MINUTE", [
                    "London",
                    "Indonesia",
                    "Europe",
                    "Oceania",
                  ]),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.white70),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "BEST TRAVEL WEBSITE\n© 2025 Travel. All rights reserved.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
