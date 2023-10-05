import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class add_products extends StatefulWidget {
  const add_products({super.key});

  @override
  State<add_products> createState() => _add_productsState();
}

class _add_productsState extends State<add_products>
    with SingleTickerProviderStateMixin {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  bool loading = false;
  File? _image;
  String? _title;
  List<File> images = [];
  final pickerimage = ImagePicker();
  dynamic _selectedOption;
  chooseImage() async {
    final pickedFile = await pickerimage.getImage(source: ImageSource.gallery);
    setState(() {
      images.add(File(pickedFile!.path));
    });
    if (pickedFile!.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await pickerimage.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        images.add(File(response.file!.path));
      });
    } else {
      print(response.file);
    }
  }
// import 'package:cloud_firestore/cloud_firestore.dart';

// Get the reference to the 'products' collection

  final TextEditingController pricecontroler = TextEditingController();

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');
  Future<void> _pickimage(ImageSource source) async {
    final pickedimage = await ImagePicker().getImage(source: source);
    if (pickedimage != null) {
      setState(() {
        _image = File(pickedimage.path);
      });
    }
  }

  Future<void> uploadingimage() async {
    if (_image == null || images.isEmpty) {
      return;
    }

    List fileNames = [];
    List download = [];

    try {
      setState(() {
        loading = true;
      });
      // _image = null;
      // images.clear();

      // Upload the main image file to Firebase Storage
      String filename = DateTime.now().millisecondsSinceEpoch.toString();
      await firebaseStorage.ref(filename).putFile(_image!);
      String downloadURLs =
          await firebaseStorage.ref(filename).getDownloadURL();

      // Upload the additional images to Firebase Storage
      for (int i = 0; i < images.length; i++) {
        String fileName =
            DateTime.now().millisecondsSinceEpoch.toString() + '_$i';
        await firebaseStorage.ref(fileName).putFile(images[i]);
        String downloadURL =
            await firebaseStorage.ref(fileName).getDownloadURL();
        fileNames.add(fileName);
        download.add(downloadURL);
      }

      final double? price = double.tryParse(pricecontroler.text);

      await FirebaseFirestore.instance.collection('products').add({
        'title': _title,
        'mainImageURL': download,
        'secondimage': fileNames,
        'imageURLs': downloadURLs,
        'imageNames': filename,
        'brand': _selectedOption,
        'price': price,
        'size': selectdata.toList()
      });

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.amber,
          content: Text('Successfully uploaded'),
        ),
      );
    } catch (error) {
      print(error);
      // Handle error
      // ...
    }
  }

  Future<void> delete(String documentId, String ref) async {
    // setState(() {
    //   isloding = true;
    // });
    // Delete the document from Firestore
    await FirebaseFirestore.instance
        .collection('products')
        .doc(documentId)
        .delete();

    // Delete the image from Firebase Storage
    await firebaseStorage.ref(ref).delete();

    // setState(() {
    //   isloding = false;
    // });
  }

  int curentindex = 0;
  List size = [
    {"size": "3"},
    {"size": "3.5"},
    {"size": "4"},
    {"size": "4.5"},
    {"size": "5"},
    {"size": "5.5"},
    {"size": "6"},
    {"size": "6.5"},
    {"size": "7"},
    {"size": "7.5"},
    {"size": "8"},
    {"size": "8.5"},
    {"size": "9"},
    {"size": "9.5"},
    {"size": "10"},
    {"size": "10.5"},
    {"size": "11"},
    {"size": "11.5"},
  ];

