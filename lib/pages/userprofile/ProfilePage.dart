import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pjtravelapp/entities/UserProfile.dart';
import 'package:pjtravelapp/entities/account.dart';
import 'package:pjtravelapp/pages/navbar/Navbar.dart';
import 'package:pjtravelapp/service/ApiService.dart';
import 'package:pjtravelapp/service/AuthService.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:pjtravelapp/pages/userprofile/TourDetailDialog.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showDetail = false;
  bool isLoading = true;
  String? _errorMessage;
  UserProfile? profile;

  late TextEditingController fullNameCtrl;
  late TextEditingController bioCtrl;
  late TextEditingController genderCtrl;
  late TextEditingController dobCtrl;
  late TextEditingController addressCtrl;

  List<Map<String, dynamic>> myTours = [];
  final Account? account = AuthService.currentAccount;

  @override
  void initState() {
    super.initState();
    _initControllers();
    fetchProfile();
  }

  void _initControllers() {
    fullNameCtrl = TextEditingController();
    bioCtrl = TextEditingController();
    genderCtrl = TextEditingController();
    dobCtrl = TextEditingController();
    addressCtrl = TextEditingController();
  }

  Future<void> fetchProfile() async {
    final accountId = account?.accountId;
    if (accountId == null) {
      setState(() {
        _errorMessage = 'Account not found';
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      _errorMessage = null;
    });

    try {
      // Fetch profile
      final profileResp = await http.get(
        Uri.parse('http://192.168.2.7:9999/api/profiles/$accountId'),
      );

      if (profileResp.statusCode == 200) {
        final data = json.decode(profileResp.body);
        profile = UserProfile.fromJson(data);

        fullNameCtrl.text = profile?.fullName ?? '';
        bioCtrl.text = profile?.bio ?? '';
        genderCtrl.text = profile?.gender ?? '';
        dobCtrl.text = profile?.dateOfBirth ?? '';
        addressCtrl.text = profile?.address ?? '';
      } else {
        _errorMessage = 'Failed to load profile: ${profileResp.statusCode}';
      }

      // Fetch tours
      final toursResp = await http.get(
        Uri.parse('http://192.168.2.7:9999/api/tours/account/$accountId'),
      );

      if (toursResp.statusCode == 200) {
        final List<dynamic> data = json.decode(toursResp.body);
        myTours = data.cast<Map<String, dynamic>>();
      } else {
        _errorMessage = 'Failed to load tours: ${toursResp.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Error fetching data: $e';
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    final accountId = account?.accountId;
    if (accountId == null) {
      setState(() => _errorMessage = 'Account not found');
      return;
    }

    final payload = {
      "fullName": fullNameCtrl.text,
      "bio": bioCtrl.text,
      "gender": genderCtrl.text,
      "dateOfBirth": dobCtrl.text,
      "address": addressCtrl.text,
    };

    setState(() {
      isLoading = true;
      _errorMessage = null;
    });

    try {
      final success = await ApiService.updateUserProfile(accountId, payload);

      if (!success) {
        setState(() => _errorMessage = 'Failed to update profile');
      } else {
        await fetchProfile();
        setState(() => showDetail = false);
      }
    } catch (e) {
      setState(() => _errorMessage = 'Error updating profile: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    fullNameCtrl.dispose();
    bioCtrl.dispose();
    genderCtrl.dispose();
    dobCtrl.dispose();
    addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (account == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Profile")),
        body: const Center(child: Text("You are not logged in.")),
      );
    }

    final isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(title: const Text("User Profile")),
      drawer: NavbarDrawer(
        account: account,
        onLogout: () => Navigator.pop(context),
        onLogin: (_) {},
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _buildProfileSection()),
                        const SizedBox(width: 20),
                        Expanded(flex: 7, child: _buildRightSection()),
                      ],
                    )
                  : Column(
                      children: [
                        _buildProfileSection(),
                        const SizedBox(height: 20),
                        _buildRightSection(),
                      ],
                    ),
            ),
    );
  }

  Widget _buildProfileSection() {
    if (profile == null) return const SizedBox();

  final avatarProvider =
    profile?.avatarUrl != null && profile!.avatarUrl!.isNotEmpty
        ? AssetImage('assets/images/account/${profile!.avatarUrl!}')
        : const AssetImage('assets/images/account/default.png');

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              setState(() => showDetail = !showDetail);
            },
            icon: const Icon(Icons.person),
            label: const Text("Edit Profile"),
          ),
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: avatarProvider as ImageProvider,
                child: profile?.avatarUrl == null || profile!.avatarUrl!.isEmpty
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
              if (showDetail)
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white, size: 18),
                    onPressed: () {},
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          if (showDetail)
            Column(
              children: [
                TextField(
                  controller: fullNameCtrl,
                  decoration: const InputDecoration(labelText: "Full Name"),
                ),
                TextField(
                  controller: bioCtrl,
                  decoration: const InputDecoration(labelText: "Bio"),
                ),
                TextField(
                  controller: genderCtrl,
                  decoration: const InputDecoration(labelText: "Gender"),
                ),
                TextField(
                  controller: dobCtrl,
                  decoration: const InputDecoration(labelText: "Date of Birth"),
                ),
                TextField(
                  controller: addressCtrl,
                  decoration: const InputDecoration(labelText: "Address"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size.fromHeight(45),
                  ),
                  onPressed: _saveProfile,
                  child: const Text("Save"),
                ),
              ],
            )
          else
            Column(
              children: [
                buildRow('Full Name', profile!.fullName),
                buildRow('Bio', profile!.bio),
                buildRow('Gender', profile!.gender),
                buildRow('Date of Birth', profile!.dateOfBirth),
                buildRow('Address', profile!.address),
                buildRow('Phone', profile!.phone),
                buildRow('Facebook', profile!.facebook),
                buildRow('Instagram', profile!.instagram),
                buildRow('Website', profile!.website),
                buildRow('Location', profile!.location),
              ],
            ),
        ],
      ),
    );
  }

  Widget buildRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value ?? '-')),
        ],
      ),
    );
  }

  Widget _buildRightSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 3,
          children: [
            _buildCreateCard(
  "Create Tour With AI",
  Colors.orange[200]!,
  onTap: () {
    // Mở dialog giống TourDetailDialog chẳng hạn
    showDialog(
      context: context,
      builder: (ctx) => TourDetailDialog(
        selectedTour: null, // vì đang tạo mới
        onClose: () => Navigator.of(ctx).pop(),
        onGenerateAI: () async {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Generating AI Tour...")),
          );
        },
        onSaveAI: () async {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("AI Tour saved!")),
          );
        },
        isLoading: false,
        hasAiTour: false,
      ),
    );
  },
),

            _buildCreateCard("Create Tour", Colors.orange[200]!),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "My Tours",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.75,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: myTours.length,
                itemBuilder: (context, index) {
                  return _buildTourCard(myTours[index]);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildCreateCard(String title, Color color) {
  //   return Container(
  //     padding: const EdgeInsets.all(10),
  //     decoration: BoxDecoration(
  //       color: color,
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     alignment: Alignment.center,
  //     child: Text(
  //       title,
  //       textAlign: TextAlign.center,
  //       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
  //     ),
  //   );
  // }
Widget _buildCreateCard(String title, Color color, {VoidCallback? onTap}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    ),
  );
}


Widget _buildTourCard(Map<String, dynamic> tour) {
  final imageName = tour["imageUrl"] ?? 'hoian.png';
  final imagePath = 'assets/images/tours/$imageName';

  return GestureDetector(
    onTap: () {
      showDialog(
        context: context,
        builder: (ctx) => TourDetailDialog(
          selectedTour: tour,
          onClose: () => Navigator.of(ctx).pop(),
          // Nếu có AI thì truyền thêm 2 callback
          onGenerateAI: () async {
            // TODO: gọi API generate AI tour
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Generating AI Tour...")),
            );
          },
          onSaveAI: () async {
            // TODO: gọi API save AI tour
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("AI Tour saved!")),
            );
          },
          isLoading: false,
          hasAiTour: true, // hoặc check tour có phải AI tạo ra không
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tour["title"] ?? '-',
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  "📍 ${tour["location"]?["name"] ?? "Unknown"}",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  "💰 \$${tour["price"] ?? '-'} / person",
                  style: const TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

}
