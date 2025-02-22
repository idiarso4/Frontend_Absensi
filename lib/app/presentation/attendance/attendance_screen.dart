import 'package:flutter/material.dart';
import 'package:skansapung_presensi/app/presentation/attendance/attendance_notifier.dart';
import 'package:skansapung_presensi/app/presentation/widgets/base_screen.dart';

class AttendanceScreen extends BaseScreen<AttendanceNotifier> {
  const AttendanceScreen({Key? key}) : super(title: 'Absensi', key: key);

  @override
  Widget buildScreenContent(BuildContext context, AttendanceNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildStatusCard(notifier),
          const SizedBox(height: 20),
          _buildPhotoSection(notifier),
          const SizedBox(height: 20),
          _buildLocationSection(notifier),
          const SizedBox(height: 20),
          _buildSubmitButton(context, notifier),
        ],
      ),
    );
  }

  Widget _buildStatusCard(AttendanceNotifier notifier) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Status Absensi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              notifier.attendanceStatus ?? 'Belum Absen',
              style: TextStyle(
                fontSize: 24,
                color: notifier.attendanceStatus == null ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection(AttendanceNotifier notifier) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (notifier.selectedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  notifier.selectedImage!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: 64,
                  color: Colors.grey[400],
                ),
              ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => notifier.takePhoto(),
              icon: Icon(Icons.camera_alt),
              label: Text('Ambil Foto'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(243, 154, 0, 0.988),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection(AttendanceNotifier notifier) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Lokasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: notifier.currentLocation != null
                  ? Center(
                      child: Text(
                        '${notifier.currentLocation!.latitude}, ${notifier.currentLocation!.longitude}',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : Center(
                      child: Text(
                        'Lokasi belum tersedia',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => notifier.getCurrentLocation(),
              icon: Icon(Icons.location_on),
              label: Text('Dapatkan Lokasi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(243, 154, 0, 0.988),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, AttendanceNotifier notifier) {
    return ElevatedButton(
      onPressed: notifier.isLoading || notifier.selectedImage == null || notifier.currentLocation == null
          ? null
          : () => notifier.submitAttendance(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(243, 154, 0, 0.988),
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: notifier.isLoading
          ? CircularProgressIndicator(color: Colors.white)
          : Text(
              'Submit Absensi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
