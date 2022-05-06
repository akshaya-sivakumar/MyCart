import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mycart/bloc/products_bloc/products_bloc.dart';
import 'package:mycart/model/products_model.dart';
import 'package:mycart/ui/widgets/app_scaffold.dart';
import 'package:mycart/ui/widgets/toast_widget.dart';

import '../widgets/loader_widget.dart';
import '../widgets/textform_widget.dart';

class AddItemArgs {
  final String category, orderId;

  AddItemArgs(this.category, this.orderId);
}

class AddItem extends StatefulWidget {
  final AddItemArgs args;
  const AddItem({Key? key, required this.args}) : super(key: key);

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
          LoaderWidget()
              .showLoader(context, text: "Please wait", showLoader: false);
          FlutterToast.showToast("Product Added Successfully");
          Navigator.pop(context);
        }
      });
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController productnameController = TextEditingController();
  TextEditingController modelNoController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController manufacturedateController = TextEditingController();
  TextEditingController manufactureaddController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: const Text("Add Item"),
      bottomappbar: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        child: ElevatedButton.icon(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                LoaderWidget()
                    .showLoader(context, text: "Please wait", showLoader: true);
                context.read<ProductsBloc>().add(ProductAddEvent(Product(
                    productName: productnameController.text,
                    modelNumber: modelNoController.text,
                    price: priceController.text,
                    description: descriptionController.text,
                    manufactureDate: manufacturedateController.text,
                    manufactureAddress: manufactureaddController.text,
                    category: widget.args.category,
                    orderId: widget.args.orderId)));
              }
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text("Add")),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              TextFormWidget(
                title: "Product Name",
                controller: productnameController,
                withlabel: true,
                validator: (value) {
                  if (productnameController.text.trim().isEmpty) {
                    return "Please Enter the Product name";
                  }
                  return null;
                },
              ),
              TextFormWidget(
                title: "Model Number",
                controller: modelNoController,
                withlabel: true,
                validator: (value) {
                  if (modelNoController.text.trim().isEmpty) {
                    return "Please Enter the Model Number";
                  }
                  return null;
                },
              ),
              TextFormWidget(
                title: "Price",
                controller: priceController,
                withlabel: true,
                validator: (value) {
                  if (priceController.text.trim().isEmpty) {
                    return "Please Enter the Price";
                  }
                  return null;
                },
              ),
              TextFormWidget(
                title: "Decsription",
                textAreaField: true,
                controller: descriptionController,
                validator: (value) {
                  if (descriptionController.text.trim().isEmpty) {
                    return "Please Enter the Description";
                  }
                  return null;
                },
              ),
              TextFormWidget(
                title: "Manufacture Date",
                controller: manufacturedateController,
                withlabel: true,
                readOnly: true,
                validator: (value) {
                  if (manufacturedateController.text.trim().isEmpty) {
                    return "Please Select the Date";
                  }
                  return null;
                },
                suffixiconButton: IconButton(
                    icon: const Icon(Icons.edit_calendar),
                    onPressed: selectDob),
              ),
              TextFormWidget(
                title: "Manufacture Address",
                textAreaField: true,
                validator: (value) {
                  if (manufactureaddController.text.trim().isEmpty) {
                    return "Please Enter the Address";
                  }
                  return null;
                },
                controller: manufactureaddController,
              ),
            ],
          ),
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
