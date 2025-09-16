import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  final String tourTitle;
  final String imageUrl;
  final double price;

  const BookingPage({
    super.key,
    required this.tourTitle,
    required this.imageUrl,
    required this.price,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int peopleCount = 1;
  double basePrice = 0;
  double discountPercent = 10; // Giảm giá 10%
  double tax = 0; // Phí cố định
  double discountAmount = 0;
  double totalPrice = 0;

  final _formKey = GlobalKey<FormState>();
  String fullName = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    // _updatePrice();
    _calculatePrice();
  }

  void _calculatePrice() {
    // Giá gốc cho tất cả số người
    basePrice = widget.price * peopleCount;

    // Giảm giá %
    discountAmount = basePrice * (discountPercent / 100);

    double subtotal = basePrice * peopleCount - discountAmount;

    // Thuế 10% dựa trên giá gốc (sau khi nhân số người)
    tax = subtotal * 0.05;

    // Tổng tiền = giá gốc - giảm giá + thuế
    totalPrice = basePrice - discountAmount + tax;
  }


  void _updatePrice() {
    setState(() {
      basePrice = widget.price * peopleCount;
      discountAmount = (discountPercent > 0)
          ? basePrice * (discountPercent / 100)
          : 0;
      totalPrice = basePrice - discountAmount + tax;
    });
  }

  void increasePeople() {
    setState(() {
      peopleCount++;
      // _updatePrice();
      _calculatePrice();
    });
  }

  void decreasePeople() {
    if (peopleCount > 1) {
      setState(() {
        peopleCount--;
        // _updatePrice();
        _calculatePrice();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Tour"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ảnh tour
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: widget.imageUrl.startsWith("assets/")
                    ? Image.asset(
                  widget.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                    : Image.network(
                  widget.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),

              // Tên tour
              Text(
                widget.tourTitle,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),


              // Giá tour
              Text(
                "Price: ${widget.price.toStringAsFixed(0)} USD/people",
                  // \$${priceUSD.toStringAsFixed(2)}
                style:
                const TextStyle(fontSize: 18, color: Colors.orange),
              ),
              const SizedBox(height: 20),

              // Full Name
              TextFormField(
                decoration: const InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder()),
                validator: (value) =>
                value == null || value.isEmpty
                    ? "Enter your name"
                    : null,
                onSaved: (value) => fullName = value!,
              ),
              const SizedBox(height: 20),

              TextFormField(
                decoration: const InputDecoration(
                    labelText: "Phone",
                    border: OutlineInputBorder()),
                validator: (value) =>
                value == null || value.isEmpty
                    ? "Enter your phone"
                    : null,
                onSaved: (value) => fullName = value!,
              ),
              const SizedBox(height: 20),
              // Email
              TextFormField(
                decoration: const InputDecoration(
                    labelText: "Email", border: OutlineInputBorder()),
                validator: (value) =>
                value == null || value.isEmpty
                    ? "Enter your email"
                    : null,
                onSaved: (value) => email = value!,
              ),
              const SizedBox(height: 20),

              // Chọn số người
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Number:",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500)),
                  Row(
                    children: [
                      IconButton(
                        onPressed: decreasePeople,
                        icon:
                        const Icon(Icons.remove_circle_outline),
                      ),
                      Text(
                        "$peopleCount",
                        style: const TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        onPressed: increasePeople,
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Price Summary
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      _buildPriceRow(
                          "Base Price ($peopleCount person(s))",
                          basePrice),
                      if (discountPercent > 0)
                        _buildPriceRow(
                            "Discount (-${discountPercent.toStringAsFixed(0)}%)",
                            -discountAmount),
                      _buildPriceRow("Tax & Fees", tax),
                      const Divider(),
                      _buildPriceRow("Total", totalPrice,
                          isBold: true, color: Colors.red),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Nút đặt
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Tour booking successful!!"),
                        duration: Duration(seconds: 2), // hiển thị 2 giây
                      ),
                    );

                    // Chuyển trang sau khi thông báo xong
                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.pushReplacementNamed(context, '/tour');
                      // Hoặc nếu muốn clear toàn bộ stack:
                      // Navigator.pushNamedAndRemoveUntil(context, '/tour', (route) => false);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.all(16)),
                  child: const Text(
                    "Book Now",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double value,
      {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight:
                  isBold ? FontWeight.bold : FontWeight.normal)),
          Text(
            "${value >= 0 ? '' : '-'}${value.abs().toStringAsFixed(0)} USD",
            style: TextStyle(
                fontWeight:
                isBold ? FontWeight.bold : FontWeight.normal,
                color: color),
          ),
        ],
      ),
    );
  }
}
