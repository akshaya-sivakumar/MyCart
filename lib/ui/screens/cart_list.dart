import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycart/bloc/products_bloc/products_bloc.dart';
import 'package:mycart/ui/widgets/textform_widget.dart';

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
    productsBloc = BlocProvider.of<ProductsBloc>(context);

    productsBloc.add(Fetchproducts());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabController.length,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, "/addItem",
                  arguments: categories[tabController.index]);
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text("Add item")),
        appBar: AppBar(
            title: const Text("Cart"),
            bottom: TabBar(
                controller: tabController,
                isScrollable: true,
                tabs: List.generate(
                    tabController.length,
                    (index) => Tab(
                          text: categories[index],
                        )))),
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
              return TabBarView(controller: tabController, children: [
                ListView.builder(
                    itemCount: state.products.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Text(state.products[index].productName);
                    }),
                ListView.builder(
                    itemCount: state.products.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Text(state.products[index].productName);
                    }),
                ListView.builder(
                    itemCount: state.products.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Text(state.products[index].productName);
                    }),
                ListView.builder(
                    itemCount: state.products.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Text(state.products[index].productName);
                    }),
                ListView.builder(
                    itemCount: state.products.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Text(state.products[index].productName);
                    })
              ]);
            }

            return Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ));
          },
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
