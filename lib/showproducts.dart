import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class show_products extends StatefulWidget {
  const show_products({super.key});

  @override
  State<show_products> createState() => _show_productsState();
}

class _show_productsState extends State<show_products> {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _brandcontroler = TextEditingController();

  String? _selectedOption;
  bool isloding = false;
  Future loadimage() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('products').get();
    return snapshot.docs;
  }

  Future<void> delete(String documentId, String ref) async {
    setState(() {
      isloding = true;
    });
    // Delete the document from Firestore
    await FirebaseFirestore.instance
        .collection('products')
        .doc(documentId)
        .delete();

    // Delete the image from Firebase Storage
    await firebaseStorage.ref(ref).delete();

    setState(() {
      isloding = false;
    });
  }

  Future<void> editTitle(
      String documentId, String newTitle, double price, String brands) async {
    setState(() {
      isloding = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(documentId)
          .update({'title': newTitle, 'price': price, 'brand': brands});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.amber,
          content: Text('Title updated successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Title updated $e')));
    }
    setState(() {
      isloding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: ((context, orientation, deviceType) {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              'DashBord',
              style: TextStyle(color: Colors.black),
            ),
            titleSpacing: 2,
            centerTitle: true,
          ),
          body: FutureBuilder(
              future: loadimage(),
              builder: ((context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.amber,
                    ),
                  );
                }

                return ListView.builder(
                    controller: ScrollController(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ExpansionTile(
                          collapsedBackgroundColor: Colors.amber,
                          shape: Border.all(),
                          leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  snapshot.data[index]['imageURLs'])),
                          title: Text(
                            snapshot.data[index]['title'] ?? 'Not Found',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 17.h,
                                  width: 40.w,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(snapshot
                                              .data[index]['imageURLs']),
                                          fit: BoxFit.cover),
                                      border: Border.all(
                                          color: Colors.amber, width: 4),
                                      borderRadius: BorderRadius.circular(16)),
                                ),
                                Container(
                                  width: 90.w,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Text(
                                        'Title',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextFormField(
                                        controller: _titleController,
                                        decoration: InputDecoration(
                                            hintText: snapshot.data[index]
                                                ['title'],
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.amber,
                                                  width: 4),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.amber,
                                                  width: 4),
                                            )),
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Text(
                                        'Price',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextFormField(
                                        controller: _priceController,
                                        decoration: InputDecoration(
                                            hintText: snapshot.data[index]
                                                    ['price']
                                                .toString(),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.amber,
                                                  width: 4),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.amber,
                                                  width: 4),
                                            )),
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Text(
                                        'Brand',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextFormField(
                                        controller: _brandcontroler,
                                        decoration: InputDecoration(
                                            hintText: snapshot.data[index]
                                                    ['brand']
                                                .toString(),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.amber,
                                                  width: 4),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.amber,
                                                  width: 4),
                                            )),
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Text(
                                        'Choose Color',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Row(
                                          children: List.generate(
                                              snapshot
                                                  .data[index]['mainImageURL']
                                                  .length,
                                              (index2) => Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0),
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          height: 7.h,
                                                          width: 18.w,
                                                          decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: NetworkImage(snapshot
                                                                              .data[index]
                                                                          ['mainImageURL']
                                                                      [index2]),
                                                                  fit: BoxFit
                                                                      .cover),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .amber,
                                                                  width: 4),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15)),
                                                        ),
                                                        Positioned(
                                                          left: 0,
                                                          top: -10,
                                                          right: 90,
                                                          bottom: 300,
                                                          child: IconButton(
                                                              onPressed:
                                                                  () async {
                                                                await delete(
                                                                  snapshot.data[
                                                                          index]
                                                                      ['size'],
                                                                  snapshot.data[
                                                                              index]
                                                                          [
                                                                          'secondimage']
                                                                      [index2],
                                                                );
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(SnackBar(
                                                                        backgroundColor:
                                                                            Colors
                                                                                .amber,
                                                                        content:
                                                                            Text('Image delete succefull')));
                                                              },
                                                              icon: Icon(
                                                                Icons
                                                                    .highlight_remove_outlined,
                                                                size: 20,
                                                                color:
                                                                    Colors.red,
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ))),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Text(
                                        'Select Size',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      GridView.builder(
                                          shrinkWrap: true,
                                          controller: ScrollController(),
                                          itemCount: snapshot
                                              .data[index]['size'].length,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 6,
                                                  mainAxisSpacing: 10),
                                          itemBuilder: ((context, index3) =>
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                child: Container(
                                                  height: 1.h,
                                                  width: 5.w,
                                                  child: Center(
                                                      child: Text(
                                                    snapshot.data[index]['size']
                                                        [index3],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                  )),
                                                  decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.grey,
                                                            offset:
                                                                Offset(1, 2),
                                                            blurRadius: 2,
                                                            spreadRadius: 2)
                                                      ],
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14)),
                                                ),
                                              ))),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          isloding
                                              ? CircularProgressIndicator(
                                                  color: Colors.red,
                                                )
                                              : ElevatedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color?>(
                                                                Colors.green),
                                                  ),
                                                  onPressed: () {
                                                    final double? pricee =
                                                        double.tryParse(
                                                            _priceController
                                                                .text);
                                                    if (pricee != null) {
                                                      editTitle(
                                                          snapshot
                                                              .data[index].id,
                                                          _titleController.text,
                                                          pricee,
                                                          _brandcontroler.text);
                                                    }
                                                    _titleController.clear();
                                                    _priceController.clear();
                                                    _brandcontroler.clear();
                                                  },
                                                  child: Text('Update')),
                                          isloding
                                              ? CircularProgressIndicator(
                                                  color: Colors.red,
                                                )
                                              : ElevatedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color?>(
                                                                Colors.red),
                                                  ),
                                                  onPressed: () async {
                                                    await delete(
                                                      snapshot.data[index].id,
                                                      snapshot.data[index]
                                                          ['imageNames'],
                                                    );
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            backgroundColor:
                                                                Colors.amber,
                                                            content: Text(
                                                                'Image delete succefull')));
                                                  },
                                                  child: Text('Delete')),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    }));
              })));
    }));
  }
}
