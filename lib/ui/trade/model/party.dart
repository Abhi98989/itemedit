// class Customer {
//   final String partyId;
//   String title;
//   String address;
//   String panNo;
//   String mobile;
//   final String email;
//   final String balance;
//   final String balanceType;
//   final String discountPer;
//   final String loyaltyPoint;
//   final String applyRewards;
//   final String partyGUID;

//   Customer({
//     required this.partyId,
//     required this.title,
//     required this.address,
//     required this.panNo,
//     required this.mobile,
//     required this.email,
//     required this.balance,
//     required this.balanceType,
//     required this.discountPer,
//     required this.loyaltyPoint,
//     required this.applyRewards,
//     required this.partyGUID,
//   });

//   factory Customer.fromJson(Map<String, dynamic> json) => Customer(
//     partyId: json["partyID"],
//     title: json["title"],
//     address: json["address"],
//     panNo: json["panNo"],
//     mobile: json["mobile"],
//     email: json["email"],
//     balance: json["balance"],
//     balanceType: json["balanceType"],
//     discountPer: json["discountPer"],
//     loyaltyPoint: json["loyaltyPoint"],
//     applyRewards: json["applyRewards"],
//     partyGUID: json["PartyGUID"] ?? "",
//   );

//   Map<String, dynamic> toJson() => {
//     "partyID": partyId,
//     "title": title,
//     "address": address,
//     "panNo": panNo,
//     "mobile": mobile,
//     "email": email,
//     "openingBalance": balance,
//     "balType": balanceType,
//     "discountPer": discountPer,
//     "partyType": loyaltyPoint,
//     "applyRewards": applyRewards,
//     "partyGUID": partyGUID,
//   };
// }