import "package:flutter/material.dart";

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, Icons.home, 0),
          _buildNavItem(Icons.camera_alt_outlined, Icons.camera_alt, 1),
          _buildNavItem(Icons.person_outline, Icons.person, 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData iconOutline, IconData iconFilled, int index) {
    bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color.fromRGBO(128, 128, 128, 0.3)
                  : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isSelected ? iconFilled : iconOutline,
          color: isSelected ? Colors.white : Colors.grey,
          size: 30,
        ),
      ),
    );
  }
}
