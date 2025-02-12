import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crumbles/common/appbar/appbar.dart';
import 'package:crumbles/navigation_menu.dart';
import 'package:crumbles/utils/constants/colors.dart';
import 'package:crumbles/utils/constants/image_strings.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:crumbles/data/repositories/authencation/user_controller.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final ValueNotifier<double> _foodQuantityNotifier = ValueNotifier(1.0);
  final ValueNotifier<TimeOfDay> _selectedTimeNotifier = ValueNotifier(TimeOfDay.now());
  final ValueNotifier<bool> _useCurrentLocationNotifier = ValueNotifier(false);
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _pickupAddressController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  final UserController userController = Get.find();
  List<dynamic> _locationSuggestions = [];

  @override
  void initState() {
    super.initState();
    ensureUserAuthenticated(); // Ensure user is authenticated
  }

  Future<void> ensureUserAuthenticated() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // If the user is not signed in, sign in anonymously
      await FirebaseAuth.instance.signInAnonymously();
    }
  }

  Future<void> _selectTime(BuildContext context, ValueNotifier<TimeOfDay> timeNotifier) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: timeNotifier.value,
    );
    if (picked != null && picked != timeNotifier.value) {
      timeNotifier.value = picked;
    }
  }

  Future<void> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied, we cannot request permissions.';
      }

      Position position = await Geolocator.getCurrentPosition();
      print('Current position: ${position.latitude}, ${position.longitude}');

      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _pickupAddressController.text = "${place.street}, ${place.locality}, ${place.country}";
          _zipCodeController.text = place.postalCode ?? '';
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      _analyzeImage(_selectedImage!);
    }
  }


  Future<void> _analyzeImage(File image) async {
  String apiKey = "5TnNVeccWJjAf4thrkas";
  String apiUrl = "https://detect.roboflow.com/mold-detection-lmjjt/1?api_key=5TnNVeccWJjAf4thrkas";

  _showLoader(context);

  var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
  request.files.add(await http.MultipartFile.fromPath('file', image.path));

  var response = await request.send();

  _hideLoader(context);

  if (response.statusCode == 200) {
    var responseData = await response.stream.bytesToString();
    var resultData = jsonDecode(responseData);
    _showAnalysisResultDialog(resultData);
  } else {
    print('Error: ${response.statusCode}');
  }
}


  void _showLoader(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8, // Adjust the width to fit the screen
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  "Analysing Food Item Quality...",
                  style: TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis, // Ensure text doesn't overflow
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _hideLoader(BuildContext context) {
  Navigator.of(context).pop();
}


  

 

  void _showAnalysisResultDialog(Map<String, dynamic> resultData) {
    String resultMessage = "All Good: No signs of spoilage detected 👍";
    if (resultData['predictions'] != null && resultData['predictions'].isNotEmpty) {
      resultMessage = "Spoilage detected: ${resultData['predictions'][0]['class']}";
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
      
        return Theme(
          data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
          child: AlertDialog(
            title: Text('Food Analysis Result'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _selectedImage != null
                    ? Image.file(_selectedImage!, height: 100, width: 100, fit: BoxFit.cover)
                    : Container(),
                SizedBox(height: 10),
                Text(resultMessage),
                SizedBox(height: 10),
                Text(
                  'Please check the food condition before uploading the item to ensure the health and safety of the people at the NGO, as any suspected spoilage could impact their well-being.',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 10),
                Text(
                  'Disclaimer: Analysis result might not be 100% accurate, please interpret the result cautiously.',
                  style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String> _uploadImage(File image) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference = FirebaseStorage.instance.ref().child('images/$fileName');
      UploadTask uploadTask = storageReference.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  Future<void> _uploadData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      String imageUrl = _selectedImage != null ? await _uploadImage(_selectedImage!) : '';
      String description = _descriptionController.text;
      double foodQuantity = _foodQuantityNotifier.value;
      String cookingTime = DateFormat('h:mm a').format(
        DateTime(0, 0, 0, _selectedTimeNotifier.value.hour, _selectedTimeNotifier.value.minute)
      );
      String address = _pickupAddressController.text;
      String zipCode = _zipCodeController.text;

      CollectionReference posts = FirebaseFirestore.instance.collection('posts');
      await posts.add({
        'description': description,
        'foodQuantity': foodQuantity,
        'cookingTime': cookingTime,
        'address': address,
        'zipCode': zipCode,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': user.uid,
        'isNew': true,
        'status': 'New',
        'username': userController.user.value.username, // Add username
      });

      _showPostConfirmationDialog(context);
    } catch (e) {
      print('Error uploading data: $e');
    }
  }

  void _showPostConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Your food has been posted!'),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => NavigationMenu()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  Future<void> autoCompleteSearch(String value) async {
    final response = await http.get(Uri.parse('https://nominatim.openstreetmap.org/search?q=$value&countrycodes=my&format=json'));
    if (response.statusCode == 200) {
      setState(() {
        _locationSuggestions = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Create New Post'),
        actions: [
          TextButton(
            onPressed: _uploadData,
            child: Text('Post'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final user = userController.user.value;
                return Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: user.profilePicture.isNotEmpty
                          ? NetworkImage(user.profilePicture)
                          : AssetImage(TImages.user) as ImageProvider, // Replace with actual image
                    ),
                    SizedBox(width: 10),
                    Text(user.fullName), // Display user's full name
                  ],
                );
              }),
              SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'INPUT FOOD DESCRIPTION',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Food quantity', style: Theme.of(context).textTheme.headlineSmall,),
                  ValueListenableBuilder<double>(
                    valueListenable: _foodQuantityNotifier,
                    builder: (context, value, child) {
                      return Text('${value.round()} person');
                    },
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: TColors.primary,
                  inactiveTrackColor: Colors.purple[100],
                  trackShape: RoundedRectSliderTrackShape(),
                  trackHeight: 4.0,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  thumbColor: TColors.primary,
                  overlayColor: TColors.primary.withAlpha(32),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                  tickMarkShape: RoundSliderTickMarkShape(),
                  activeTickMarkColor: TColors.primary,
                  inactiveTickMarkColor: Colors.purple[100],
                ),
                child: ValueListenableBuilder<double>(
                  valueListenable: _foodQuantityNotifier,
                  builder: (context, value, child) {
                    final adjustedValue = value.clamp(1.0, 500.0);
                    if (value != adjustedValue) {
                      _foodQuantityNotifier.value = adjustedValue;
                    }
                    return Slider(
                      value: adjustedValue,
                      min: 1,
                      max: 500,
                      divisions: 499,
                      label: '${adjustedValue.round()} person',
                      onChanged: (newValue) {
                        _foodQuantityNotifier.value = newValue;
                      },
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Cooking time', style: Theme.of(context).textTheme.headlineSmall,),
                  TextButton(
                    onPressed: () => _selectTime(context, _selectedTimeNotifier),
                    child: Text('Select'),
                  ),
                ],
              ),
              ValueListenableBuilder<TimeOfDay>(
                valueListenable: _selectedTimeNotifier,
                builder: (context, value, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.timer),
                      Text(DateFormat('h:mm a').format(
                        DateTime(0, 0, 0, value.hour, value.minute))),
                    ],
                  );
                },
              ),
              SizedBox(height: 20),
              Text('Address', style: Theme.of(context).textTheme.headlineSmall,),
              ValueListenableBuilder<bool>(
                valueListenable: _useCurrentLocationNotifier,
                builder: (context, value, child) {
                  return CheckboxListTile(
                    title: Text('Use my current location'),
                    value: value,
                    onChanged: (newValue) async {
                      _useCurrentLocationNotifier.value = newValue!;
                      if (newValue) {
                        await _determinePosition();
                      }
                    },
                  );
                },
              ),
              TextField(
                controller: _pickupAddressController,
                decoration: InputDecoration(
                  labelText: 'Pickup Address',
                  hintText: 'Enter your food pickup address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                onChanged: (value) {
                  if (!_useCurrentLocationNotifier.value) {
                    autoCompleteSearch(value);
                  }
                },
              ),
              if (_locationSuggestions.isNotEmpty)
                Container(
                  height: 200,
                  child: ListView.builder(
                    itemCount: _locationSuggestions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.location_on),
                        title: Text(_locationSuggestions[index]['display_name'] ?? ''),
                        onTap: () {
                          setState(() {
                            _pickupAddressController.text = _locationSuggestions[index]['display_name'] ?? '';
                            _locationSuggestions = [];
                          });
                        },
                      );
                    },
                  ),
                ),
              SizedBox(height: 10),
              TextField(
                controller: _zipCodeController,
                decoration: InputDecoration(
                  labelText: 'Zip code',
                  hintText: 'Enter food pickup area code',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text('Add Image', style: Theme.of(context).textTheme.headlineSmall,),
              SizedBox(height: 20),
              _selectedImage != null
                  ? Stack(
                      children: [
                        Image.file(
                          _selectedImage!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.white),
                            onPressed: _removeImage,
                          ),
                        ),
                      ],
                    )
                  : GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, color: Colors.grey, size: 40),
                            Text('Add Image', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _uploadData, 
                  child: Text('Post'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                    minimumSize: Size(280, 50), 
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
