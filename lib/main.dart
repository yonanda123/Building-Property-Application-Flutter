import 'package:flutter/material.dart';

class NestedDropdown extends StatefulWidget {
  @override
  _NestedDropdownState createState() => _NestedDropdownState();
}

class _NestedDropdownState extends State<NestedDropdown> {
  String? _selectedItem1;
  String? _selectedItem2;
  String? _selectedItem3;

  List<String> _listItem1 = [
    'Blok A',
    'Blok B',
    'Blok C',
  ];

  Map<String, List<String>> _listItem2 = {
    'Blok A': ['21', '36', '45'],
    'Blok B': ['54', '60', '70'],
    'Blok C': ['90', '120', '140'],
  };

  Map<String, List<String>> _listItem3 = {
    '21': ['30 m²', '35 m²', '60 m²'],
    '36': ['60 m²', '72 m²', '90 m²'],
    '45': ['60 m²', '70 m²', '90 m²'],
    '54': ['90 m²', '120 m²'],
    '60': ['90 m²', '72 m²', '100 m²'],
    '70': ['100 m²', '150 m²', '200 m²'],
    '90': ['120 m²', '150 m²'],
    '120': ['120 m²', '150 m²'],
    '140': ['120 m²'],
  };

  bool get isDropdownFilled =>
      _selectedItem1 != null &&
      _selectedItem2 != null &&
      _selectedItem3 != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Building Properties'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Location', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8.0),
              DropdownButton<String>(
                value: _selectedItem1,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedItem1 = newValue;
                    _selectedItem2 = null;
                    _selectedItem3 = null;
                  });
                },
                isExpanded: true,
                items: _listItem1.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0),
              if (_selectedItem1 != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Property Type', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8.0),
                    DropdownButton<String>(
                      value: _selectedItem2,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedItem2 = newValue;
                          _selectedItem3 = null;
                        });
                      },
                      isExpanded: true,
                      items: _listItem2[_selectedItem1!]?.map((String subitem) {
                            return DropdownMenuItem<String>(
                              value: subitem,
                              child: Text(subitem),
                            );
                          }).toList() ??
                          [],
                    ),
                    SizedBox(height: 16.0),
                    if (_selectedItem2 != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Surface Area', style: TextStyle(fontSize: 16)),
                          SizedBox(height: 8.0),
                          DropdownButton<String>(
                            value: _selectedItem3,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedItem3 = newValue;
                              });
                            },
                            isExpanded: true,
                            items: _listItem3[_selectedItem2!]
                                    ?.map((String option) {
                                  return DropdownMenuItem<String>(
                                    value: option,
                                    child: Text(option),
                                  );
                                }).toList() ??
                                [],
                          ),
                        ],
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: isDropdownFilled
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => MyAlertDialog(
                    selectedItem1: _selectedItem1,
                    selectedItem2: _selectedItem2,
                    selectedItem3: _selectedItem3,
                  ),
                );
              },
              child: Icon(Icons.add),
            )
          : FloatingActionButton(
              onPressed: null,
              child: Icon(Icons.add),
              backgroundColor: Colors.grey,
            ),
    );
  }
}

class MyAlertDialog extends StatelessWidget {
  final String? selectedItem1;
  final String? selectedItem2;
  final String? selectedItem3;

  const MyAlertDialog({
    required this.selectedItem1,
    required this.selectedItem2,
    required this.selectedItem3,
  });

  Map<String, dynamic> getBuildingOptions() {
    String price = '';
    String rooms = '';
    String bathroom = '';
    String floor = '';
    String image = '';

    if (selectedItem2 == '21') {
      price = 'Rp. 320.000.000';
      rooms = '2 Kamar';
      bathroom = '1 Kamar Mandi';
      floor = '1 lantai';
      image = 'assets/images/type21.png';
    } else if (selectedItem2 == '36') {
      price = 'Rp. 450.000.000';
      rooms = '3 Kamar';
      bathroom = '1 Kamar Mandi';
      floor = '1 lantai';
      image = 'assets/images/type36.jpg';
    } else if (selectedItem2 == '45') {
      price = 'Rp. 450.000.000';
      rooms = '3 Kamar';
    }

    return {
      'price': price,
      'rooms': rooms,
      'bathroom': bathroom,
      'floor': floor,
      'image': image,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
        ),
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Building Properties',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Image.asset(
                '${getBuildingOptions()['image'] != null ? getBuildingOptions()['image'] : 'assets/images/notAvailable.jpg'}',
                fit: BoxFit.fill,
                alignment: Alignment.topCenter,
              ),
              SizedBox(height: 16.0),
              Text(
                'Location:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(selectedItem1 ?? ''),
              SizedBox(height: 8.0),
              Text(
                'Property Type:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Type ${selectedItem2 != null ? selectedItem2 : ''}'),
              SizedBox(height: 8.0),
              Text(
                'Building Area:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('${selectedItem2 != null ? selectedItem2 : ''} m²'),
              SizedBox(height: 8.0),
              Text(
                'Surface Area:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(selectedItem3 ?? ''),
              SizedBox(height: 16.0),
              Text(
                'Details:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                  'Price: ${getBuildingOptions()['price'] != null ? getBuildingOptions()['price'] : ''}'),
              Text(
                  'Rooms: ${getBuildingOptions()['rooms'] != null ? getBuildingOptions()['rooms'] : ''}'),
              Text(
                  'Bathroom: ${getBuildingOptions()['bathroom'] != null ? getBuildingOptions()['bathroom'] : ''}'),
              Text(
                  'Floor: ${getBuildingOptions()['floor'] != null ? getBuildingOptions()['floor'] : ''}'),
              SizedBox(height: 16.0),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Building Properties',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.blue),
    home: NestedDropdown(),
  ));
}
