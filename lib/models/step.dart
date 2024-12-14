class foodStep {
  final int stepNumber;
  final String description;

  foodStep({
    required this.stepNumber,
    required this.description,
  });

  factory foodStep.fromJson(Map<String, dynamic> json) {
    return foodStep(
      stepNumber: json['stepNumber'],
      description: json['description'], // Bisa null jika tidak ada gambar
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stepNumber': stepNumber,
      'description': description,
    };
  }
}
