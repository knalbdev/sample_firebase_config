import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/ui/absent/absent_screen.dart';
import 'package:test_app/ui/attend/attend_screen.dart';
import 'package:test_app/ui/attendance_history/attendance_history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        _onWillPop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Expanded(
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AttendScreeen()));
                      },
                      child: const Column(
                        children: [
                          Image(
                            image: AssetImage('assets/images/ic_absen.png'),
                            height: 100,
                            width: 100,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Absen Kehadiran",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Expanded(
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AbsentScreen()));
                      },
                      child: const Column(
                        children: [
                          Image(
                            image: AssetImage('assets/images/ic_leave.png'),
                            height: 100,
                            width: 100,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Cuti / Izin",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Expanded(
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AttendanceHistoryScreen()));
                      },
                      child: const Column(
                        children: [
                          Image(
                            image: AssetImage('assets/images/ic_history.png'),
                            height: 100,
                            width: 100,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Riwayat Absensi",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    return (await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text("INFO",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
            ),
            content: const Text("Apa Anda ingin keluar dari aplikasi?",
                style: TextStyle(color: Colors.black, fontSize: 16)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Batal",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14)),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Text("Ya",
                    style: TextStyle(
                        color: Colors.pinkAccent,
                        fontSize: 14)),
              ),
            ],
          ),
    )) ?? false;
  }
}