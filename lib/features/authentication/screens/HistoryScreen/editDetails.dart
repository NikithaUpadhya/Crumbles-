
import 'package:crumbles/features/authentication/screens/HistoryScreen/history.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:crumbles/data/repositories/authencation/user_controller.dart';

class EditDetailScreen extends StatefulWidget {
  final String postId;

  EditDetailScreen({required this.postId});

  static const routeName = '/edit-detail';

  @override
  _EditDetailScreenState createState() => _EditDetailScreenState();
}

class _EditDetailScreenState extends State<EditDetailScreen> {
  final UserController userController = Get.find();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _pickupAddressController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final ValueNotifier<double> _foodQuantityNotifier = ValueNotifier(1.0);
  final ValueNotifier<TimeOfDay> _selectedTimeNotifier = ValueNotifier(TimeOfDay.now());
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadPostDetails();
  }

  Future<void> _loadPostDetails() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('posts').doc(widget.postId).get();
    if (snapshot.exists) {
      final post = snapshot.data() as Map<String, dynamic>;
      setState(() {
        _descriptionController.text = post['description'] ?? '';
        _pickupAddressController.text = post['address'] ?? '';
        _zipCodeController.text = post['zipCode'] ?? '';
        _foodQuantityNotifier.value = (post['foodQuantity'] ?? 1.0).toDouble();
        final timeParts = (post['cookingTime'] ?? '00:00').split(':');
        _selectedTimeNotifier.value = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
        _imageUrl = post['imageUrl'];
      });
    }
  }

  Future<void> _savePostDetails() async {
  try {
    await FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({
      'description': _descriptionController.text,
      'address': _pickupAddressController.text,
      'zipCode': _zipCodeController.text,
      'foodQuantity': _foodQuantityNotifier.value,
      'cookingTime': '${_selectedTimeNotifier.value.hour}:${_selectedTimeNotifier.value.minute}',
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post updated successfully')));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Your post has been updated successfully!'),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Get.to(()=> const HistoryPage()); // Return to the history page
              },
            ),
          ],
        );
      },
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating post: $e')));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _savePostDetails,
          ),
        ],
      ),
      body: _buildEditForm(),
    );
  }

  Widget _buildEditForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_imageUrl != null && _imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  _imageUrl!,
                  fit: BoxFit.cover,
                  height: 300,
                  width: double.infinity,
                ),
              ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _pickupAddressController,
              decoration: InputDecoration(
                labelText: 'Pickup Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _zipCodeController,
              decoration: InputDecoration(
                labelText: 'Zip Code',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Food Quantity', style: Theme.of(context).textTheme.headlineSmall),
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
                activeTrackColor: Colors.blue,
                inactiveTrackColor: Colors.blue[100],
                trackShape: RoundedRectSliderTrackShape(),
                trackHeight: 4.0,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                thumbColor: Colors.blue,
                overlayColor: Colors.blue.withAlpha(32),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                tickMarkShape: RoundSliderTickMarkShape(),
                activeTickMarkColor: Colors.blue,
                inactiveTickMarkColor: Colors.blue[100],
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
                Text('Cooking Time', style: Theme.of(context).textTheme.headlineSmall),
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
            Center(
              child: ElevatedButton(
                onPressed: _savePostDetails,
                child: Text('Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(280, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
