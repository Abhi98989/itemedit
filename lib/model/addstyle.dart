
class AddedStyle {
  final String id;
  final String styleHeading;
  final String childOption;
  final String styleHeadingDesc;
  final String childOptionDesc;
  final String compulsoryChildOption;

  AddedStyle({
    required this.id,
    required this.styleHeading,
    required this.childOption,
    required this.styleHeadingDesc,
    required this.childOptionDesc,
    required this.compulsoryChildOption,
  });

  // --- STATIC DATA FOR ADDED STYLE ---
  static List<AddedStyle> get staticStyles => [
    AddedStyle(
      id: "s1",
      styleHeading: "Sugar Level",
      childOption: "No Sugar",
      styleHeadingDesc: "Select your sweetness",
      childOptionDesc: "0% Sugar added",
      compulsoryChildOption: "Yes",
    ),
    AddedStyle(
      id: "s2",
      styleHeading: "Sugar Level",
      childOption: "Half Sugar",
      styleHeadingDesc: "Select your sweetness",
      childOptionDesc: "50% Sugar added",
      compulsoryChildOption: "Yes",
    ),
    AddedStyle(
      id: "s3",
      styleHeading: "Toppings",
      childOption: "Extra Cheese",
      styleHeadingDesc: "Add more flavor",
      childOptionDesc: "Premium mozzarella",
      compulsoryChildOption: "No",
    ),
    AddedStyle(
      id: "s4",
      styleHeading: "Ice Level",
      childOption: "Normal Ice",
      styleHeadingDesc: "Coldness level",
      childOptionDesc: "Standard amount of ice",
      compulsoryChildOption: "Yes",
    ),
  ];

  factory AddedStyle.fromJson(Map<String, dynamic> json) => AddedStyle(
    id: json["id"],
    styleHeading: json["StyleHeading"],
    childOption: json["childOption"],
    styleHeadingDesc: json["StyleHeadingDesc"],
    childOptionDesc: json["ChildOptionDesc"],
    compulsoryChildOption: json["CompulsoryChildOption"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "StyleHeading": styleHeading,
    "childOption": childOption,
    "StyleHeadingDesc": styleHeadingDesc,
    "ChildOptionDesc": childOptionDesc,
    "CompulsoryChildOption": compulsoryChildOption,
  };
}

class ItemWithAddedStyle {
  final String itemid;
  final String styleHeading;

  ItemWithAddedStyle({required this.itemid, required this.styleHeading});

  // --- STATIC DATA TO MAP ITEMS TO STYLE GROUPS ---
  static List<ItemWithAddedStyle> get staticItemMappings => [
    ItemWithAddedStyle(itemid: "item_coffee_01", styleHeading: "Sugar Level"),
    ItemWithAddedStyle(itemid: "item_coffee_01", styleHeading: "Ice Level"),
    ItemWithAddedStyle(itemid: "item_pizza_05", styleHeading: "Toppings"),
  ];

  factory ItemWithAddedStyle.fromJson(Map<String, dynamic> json) =>
      ItemWithAddedStyle(
        itemid: json["itemid"],
        styleHeading: json["styleHeading"],
      );

  Map<String, dynamic> toJson() => {
    "itemid": itemid,
    "styleHeading": styleHeading,
  };
}