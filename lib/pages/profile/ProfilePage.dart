// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import '../../entities/UserProfile.dart';
// import '../../service/ApiService.dart';
// import '../account/AuthProvider.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   UserProfile? profile;
//   bool isLoading = true;
//   bool isPopupOpen = false;
//   final picker = ImagePicker();
//   File? selectedImage;

//   final TextEditingController fullNameController = TextEditingController();
//   final TextEditingController bioController = TextEditingController();
//   final TextEditingController genderController = TextEditingController();
//   final TextEditingController dobController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     loadProfile();
//   }

//   Future<void> loadProfile() async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final accountId = authProvider.currentAccount?.accountId;

//     if (accountId != null) {
//       try {
//         final userProfile = await ApiService.getUserProfile(accountId);
//         setState(() {
//           profile = userProfile;
//           fullNameController.text = userProfile.fullName;
//           bioController.text = userProfile.bio;
//           genderController.text = userProfile.gender;
//           dobController.text = userProfile.dateOfBirth;
//           addressController.text = userProfile.address;
//           isLoading = false;
//         });
//       } catch (e) {
//         print('Error loading profile: $e');
//         setState(() => isLoading = false);
//       }
//     }
//   }

//   Future<void> pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         selectedImage = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> saveProfile() async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final accountId = authProvider.currentAccount?.accountId;

//     if (accountId != null && profile != null) {
//       try {
//         String avatarFileName = profile!.avatarUrl;

//         if (selectedImage != null) {
//           avatarFileName = await ApiService.uploadAvatar(selectedImage!);
//         }

//         Map<String, dynamic> payload = {
//           'fullName': fullNameController.text,
//           'avatarUrl': avatarFileName,
//           'bio': bioController.text,
//           'gender': genderController.text,
//           'dateOfBirth': dobController.text,
//           'address': addressController.text,
//           'phone': profile!.phone,
//           'facebook': profile!.facebook,
//           'instagram': profile!.instagram,
//           'website': profile!.website,
//           'location': profile!.location,
//         };

//         bool isUpdated = await ApiService.updateUserProfile(accountId, payload);

//         if (isUpdated) {
//           setState(() {
//             profile = UserProfile(
//               accountId: profile!.accountId,
//               account: profile!.account,
//               fullName: fullNameController.text,
//               avatarUrl: avatarFileName,
//               bio: bioController.text,
//               gender: genderController.text,
//               dateOfBirth: dobController.text,
//               address: addressController.text,
//               location: profile!.location,
//               phone: profile!.phone,
//               facebook: profile!.facebook,
//               instagram: profile!.instagram,
//               website: profile!.website,
//             );
//             selectedImage = null;
//           });

//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Profile updated successfully!')),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Failed to update profile.')),
//           );
//         }
//       } catch (e) {
//         print('Error saving profile: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to update profile.')),
//         );
//       }
//     }
//   }

//   void logout() {
//     Provider.of<AuthProvider>(context, listen: false).logout();
//     Navigator.pushReplacementNamed(context, '/home');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: logout,
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             GestureDetector(
//               onTap: pickImage,
//               // child: CircleAvatar(
//               //   radius: 60,
//               //   backgroundImage: selectedImage != null
//               //       ? FileImage(selectedImage!)
//               //       : (profile!.avatarUrl.isNotEmpty
//               //       ? NetworkImage(
//               //       'http://192.168.2.7:9999/images/accounts/${profile!.avatarUrl}')
//               //       : null),
//               //   child: profile!.avatarUrl.isEmpty && selectedImage == null
//               //       ? const Icon(Icons.add_a_photo, size: 40)
//               //       : null,
//               // ),
//             ),
//             const SizedBox(height: 20),
//             buildTextField('Full Name', fullNameController),
//             buildTextField('Bio', bioController),
//             buildTextField('Gender', genderController),
//             buildTextField('Date of Birth', dobController),
//             buildTextField('Address', addressController),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: saveProfile,
//               child: const Text('Save'),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   isPopupOpen = true;
//                 });
//               },
//               child: const Text('Detail'),
//             ),
//             if (isPopupOpen)
//               AlertDialog(
//                 title: const Text('Profile Detail'),
//                 content: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Phone: ${profile!.phone}'),
//                     Text('Location: ${profile!.location}'),
//                     Text('Facebook: ${profile!.facebook}'),
//                     Text('Instagram: ${profile!.instagram}'),
//                     Text('Website: ${profile!.website}'),
//                   ],
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () => setState(() => isPopupOpen = false),
//                     child: const Text('Close'),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildTextField(String label, TextEditingController controller) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//       ),
//     );
//   }
// }
