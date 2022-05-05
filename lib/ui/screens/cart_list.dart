import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mycart/bloc/products_bloc/products_bloc.dart';
import 'package:mycart/model/sqlite/sqlite_model.dart';
import 'package:mycart/ui/widgets/textform_widget.dart';
import 'package:mycart/ui/widgets/toast_widget.dart';

import '../widgets/AppScaffold.dart';
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
        title: Text("My Cart"),
        bottom: TabBar(
            controller: tabController,
            isScrollable: true,
            onTap: (index) {
              productsBloc.add(Fetchproducts(categories[index]));
            },
            tabs: List.generate(
                tabController.length,
                (index) => Tab(
                      text: categories[index],
                    ))),
        body: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, "/addItem",
                        arguments: categories[tabController.index])
                    .then((value) => productsBloc
                        .add(Fetchproducts(categories[tabController.index])));
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text("Add item")),
          body: BlocBuilder<ProductsBloc, ProductsState>(
            /*  buildWhen: (previous, current) {
              return current is ProductsDone;
            }, */
            builder: (context, ProductsState state) {
              if (state is ProductsLoad) {
                return Center(
                    child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ));
              }
              if (state is ProductsError) {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error,
                      size: 60,
                      color: Colors.red[900],
                    ),
                    Text("Unknown Error")
                  ],
                ));
              }
              if (state is ProductsDone) {
                return Container(
                  margin: const EdgeInsets.all(10.0),
                  child: TabBarView(
                    controller: tabController,
                    children: List.generate(
                        tabController.length,
                        (index) => ListView.builder(
                            itemCount: state.products.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                direction: DismissDirection.startToEnd,
                                key: ObjectKey(state.products[index]),
                                onDismissed: (direction) async {
                                  productsBloc.add(ProductDeleteEvent(
                                      state.products[index].id ?? 0));
                                },
                                background: Container(
                                    padding: const EdgeInsets.only(
                                      left: 10.0,
                                    ),
                                    color: HexColor("#d8000c"),
                                    child: const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Delete >>',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    )),
                                child: ExpandableNotifier(
                                    child: Builder(builder: (context) {
                                  var controller = ExpandableController.of(
                                      context,
                                      required: true)!;

                                  return Container(
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border:
                                            Border.all(color: Colors.green)),
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
                                            margin: EdgeInsets.all(10),
                                            padding: EdgeInsets.only(
                                                left: 10,
                                                top: 10,
                                                right: 10,
                                                bottom: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(state.products[index]
                                                    .productName),
                                                Text(state.products[index]
                                                    .modelNumber),
                                                Text(state
                                                    .products[index].price),
                                              ],
                                            )),
                                        expanded: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                                      color: Colors.grey))),
                                          margin: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              TextWidget(
                                                  text: "Description",
                                                  fontWeight: FontWeight.bold),
                                              TextWidget(
                                                  text: "       " +
                                                      state.products[index]
                                                          .description),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  TextWidget(
                                                      text:
                                                          "Manufactured Date ",
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  Text(state.products[index]
                                                      .manufactureDate)
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              TextWidget(
                                                  text: "Manufactured Address ",
                                                  fontWeight: FontWeight.bold),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              TextWidget(
                                                  text: state.products[index]
                                                      .manufactureAddress),
                                              SizedBox(
                                                height: 5,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ))
                                    ]),
                                  );
                                })),
                              );
                            })),
                  ),
                );
              }

              return Center(
                  child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ));
            },
          ),
        ),
      ),
    );
  }

  bottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        builder: (BuildContext context) {
          return SizedBox();
        });
  }
}
