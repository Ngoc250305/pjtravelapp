// // import 'package:flutter/material.dart';
// // import 'package:video_player/video_player.dart';
// //
// // class HomePage extends StatefulWidget {
// //   final Function(String)? onSearch;
// //
// //   const HomePage({
// //     super.key,
// //     this.onSearch,
// //   });
// //
// //   @override
// //   State<HomePage> createState() => _HomePageState();
// // }
// //
// // class _HomePageState extends State<HomePage> {
// //   late VideoPlayerController _videoController;
// //   final TextEditingController _searchController = TextEditingController();
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _videoController = VideoPlayerController.asset('assets/videos/video1.mp4')
// //       ..initialize().then((_) {
// //         setState(() {});
// //         _videoController.setLooping(true);
// //         _videoController.play();
// //       });
// //   }
// //
// //   @override
// //   void dispose() {
// //     _videoController.dispose();
// //     _searchController.dispose();
// //     super.dispose();
// //   }
// //   //
// //   // @override
// //   // Widget build(BuildContext context) {
// //   //   return Stack(
// //   //     children: [
// //   //       // Video Background
// //   //       SizedBox.expand(
// //   //         child: FittedBox(
// //   //           fit: BoxFit.cover,
// //   //           child: SizedBox(
// //   //             width: _videoController.value.size.width,
// //   //             height: _videoController.value.size.height,
// //   //             child: VideoPlayer(_videoController),
// //   //           ),
// //   //         ),
// //   //       ),
// //   //
// //   //       // Overlay
// //   //       Container(color: Colors.black.withOpacity(0.4)),
// //   //
// //   //       // Content
// //   //       SingleChildScrollView(
// //   //         child: Container(
// //   //           padding: const EdgeInsets.all(20),
// //   //           child: Column(
// //   //             crossAxisAlignment: CrossAxisAlignment.start,
// //   //             children: [
// //   //               const SizedBox(height: 60),
// //   //               // Header Text
// //   //               const Column(
// //   //                 crossAxisAlignment: CrossAxisAlignment.start,
// //   //                 children: [
// //   //                   Text(
// //   //                     'Our Services!!',
// //   //                     style: TextStyle(
// //   //                       color: Colors.white,
// //   //                       fontSize: 16,
// //   //                       fontWeight: FontWeight.w300,
// //   //                     ),
// //   //                   ),
// //   //                   SizedBox(height: 10),
// //   //                   Text(
// //   //                     'Search your Holiday',
// //   //                     style: TextStyle(
// //   //                       color: Colors.white,
// //   //                       fontSize: 28,
// //   //                       fontWeight: FontWeight.bold,
// //   //                     ),
// //   //                   ),
// //   //                 ],
// //   //               ),
// //   //
// //   //               const SizedBox(height: 40),
// //   //
// //   //               // Search Card
// //   //               Container(
// //   //                 padding: const EdgeInsets.all(16),
// //   //                 decoration: BoxDecoration(
// //   //                   color: Colors.white.withOpacity(0.8),
// //   //                   borderRadius: BorderRadius.circular(10),
// //   //                 ),
// //   //                 child: Column(
// //   //                   children: [
// //   //                     // Destination Input
// //   //                     Column(
// //   //                       crossAxisAlignment: CrossAxisAlignment.start,
// //   //                       children: [
// //   //                         const Text(
// //   //                           'Where do you want to go?:',
// //   //                           style: TextStyle(
// //   //                             fontWeight: FontWeight.w500,
// //   //                           ),
// //   //                         ),
// //   //                         const SizedBox(height: 8),
// //   //                         TextField(
// //   //                           controller: _searchController,
// //   //                           decoration: InputDecoration(
// //   //                             hintText: 'Enter name here...',
// //   //                             suffixIcon: const Icon(Icons.location_on),
// //   //                             border: OutlineInputBorder(
// //   //                               borderRadius: BorderRadius.circular(8),
// //   //                             ),
// //   //                           ),
// //   //                         ),
// //   //                       ],
// //   //                     ),
// //   //
// //   //                     const SizedBox(height: 16),
// //   //
// //   //                     // More Filters
// //   //                     GestureDetector(
// //   //                       onTap: () {
// //   //                         // Handle more filters
// //   //                       },
// //   //                       child: Row(
// //   //                         children: [
// //   //                           const Icon(Icons.filter_alt),
// //   //                           const SizedBox(width: 8),
// //   //                           Text(
// //   //                             'MORE FILTERS',
// //   //                             style: TextStyle(
// //   //                               fontWeight: FontWeight.w500,
// //   //                               color: Colors.grey[700],
// //   //                             ),
// //   //                           ),
// //   //                         ],
// //   //                       ),
// //   //                     ),
// //   //                   ],
// //   //                 ),
// //   //               ),
// //   //
// //   //               const SizedBox(height: 20),
// //   //
// //   //               // Search Button
// //   //               Center(
// //   //                 child: ElevatedButton(
// //   //                   onPressed: () {
// //   //                     if (_searchController.text.isNotEmpty && widget.onSearch != null) {
// //   //                       widget.onSearch!(_searchController.text);
// //   //                     }
// //   //                   },
// //   //                   style: ElevatedButton.styleFrom(
// //   //                     backgroundColor: Colors.blue,
// //   //                     padding: const EdgeInsets.symmetric(
// //   //                         horizontal: 40, vertical: 16),
// //   //                     shape: RoundedRectangleBorder(
// //   //                       borderRadius: BorderRadius.circular(30),
// //   //                     ),
// //   //                   ),
// //   //                   child: const Text(
// //   //                     'SEARCH',
// //   //                     style: TextStyle(
// //   //                       color: Colors.white,
// //   //                       fontWeight: FontWeight.bold,
// //   //                     ),
// //   //                   ),
// //   //                 ),
// //   //               ),
// //   //
// //   //               const SizedBox(height: 40),
// //   //
// //   //               // Footer Icons
// //   //               Row(
// //   //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //   //                 children: [
// //   //                   // Right Icons
// //   //                   Row(
// //   //                     children: [
// //   //                       IconButton(
// //   //                         icon: const Icon(Icons.facebook),
// //   //                         onPressed: () {},
// //   //                         color: Colors.white,
// //   //                       ),
// //   //                       IconButton(
// //   //                         icon: const Icon(Icons.camera_alt),
// //   //                         onPressed: () {},
// //   //                         color: Colors.white,
// //   //                       ),
// //   //                       IconButton(
// //   //                         icon: const Icon(Icons.travel_explore),
// //   //                         onPressed: () {},
// //   //                         color: Colors.white,
// //   //                       ),
// //   //                     ],
// //   //                   ),
// //   //
// //   //                   // Left Icons
// //   //                   Row(
// //   //                     children: [
// //   //                       IconButton(
// //   //                         icon: const Icon(Icons.list),
// //   //                         onPressed: () {},
// //   //                         color: Colors.white,
// //   //                       ),
// //   //                       IconButton(
// //   //                         icon: const Icon(Icons.apps),
// //   //                         onPressed: () {},
// //   //                         color: Colors.white,
// //   //                       ),
// //   //                     ],
// //   //                   ),
// //   //                 ],
// //   //               ),
// //   //             ],
// //   //           ),
// //   //         ),
// //   //       ),
// //   //     ],
// //   //   );
// //   // }
// //   Widget _buildFooterIcons() {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 24.0),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           IconButton(
// //             icon: const Icon(Icons.facebook, color: Colors.blue),
// //             onPressed: () {
// //               // mở link Facebook
// //             },
// //           ),
// //           IconButton(
// //             icon: const Icon(Icons.email, color: Colors.red),
// //             onPressed: () {
// //               // mở email
// //             },
// //           ),
// //           IconButton(
// //             icon: const Icon(Icons.call, color: Colors.green),
// //             onPressed: () {
// //               // gọi điện hoặc điều hướng tới trang liên hệ
// //             },
// //           ),
// //           IconButton(
// //             icon: const Icon(Icons.ondemand_video, color: Colors.redAccent),
// //             onPressed: () {
// //               // mở Youtube hoặc video hướng dẫn
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildSearchButton() {
// //     return SizedBox(
// //       width: double.infinity,
// //       child: ElevatedButton(
// //         onPressed: () {
// //           final keyword = _searchController.text.trim();
// //           if (keyword.isNotEmpty) {
// //             // widget.onSearch(keyword);
// //           }
// //         },
// //         style: ElevatedButton.styleFrom(
// //           backgroundColor: Colors.blue,
// //           padding: const EdgeInsets.symmetric(vertical: 16),
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(8),
// //           ),
// //         ),
// //         child: const Text(
// //           'Search',
// //           style: TextStyle(fontSize: 16, color: Colors.white),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildSearchCard() {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.white.withOpacity(0.8),
// //         borderRadius: BorderRadius.circular(10),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const Text('Where do you want to go?:',
// //               style: TextStyle(fontWeight: FontWeight.w500)),
// //           const SizedBox(height: 8),
// //           TextField(
// //             controller: _searchController,
// //             decoration: InputDecoration(
// //               hintText: 'Enter name here...',
// //               suffixIcon: const Icon(Icons.location_on),
// //               border: OutlineInputBorder(
// //                 borderRadius: BorderRadius.circular(8),
// //               ),
// //             ),
// //           ),
// //           const SizedBox(height: 16),
// //           GestureDetector(
// //             onTap: () {},
// //             child: Row(
// //               children: [
// //                 const Icon(Icons.filter_alt),
// //                 const SizedBox(width: 8),
// //                 Text(
// //                   'MORE FILTERS',
// //                   style: TextStyle(
// //                     fontWeight: FontWeight.w500,
// //                     color: Colors.grey[700],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return _videoController.value.isInitialized
// //         ? Stack(
// //       children: [
// //         // Video Background
// //         SizedBox.expand(
// //           child: FittedBox(
// //             fit: BoxFit.cover,
// //             child: SizedBox(
// //               width: _videoController.value.size.width,
// //               height: _videoController.value.size.height,
// //               child: VideoPlayer(_videoController),
// //             ),
// //           ),
// //         ),
// //
// //         // Overlay + Content
// //         Container(color: Colors.black.withOpacity(0.4)),
// //
// //         // Main content
// //         SingleChildScrollView(
// //           child: Container(
// //             padding: const EdgeInsets.all(20),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 const SizedBox(height: 60),
// //                 const Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       'Our Services!!',
// //                       style: TextStyle(color: Colors.white, fontSize: 16),
// //                     ),
// //                     SizedBox(height: 10),
// //                     Text(
// //                       'Search your Holiday',
// //                       style: TextStyle(
// //                           color: Colors.white,
// //                           fontSize: 28,
// //                           fontWeight: FontWeight.bold),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 40),
// //                 _buildSearchCard(),
// //                 const SizedBox(height: 20),
// //                 _buildSearchButton(),
// //                 const SizedBox(height: 40),
// //                 _buildFooterIcons(),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ],
// //     )
// //         : const Center(child: CircularProgressIndicator());
// //   }
// //
// // }
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
//
// class HomePage extends StatefulWidget {
//   final Function(String)? onSearch;
//
//   const HomePage({super.key, this.onSearch});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   late VideoPlayerController _videoController;
//   final TextEditingController _searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _videoController = VideoPlayerController.asset('assets/videos/video1.mp4')
//       ..initialize().then((_) {
//         setState(() {});
//         _videoController.setLooping(true);
//         _videoController.play();
//       });
//   }
//
//   @override
//   void dispose() {
//     _videoController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   Widget _buildFooterIcons() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 24.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           IconButton(
//             icon: const Icon(Icons.facebook, color: Colors.blue),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: const Icon(Icons.email, color: Colors.red),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: const Icon(Icons.call, color: Colors.green),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: const Icon(Icons.ondemand_video, color: Colors.redAccent),
//             onPressed: () {},
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSearchButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: () {
//           final keyword = _searchController.text.trim();
//           if (keyword.isNotEmpty && widget.onSearch != null) {
//             widget.onSearch!(keyword);
//           }
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.blue,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//         child: const Text(
//           'Search',
//           style: TextStyle(fontSize: 16, color: Colors.white),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSearchCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.8),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Where do you want to go?:',
//             style: TextStyle(fontWeight: FontWeight.w500),
//           ),
//           const SizedBox(height: 8),
//           TextField(
//             controller: _searchController,
//             decoration: InputDecoration(
//               hintText: 'Enter name here...'
//               ,
//               suffixIcon: const Icon(Icons.location_on),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           GestureDetector(
//             onTap: () {},
//             child: Row(
//               children: [
//                 const Icon(Icons.filter_alt),
//                 const SizedBox(width: 8),
//                 Text(
//                   'MORE FILTERS',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey[700],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // return _videoController.value.isInitialized
//     //     ? Stack(
//     //   children: [
//     //     SizedBox.expand(
//     //       child: FittedBox(
//     //         fit: BoxFit.cover,
//     //         child: SizedBox(
//     //           width: _videoController.value.size.width,
//     //           height: _videoController.value.size.height,
//     //           child: VideoPlayer(_videoController),
//     //         ),
//     //       ),
//     //     ),
//     //     Container(color: Colors.black.withOpacity(0.4)),
//     //     SingleChildScrollView(
//     //       child: Padding(
//     //         padding: const EdgeInsets.all(20),
//     //         child: Column(
//     //           crossAxisAlignment: CrossAxisAlignment.start,
//     //           children: [
//     //             const SizedBox(height: 60),
//     //             const Column(
//     //               crossAxisAlignment: CrossAxisAlignment.start,
//     //               children: [
//     //                 Text(
//     //                   'Our Services!!',
//     //                   style: TextStyle(color: Colors.white, fontSize: 16),
//     //                 ),
//     //                 SizedBox(height: 10),
//     //                 Text(
//     //                   'Search your Holiday',
//     //                   style: TextStyle(
//     //                       color: Colors.white,
//     //                       fontSize: 28,
//     //                       fontWeight: FontWeight.bold),
//     //                 ),
//     //               ],
//     //             ),
//     //             const SizedBox(height: 40),
//     //             _buildSearchCard(),
//     //             const SizedBox(height: 20),
//     //             _buildSearchButton(),
//     //             const SizedBox(height: 40),
//     //             _buildFooterIcons(),
//     //           ],
//     //         ),
//     //       ),
//     //     ),
//     //   ],
//     // )
//     //     : const Center(child: CircularProgressIndicator());
//     return Column(
//       children: [
//         AspectRatio(
//           aspectRatio: _videoController.value.aspectRatio,
//           child: VideoPlayer(_videoController),
//         ),
//         Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               const Text(
//                 'Where would you like to go?',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 // onSubmitted: onSearch,
//                 decoration: const InputDecoration(
//                   prefixIcon: Icon(Icons.search),
//                   hintText: 'Search holiday...',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//
//   }
// }
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  final Function(String)? onSearch;

  const HomePage({super.key, this.onSearch});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _videoController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/videos/rua.mp4')
      ..initialize().then((_) {
        setState(() {});
        _videoController.setLooping(true);
        _videoController.play();
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildFooterIcons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(icon: const Icon(Icons.facebook, color: Colors.blue), onPressed: () {}),
          IconButton(icon: const Icon(Icons.email, color: Colors.red), onPressed: () {}),
          IconButton(icon: const Icon(Icons.call, color: Colors.green), onPressed: () {}),
          IconButton(icon: const Icon(Icons.ondemand_video, color: Colors.redAccent), onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildSearchCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Where do you want to go?', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Enter name here...',
              suffixIcon: const Icon(Icons.location_on),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                const Icon(Icons.filter_alt),
                const SizedBox(width: 8),
                Text('MORE FILTERS', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final keyword = _searchController.text.trim();
          if (keyword.isNotEmpty && widget.onSearch != null) {
            widget.onSearch!(keyword);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Search', style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_videoController.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: _videoController.value.aspectRatio,
          child: Stack(
            fit: StackFit.expand,
            children: [
              VideoPlayer(_videoController),
              Container(color: Colors.black.withOpacity(0.3)),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Our Services!!', style: TextStyle(color: Colors.white70, fontSize: 16)),
                    SizedBox(height: 10),
                    Text(
                      'Search your Holiday',
                      style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildSearchCard(),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildSearchButton(),
        ),
        _buildFooterIcons(),
      ],
    );
  }
}
