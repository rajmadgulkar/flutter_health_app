import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AssessmentTab extends StatefulWidget {
  const AssessmentTab({super.key});

  @override
  State<AssessmentTab> createState() => _AssessmentTabState();
}

class _AssessmentTabState extends State<AssessmentTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Color.fromRGBO(232, 233, 237, 1)),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 322,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(105, 245, 187, 0.5),
                        Color.fromRGBO(145, 182, 85, 0.5),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 62, left: 35),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: SvgPicture.asset(
                                "assets/svg/arrow_back.svg",
                                height: 17,
                                width: 17,
                              ),
                            ),
                            SizedBox(height: 40),
                            Text(
                              "Health Risk\nAssessment",
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(34, 46, 88, 1),
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              height: 20,
                              width: 62,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset("assets/svg/timer.svg"),
                                    SizedBox(width: 5),
                                    Text(
                                      "4 min",
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromRGBO(34, 46, 88, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ClipRRect(
                        child: Image.asset(
                          "assets/image/men.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 265,
              child: Container(
                height: MediaQuery.of(context).size.height - 265,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "What do you get ?",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Color.fromRGBO(34, 46, 88, 1),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 68.91,
                                  width: 68.91,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 1.5,
                                      color: Color.fromRGBO(232, 233, 237, 1),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: SvgPicture.asset(
                                      "assets/svg/heart_symb.svg",
                                    ),
                                  ),
                                ),
                                Text(
                                  "Key Body",
                                  style: GoogleFonts.poppins(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(48, 48, 48, 1),
                                  ),
                                ),
                                Text(
                                  "Vitals",
                                  style: GoogleFonts.poppins(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(48, 48, 48, 1),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 27.8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 68.91,
                                  width: 68.91,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 1.5,
                                      color: Color.fromRGBO(232, 233, 237, 1),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: SvgPicture.asset(
                                      "assets/svg/body_pos.svg",
                                    ),
                                  ),
                                ),
                                Text(
                                  "Posture",
                                  style: GoogleFonts.poppins(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(48, 48, 48, 1),
                                  ),
                                ),
                                Text(
                                  "Analysis",
                                  style: GoogleFonts.poppins(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(48, 48, 48, 1),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 27.8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 68.91,
                                  width: 68.91,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 1.5,
                                      color: Color.fromRGBO(232, 233, 237, 1),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: SvgPicture.asset(
                                      "assets/svg/body_comp.svg",
                                    ),
                                  ),
                                ),
                                Text(
                                  "Body",
                                  style: GoogleFonts.poppins(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(48, 48, 48, 1),
                                  ),
                                ),
                                Text(
                                  "Composition",
                                  style: GoogleFonts.poppins(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(48, 48, 48, 1),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 27.8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 68.91,
                                  width: 68.91,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 1.5,
                                      color: Color.fromRGBO(232, 233, 237, 1),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: SvgPicture.asset(
                                      "assets/svg/instant_rep.svg",
                                    ),
                                  ),
                                ),
                                Text(
                                  "Instant",
                                  style: GoogleFonts.poppins(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(48, 48, 48, 1),
                                  ),
                                ),
                                Text(
                                  "Reports",
                                  style: GoogleFonts.poppins(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(48, 48, 48, 1),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "How we do it?",
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(34, 46, 88, 1),
                                  ),
                                ),
                                const SizedBox(width: 60),
                                SvgPicture.asset("assets/svg/men_circle.svg"),
                              ],
                            ),
                            Positioned(
                              top: 110,
                              left: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(250, 252, 255, 1),
                                  border: Border.all(
                                    width: 1,
                                    color: Color.fromRGBO(230, 230, 230, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: [
                                        SizedBox(height: 220),
                                        Container(
                                          height: 31,
                                          width: 300,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            color: Color.fromRGBO(
                                              0,
                                              191,
                                              77,
                                              0.1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/svg/security.svg",
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "We do not store or share your personal data",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromRGBO(
                                                    112,
                                                    112,
                                                    112,
                                                    1,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "1. ",
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromRGBO(
                                                  0,
                                                  0,
                                                  0,
                                                  1,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                "Ensure that you are in a well-lit space",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromRGBO(
                                                    0,
                                                    0,
                                                    0,
                                                    1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "2. ",
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromRGBO(
                                                  0,
                                                  0,
                                                  0,
                                                  1,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                "Allow camera access and place your device against a stable object or wall",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromRGBO(
                                                    0,
                                                    0,
                                                    0,
                                                    1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "3. ",
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromRGBO(
                                                  0,
                                                  0,
                                                  0,
                                                  1,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                "Avoiding wearing baggy clothes",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromRGBO(
                                                    0,
                                                    0,
                                                    0,
                                                    1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "4. ",
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromRGBO(
                                                  0,
                                                  0,
                                                  0,
                                                  1,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                "Make sure you exercise as per the instruction provided by the traine",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromRGBO(
                                                    0,
                                                    0,
                                                    0,
                                                    1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "5. ",
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromRGBO(
                                                  0,
                                                  0,
                                                  0,
                                                  1,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                "Watch the short preview before each exercise",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromRGBO(
                                                    0,
                                                    0,
                                                    0,
                                                    1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Positioned(
                              top: 73,
                              left: 20,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  "assets/image/demo.png",
                                  height: 220,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
