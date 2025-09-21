import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_task/controller/user_controller.dart';
import 'package:flutter_task/local_repository.dart';
import 'package:flutter_task/model/appointment_card_model.dart';
import 'package:flutter_task/model/assesment_card_model.dart';
import 'package:flutter_task/view/all_appointments_screen.dart';
import 'package:flutter_task/view/all_assessments_screen.dart';
import 'package:flutter_task/view/assessment_tab.dart';
import 'package:flutter_task/view/book_appointment_page.dart';
import 'package:flutter_task/view/book_assessment_page.dart';
import 'package:flutter_task/view/login_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_task/services/firestore_service.dart';

class AssesmentsPage extends StatefulWidget {
  const AssesmentsPage({super.key});

  @override
  State<AssesmentsPage> createState() => _AssesmentsPageState();
}

class _AssesmentsPageState extends State<AssesmentsPage> {
  final FirestoreService _fs = FirestoreService();
  UserController userController = UserController();
  late List<AssesmentCardModel> assesments;

  @override
  void initState() {
    super.initState();
  }

  List<List<Color>> gradientColorList = [
    [Color.fromRGBO(227, 103, 49, 0.5), Color.fromRGBO(218, 190, 93, 0.5)],
    [Color.fromRGBO(105, 245, 187, 0.5), Color.fromRGBO(145, 182, 85, 0.5)],
  ];

  List<String> imageList = [
    "assets/image/girl_exe.png",
    "assets/image/boy_exe.png",
  ];

