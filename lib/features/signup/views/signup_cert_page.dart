import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../common/color_styles.dart';
import '../provider/SignUpProvider.dart';

class SignUpCert extends StatefulWidget {
  @override
  _MembershipScreenState createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<SignUpCert> {
  bool? hasCertificate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('회원가입', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            child: Text('건너뛰기', style: TextStyle(color: Colors.grey)),
            onPressed: () {
              // Handle skip action
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 2),
                  child: Container(
                    width: 84.25,
                    height: 2,
                    decoration: BoxDecoration(color: Color(0xFFFE2D00)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 2),
                  child: Container(
                    width: 84.25,
                    height: 2,
                    decoration: BoxDecoration(color: Color(0xFFFE2D00)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 2),
                  child: Container(
                    width: 84.25,
                    height: 2,
                    decoration: BoxDecoration(color: Color(0xFFFE2D00)),
                  ),
                ),
                Container(
                  width: 84.25,
                  height: 2,
                  decoration: BoxDecoration(color: Color(0xFFCFCFCF)),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '커피 관련 자격증이 있으세요?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  '현재, 취득한 자격증이 있는지 알려주세요.',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text('있어요',
                            style: TextStyle(
                                color: hasCertificate == true
                                    ? Colors.white
                                    : Colors.black)),
                        onPressed: () {
                          setState(() {
                            hasCertificate = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hasCertificate == true
                              ? Colors.red
                              : Colors.white,
                          side: BorderSide(
                              color: hasCertificate == true
                                  ? Colors.red
                                  : Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        child: Text('없어요',
                            style: TextStyle(
                                color: hasCertificate == false
                                    ? Colors.white
                                    : Colors.black)),
                        onPressed: () {
                          setState(() {
                            hasCertificate = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hasCertificate == false
                              ? Colors.red
                              : Colors.white,
                          side: BorderSide(
                              color: hasCertificate == false
                                  ? Colors.red
                                  : Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0, left: 16, right: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: Text('다음'),
                onPressed: hasCertificate != null
                    ? () {
                        context.read<SignUpProvider>().getIsCertificated(hasCertificate!);
                        context.push("/signup/select");
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor:
                    hasCertificate != null ? Colors.black : ColorStyles.gray30,
                    foregroundColor: hasCertificate != null ? Colors.white : ColorStyles.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),

                // ElevatedButton.styleFrom(
                //   foregroundColor:  ColorStyles.gray60,
                //   backgroundColor: hasCertificate != null ? Colors.black : ColorStyles.gray30,
                //   padding: EdgeInsets.symmetric(vertical: 16),
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
