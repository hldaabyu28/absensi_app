// main.dart
import 'package:absensi_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:absensi_app/features/auth/presentation/providers/authenticate_provider.dart';
import 'package:absensi_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/attendance/data/repositories/attendance_repository_impl.dart';
import 'features/attendance/domain/repositories/attendance_repository.dart';
import 'features/attendance/presentation/providers/attendance_provider.dart';
import 'features/history/data/repositories/history_repository_impl.dart';
import 'features/history/domain/repositories/history_repository.dart';
import 'features/history/presentation/providers/history_provider.dart';
import 'core/utils/location_service.dart';
import 'core/utils/camera_service.dart';
import 'core/utils/cloudinary_service.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/attendance/presentation/pages/attendance_page.dart';
import 'features/history/presentation/pages/history_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize services
    final LocationService locationService = LocationService();
    final CameraService cameraService = CameraService();
    final CloudinaryService cloudinaryService = CloudinaryService(
      cloudName: 'dq1034grt', // Replace with your Cloudinary cloud name
      uploadPreset:
          'attendace_upload', // Replace with your Cloudinary upload preset
    );

    // Initialize repositories
    final AuthRepository authRepository = AuthRepositoryImpl(
      FirebaseAuth.instance,
    );
    final AttendanceRepository attendanceRepository = AttendanceRepositoryImpl(
      FirebaseFirestore.instance,
      cloudinaryService,
    );
    final HistoryRepository historyRepository = HistoryRepositoryImpl(
      FirebaseFirestore.instance,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthenticateProvider(),
        ), // Fixed: Use AuthProvider instead of AuthenticateProvider
        ChangeNotifierProvider(
          create:
              (_) => AttendanceProvider(
                attendanceRepository,
                locationService,
                cameraService,
              ),
        ),
        ChangeNotifierProvider(
          create: (_) => HistoryProvider(historyRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Sistem Absensi',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Consumer<AuthenticateProvider>(
          builder: (context, authProvider, _) {
            if (authProvider.isAuthenticated) {
              return AttendancePage();
            } else {
              return LoginPage();
            }
          },
        ),
        routes: {'/history': (context) => HistoryPage()},
      ),
    );
  }
}
