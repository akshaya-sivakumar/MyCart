import 'package:expandable/expandable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mycart/bloc/products_bloc/products_bloc.dart';
import 'package:mycart/model/sqlite/sqlite_model.dart';
import 'package:mycart/ui/screens/add_item.dart';

import 'package:mycart/ui/widgets/toast_widget.dart';

import '../../model/products_model.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/text_widget.dart';

class CartList extends StatefulWidget {
  const CartList({Key? key}) : super(key: key);

  @override
  State<CartList> createState() => _CartListState();
}

class _CartListState extends State<CartList>
    with SingleTickerProviderStateMixin {
  String? category;
  late ProductsBloc productsBloc;
  late TabController tabController;
  TextEditingController productnameController = TextEditingController();
  TextEditingController modelNoController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController manufacturedateController = TextEditingController();
  TextEditingController manufactureaddController = TextEditingController();
  List categories = ["Mobile", "AC", "Laptops", "Watch", "TV"];
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: categories.length, vsync: this);
    productsBloc = BlocProvider.of<ProductsBloc>(context)
      ..stream.listen((event) {
        if (event is ProductsDeleted) {
          FlutterToast.showToast("Product Deleted");
          productsBloc.add(Fetchproducts(categories[tabController.index]));
        }
      });
    productsBloc.add(Fetchproducts(categories[tabController.index]));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabController.length,
      child: AppScaffold(
        title: const Text("My Cart"),
        bottom: TabBar(
            controller: tabController,
            isScrollable: true,
            onTap: (index) {
              productsBloc.add(Fetchproducts(categories[index]));
            },
            tabs: List.generate(
                5,
                (index) => Tab(
                      text: categories[index],
                    ))),
        body: BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, ProductsState state) {
            if (state is ProductsLoad) {
              return loadData(context);
            }
            if (state is ProductsError) {
              return const ErrorWidget();
            }
            if (state is ProductsDone) {
              return Scaffold(
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                  floatingActionButton: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, "/addItem",
                                arguments: AddItemArgs(
                                    categories[tabController.index],
                                    (state.products.length).toString()))
                            .then((value) => productsBloc.add(Fetchproducts(
                                categories[tabController.index])));
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text("Add item")),
                  body: bodyData(state.products));
            }

            return loadData(context);
          },
        ),
      ),
    );
  }

  Center loadData(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
      color: Theme.of(context).primaryColor,
    ));
  }

  Container bodyData(List<Product> products) {
    print(products.first.productName);
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: TabBarView(
        controller: tabController,
        physics: const NeverScrollableScrollPhysics(),
        dragStartBehavior: DragStartBehavior.down,
        children: List.generate(
          5,
          (i) => ReorderableListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: products.length,
              onReorder: (int oldIndex, newIndex) async {
                final bool isPositionChanged =
                    (oldIndex < newIndex && oldIndex != (newIndex - 1)) ||
                        (oldIndex > newIndex && oldIndex != newIndex);
                if (isPositionChanged) {
                  await reorderData(oldIndex, newIndex, products);
                  await reorderData(newIndex, oldIndex, products);
                  productsBloc
                      .add(Fetchproducts(categories[tabController.index]));
                }
              },
              itemBuilder: (context, index) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  key: ObjectKey(products[index]),
                  onDismissed: (direction) async {
                    productsBloc.add(
                        ProductDeleteEvent(products[index].productId ?? 0));
                  },
                  background: Container(
                      padding: const EdgeInsets.only(
                        right: 10.0,
                      ),
                      color: HexColor("#d8000c"),
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Text('<<Delete',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      )),
                  child: ExpandableNotifier(child: Builder(builder: (context) {
                    return Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.green)),
                      child: Column(children: [
                        ScrollOnExpand(
                            /*  scrollOnExpand: true,
                                    scrollOnCollapse: true, */
                            child: ExpandablePanel(
                          theme: const ExpandableThemeData(
                            hasIcon: false,
                            useInkWell: true,
                          ),
                          collapsed: Container(
                            height: 1,
                          ),
                          header: Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.only(
                                  left: 10, top: 10, right: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(products[index].productName),
                                  Text(products[index].modelNumber),
                                  Text(products[index].price),
                                ],
                              )),
                          expanded: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: const BoxDecoration(
                                border: Border(
                                    top: BorderSide(color: Colors.grey))),
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Table(
                                  children: [
                                    tableRowdata("Description",
                                        products[index].description),
                                    tableRowdata("Manufactured Date",
                                        products[index].manufactureDate),
                                    tableRowdata("Manufactured Address ",
                                        products[index].manufactureAddress)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ))
                      ]),
                    );
                  })),
                );
              }),
        ),
      ),
    );
  }

  Future<void> reorderData(
      int oldIndex, int newIndex, List<Product> products) async {
    var product = products
        .where((element) => element.orderId == oldIndex.toString())
        .toList()
        .first;

    product.orderId = newIndex.toString();

    await SqlProducts.fromMap(product.toJson()).upsert();
  }

  TableRow tableRowdata(String title, data) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextWidget(text: title, fontWeight: FontWeight.bold),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextWidget(text: data),
      ),
    ]);
  }

  bottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        builder: (BuildContext context) {
          return const SizedBox();
        });
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error,
          size: 60,
          color: Colors.red[900],
        ),
        const Text("Unknown Error")
      ],
    ));
  }
}
