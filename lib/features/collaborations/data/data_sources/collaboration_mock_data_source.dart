import 'package:taskflow_app/features/collaborations/data/data_sources/collaboration_remote_data_source.dart';
import 'package:taskflow_app/features/collaborations/data/models/collaboration_model.dart';

/// Mock implementation of CollaborationRemoteDataSource for testing without real API
class CollaborationMockDataSource implements CollaborationRemoteDataSource {
  final List<Map<String, dynamic>> _mockCollaborations = [];

  @override
  Future<void> uploadCollaboration(CollaborationModel collaboration) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    // Store the collaboration in our mock database
    _mockCollaborations.add(collaboration.toJson());
    
    // Simulate successful upload (no exception means success)
  }

  /// Helper method to retrieve stored collaborations (for testing/debugging)
  List<Map<String, dynamic>> getStoredCollaborations() {
    return List.unmodifiable(_mockCollaborations);
  }

  /// Helper method to clear all stored collaborations (for testing)
  void clearCollaborations() {
    _mockCollaborations.clear();
  }
}

