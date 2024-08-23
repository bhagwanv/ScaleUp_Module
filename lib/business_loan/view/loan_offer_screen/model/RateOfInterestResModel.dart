class RateOfInterestResModel {
  final int monthDuration;
  final double rateOfInterestInPer;
  final String remarks;
  final int id;
  final String created;
  final String? createdBy;
  final String? lastModified;
  final String? lastModifiedBy;
  final String? deleted;
  final String? deletedBy;
  final bool isActive;
  final bool isDeleted;
  final List<dynamic> domainEvents;

  RateOfInterestResModel({
    required this.monthDuration,
    required this.rateOfInterestInPer,
    required this.remarks,
    required this.id,
    required this.created,
    this.createdBy,
    this.lastModified,
    this.lastModifiedBy,
    this.deleted,
    this.deletedBy,
    required this.isActive,
    required this.isDeleted,
    required this.domainEvents,
  });

  factory RateOfInterestResModel.fromJson(Map<String, dynamic> json) {
    return RateOfInterestResModel(
      monthDuration: json['monthDuration'],
      rateOfInterestInPer: json['rateOfInterestInPer'],
      remarks: json['remarks'],
      id: json['id'],
      created: json['created'],
      createdBy: json['createdBy'],
      lastModified: json['lastModified'],
      lastModifiedBy: json['lastModifiedBy'],
      deleted: json['deleted'],
      deletedBy: json['deletedBy'],
      isActive: json['isActive'],
      isDeleted: json['isDeleted'],
      domainEvents: List<dynamic>.from(json['domainEvents']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monthDuration': monthDuration,
      'rateOfInterestInPer': rateOfInterestInPer,
      'remarks': remarks,
      'id': id,
      'created': created,
      'createdBy': createdBy,
      'lastModified': lastModified,
      'lastModifiedBy': lastModifiedBy,
      'deleted': deleted,
      'deletedBy': deletedBy,
      'isActive': isActive,
      'isDeleted': isDeleted,
      'domainEvents': domainEvents,
    };
  }
}
