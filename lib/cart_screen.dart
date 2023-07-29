import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/cart_model.dart';
import 'package:shopping_cart/cart_provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shopping_cart/db_helper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  DBHelper? dbHelper= DBHelper();
  @override
  Widget build(BuildContext context) {

    final cart= Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('CheckList'),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: [
          Center(
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
          SizedBox(width: 20.0,),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: cart.getData(),
              builder: (context, AsyncSnapshot<List<Cart>> snapshot){
             if(snapshot.hasData){
               return Expanded(
                   child: ListView.builder(
                       itemCount: snapshot.data!.length,
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
                                       image: NetworkImage(snapshot.data![index].image.toString()),
                                     ),
                                     SizedBox( width: 10,),
                                     Expanded(
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.start,
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                             children: [
                                               Text(snapshot.data![index].productName.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                               ),
                                               InkWell(
                                                   onTap: (){
                                                     dbHelper!.delete(snapshot.data![index].id!);
                                                     cart.removeCounter();
                                                     cart.removeTotalPrice(double.parse(snapshot.data![index].productPrice.toString()));
                                                   },
                                                   child: Icon(Icons.delete)),
                                             ],
                                           ),

                                           SizedBox(height: 5,),
                                           Text(snapshot.data![index].unitTag.toString() + " " +"pkr"+ snapshot.data![index].productPrice.toString()
                                             , style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                           ),
                                           SizedBox(height: 5,),
                                           Align(
                                             alignment: Alignment.centerRight,
                                             child: InkWell(
                                               onTap: (){

                                               },
                                               child: Container(
                                                 height: 35,
                                                 width: 100,
                                                 decoration: BoxDecoration(
                                                   color: Colors.green,
                                                   borderRadius: BorderRadius.circular(5),
                                                 ),
                                                 child: Padding(
                                                   padding: const EdgeInsets.all(4.0),
                                                   child: Row(
                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                     children: [
                                                       InkWell(
                                                         onTap: (){
                                                           int quantity= snapshot.data![index].quantity!;
                                                           int price= snapshot.data![index].initialPrice!;
                                                           quantity--;
                                                           int newPrice= price * quantity;

                                                           if(quantity >=1 ){
                                                             dbHelper!.update(
                                                               Cart(
                                                                 id: snapshot.data![index].id!,
                                                                 productId:snapshot.data![index].id.toString(),
                                                                 productName: snapshot.data![index].productName!,
                                                                 initialPrice: snapshot.data![index].initialPrice!,
                                                                 productPrice: newPrice,
                                                                 quantity: quantity,
                                                                 unitTag: snapshot.data![index].unitTag,
                                                                 image: snapshot.data![index].image.toString(),
                                                               ),
                                                             ).then((value){
                                                               newPrice= 0;
                                                               quantity= 0;
                                                               cart.removeTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));


                                                             }).onError((error, stackTrace){
                                                               print(error.toString());
                                                             });

                                                           }
                                                 },
                                                           child: Icon(Icons.remove, color: Colors.white,)),
                                                     Text(snapshot.data![index].quantity.toString(), style: TextStyle(color: Colors.white)),
                                                       InkWell(
                                                           onTap: (){
                                                             int quantity= snapshot.data![index].quantity!;
                                                             int price= snapshot.data![index].initialPrice!;
                                                             quantity++;
                                                             int newPrice= price * quantity;

                                                             dbHelper!.update(
                                                               Cart(
                                                                   id: snapshot.data![index].id!,
                                                                   productId:snapshot.data![index].id.toString(),
                                                                   productName: snapshot.data![index].productName!,
                                                                   initialPrice: snapshot.data![index].initialPrice!,
                                                                   productPrice: newPrice,
                                                                   quantity: quantity,
                                                                   unitTag: snapshot.data![index].unitTag,
                                                                   image: snapshot.data![index].image.toString(),
                                                               ),
                                                             ).then((value){
                                                               newPrice= 0;
                                                               quantity= 0;
                                                               cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));


                                                             }).onError((error, stackTrace){
                                                               print(error.toString());
                                                             });
                                                           },
                                                           child: Icon(Icons.add, color: Colors.white,)),
                                                     ],
                                                   ),
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
                       }),
               );
             }
           return Text('loading');
          }),
    Consumer<CartProvider>(builder: (context, value, child){
    return Visibility(
      visible: value.getTotalPrice().toStringAsFixed(2) == "0.00" ? false : true,
      child: Column(
      children: [
      ReuseRow(title: 'Sub Total', value: r'pkr'+ value.getTotalPrice().toStringAsFixed(2)),
      ],
      ),
    );
     }),
        ],
      ),
    );
  }
}

class ReuseRow extends StatelessWidget {
  final String title, value;
   const ReuseRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.subtitle2,),
          Text(value.toString(), style: Theme.of(context).textTheme.subtitle2,),
        ],
      ),
    );
  }
}

