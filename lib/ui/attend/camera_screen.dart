import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:lottie/lottie.dart';
import 'package:test_app/ui/attend/attend_screen.dart';
import 'package:test_app/utils/face_detection/google_ml_kit.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _State();
}

class _State extends State<CameraScreen> with TickerProviderStateMixin {

  //set face detection
  FaceDetector faceDetector = GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
    enableContours: true,
    enableClassification: true,
    enableTracking: true,
    enableLandmarks: true
  ));

  List<CameraDescription>? cameras;
  CameraController? controller;
  XFile? image;
  bool isBusy = false;

  @override
  void initState() {
    loadCamera();
    super.initState();
  }

  //set open front camera device
  //if 1 front, if 0 rear
  loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(cameras![1], ResolutionPreset.max);
      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.camera_enhance_outlined,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text("Ups, camera not found!", style: TextStyle(color: Colors.white))
          ],
        ),
        backgroundColor: Colors.blueGrey,
        shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    //set loading
    showLoaderDialog(BuildContext context) {
      AlertDialog alert = AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(valueColor:
            AlwaysStoppedAnimation<Color>(Colors.blueAccent)),
            Container(
                margin: const EdgeInsets.only(left: 20),
                child: const Text("Checking the data...")
            ),
          ],
        ),
      );
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Capture a selfie image",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
              height: size.height,
              width: size.width,
              child: controller == null
                  ? const Center(child: Text("Ups, camera error!",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))
                  : !controller!.value.isInitialized
                  ? const Center(child: CircularProgressIndicator())
                  : CameraPreview(controller!)
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Lottie.asset(
              "assets/raw/face_id_ring.json",
              fit: BoxFit.cover,
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: size.width,
                height: 200,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                        "Make sure you're in a well-lit area so your face is clearly visible.",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: ClipOval(
                        child: Material(
                          color: Colors.blueAccent, // Button color
                          child: InkWell(
                            splashColor: Colors.blue, // Splash color
                            onTap: () async {
                              final hasPermission = await handleLocationPermission();
                              try {
                                if (controller != null) {
                                  if (controller!.value.isInitialized) {
                                    controller!.setFlashMode(FlashMode.off);
                                    image = await controller!.takePicture();
                                    setState(() {
                                      if (hasPermission) {
                                        showLoaderDialog(context);
                                        final inputImage = InputImage.fromFilePath(image!.path);
                                        Platform.isAndroid ? processImage(inputImage) : Navigator.push(context,
                                            MaterialPageRoute(builder: (context) => AttendScreen(image: image)));
                                      }
                                      else {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                          content: Row(
                                            children: [
                                              Icon(
                                                Icons.location_on_outlined,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 10),
                                              Text("Please allow the permission first!",
                                                  style: TextStyle(color: Colors.white),
                                              )
                                            ],
                                          ),
                                          backgroundColor: Colors.blueGrey,
                                          shape: StadiumBorder(),
                                          behavior: SnackBarBehavior.floating,
                                        ));
                                      }
                                    });
                                  }
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(
                                        Icons.error_outline,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 10),
                                      Text("Ups, $e",
                                        style: const TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                  backgroundColor: Colors.blueGrey,
                                  shape: const StadiumBorder(),
                                  behavior: SnackBarBehavior.floating,
                                ));
                              }
                            },
                            child: const SizedBox(
                                width: 56,
                                height: 56,
                                child: Icon(
                                  Icons.camera_enhance_outlined,
                                  color: Colors.white,
                                ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ),
        ],
      ),
    );
  }

  //permission location
  Future<bool> handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.location_off,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text("Location services are disabled. Please enable the services.",
                style: TextStyle(color: Colors.white),
            )
          ],
        ),
        backgroundColor: Colors.blueGrey,
        shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      ));
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.location_off,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text("Location permission denied.",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          backgroundColor: Colors.blueGrey,
          shape: StadiumBorder(),
          behavior: SnackBarBehavior.floating,
        ));
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.location_off,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text("Location permission denied forever, we cannot access.",
                style: TextStyle(color: Colors.white),
            )
          ],
        ),
        backgroundColor: Colors.blueGrey,
        shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      ));
      return false;
    }
    return true;
  }

  //face detection
  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    final faces = await faceDetector.processImage(inputImage);
    isBusy = false;

    if (mounted) {
      setState(() {
        Navigator.of(context).pop(true);
        if (faces.length > 0) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AttendScreen(image: image)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.face_retouching_natural_outlined,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                      "Ups, make sure that you're face is clearly visible!",
                      style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
            backgroundColor: Colors.blueGrey,
            shape: StadiumBorder(),
            behavior: SnackBarBehavior.floating,
          ));
        }
      });
    }
  }
}