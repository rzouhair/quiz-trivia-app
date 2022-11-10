import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Selection extends StatefulWidget {
  const Selection(
      {super.key,
      required this.selected,
      required this.onPressed,
      required this.label});

  final bool selected;
  final String label;

  final void Function() onPressed;

  @override
  State<Selection> createState() => _SelectionState();
}

class _SelectionState extends State<Selection> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 80,
        decoration: BoxDecoration(
            boxShadow: widget.selected
                ? [
                    const BoxShadow(
                      offset: Offset(0, 15),
                      spreadRadius: 7,
                      blurRadius: 50,
                      color: Color.fromRGBO(0, 0, 0, 0.2),
                    )
                  ]
                : [],
            color: widget.selected ? Colors.deepPurple.shade300 : Colors.white,
            borderRadius: BorderRadius.circular(4)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: widget.selected
                          ? Colors.white
                          : Colors.deepPurple.shade300,
                      width: 2),
                  borderRadius: BorderRadius.circular(99999)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(9999)),
                    color: widget.selected ? Colors.white : Colors.transparent),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  widget.label,
                  style: TextStyle(
                      color: widget.selected
                          ? Colors.white
                          : Color(Colors.grey.shade900.value),
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
