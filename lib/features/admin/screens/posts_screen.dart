import 'package:amazon_flutter_tutorial/common/widgets/loader.dart';
import 'package:amazon_flutter_tutorial/features/account/widgets/single_product.dart';
import 'package:amazon_flutter_tutorial/features/admin/services/admin_services.dart';
import 'package:flutter/material.dart';

import '../../../models/product_dart.dart';
import 'add_product_screen.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Product>? products;
  final AdminServices adminServices = AdminServices();
  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  fetchAllProducts() async {
    products = await adminServices.fetchAllProducts(context);
    setState(() {

    });
  }

  void deleteProduct(Product product, int index){
    adminServices.deleteProduct(context: context, product: product, onSuccess: (){
       products!.removeAt(index);
       setState(() {

       });
    });
  }

  @override
  Widget build(BuildContext context) {
    return  products == null ?
        const Loader() :
      Scaffold(
      body: GridView.builder(
          itemCount: products!.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2
          ),
          itemBuilder: (context, index) {
            final productData = products![index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 110,
                    child: SingleProduct(
                        image: productData.images[0],
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                        Expanded(
                            child: Text(
                              productData.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            )
                           ),
                        IconButton(
                        onPressed: ()=> deleteProduct(productData,index),
                        icon: const Icon(
                          Icons.delete_outline,
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            );
          },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddProduct,
        tooltip: 'Add a Product',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
