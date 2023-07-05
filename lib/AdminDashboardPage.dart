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

  Future<void> _updateProperty(Map<String, dynamic> property) async {
    await _databaseHelper.updateProperty(property);
    await _loadProperties();
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

  void _showPropertyDetails(Map<String, dynamic> property) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(property['property_type']),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (property['image'] != null && property['image'].isNotEmpty)
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(File(property['image'])),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                SizedBox(height: 16.0),
                Text(
                  'Building Area: ${property['building_area']}',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Surface Area: ${property['surface_area']}',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Price: \$${property['price']}',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Room: ${property['room']}',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Bathroom: ${property['bathroom']}',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Floor: ${property['floor']}',
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Edit Data'),
              onPressed: () {
                Navigator.of(context).pop();
                _editProperty(property);
              },
            ),
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editProperty(Map<String, dynamic> property) {
    final TextEditingController propertyTypeController =
        TextEditingController(text: property['property_type']);
    final TextEditingController buildingAreaController =
        TextEditingController(text: property['building_area'].toString());
    final TextEditingController surfaceAreaController =
        TextEditingController(text: property['surface_area'].toString());
    final TextEditingController priceController =
        TextEditingController(text: property['price'].toString());
    final TextEditingController roomController =
        TextEditingController(text: property['room'].toString());
    final TextEditingController bathroomController =
        TextEditingController(text: property['bathroom'].toString());
    final TextEditingController floorController =
        TextEditingController(text: property['floor'].toString());

    File? imageFile;
    final ImagePicker _picker = ImagePicker();

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
          title: Text('Edit Property'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                if (property['image'] != null && property['image'].isNotEmpty)
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(File(property['image'])),
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
                final Map<String, dynamic> updatedProperty = {
                  'id': property['id'],
                  'property_type': propertyTypeController.text,
                  'building_area': double.parse(buildingAreaController.text),
                  'surface_area': double.parse(surfaceAreaController.text),
                  'price': double.parse(priceController.text),
                  'room': int.parse(roomController.text),
                  'bathroom': int.parse(bathroomController.text),
                  'floor': int.parse(floorController.text),
                  'image':
                      imageFile != null ? imageFile!.path : property['image'],
                };
                await _updateProperty(updatedProperty);
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
              _showPropertyDetails(property);
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
