import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mycart/bloc/products_bloc/products_bloc.dart';
import 'package:mycart/model/products_model.dart';
import 'package:mycart/ui/widgets/AppScaffold.dart';
import 'package:mycart/ui/widgets/toast_widget.dart';

import '../widgets/textform_widget.dart';

class AddItem extends StatefulWidget {
  final String category;
  AddItem({Key? key, this.category = ""}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  late ProductsBloc productBloc;
  @override
  void initState() {
    super.initState();
    productBloc = BlocProvider.of<ProductsBloc>(context)
      ..stream.listen((state) {
        if (state is ProductsAdded) {
          FlutterToast.showToast("Product Added Successfully");
        }
      });
  }

  TextEditingController productnameController = TextEditingController();
  TextEditingController modelNoController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController manufacturedateController = TextEditingController();
  TextEditingController manufactureaddController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      floatingLocation: FloatingActionButtonLocation.centerFloat,
      floatingButton: ElevatedButton.icon(
          onPressed: () {
            context.read<ProductsBloc>().add(ProductAddEvent(Product(
                productName: productnameController.text,
                modelNumber: modelNoController.text,
                price: priceController.text,
                description: descriptionController.text,
                manufactureDate: manufacturedateController.text,
                manufactureAddress: manufactureaddController.text,
                category: widget.category)));
            // Navigator.pushNamed(context, "/addItem");
          },
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text("Add")),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 20, right: 10),
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(bottom: 5),
              decoration: const BoxDecoration(),
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    "Add Item",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            TextFormWidget(
              title: "Product Name",
              controller: productnameController,
              withlabel: true,
            ),
            TextFormWidget(
              title: "Model Number",
              controller: modelNoController,
              withlabel: true,
            ),
            TextFormWidget(
              title: "Price",
              controller: priceController,
              withlabel: true,
            ),
            TextFormWidget(
              title: "Decsription",
              textAreaField: true,
              controller: descriptionController,
            ),
            TextFormWidget(
              title: "Manufacture Date",
              controller: manufacturedateController,
              withlabel: true,
              suffixiconButton: IconButton(
                  icon: const Icon(Icons.edit_calendar), onPressed: selectDob),
            ),
            TextFormWidget(
              title: "Manufacture Address",
              textAreaField: true,
              controller: manufactureaddController,
            ),
          ],
        ),
      ),
    );
  }

  void selectDob() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: (manufacturedateController.text != "")
            ? DateTime.parse(manufacturedateController.text)
            : DateTime.now(),
        firstDate: DateTime(1900, 8),
        lastDate: DateTime.now());
    if (picked != null) {
      manufacturedateController.text = DateFormat("yyyy-MM-dd").format(picked);
    }
  }
}
