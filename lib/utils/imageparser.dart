import 'package:flutter/material.dart';
import 'package:infosurvey/enum.dart';
import 'package:infosurvey/tree_node.dart';

class ImageParser extends StatefulWidget {
   ImageParser({super.key,
    required this.data,
}) ;
  TreeNode data;

  @override
  State<ImageParser> createState() => _ImageParserState();
}

class _ImageParserState extends State<ImageParser> {
  @override
  Widget build(BuildContext context) {
    ImagePlace imagePlace = ImagePlace.center;
    if (widget.data.imagePlace != null) {
      imagePlace = ImagePlace.values.firstWhere(
            (e) => e.toString().split('.').last == widget.data.imagePlace!,
        orElse: () => ImagePlace.center,
      );
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: FadeInImage.assetNetwork(
        image: widget.data.image!,
          height: widget.data.imageHeight?.toDouble(),
          alignment: imagePlace == ImagePlace.left
              ? Alignment.topLeft
              : imagePlace == ImagePlace.right
              ? Alignment.topRight
              : Alignment.topCenter,
        placeholder: 'assets/images/placeholder1.png'),
    );
  }}