// secon stetp
  List selectdata = [];
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            'Add_products',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 3.h,
                ),
                Center(
                  child: Container(
                    height: 20.h,
                    width: 70.w,
                    child: loading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.amber,
                            ),
                          )
                        : _image != null
                            ? Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              )
                            : Center(
                                child: Text(
                                'Add_Image',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 247, 199, 39), width: 5),
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  'Choose Option',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color?>(Colors.green),
                        ),
                        onPressed: () {
                          _pickimage(ImageSource.camera);
                        },
                        icon: Icon(Icons.camera),
                        label: Text('Camera')),
                    ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color?>(Colors.amber),
                        ),
                        onPressed: () {
                          _pickimage(ImageSource.gallery);
                        },
                        icon: Icon(Icons.camera),
                        label: Text(
                          'gallery',
                        )),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  height: 7.h,
                  width: 80.w,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _title = value;
                      });
                    },
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber, width: 4),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber, width: 4),
                        ),
                        label: Text('Name',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        border: UnderlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Container(
                  height: 7.h,
                  width: 80.w,
                  child: TextField(
                    controller: pricecontroler,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber, width: 4),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber, width: 4),
                        ),
                        label: Text('Price',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        border: UnderlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  'Choose Brand',
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    PopupMenuButton(
                        onSelected: (String value) {
                          setState(() {
                            _selectedOption = value;
                          });
                        },
                        itemBuilder: (BuildContext context) => [
                              PopupMenuItem(
                                value: 'Sneakers',
                                child: Text(
                                  'Sneakers',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Nike',
                                child: Text(
                                  'Nike',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Addidas',
                                child: Text(
                                  'Addidas',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Relaxo',
                                child: Text(
                                  'Relaxo',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Paragon',
                                child: Text(
                                  'Paragon',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Lancer',
                                child: Text(
                                  'Lancer',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Abinitio',
                                child: Text(
                                  'Abinitio',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Sanlong',
                                child: Text(
                                  'Sanlong',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Tirumala',
                                child: Text(
                                  'Tirumala',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Hitz',
                                child: Text(
                                  'Hitz',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                        child: TextButton(
                          onPressed: null,
                          child: Text(
                            _selectedOption ?? 'add your brand',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  'Choose Color',
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 2.h,
                ),
                GridView.builder(
                  itemCount: images.length + 1,
                  shrinkWrap: true,
                  controller: ScrollController(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 1,
                      mainAxisExtent: 70,
                      crossAxisSpacing: 2),
                  itemBuilder: ((context, index) {
                    return index == 0
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              // height: 5.h,
                              // width: 20.w,
                              child: Center(
                                  child: IconButton(
                                      onPressed: () {
                                        chooseImage();
                                      },
                                      icon: Icon(Icons.add))),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.amber, width: 4),
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Container(
                                  height: 10.h,
                                  width: 20.w,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: FileImage(images[index - 1]),
                                          fit: BoxFit.cover),
                                      border: Border.all(
                                          color: Colors.amber, width: 4),
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                                Positioned(
                                    left: -9,
                                    top: -13,
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            images.removeAt(index - 1);
                                          });
                                        },
                                        icon: Icon(
                                            Icons.highlight_off_outlined))),
                              ],
                            ),
                          );
                  }),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  'Select Size',
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 2.h,
                ),
                GridView.builder(
                    shrinkWrap: true,
                    controller: ScrollController(),
                    itemCount: size.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6, mainAxisSpacing: 10),
                    itemBuilder: ((context, index) => InkWell(
                          onTap: () {
                            if (selectdata.contains(size[index]['size'])) {
                              selectdata.remove(size[index]['size']);
                            } else {
                              selectdata.add(size[index]['size']);
                            }
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                              height: 1.h,
                              width: 5.w,
                              child: Center(
                                  child: Text(
                                // size[index]['size'],
                                size[index]['size'],
                                style: Theme.of(context).textTheme.bodyLarge,
                              )),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(1, 2),
                                        blurRadius: 2,
                                        spreadRadius: 2)
                                  ],
                                  color:
                                      selectdata.contains(size[index]['size'])
                                          ? Colors.amber
                                          : Colors.white,
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ))),
                SizedBox(
                  height: 6.h,
                ),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color?>(
                          Color.fromARGB(255, 254, 146, 30)),
                    ),
                    onPressed: () {
                      uploadingimage();
                    },
                    child: Text('Upload Image'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
