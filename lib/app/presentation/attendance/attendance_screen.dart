import 'package:flutter/material.dart';
import 'package:skansapung_presensi/app/presentation/attendance/attendance_notifier.dart';
import 'package:skansapung_presensi/app/presentation/widgets/base_screen.dart';

class AttendanceScreen extends BaseScreen<AttendanceNotifier> {
  AttendanceScreen() : super(title: 'Absensi');

  @override
  Widget buildScreenContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildStatusCard(),
          SizedBox(height: 20),
          _buildPhotoSection(),
          SizedBox(height: 20),
          _buildLocationSection(),
          SizedBox(height: 20),
          _buildSubmitButton(context),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
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
              'Belum Absen',
              style: TextStyle(
                fontSize: 24,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
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

  Widget _buildLocationSection() {
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
            if (notifier.isLoading)
              CircularProgressIndicator()
            else if (notifier.errorMessage.isNotEmpty)
              Text(
                notifier.errorMessage,
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              )
            else if (notifier.currentPosition != null)
              Column(
                children: [
                  Text(
                    notifier.isWithinRange
                        ? 'Anda berada dalam area sekolah'
                        : 'Anda berada di luar area sekolah',
                    style: TextStyle(
                      color: notifier.isWithinRange ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Lat: ${notifier.currentPosition!.latitude}\nLong: ${notifier.currentPosition!.longitude}',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => notifier.checkLocation(),
              icon: Icon(Icons.location_on),
              label: Text('Periksa Lokasi'),
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

  Widget _buildSubmitButton(BuildContext context) {
    bool canSubmit = notifier.selectedImage != null &&
        notifier.currentPosition != null &&
        notifier.isWithinRange;

    return ElevatedButton(
      onPressed: canSubmit ? () => notifier.submitAttendance() : null,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'Submit Absensi',
          style: TextStyle(fontSize: 18),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(243, 154, 0, 0.988),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
