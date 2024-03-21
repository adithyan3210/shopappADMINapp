import 'package:flutter/material.dart';
import 'package:myshopadminapp/services/asset_manager.dart';
import 'package:myshopadminapp/widgets/title.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/empty_bag.dart';
import '../provider/order_provider.dart';
import 'orders_widget.dart';

class OrdersScreenFree extends StatefulWidget {
  static const routeName = '/Orderscreen';

  const OrdersScreenFree({Key? key}) : super(key: key);

  @override
  State<OrdersScreenFree> createState() => _OrdersScreenFreeState();
}

class _OrdersScreenFreeState extends State<OrdersScreenFree> {
  bool isEmptyOrders = false;
  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const TitleTextWidget(
            label: 'Placed orders',
          ),
        ),
        body: isEmptyOrders
            ? EmptyBagWidget(
                imagePath: AssetsManager.order,
                title: "No orders has been placed yet",
                subtitle: "",
              )
            : ListView.separated(
                itemCount: ordersProvider.getOrders.length,
                itemBuilder: (ctx, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                    child: OrdersWidgetFree(
                      orderModelAdvanced: ordersProvider.getOrders[index],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
              ));
  }
}
