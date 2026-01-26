import 'dart:ui' show Color;

class Product {
  final String name;
  final double price;
  final String category;
  final String? image;
  final Color color;
  final String? sku;
  final String? description;
  bool? isWeightBased;
  Product({
    required this.name,
    required this.price,
    required this.category,
    this.image,
    required this.color,
    this.sku,
    this.description,
    this.isWeightBased = false,
  });
}

final List<Product> products = [
  Product(
    name: "Cappuccino",
    price: 225,
    category: "Beverages",
    // image: "https://loremflickr.com/200/200/cappuccino",
    sku: '123456',
    description: 'This is a cappuccino',
    color: const Color(0xFFFEF3C7),
  ),
  Product(
    name: "Espresso",
    price: 180,
    category: "Beverages",
    image: "https://loremflickr.com/200/200/espresso",
    sku: '1256',
    description: 'This is a espresso',
    color: const Color(0xFFDDD6FE),
  ),
  Product(
    name: "Caesar Salad",
    price: 650,
    category: "Food",
    image: "https://loremflickr.com/200/200/salad",
    sku: '1256',
    description: 'This is a caesar salad',
    color: const Color(0xFFBBF7D0),
  ),
  Product(
    name: "Margherita Pizza",
    price: 890,
    category: "Food",
    image: "https://loremflickr.com/200/200/pizza",
    sku: '1256',
    description: 'This is a margherita pizza',
    color: const Color(0xFFFECDD3),
  ),
  Product(
    name: "Cheesecake",
    price: 400,
    category: "Dessert",
    image: "https://loremflickr.com/200/200/cheesecake",
    sku: '1256',
    description: 'This is a cheesecake',
    color: const Color(0xFFFED7AA),
  ),
  Product(
    name: "Brownie",
    price: 320,
    category: "Dessert",
    image: "https://loremflickr.com/200/200/brownie",
    sku: '1256',
    description: 'This is a brownie',
    color: const Color(0xFFD1D5DB),
  ),
  Product(
    name: "French Fries",
    price: 280,
    category: "Snacks",
    image: "https://loremflickr.com/200/200/fries",
    color: const Color(0xFFFEF08A),
  ),
  Product(
    name: "Nachos",
    price: 350,
    category: "Snacks",
    image: "https://loremflickr.com/200/200/nachos",
    color: const Color(0xFFFBCAFE),
  ),
  Product(
    name: "Latte",
    price: 210,
    category: "Beverages",
    image: "https://loremflickr.com/200/200/latte",
    color: const Color(0xFFE0F2FE),
  ),
  Product(
    name: "Mocha",
    price: 240,
    category: "Beverages",
    image: "https://loremflickr.com/200/200/mocha",
    color: const Color(0xFFFDE68A),
  ),
  Product(
    name: "Iced Tea",
    price: 160,
    category: "Beverages",
    image: "https://loremflickr.com/200/200/icedtea",
    color: const Color(0xFFCCFBF1),
  ),
  Product(
    name: "Fresh Lime Soda",
    price: 150,
    category: "Beverages",
    image: "https://loremflickr.com/200/200/lime,soda",
    color: const Color(0xFFD9F99D),
  ),

  // Food
  Product(
    name: "Grilled Chicken Sandwich",
    price: 520,
    category: "Food",
    image: "https://loremflickr.com/200/200/sandwich",
    color: const Color(0xFFBFDBFE),
  ),
  Product(
    name: "Chicken Burger",
    price: 480,
    category: "Food",
    image: "https://loremflickr.com/200/200/burger",
    color: const Color(0xFFFECACA),
  ),
  Product(
    name: "Veg Pasta",
    price: 450,
    category: "Food",
    image: "https://loremflickr.com/200/200/pasta",
    color: const Color(0xFFDCFCE7),
  ),
  Product(
    name: "Chicken Biryani",
    price: 750,
    category: "Food",
    image: "https://loremflickr.com/200/200/biryani",
    color: const Color(0xFFFDE2E2),
  ),

  // Dessert
  Product(
    name: "Ice Cream Sundae",
    price: 300,
    category: "Dessert",
    image: "https://loremflickr.com/200/200/icecream",
    color: const Color(0xFFE9D5FF),
  ),
  Product(
    name: "Chocolate Mousse",
    price: 420,
    category: "Dessert",
    image: "https://loremflickr.com/200/200/mousse",
    color: const Color(0xFFFAE8FF),
  ),
  Product(
    name: "Fruit Tart",
    price: 380,
    category: "Dessert",
    image: "https://loremflickr.com/200/200/fruittart",
    color: const Color(0xFFFFEDD5),
  ),

  // Snacks
  Product(
    name: "Garlic Bread",
    price: 260,
    category: "Snacks",
    image: "https://loremflickr.com/200/200/garlicbread",
    color: const Color(0xFFFFF7ED),
  ),
  Product(
    name: "Chicken Nuggets",
    price: 340,
    category: "Snacks",
    image: "https://loremflickr.com/200/200/nuggets",
    color: const Color(0xFFFDE68A),
  ),
  Product(
    name: "Spring Rolls",
    price: 300,
    category: "Snacks",
    image: "https://loremflickr.com/200/200/springrolls",
    color: const Color(0xFFECFEFF),
  ),
  Product(
    name: "Banana",
    price: 120,
    category: "Fruits",
    image: "https://loremflickr.com/200/200/banana",
    color: const Color(0xFFFEF08A),
    isWeightBased: true,
  ),
  Product(
    name: "Apple",
    price: 250,
    category: "Fruits",
    image: "https://loremflickr.com/200/200/apple",
    color: const Color(0xFFFECACA),
    isWeightBased: true,
  ),
  Product(
    name: "Grapes",
    price: 180,
    category: "Fruits",
    image: "https://loremflickr.com/200/200/grapes",
    color: const Color(0xFFE9D5FF),
    isWeightBased: true,
  ),
  Product(
    name: "Watermelon",
    price: 60,
    category: "Fruits",
    image: "https://loremflickr.com/200/200/watermelon",
    color: const Color(0xFFBBF7D0),
    isWeightBased: true,
  ),
  Product(
    name: "Orange",
    price: 150,
    category: "Fruits",
    image: "https://loremflickr.com/200/200/orange",
    color: const Color(0xFFFED7AA),
    isWeightBased: true,
  ),
  Product(
    name: "Mango",
    price: 200,
    category: "Fruits",
    image: "https://loremflickr.com/200/200/mango",
    color: const Color(0xFFFDE68A),
    isWeightBased: true,
  ),
];

