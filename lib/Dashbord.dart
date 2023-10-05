import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pannel/addproducts.dart';
import 'package:pannel/showproducts.dart';
import 'package:sizer/sizer.dart';

class Dashbord extends StatefulWidget {
  const Dashbord({super.key});

  @override
  State<Dashbord> createState() => _DashbordState();
}

class _DashbordState extends State<Dashbord> {
  List<dynamic> data = [
    {"title": "Add Products", "image": "assets/dashborditems (2).png"},
    {"title": "Show Products", "image": "assets/dashborditems (3).png"},
    {"title": "Notifcations", "image": "assets/dashborditems (4).png"},
    {"title": "User", "image": "assets/dashborditems (5).png"},
    {"title": "Setting", "image": "assets/dashborditems (6).png"},
    {"title": "History", "image": "assets/dashborditems (1).png"},
  ];
  List pages = [
    add_products(),
    show_products(),
    Notifcations(),
    user(),
    setting(),
    history()
  ];
  /////////////
  int totalitemslength = 0;
  Future loadimage() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('products').get();
    setState(() {
      totalitemslength = snapshot.docs.length;
    });
  }

  CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');

// Retrieve the documents from the collection
  int datacollect = 0;
  Future dataollect() async {
    QuerySnapshot snapshot = await productsCollection.get();
    int productCount = snapshot.docs.length;
    setState(() {
      datacollect = productCount;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataollect();
  }
// Get the length of the documents

// Print the product count
// print('Number of products: $productCount');
  /////////////
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
        body: Column(
          children: [
            SizedBox(
              height: 9.h,
            ),
            SizedBox(
              height: 65.h,
              child: GridView.builder(
                  itemCount: data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 160,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: ((context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              pages[index];
                            });
                            Get.to(pages[index]);
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    data[index]['image'],
                                    width: 15.w,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    data[index]['title'],
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 69, 68, 68),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    index == 0
                                        ? datacollect.toString()
                                        : 0.toString(),
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 170, 51),
                                        fontSize: 25.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(1, 2),
                                      spreadRadius: 2,
                                      blurRadius: 3,
                                      blurStyle: BlurStyle.inner)
                                ],
                                color: Color.fromARGB(255, 217, 213, 213),
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ))),
            )
          ],
        ),
      );
    }));
  }
}

class Notifcations extends StatelessWidget {
  const Notifcations({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class user extends StatefulWidget {
  const user({super.key});

  @override
  State<user> createState() => _userState();
}

class _userState extends State<user> {
  void updateUserCount() async {
    DocumentReference userCountRef =
        FirebaseFirestore.instance.doc('admin/user_count');

    try {
      await userCountRef.set({
        'count': FieldValue.increment(1),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error updating user count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class setting extends StatelessWidget {
  const setting({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class history extends StatelessWidget {
  const history({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.doc('admin/user_count').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.exists) {
            int userCount = snapshot.data!.get('count') ?? 0;

            return Center(
              child: Text(
                'Total Users: $userCount',
                style: TextStyle(fontSize: 24),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error loading user count');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
