import 'package:flutter/material.dart';
import 'package:pjtravelapp/entities/TourDetail.dart';
import 'package:pjtravelapp/pages/tour/booking_page.dart';

class TourDetailPage extends StatefulWidget {
  final TourDetail tour;
  const TourDetailPage({Key? key, required this.tour}) : super(key: key);

  @override
  State<TourDetailPage> createState() => _TourDetailPageState();
}

class _TourDetailPageState extends State<TourDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildImageGallery() {
    if (widget.tour.images != null && widget.tour.images!.isNotEmpty) {
      return SizedBox(
        height: 250,
        child: PageView(
          children: widget.tour.images!
              .map((img) => Image.asset(
            'assets/images/tour_details/${img.original ?? ''}',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported),
            ),
          ))
              .toList(),

        ),
      );
    } else {
      return Container(
        height: 250,
        color: Colors.grey[300],
        child: const Icon(Icons.image, size: 50),
      );
    }
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.tour.description ?? ''),
          const SizedBox(height: 16),
          Text("Tour Info", style: const TextStyle(fontWeight: FontWeight.bold)),
          ...?widget.tour.tourInfo?.map((info) => ListTile(
            title: Text(info),
            dense: true,
          )),
          const SizedBox(height: 16),
          Text("Highlights", style: const TextStyle(fontWeight: FontWeight.bold)),
          ...?widget.tour.highlights?.map((h) => ListTile(
            title: Text(h),
            dense: true,
          )),
        ],
      ),
    );
  }

  Widget _buildItineraryTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.tour.itineraries?.length ?? 0,
      itemBuilder: (_, i) {
        final item = widget.tour.itineraries![i];
        return ExpansionTile(
          title: Text(item.title ?? ''),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item.description ?? ''),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInclusionExclusionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Inclusions", style: const TextStyle(fontWeight: FontWeight.bold)),
          ...?widget.tour.included?.map((inc) => ListTile(
            leading: const Icon(Icons.check, color: Colors.green),
            title: Text(inc),
            dense: true,
          )),
          const SizedBox(height: 16),
          Text("Exclusions", style: const TextStyle(fontWeight: FontWeight.bold)),
          ...?widget.tour.exclusion?.map((exc) => ListTile(
            leading: const Icon(Icons.close, color: Colors.red),
            title: Text(exc),
            dense: true,
          )),
        ],
      ),
    );
  }

  Widget _buildLocationTab() {
    return const Center(
      child: Text("Google Map iframe có thể nhúng bằng WebView ở đây"),
    );
  }

  Widget _buildSidebar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("\$${widget.tour.price}",
                    style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Text("/person"),
                Row(
                  children: [
                    Text("${widget.tour.rating}"),
                    const Icon(Icons.star, color: Colors.orange),
                    const Spacer(),
                    Text("(${widget.tour.reviews})"),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookingPage(
                          tourTitle: widget.tour.title,
                          imageUrl: 'assets/images/tour_details/${widget.tour.urls}', // lấy từ model
                          price: widget.tour.price,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48)),
                  child: const Text("Book Now"),
                )
              ],
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Need Help?",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text("Call us: +91 123 456 789"),
                ),
                ListTile(
                  leading: Icon(Icons.access_time),
                  title: Text("Timing: 10AM to 7PM"),
                ),
                ListTile(
                  leading: Icon(Icons.headset),
                  title: Text("Let us call you"),
                ),
                ListTile(
                  leading: Icon(Icons.calendar_month),
                  title: Text("Book Appointments"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;
    final tour = widget.tour;

    return Scaffold(
      appBar: AppBar(title: Text(tour.title ?? '')),
      body: isWide
          ? Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                _buildImageGallery(),
                TabBar(
                  controller: _tabController,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(text: "Overview"),
                    Tab(text: "Itinerary"),
                    Tab(text: "Inclusion & Exclusion"),
                    Tab(text: "Location"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOverviewTab(),
                      _buildItineraryTab(),
                      _buildInclusionExclusionTab(),
                      _buildLocationTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 300, child: _buildSidebar())
        ],
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            _buildImageGallery(),
            TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: "Overview"),
                Tab(text: "Itinerary"),
                Tab(text: "Inclusion & Exclusion"),
                Tab(text: "Location"),
              ],
            ),
            SizedBox(
              height: 400, // chiều cao cho TabBarView trong mobile
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildItineraryTab(),
                  _buildInclusionExclusionTab(),
                  _buildLocationTab(),
                ],
              ),
            ),
            _buildSidebar(),
          ],
        ),
      ),
    );
  }
}
