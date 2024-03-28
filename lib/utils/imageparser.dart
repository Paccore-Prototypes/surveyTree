import 'package:flutter/material.dart';
import 'package:infosurvey/enum.dart';
import 'package:infosurvey/tree_node.dart';

class ImageParser extends StatefulWidget {
   ImageParser({super.key,
    required this.data,
    this.imagePaceHolder
}) ;
  TreeNode data;
  final String? imagePaceHolder;

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
          height: MediaQuery.sizeOf(context).height/1000*widget.data.imageHeight!.toDouble(),
        width: MediaQuery.sizeOf(context).width/1000*widget.data.imageWidth!.toDouble(),
          alignment: imagePlace == ImagePlace.left
              ? Alignment.topLeft
              : imagePlace == ImagePlace.right
              ? Alignment.topRight
              : Alignment.topCenter,
              placeholderErrorBuilder: (context, error, stackTrace) {
                return Center(child: CircularProgressIndicator(),);
              },
              imageErrorBuilder: (context, error, stackTrace) {
                return Center(child: CircularProgressIndicator(),);
              },
        placeholder: widget.imagePaceHolder??'',placeholderCacheWidth: 200,placeholderCacheHeight: 200,),
    );
  }}
