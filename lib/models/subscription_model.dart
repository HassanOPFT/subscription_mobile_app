class Subscription {
  final int id;
  final String name;
  final double price;
  final String billingCycle;
  final DateTime renewalDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Subscription({
    required this.id,
    required this.name,
    required this.price,
    required this.billingCycle,
    required this.renewalDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] as int,
      name: json['name'] as String,
      price:
          json['price'] is String
              ? double.parse(json['price'] as String)
              : json['price'] is int
              ? (json['price'] as int).toDouble()
              : json['price'] as double,
      billingCycle: json['billing_cycle'] as String,
      renewalDate: DateTime.parse(json['renewal_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'billing_cycle': billingCycle,
      'renewal_date': renewalDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Subscription copyWith({
    int? id,
    String? name,
    double? price,
    String? billingCycle,
    DateTime? renewalDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Subscription(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      billingCycle: billingCycle ?? this.billingCycle,
      renewalDate: renewalDate ?? this.renewalDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Subscription &&
        other.id == id &&
        other.name == name &&
        other.price == price &&
        other.billingCycle == billingCycle &&
        other.renewalDate == renewalDate &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    price,
    billingCycle,
    renewalDate,
    createdAt,
    updatedAt,
  );

  @override
  String toString() {
    return 'Subscription{id: $id, name: $name, price: $price, billingCycle: $billingCycle, renewalDate: $renewalDate}';
  }
}
