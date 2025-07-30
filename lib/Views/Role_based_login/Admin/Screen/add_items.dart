import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myecommerceapp/Views/Role_based_login/Admin/Controller/add_items_controller.dart';
import 'package:myecommerceapp/Widgets/my_button.dart';
import 'package:myecommerceapp/Widgets/show_snackbar.dart';

class AddItems extends ConsumerWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _discountpercentageController = TextEditingController();

  final bool isEditing;
  final String? itemId;
  final Map<String, dynamic>? itemData;

  AddItems({
    super.key,
    this.isEditing = false,
    this.itemId,
    this.itemData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addItemProvider);
    final notifier = ref.read(addItemProvider.notifier);

    // Initialize data when editing
    if (isEditing && itemData != null && _nameController.text.isEmpty) {
      _nameController.text = itemData!['name'] ?? '';
      _priceController.text = itemData!['price'] ?? '';
      _discountpercentageController.text = itemData!['discountPercentage']?.toString() ?? '';

      // Set existing data to the state
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifier.setEditingData(itemData!, itemId!);
      });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(isEditing ? "Edit Item" : "Add New Items"),
      ),
      body: Padding(
        padding:  const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: state.imagePath != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),

                    child: state.imagePath!.startsWith('http')
                        ? Image.network(
                      state.imagePath!,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return CircularProgressIndicator();
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error);
                      },
                    )
                        : Image.file(
                      File(state.imagePath!),
                      fit: BoxFit.cover,
                    ),
                  )
                      :state.isLoading
                      ? const CircularProgressIndicator()
                      : GestureDetector(
                        onTap: notifier.pickImage,
                        child: Icon(Icons.camera_alt, size: 30,),
                  ),
                ),
              ),
              SizedBox(height: 10),
              //for name
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
              ),
              ),
              const SizedBox(height: 10),
              //for price
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: "Price",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              //for category selection
              DropdownButtonFormField<String>(
                value: state.selectedCategory,
                decoration: InputDecoration(
                  labelText: "Select Category",
                  border: OutlineInputBorder(),
                ),
                onChanged: notifier.setSelectedCategory,
                items: state.categories.map((String category){
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              //for size
              TextField(
                controller: _sizeController,
                decoration: InputDecoration(
                  labelText: "Sizes (comma separated)",
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  notifier.addSize(value);
                  _sizeController.clear();
                }
              ),
              Wrap(
                spacing: 8,
                children: state.sizes.map(
                      (size) => Chip(
                        onDeleted: () => notifier.removeSize(size),
                        label: Text(size),
                      ),
                ).toList(),
              ),
              const SizedBox(height: 10),
              // for color
              TextField(
                controller: _colorController,
                decoration: InputDecoration(
                  labelText: "Color (comma separated)",
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  notifier.addColor(value);
                  _colorController.clear();
                },
              ),
              Wrap(
                spacing: 8,
                children: state.colors.
                map(
                      (color) => Chip(
                    onDeleted: () => notifier.removeColor(color),
                    label: Text(color),
                  ),
                ).toList(),
              ),
              Row(children: [
                  Checkbox(
                    value: state.isDiscounted,
                    onChanged: notifier.toggleDiscount,
                  ),
                Text("Apply Discount"),
                ],
              ),

              if(state.isDiscounted)
                  Column(children: [
                    TextField(
                      controller: _discountpercentageController,
                      decoration: const InputDecoration(
                        labelText: "Discount Percentage (%)",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        notifier.setDiscountPercentage(value);
                      },
                    ),

                    ],
                  ),
              const SizedBox(height: 20),
              const SizedBox(height: 10),
              state.isLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : Center(
                child: MyButton (
                  onTab: () async{
                    try{
                      if (isEditing && itemId != null) {
                        await notifier.updateItem(
                          itemId!,
                          _nameController.text,
                          _priceController.text,
                        );
                        showSnackBar(context, "Item updated successfully!");
                      } else {
                        await notifier.uploadAndSaveItem(
                          _nameController.text,
                          _priceController.text,
                        );
                        showSnackBar(context, "Item added successfully!");
                      }
                      Navigator.of(context).pop();
                    }catch(e){
                      showSnackBar(context, "Error: $e");
                    }
                  },
                  // buttonText: "Save item",
                  buttonText: isEditing ? "Update Item" : "Save item",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