class OrderItem {
  String name;
  double quantity;
  double price;
  String category;
  String? note;
  double? discount;
  bool isFree;
  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.category,
    this.note,
    this.discount = 0.0,
    this.isFree = false,
  });
  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    name: json["name"],
    quantity: json["quantity"].toDouble(),
    price: json["price"].toDouble(),
    category: json["category"],
    note: json["note"],
    discount: json["discount"]?.toDouble(),
    isFree: json["isFree"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "quantity": quantity,
    "price": price,
    "category": category,
    "note": note,
    "discount": discount,
    "isFree": isFree,
  };
}

final List<OrderItem> orderItems = <OrderItem>[
  OrderItem(name: "Burger", quantity: 2, price: 240, category: "Food"),
  OrderItem(name: "Fries", quantity: 1, price: 120, category: "Food"),
  OrderItem(name: "Coke", quantity: 1, price: 80, category: "Beverages"),
  OrderItem(name: "Ice Cream", quantity: 1, price: 150, category: "Dessert"),
  OrderItem(name: "Sandwich", quantity: 1, price: 180, category: "Food"),
  OrderItem(name: "Pizza", quantity: 1, price: 250, category: "Food"),
  OrderItem(name: "Burger", quantity: 2, price: 240, category: "Food"),
  OrderItem(name: "Fries", quantity: 1, price: 120, category: "Food"),
  OrderItem(name: "Coke", quantity: 1, price: 80, category: "Beverages"),
  OrderItem(name: "Ice Cream", quantity: 1, price: 150, category: "Dessert"),
];

//customer
class Customer {
  String name;
  String phone;
  String address;
  String tipn;
  String outstandingbalance;
  Customer({
    required this.name,
    required this.phone,
    required this.address,
    required this.tipn,
    required this.outstandingbalance,
  });
}

final List<Customer> customers = <Customer>[
  Customer(
    name: "John Doe",
    phone: "1234567890",
    address: "123 Main St, Anytown USA",
    tipn: "1234",
    outstandingbalance: "100.00",
  ),
  Customer(
    name: "Jane Doe",
    phone: "9876543210",
    address: "456 Elm St, Anytown USA",
    tipn: "5678",
    outstandingbalance: "50.00",
  ),
  Customer(
    name: "Bob Smith",
    phone: "5555555555",
    address: "789 Oak St, Anytown USA",
    tipn: "9012",
    outstandingbalance: "75.00",
  ),
];
