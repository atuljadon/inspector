import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChecklistScreen extends StatefulWidget {
  @override
  _ChecklistScreenState createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  final List<Map<String, dynamic>> _checklistItems = [];

  void _addChecklistItem() {
    setState(() {
      _checklistItems.add({
        'title': '',
        'description': '',
        'checked': false,
        'mainImage': null,
        'checkboxImage': null,
      });
    });
  }

  void _toggleCheckbox(int index) {
    setState(() {
      _checklistItems[index]['checked'] = !_checklistItems[index]['checked'];
    });
  }

  Future<void> _pickImage(int index, String imageType) async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedFile;

    // Show dialog to choose between camera and gallery
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take a Photo'),
              onTap: () async {
                pickedFile = await picker.pickImage(source: ImageSource.camera);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_album),
              title: Text('Choose from Gallery'),
              onTap: () async {
                pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );

    if (pickedFile != null) {
      setState(() {
        if (imageType == 'main') {
          _checklistItems[index]['mainImage'] = File(pickedFile!.path);
        } else if (imageType == 'checkbox') {
          _checklistItems[index]['checkboxImage'] = File(pickedFile!.path);
        }
      });
    }
  }

  void _deleteChecklistItem(int index) {
    setState(() {
      _checklistItems.removeAt(index);
    });
  }

  void _editChecklistItem(int index, String field, String value) {
    setState(() {
      _checklistItems[index][field] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inspecor',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _checklistItems.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Checkbox with green tick when checked
                        Checkbox(
                          value: _checklistItems[index]['checked'],
                          onChanged: (bool? value) {
                            _toggleCheckbox(index);
                          },
                          activeColor: Colors.green,
                          checkColor: Colors.white,
                        ),
                        SizedBox(width: 8),
                        // Title Input Field
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              _editChecklistItem(index, 'title', value);
                            },
                            decoration: InputDecoration(
                              hintText: 'Title',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteChecklistItem(index),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    // Description Input Field
                    TextField(
                      onChanged: (value) {
                        _editChecklistItem(index, 'description', value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      maxLines: 2,
                    ),
                    SizedBox(height: 8),
                    // Main Image and Checkbox Image Upload
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text('Reference Image:'),
                            SizedBox(height: 4),
                            InkWell(
                              onTap: () => _pickImage(index, 'main'),
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                  image: _checklistItems[index]['mainImage'] !=
                                          null
                                      ? DecorationImage(
                                          image: FileImage(
                                              _checklistItems[index]
                                                  ['mainImage']),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child:
                                    _checklistItems[index]['mainImage'] == null
                                        ? Icon(Icons.add_a_photo,
                                            color: Colors.teal, size: 40)
                                        : null,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text('Inspected Image:'),
                            SizedBox(height: 4),
                            InkWell(
                              onTap: () => _pickImage(index, 'checkbox'),
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                  image: _checklistItems[index]
                                              ['checkboxImage'] !=
                                          null
                                      ? DecorationImage(
                                          image: FileImage(
                                              _checklistItems[index]
                                                  ['checkboxImage']),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: _checklistItems[index]
                                            ['checkboxImage'] ==
                                        null
                                    ? Icon(Icons.add_a_photo,
                                        color: Colors.teal, size: 40)
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addChecklistItem,
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
      ),
    );
  }
}
