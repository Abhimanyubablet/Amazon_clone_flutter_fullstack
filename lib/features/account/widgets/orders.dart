import 'package:amazon_flutter_tutorial/features/account/widgets/single_product.dart';
import 'package:flutter/material.dart';

import '../../../constants/global_variables.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {

  List list =[
    "https://d2v5dzhdg4zhx3.cloudfront.net/web-assets/images/storypages/primary/ProductShowcasesampleimages/JPEG/Product+Showcase-1.jpg",
    "https://d2v5dzhdg4zhx3.cloudfront.net/web-assets/images/storypages/primary/ProductShowcasesampleimages/JPEG/Product+Showcase-1.jpg",
    "https://d2v5dzhdg4zhx3.cloudfront.net/web-assets/images/storypages/primary/ProductShowcasesampleimages/JPEG/Product+Showcase-1.jpg",
    "https://d2v5dzhdg4zhx3.cloudfront.net/web-assets/images/storypages/primary/ProductShowcasesampleimages/JPEG/Product+Showcase-1.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
       children: [
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [

             Container(
               padding: const EdgeInsets.only(
                 left: 15,
               ),
               child: const Text(
                 'Your Orders',
                 style: TextStyle(
                   fontSize: 18,
                   fontWeight: FontWeight.w600,
                 ),
               ),
             ),

             Container(
               padding: const EdgeInsets.only(
                 right: 15,
               ),
               child: Text(
                 'See all',
                 style: TextStyle(
                   color: GlobalVariables.selectedNavBarColor,
                 ),
               ),
             ),
           ],
         ),

         // display orders
         Container(
           height: 170,
           padding: const EdgeInsets.only(
             left: 10,
             top: 20,
             right: 0,
           ),
           child: ListView.builder(
             scrollDirection: Axis.horizontal,
             itemCount: list.length,
             itemBuilder: (context, index) {
               return GestureDetector(
                 onTap: () {

                 },
                 child: SingleProduct(
                   image: list[index],
                 ),
               );
             },
           ),
         ),
       ],
    );
  }
}
