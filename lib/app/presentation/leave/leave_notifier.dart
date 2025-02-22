import 'package:flutter/material.dart';
import 'package:absen_smkn1_punggelan/app/data/model/leave_request.dart';
import 'package:absen_smkn1_punggelan/core/provider/app_provider.dart';
import 'dart:io';

class LeaveNotifier extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  List<LeaveRequest> _leaveRequests = [];
  File? _selectedAttachment;

  // Form fields
  String _selectedType = LeaveRequest.leaveTypes.first;
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController reasonController = TextEditingController();

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<LeaveRequest> get leaveRequests => _leaveRequests;
  File? get selectedAttachment => _selectedAttachment;
  String get selectedType => _selectedType;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  void setType(String type) {
    _selectedType = type;
    notifyListeners();
  }

  void setStartDate(DateTime date) {
    _startDate = date;
    if (_endDate != null && _endDate!.isBefore(date)) {
      _endDate = date;
    }
    notifyListeners();
  }

  void setEndDate(DateTime date) {
    if (_startDate != null && !date.isBefore(_startDate!)) {
      _endDate = date;
      notifyListeners();
    }
  }

  Future<void> pickAttachment() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      
      if (image != null) {
        _selectedAttachment = File(image.path);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to pick attachment: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> loadLeaveRequests() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // TODO: Implement API call to fetch leave requests
      await Future.delayed(Duration(seconds: 1)); // Simulate API call

      // Simulate data
      _leaveRequests = List.generate(5, (index) {
        final date = DateTime.now().subtract(Duration(days: index * 5));
        return LeaveRequest(
          id: index + 1,
          type: LeaveRequest.leaveTypes[index % LeaveRequest.leaveTypes.length],
          startDate: date,
          endDate: date.add(Duration(days: 2)),
          reason: 'Sample reason ${index + 1}',
          status: LeaveRequest.statusTypes[index % LeaveRequest.statusTypes.length],
          createdAt: date.subtract(Duration(days: 1)),
        );
      });

      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to load leave requests';
      print(e.toString());
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> submitLeaveRequest() async {
    if (_startDate == null || _endDate == null || reasonController.text.isEmpty) {
      _errorMessage = 'Please fill in all required fields';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // TODO: Implement API call to submit leave request
      await Future.delayed(Duration(seconds: 2)); // Simulate API call

      // Clear form
      _startDate = null;
      _endDate = null;
      _selectedAttachment = null;
      reasonController.clear();
      _selectedType = LeaveRequest.leaveTypes.first;

      // Reload leave requests
      await loadLeaveRequests();

      return true;
    } catch (e) {
      _errorMessage = 'Failed to submit leave request: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }
}
