class CreateRequestState {
  final String description;
  final bool isRemote;
  final bool isPhysicalStrength;
  final DateTime? deadline;
  final double? price;

  CreateRequestState({
    required this.description,
    required this.isRemote,
    required this.isPhysicalStrength,
    this.deadline,
    this.price,
  });

  CreateRequestState copyWith({
    final String? description,
    final bool? isRemote,
    final bool? isPhysicalStrength,
    final DateTime? deadline,
    final double? price,
  }) =>
      CreateRequestState(
        description: description ?? this.description,
        isRemote: isRemote ?? this.isRemote,
        isPhysicalStrength: isPhysicalStrength ?? this.isPhysicalStrength,
        deadline: deadline ?? this.deadline,
        price: price ?? this.price,
      );
}
