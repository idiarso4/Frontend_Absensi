import 'package:flutter/material.dart';
import 'package:absen_smkn1_punggelan/app/presentation/attendance/attendance_notifier.dart';
import 'package:absen_smkn1_punggelan/app/presentation/widgets/base_screen.dart';

class AttendanceScreen extends BaseScreen<AttendanceNotifier> {
  const AttendanceScreen({Key? key}) : super(title: 'Absensi', key: key);

  @override
  Widget buildScreenContent(BuildContext context, AttendanceNotifier notifier) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStatusCard(notifier),
            const SizedBox(height: 20),
            _buildPhotoSection(notifier, context),
            const SizedBox(height: 20),
            _buildLocationSection(notifier),
            const SizedBox(height: 20),
            _buildSubmitButton(context, notifier),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(AttendanceNotifier notifier) {
    final bool hasSubmitted = notifier.attendanceStatus != null;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: hasSubmitted 
              ? [Colors.green.shade400, Colors.green.shade600]
              : [Colors.red.shade400, Colors.red.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Status Absensi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                notifier.attendanceStatus ?? 'Belum Absen',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSection(AttendanceNotifier notifier, BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Foto Absensi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            if (notifier.selectedImage != null)
              Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      notifier.selectedImage!,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => notifier.clearPhoto(),
                      ),
                    ),
                  ),
                ],
              )
            else
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Ambil foto untuk absensi',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Ambil Foto'),
              onPressed: () => notifier.takePhoto(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Lokasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: notifier.currentLocation != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.green,
                          size: 32,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Lokasi terdeteksi',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_off,
                          color: Colors.grey[400],
                          size: 32,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Lokasi belum tersedia',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => notifier.getCurrentLocation(),
              icon: Icon(Icons.location_searching),
              label: Text('Dapatkan Lokasi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(243, 154, 0, 0.988),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
    final bool canSubmit = notifier.selectedImage != null && notifier.currentLocation != null;
    
    return ElevatedButton(
      onPressed: canSubmit ? () => notifier.submitAttendance(context) : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: canSubmit ? Color.fromRGBO(243, 154, 0, 0.988) : Colors.grey,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (notifier.isLoading)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            ),
          Text(
            notifier.isLoading ? 'Mengirim...' : 'Kirim Absensi',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
