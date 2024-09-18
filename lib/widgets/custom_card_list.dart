import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCardList extends StatelessWidget {
  final Function() onTap;
  final BoxConstraints constraints;
  final Color boxColor;
  final Color leadingColor;
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;

  const CustomCardList({
    super.key,
    required this.onTap,
    required this.constraints,
    required this.leadingColor,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.boxColor = Colors.white
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Container(
          constraints: constraints,
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: boxColor,
            border: Border(left: BorderSide(color: leadingColor, width: 5)),
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded( // Ajout de Expanded pour ajuster dynamiquement la largeur
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: leading
                    ),
                    SizedBox(width: 12.0),
                    Expanded( // Ajout de Expanded pour ajuster dynamiquement la largeur
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          title ?? Container(),
                          Expanded(
                            child: subtitle ?? Container()
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              trailing ?? Container(),
            ],
          ),
        ),
      ),
    );
  }
}