  Widget assessmentCard(
    AssesmentCardModel assesment,
    VoidCallback onFavouriteToggleButton,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AssessmentTab()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
            borderRadius: BorderRadius.circular(11),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.06),
                offset: Offset(2, 2),
                blurRadius: 21,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 116,
                width: 133,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(11),
                    bottomLeft: Radius.circular(11),
                  ),
                  gradient: LinearGradient(
                    colors: assesment.gradientColors,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Image.asset(assesment.imagePath, fit: BoxFit.cover),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        assesment.title,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(34, 46, 88, 1),
                        ),
                      ),

                      Text(
                        assesment.description,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(42, 42, 42, 1),
                        ),
                      ),

                      Row(
                        children: [
                          SvgPicture.asset("assets/svg/play_button.svg"),
                          SizedBox(width: 5),
                          Text(
                            "Start",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(37, 95, 213, 1),
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(
                              assesment.isFavourite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 20,
                              color:
                                  assesment.isFavourite
                                      ? Colors.red
                                      : Colors.grey,
                            ),
                            onPressed: onFavouriteToggleButton,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void logoutUser() async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Widget appointmentCard(AppointmentModel appointmentModel) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        height: 150,
        width: 120,
        decoration: BoxDecoration(
          color: appointmentModel.bgColor,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(appointmentModel.svgPath, height: 60, width: 60),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      appointmentModel.title,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(34, 46, 88, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            Container(
              height: 23,
              width: 23,
              padding: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color.fromRGBO(89, 89, 89, 1),
                  width: 2,
                ),
              ),
              child: Container(
                height: 19.94,
                width: 19.94,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9.8),
                  color: Color.fromRGBO(89, 89, 89, 1),
                ),
                child: SvgPicture.asset(
                  "assets/svg/user.svg",
                  height: 9,
                  width: 9,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                UserController().clearSharedPrefData;
                logoutUser();
              },
              icon: Icon(Icons.exit_to_app),
            ),
          ],
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              Text(
                "Hello ${userController.name}",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(37, 95, 213, 1),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                height: 47,

                decoration: BoxDecoration(
                  color: Color.fromRGBO(241, 241, 249, 1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 6,
                  ),
                  child: TabBar(
                    isScrollable: false,
                    labelStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: Color.fromRGBO(37, 95, 213, 1),
                    unselectedLabelColor: Color.fromRGBO(107, 107, 107, 1),
                    labelPadding: EdgeInsets.symmetric(horizontal: 0),
                    tabs: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Tab(text: "    My Assesments    "),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Tab(text: "    My Appointments    "),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: Container(
                margin: const EdgeInsets.all(18),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(246, 246, 251, 1),
                  borderRadius: BorderRadius.circular(21),
                ),
                child: TabBarView(
                  children: [
                    // Replace the first TabBarView child with:
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: _fs.userAssessmentsStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // ✅ Show cached data while waiting
                          return FutureBuilder(
                            future: LocalRepository.getAssessments(),
                            builder: (context, localSnapshot) {
                              if (localSnapshot.hasData &&
                                  localSnapshot.data!.isNotEmpty) {
                                return Column(
                                  children: [
                                    Expanded(
                                      child: ListView(
                                        children:
                                            localSnapshot.data!
                                                .map(
                                                  (a) =>
                                                      assessmentCard(a, () {}),
                                                )
                                                .toList(),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    _viewAllButton(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  AllAssessmentsScreen(),
                                        ),
                                      );
                                    }),
                                  ],
                                );
                              }
                              return Center(child: CircularProgressIndicator());
                            },
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          // ✅ If Firestore empty, try cache
                          return FutureBuilder(
                            future: LocalRepository.getAssessments(),
                            builder: (context, localSnapshot) {
                              if (localSnapshot.hasData &&
                                  localSnapshot.data!.isNotEmpty) {
                                return Column(
                                  children: [
                                    Expanded(
                                      child: ListView(
                                        children:
                                            localSnapshot.data!
                                                .map(
                                                  (a) =>
                                                      assessmentCard(a, () {}),
                                                )
                                                .toList(),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    _viewAllButton(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  AllAssessmentsScreen(),
                                        ),
                                      );
                                    }),
                                  ],
                                );
                              }
                              return Center(
                                child: Text('No assessments booked yet'),
                              );
                            },
                          );
                        }

                        // ✅ Firestore has data → save to cache
                        final docs = snapshot.data!.docs;
                        final assessments =
                            docs.map((doc) {
                              final map = doc.data();
                              return AssesmentCardModel.fromMap(doc.id, map);
                            }).toList();

                        LocalRepository.saveAssessments(assessments);

                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: assessments.length,
                                itemBuilder: (context, index) {
                                  final assessment = assessments[index];
                                  return FutureBuilder<bool>(
                                    future: userController.isFavourite(
                                      assessment.id,
                                    ),
                                    builder: (context, favSnapshot) {
                                      final isFav = favSnapshot.data ?? false;
                                      assessment.isFavourite = isFav;

                                      return assessmentCard(
                                        assessment,
                                        () async {
                                          await userController.toggleFavorite(
                                            assessment.id,
                                          );
                                          setState(() {});
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            _viewAllButton(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllAssessmentsScreen(),
                                ),
                              );
                            }),
                          ],
                        );
                      },
                    ),

                    // ------------------- Appointments -------------------
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: _fs.userAppointmentsStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // ✅ Show cached appointments while waiting
                          return FutureBuilder(
                            future: LocalRepository.getAppointments(),
                            builder: (context, localSnapshot) {
                              if (localSnapshot.hasData &&
                                  localSnapshot.data!.isNotEmpty) {
                                return Column(
                                  children: [
                                    Expanded(
                                      child: GridView.count(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 20,
                                        childAspectRatio: 1.1,
                                        children:
                                            localSnapshot.data!
                                                .map((a) => appointmentCard(a))
                                                .toList(),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    _viewAllButton(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  AllAppointmentsScreen(),
                                        ),
                                      );
                                    }),
                                  ],
                                );
                              }
                              return Center(child: CircularProgressIndicator());
                            },
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          // ✅ Fallback to cache if Firestore empty
                          return FutureBuilder(
                            future: LocalRepository.getAppointments(),
                            builder: (context, localSnapshot) {
                              if (localSnapshot.hasData &&
                                  localSnapshot.data!.isNotEmpty) {
                                return Column(
                                  children: [
                                    Expanded(
                                      child: GridView.count(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 20,
                                        childAspectRatio: 1.1,
                                        children:
                                            localSnapshot.data!
                                                .map((a) => appointmentCard(a))
                                                .toList(),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    _viewAllButton(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  AllAppointmentsScreen(),
                                        ),
                                      );
                                    }),
                                  ],
                                );
                              }
                              return Center(
                                child: Text('No appointments booked'),
                              );
                            },
                          );
                        }

                        // ✅ Firestore has data → save to cache
                        final docs = snapshot.data!.docs;
                        final appointments =
                            docs.map((doc) {
                              final map = doc.data();
                              return AppointmentModel.fromMap(doc.id, map);
                            }).toList();

                        LocalRepository.saveAppointments(appointments);

                        return Column(
                          children: [
                            Expanded(
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 20,
                                      crossAxisSpacing: 20,
                                      childAspectRatio: 1.1,
                                    ),
                                itemCount: appointments.length,
                                itemBuilder: (context, index) {
                                  final appointment = appointments[index];
                                  return GestureDetector(
                                    onTap: () {
                                      // show appointment details
                                    },
                                    child: appointmentCard(appointment),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            _viewAllButton(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllAppointmentsScreen(),
                                ),
                              );
                            }),
                          ],
                        );
                      },
                    ),

                    // ------------------- Helper small button -------------------
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Text(
                          "Challenges",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(48, 48, 48, 1),
                          ),
                        ),
                        Spacer(),
                        Text(
                          "View All",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(48, 48, 48, 1),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        SizedBox(width: 5),
                        SvgPicture.asset("assets/svg/right_arrow_flutter.svg"),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: 139,
                    width: 368,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(193, 234, 209, 1),
                      borderRadius: BorderRadius.circular(21),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Today's Challenge!",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(43, 122, 113, 1),
                                  ),
                                ),
                                SizedBox(height: 7),
                                Container(
                                  height: 18,
                                  width: 84,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(43, 122, 113, 1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Push Up 20x",
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 7),
                                SvgPicture.asset("assets/svg/progress_bar.svg"),
                                SizedBox(height: 7),
                                Text(
                                  "10/20 Complete",
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(50, 50, 50, 1),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Container(
                                  height: 27,
                                  width: 98,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 3,
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/svg/play_button.svg",
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            "Continue",
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(
                                                37,
                                                95,
                                                213,
                                                1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: ClipRRect(
                            child: Image.asset(
                              "assets/image/pushup_girl_updated.png",
                              height: 125,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Text(
                          "Workout Routines",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(48, 48, 48, 1),
                          ),
                        ),
                        Spacer(),
                        Text(
                          "View All",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(48, 48, 48, 1),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        SizedBox(width: 5),
                        SvgPicture.asset("assets/svg/right_arrow_flutter.svg"),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [workoutRoutineCard(), workoutRoutineCard()],
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.white,
              heroTag: "bookAppt",
              child: Icon(
                Icons.calendar_today,
                color: Color.fromRGBO(35, 47, 88, 1),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BookAppointmentPage()),
                );
              },
            ),
            SizedBox(height: 16),
            FloatingActionButton(
              backgroundColor: Colors.white,
              heroTag: "bookAssess",
              child: Icon(
                Icons.assignment,
                color: Color.fromRGBO(35, 47, 88, 1),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BookAssessmentPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _viewAllButton(VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(35, 47, 88, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        minimumSize: Size(60, 22),
      ),
      child: Text(
        "View all",
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
      ),
    );
  }
}

Widget workoutRoutineCard() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: 112,
      width: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 1, color: Color.fromRGBO(205, 205, 205, 1)),
      ),
      child: Row(
        children: [
          Container(
            height: 109,
            width: 109,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
              color: const Color.fromARGB(255, 255, 212, 147),
            ),
            child: Center(
              child: ClipRRect(
                child: Image.asset("assets/image/squat_girl.png"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sweat Starter",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(48, 48, 48, 1),
                  ),
                ),
                Text(
                  "Full Body",
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(102, 102, 102, 1),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  height: 21,
                  width: 66,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21),
                    border: Border.all(
                      width: 1,
                      color: Color.fromRGBO(205, 205, 205, 1),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Loose Weight",
                      style: GoogleFonts.poppins(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(37, 95, 213, 1),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Difficulty : ",
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(102, 102, 102, 1),
                        ),
                      ),
                      TextSpan(
                        text: "Medium",
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(250, 4, 4, 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
