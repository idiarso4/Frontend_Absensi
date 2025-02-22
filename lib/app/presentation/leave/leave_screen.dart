import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skansapung_presensi/app/data/model/leave_request.dart';
import 'package:skansapung_presensi/app/presentation/leave/leave_notifier.dart';
import 'package:skansapung_presensi/app/presentation/widgets/base_screen.dart';

class LeaveScreen extends BaseScreen<LeaveNotifier> {
  LeaveScreen() : super(
    title: 'Cuti & Izin',
    actions: [
      Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _showNewLeaveRequest(context),
        ),
      ),
    ],
  );

  @override
  Widget buildScreenContent(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => notifier.loadLeaveRequests(),
      child: _buildLeaveList(),
    );
  }

  Widget _buildLeaveList() {
    if (notifier.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (notifier.errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              notifier.errorMessage,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => notifier.loadLeaveRequests(),
              child: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(243, 154, 0, 0.988),
              ),
            ),
          ],
        ),
      );
    }

    if (notifier.leaveRequests.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada riwayat pengajuan cuti/izin',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: notifier.leaveRequests.length,
      itemBuilder: (context, index) {
        final leave = notifier.leaveRequests[index];
        return _buildLeaveCard(leave);
      },
    );
  }

  Widget _buildLeaveCard(LeaveRequest leave) {
    Color statusColor;
    switch (leave.status.toLowerCase()) {
      case 'approved':
        statusColor = Colors.green;
        break;
      case 'rejected':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showLeaveDetail(leave),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    leave.type,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      leave.status,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Color.fromRGBO(243, 154, 0, 0.988),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '${DateFormat('dd MMM yyyy').format(leave.startDate)} - ${DateFormat('dd MMM yyyy').format(leave.endDate)}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.timer,
                    size: 16,
                    color: Color.fromRGBO(243, 154, 0, 0.988),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '${leave.durationInDays} hari',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _showNewLeaveRequest(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _NewLeaveRequestForm(),
    );
  }

  void _showLeaveDetail(LeaveRequest leave) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Pengajuan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildDetailRow('Jenis', leave.type),
            _buildDetailRow('Status', leave.status),
            _buildDetailRow(
              'Tanggal',
              '${DateFormat('dd MMM yyyy').format(leave.startDate)} - ${DateFormat('dd MMM yyyy').format(leave.endDate)}',
            ),
            _buildDetailRow('Durasi', '${leave.durationInDays} hari'),
            _buildDetailRow('Alasan', leave.reason),
            if (leave.attachmentUrl != null)
              _buildDetailRow('Lampiran', 'Lihat Dokumen'),
            _buildDetailRow(
              'Diajukan pada',
              DateFormat('dd MMM yyyy HH:mm').format(leave.createdAt),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NewLeaveRequestForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notifier = context.findAncestorStateOfType<LeaveScreen>()?.notifier;
    if (notifier == null) return SizedBox();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pengajuan Baru',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: notifier.selectedType,
              decoration: InputDecoration(
                labelText: 'Jenis Pengajuan',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: LeaveRequest.leaveTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) notifier.setType(value);
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Tanggal Mulai',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(
                      text: notifier.startDate != null
                          ? DateFormat('dd MMM yyyy').format(notifier.startDate!)
                          : '',
                    ),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: notifier.startDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (date != null) notifier.setStartDate(date);
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Tanggal Selesai',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(
                      text: notifier.endDate != null
                          ? DateFormat('dd MMM yyyy').format(notifier.endDate!)
                          : '',
                    ),
                    onTap: () async {
                      if (notifier.startDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Pilih tanggal mulai terlebih dahulu'),
                          ),
                        );
                        return;
                      }
                      final date = await showDatePicker(
                        context: context,
                        initialDate: notifier.endDate ?? notifier.startDate!,
                        firstDate: notifier.startDate!,
                        lastDate: notifier.startDate!.add(Duration(days: 365)),
                      );
                      if (date != null) notifier.setEndDate(date);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: notifier.reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Alasan',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            if (notifier.selectedAttachment != null)
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: FileImage(notifier.selectedAttachment!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ElevatedButton.icon(
              onPressed: () => notifier.pickAttachment(),
              icon: Icon(Icons.attach_file),
              label: Text('Tambah Lampiran'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(243, 154, 0, 0.988),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: notifier.isLoading
                    ? null
                    : () async {
                        final success = await notifier.submitLeaveRequest();
                        if (success) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Pengajuan berhasil dikirim'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: notifier.isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Submit',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(243, 154, 0, 0.988),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
