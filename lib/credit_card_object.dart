class CreditCard {
  String cardNumber;
  String cardType;
  String cvv;
  String country;

  CreditCard({
    required this.cardNumber,
    required this.cardType,
    required this.cvv,
    required this.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'cardNumber': cardNumber,
      'cardType': cardType,
      'cvv': cvv,
      'country': country
    };
  }

  factory CreditCard.fromJson(Map<String, dynamic> json) {
    return CreditCard(
      cardNumber: json['cardNumber'],
      cardType: json['cardType'],
      cvv: json['cvv'],
      country: json['country'],
    );
  }
}
