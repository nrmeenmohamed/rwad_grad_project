import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles/colors.dart';
import 'constants.dart';

Widget categoryContainer({
  required Map categoryModel,
  int? count,
  Function? onLongPress,
}) =>
    GestureDetector(
      onLongPress: () {
        onLongPress!();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(45.r),
            topLeft: Radius.circular(15.r),
            bottomRight: Radius.circular(15.r),
            bottomLeft: Radius.circular(15.r),
          ),
          color: backgroundColor,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: CachedNetworkImageProvider(
                  categoryImg,
                  scale: 5.0,
                ),
              ),
              Text(
                '${categoryModel['name']}',
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${count ?? 0}',
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Text(
                    'tasks',
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

// Widget categoryContainer({
//   required Map categoryModel,
//   int? count,
//   Function? onLongPress,
// }) => GestureDetector(
//       onLongPress: () {
//         onLongPress!();
//       },
//       child: Container(
//         padding: EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.only(
//             topRight: Radius.circular(45.r),
//             topLeft: Radius.circular(15.r),
//             bottomRight: Radius.circular(15.r),
//             bottomLeft: Radius.circular(15.r),
//           ),
//           color: backgroundColor,
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image(
//                 image: CachedNetworkImageProvider(
//                   categoryImg,
//                   scale: 5.0,
//                 ),
//               ),
//               Text(
//                 '${categoryModel['name']}',
//                 style: TextStyle(
//                     fontSize: 16,
//                     color: textColor,
//                     overflow: TextOverflow.ellipsis),
//               ),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     '${count == null ? 0 : count}',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: textColor,
//                     ),
//                   ),
//                   SizedBox(
//                     width: 7,
//                   ),
//                   Text(
//                     'tasks',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: textColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
