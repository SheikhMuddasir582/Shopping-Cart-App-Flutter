import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:shopping_cart/cart_model.dart';
import 'package:shopping_cart/cart_provider.dart';
import 'package:shopping_cart/cart_screen.dart';
import 'package:shopping_cart/db_helper.dart';

class ProductLineScreen extends StatefulWidget {
  const ProductLineScreen({Key? key}) : super(key: key);

  @override
  State<ProductLineScreen> createState() => _ProductLineScreenState();
}

class _ProductLineScreenState extends State<ProductLineScreen> {

  DBHelper? dbHelper= DBHelper();

  List<String> productName= ['Mango', 'Orange', 'Grapes', 'Banana', 'Chery', 'Peach', 'Mixed Fruit Basket'];
  List<String> productUnit= ['KG','Dozen','KG','Dozen','KG','KG','KG'];
  List<int> productPrice= [200, 300, 150, 140, 90, 220, 120];
  List<String> productImages= [
   'https://www.shutterstock.com/shutterstock/photos/1987479101/display_1500/stock-vector-fresh-mango-with-mango-slice-and-leaves-vector-illustration-1987479101.jpg',
    'https://www.shutterstock.com/shutterstock/photos/604042622/display_1500/stock-vector-bright-vector-set-of-colorful-slice-and-whole-of-juicy-orange-fresh-cartoon-oranges-on-white-604042622.jpg',
  'https://www.shutterstock.com/shutterstock/photos/1423239542/display_1500/stock-vector-yellow-or-green-grapes-branch-with-leaves-isolated-grape-icon-realistic-vector-1423239542.jpg',
    'https://www.shutterstock.com/shutterstock/photos/1349348600/display_1500/stock-vector-realistic-ripe-banana-bunch-fresh-yellow-fruit-for-healthy-eating-organic-food-adverts-design-1349348600.jpg',
    'https://www.shutterstock.com/shutterstock/photos/1364117666/display_1500/stock-vector-vector-illustration-cherries-photo-realistic-d-icon-isolated-on-white-background-1364117666.jpg',
    'https://www.shutterstock.com/shutterstock/photos/371390959/display_1500/stock-vector-ripe-peaches-whole-and-slice-fully-editable-handmade-mesh-vector-illustration-371390959.jpg',
    'https://media.istockphoto.com/id/119401613/photo/fruit-basket.jpg?s=1024x1024&w=is&k=20&c=xpqf8qHivkBKfpIjX2snSFHSzGEbEWw0iLTZ96-VHx4='
  ];

  @override
  Widget build(BuildContext context) {
    final cart= Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen()));
            },
            child: Center(
              child: badges.Badge(
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value, child){
                    return Text(value.getCounter().toString(), style: TextStyle(color: Colors.white));
                  },
                ),
                badgeAnimation: badges.BadgeAnimation.rotation(
                  animationDuration: Duration(milliseconds: 300),
                ),
                child: Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
          SizedBox(width: 20.0,),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(),
          Expanded(
              child: ListView.builder(
                  itemCount: productName.length,
                  itemBuilder: (context, index){
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image(
                              height: 100,
                                width: 100,
                                image: NetworkImage(productImages[index].toString()),
                            ),
                            SizedBox( width: 10,),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(productName[index].toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(productUnit[index].toString() + " " +"pkr"+ productPrice[index].toString()
                                    , style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 5,),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      onTap: (){
                                        dbHelper!.insert(
                                          Cart(
                                              id: index,
                                              productId: index.toString(),
                                              productName: productName[index].toString(),
                                              initialPrice: productPrice[index],
                                              productPrice: productPrice[index],
                                              quantity: 1,
                                              unitTag: productUnit[index].toString(),
                                              image: productImages[index].toString())
                                        ).then((value){
                                          print('product added to cart');
                                          cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                          cart.addCounter();
                                        }).onError((error, stackTrace){
                                          print(error.toString());
                                        });
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Center(
                                          child: Text('Add to cart', style: TextStyle(color: Colors.white),),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        )
                      ],
                    ),
                  ),
                );
              })
          )
        ],
      ),
    );
  }
}
