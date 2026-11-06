import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../models/item_model.dart';
import 'dart:math';

class AddItemsScreen extends StatefulWidget {
  @override
  _AddItemsScreenState createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends State<AddItemsScreen> {
  final List<ChoiceItem> _items = [];
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة عناصر'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context, _items);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // إدخال النص
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'أدخل نص العنصر...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.text_fields),
                    ),
                    onSubmitted: (_) => _addTextItem(),
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  mini: true,
                  onPressed: _addTextItem,
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ),

          // طرق إضافة الصور
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickImageFromGallery,
                    icon: Icon(Icons.photo_library),
                    label: Text('من المعرض'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickImageFromCamera,
                    icon: Icon(Icons.camera_alt),
                    label: Text('من الكاميرا'),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8),

          // رفع ملفات
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: _pickMultipleFiles,
              icon: Icon(Icons.attach_file),
              label: Text('رفع ملفات متعددة'),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ),

          SizedBox(height: 16),

          // قائمة العناصر
          Expanded(
            child: _items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox,
                          size: 100,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'لا توجد عناصر',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return Dismissible(
                        key: Key(item.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          setState(() {
                            _items.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('تم حذف العنصر'),
                              action: SnackBarAction(
                                label: 'تراجع',
                                onPressed: () {
                                  setState(() {
                                    _items.insert(index, item);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: ListTile(
                            leading: item.imagePath != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(item.imagePath!),
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : CircleAvatar(
                                    child: Text(
                                      item.text[0].toUpperCase(),
                                    ),
                                  ),
                            title: Text(item.text),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _items.removeAt(index);
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _addTextItem() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _items.add(ChoiceItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: _textController.text,
          createdAt: DateTime.now(),
        ));
        _textController.clear();
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _items.add(ChoiceItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: 'صورة ${_items.length + 1}',
            imagePath: image.path,
            createdAt: DateTime.now(),
          ));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ في تحميل الصورة')),
      );
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _items.add(ChoiceItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: 'صورة ${_items.length + 1}',
            imagePath: image.path,
            createdAt: DateTime.now(),
          ));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ في التقاط الصورة')),
      );
    }
  }

  Future<void> _pickMultipleFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.image,
      );

      if (result != null) {
        setState(() {
          for (var file in result.files) {
            _items.add(ChoiceItem(
              id: DateTime.now().millisecondsSinceEpoch.toString() + file.name,
              text: file.name,
              imagePath: file.path,
              createdAt: DateTime.now(),
            ));
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم إضافة ${result.files.length} ملفات'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ في رفع الملفات')),
      );
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}