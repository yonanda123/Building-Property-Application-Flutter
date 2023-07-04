import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_helper.dart';

class AdminDashboardPage extends StatefulWidget {
  final String username;

  AdminDashboardPage({required this.username});
  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> properties = [];

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    final List<Map<String, dynamic>> propertyList =
        await _databaseHelper.getProperties();
    setState(() {
      properties = propertyList;
    });
  }

  Future<void> _addProperty(Map<String, dynamic> property) async {
    await _databaseHelper.insertProperty(property);
    await _loadProperties();
  }

  Future<void> _updateProperty(int id) async {
    // TODO: Implement update property logic
  }

  Future<void> _deleteProperty(int id) async {
    await _databaseHelper.deleteProperty(id);
    await _loadProperties();
  }

  Future<void> _showAlert() async {
    final TextEditingController propertyTypeController =
        TextEditingController();
    final TextEditingController buildingAreaController =
        TextEditingController();
    final TextEditingController surfaceAreaController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController roomController = TextEditingController();
    final TextEditingController bathroomController = TextEditingController();
    final TextEditingController floorController = TextEditingController();

    final ImagePicker _picker = ImagePicker();
    File? imageFile;

    Future<void> _getImage() async {
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        imageFile = pickedImage != null ? File(pickedImage.path) : null;
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Property'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                if (imageFile != null)
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(imageFile!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ElevatedButton(
                  child: Text('Choose Image'),
                  onPressed: _getImage,
                ),
                TextField(
                  controller: propertyTypeController,
                  decoration: InputDecoration(labelText: 'Property Type'),
                ),
                TextField(
                  controller: buildingAreaController,
                  decoration: InputDecoration(labelText: 'Building Area'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: surfaceAreaController,
                  decoration: InputDecoration(labelText: 'Surface Area'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: roomController,
                  decoration: InputDecoration(labelText: 'Room'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: bathroomController,
                  decoration: InputDecoration(labelText: 'Bathroom'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: floorController,
                  decoration: InputDecoration(labelText: 'Floor'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                final Map<String, dynamic> newProperty = {
                  'property_type': propertyTypeController.text,
                  'building_area': double.parse(buildingAreaController.text),
                  'surface_area': double.parse(surfaceAreaController.text),
                  'price': double.parse(priceController.text),
                  'room': int.parse(roomController.text),
                  'bathroom': int.parse(bathroomController.text),
                  'floor': int.parse(floorController.text),
                  'image': imageFile != null ? imageFile!.path : '',
                };
                await _addProperty(newProperty);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: ListView.builder(
        itemCount: properties.length,
        itemBuilder: (BuildContext context, int index) {
          final property = properties[index];
          return ListTile(
            leading: Image.file(File(property['image'])),
            title: Text(property['property_type']),
            subtitle: Text('Price: \$${property['price']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteProperty(property['id']);
              },
            ),
            onTap: () {
              _updateProperty(property['id']);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _showAlert,
      ),
    );
  }
}
