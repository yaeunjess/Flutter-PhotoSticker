import 'package:flutter/material.dart';

class EmoticonSticker extends StatefulWidget {
  final VoidCallback onTransform; // 스티커의 상태가 변경될 때마다 실행
  final String imgPath; // 이미지 경로
  final bool isSelected;

  const EmoticonSticker({
    required this.onTransform,
    required this.imgPath,
    required this.isSelected,
    super.key,
  });

  @override
  State<EmoticonSticker> createState() => _EmoticonStickerState();
}

class _EmoticonStickerState extends State<EmoticonSticker> {
  double scale = 1; // 확대/축소 배율, 임의의 변수
  double hTransform = 0; // 가로의 움직임
  double vTransform = 0; // 세로의 움직임
  double actualScale = 1; // 위젯의 초기 크기 기준 확대/축소 배율

  @override
  Widget build(BuildContext context) {
    return Transform(
      // Creates a widget that transforms its child.
      // child 위젯을 변형할 수 있는 위젯
      transform: Matrix4.identity()
        ..translate(hTransform, vTransform) // 좌우 또는 상하의 움직임을 translate() 함수로 정의한다.
        ..scale(scale, scale), // 확대 또는 축소의 움직임을 scale() 함수로 정의한다.
      child: Container(
          decoration:
          widget.isSelected ?
          BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(
              color: Colors.blue,
              width: 1.0,
            ),
          )
              : BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: Colors.transparent,
            ),
          ),
          child: GestureDetector(
            onTap: (){ // 스티커를 눌렀을 때 실행
              widget.onTransform();
            },
            onScaleUpdate: (ScaleUpdateDetails details){ // 스티커의 확대 비율이 변경됐을 때 실행
              widget.onTransform();
              setState(() {
                scale = details.scale * actualScale; // details.scale은 현재 확대 배율값을 가져와줌

                vTransform += details.focalPointDelta.dy; // 세로 이동 거리 계산
                hTransform += details.focalPointDelta.dx; // 가로 이동 거리 계산
              });
            },
            onScaleEnd: (ScaleEndDetails details){ // 스티커의 확대 비율 변경 완료됐을때 실행
              actualScale = scale;
            },
            child: Image.asset(
              widget.imgPath,
            ),
          )
      )
    );
  }
}
