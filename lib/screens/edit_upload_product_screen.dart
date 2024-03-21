import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myshopadminapp/consts/app_constants.dart';
import 'package:myshopadminapp/consts/validator.dart';
import 'package:myshopadminapp/models/product_model.dart';
import 'package:myshopadminapp/screens/loading_manager.dart';
import 'package:myshopadminapp/services/my_app_functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myshopadminapp/widgets/subtitle.dart';
import 'package:myshopadminapp/widgets/title.dart';
import 'package:uuid/uuid.dart';

class EditOrUploadProductScreen extends StatefulWidget {
  static const routeName = '/EditOrUploadProductScreen';
  const EditOrUploadProductScreen({super.key, this.productModel});
  final ProductModel? productModel;

  @override
  State<EditOrUploadProductScreen> createState() =>
      _EditOrUploadProductScreenState();
}

class _EditOrUploadProductScreenState extends State<EditOrUploadProductScreen> {
  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;

  late TextEditingController _titleController,
      _priceController,
      _descriptionController,
      _quantityController;

  String? _categoryValue;

  bool isEditing = false;
  String? productNetworkImage;
  bool _isLoading = false;
  String? productImageUrl;
  @override
  void initState() {
    if (widget.productModel != null) {
      isEditing = true;
      productNetworkImage = widget.productModel!.productImage;
      _categoryValue = widget.productModel!.productCategory;
    }
    _titleController =
        TextEditingController(text: widget.productModel?.productTitle);
    _priceController =
        TextEditingController(text: widget.productModel?.productPrice);
    _descriptionController =
        TextEditingController(text: widget.productModel?.productDescription);
    _quantityController =
        TextEditingController(text: widget.productModel?.productQuantity);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void clearForm() {
    _titleController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _quantityController.clear();
    
  }

  void removePickedImage() {
    setState(() {
      _pickedImage = null;
      productNetworkImage = null;
    });
  }

  Future<void> _uploadProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_pickedImage == null) {
      MyAppFunctions.showErrorOrWarningDialog(
          context: context,
          fct: () {},
          subtitle: "Make sure to pick an image ");
      return;
    }
    if (isValid) {
      try {
        setState(() {
          _isLoading = true;
        });
        final productId = Uuid().v4();
        final ref = FirebaseStorage.instance
            .ref()
            .child("productImages")
            .child("$productId.text.jpg");
        await ref.putFile(File(_pickedImage!.path));
        productImageUrl = await ref.getDownloadURL();
        //initialise firestore ---- user information firestrore
        await FirebaseFirestore.instance
            .collection("products")
            .doc(productId)
            .set({
          'productId': productId,
          'productTitle': _titleController.text,
          'productPrice': _priceController.text,
          'productImage': productImageUrl,
          'productCategory': _categoryValue,
          'productDescription': _descriptionController.text,
          'productQuantity': _quantityController.text,
          'createdAt': Timestamp.now(),
        });

        Fluttertoast.showToast(
          msg: "Product added",
          textColor: Colors.white,
        );
        if (!mounted) return;
        MyAppFunctions.showErrorOrWarningDialog(
            isError: false,
            context: context,
            subtitle: "Clear Form?",
            fct: () {
              clearForm();
            });
      } on FirebaseException catch (error) {
        await MyAppFunctions.showErrorOrWarningDialog(
          context: context,
          fct: () {},
          subtitle: error.message.toString(),
        );
      } catch (error) {
        await MyAppFunctions.showErrorOrWarningDialog(
          context: context,
          fct: () {},
          subtitle: error.toString(),
        );
      }
      {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _editProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_pickedImage == null && productNetworkImage == null) {
      MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: "Please pick up an image",
        fct: () {},
      );
      return;
    }

    if (isValid) {
      try {
        setState(() {
          _isLoading = true;
        });

        if (_pickedImage != null) {
          final ref = FirebaseStorage.instance
              .ref()
              .child("productImages")
              .child("${_titleController.text}.jpg");
          await ref.putFile(File(_pickedImage!.path));
          productImageUrl = await ref.getDownloadURL();
        }
        //initialise firestore ---- user information firestrore

        await FirebaseFirestore.instance
            .collection("products")
            .doc(widget.productModel!.productId)
            .update({
          'productId': widget.productModel!.productId,
          'productTitle': _titleController.text,
          'productPrice': _priceController.text,
          'productImage': productImageUrl ?? productNetworkImage,
          'productCategory': _categoryValue,
          'productDescription': _descriptionController.text,
          'productQuantity': _quantityController.text,
          'createdAt': widget.productModel!.createdAt,
        });

        Fluttertoast.showToast(
          msg: "Product edited",
          textColor: Colors.white,
        );
        if (!mounted) return;
        MyAppFunctions.showErrorOrWarningDialog(
            isError: false,
            context: context,
            subtitle: "Clear Form?",
            fct: () {
              clearForm();
            });
      } on FirebaseException catch (error) {
        await MyAppFunctions.showErrorOrWarningDialog(
          context: context,
          fct: () {},
          subtitle: error.message.toString(),
        );
      } catch (error) {
        await MyAppFunctions.showErrorOrWarningDialog(
          context: context,
          fct: () {},
          subtitle: error.toString(),
        );
      }
      {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> localImagePicker() async {
    final ImagePicker picker = ImagePicker();
    await MyAppFunctions.imagePickerDialog(
        context: context,
        cameraFCT: () async {
          _pickedImage = await picker.pickImage(source: ImageSource.camera);
          setState(() {
            productNetworkImage = null;
          });
        },
        galleryFCT: () async {
          _pickedImage = await picker.pickImage(source: ImageSource.gallery);
          setState(() {
            productNetworkImage = null;
          });
        },
        removeFCT: () {
          setState(() {
            _pickedImage = null;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Loadingmanager(
      isLoading: _isLoading,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          bottomSheet: SizedBox(
            height: kBottomNavigationBarHeight + 10,
            child: Material(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.clear),
                    label: const Text(
                      "Clear",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      clearForm();
                    },
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.upload),
                    label: Text(
                      isEditing ? "Edit product" : "Upload product",
                      style: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      if (isEditing) {
                        _editProduct();
                      } else {
                        _uploadProduct();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            centerTitle: true,
            title: TitleTextWidget(
              label: isEditing ? "Edit Product " : "Upload a new product",
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  if (isEditing && productNetworkImage != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        productNetworkImage!,
                        height: size.width * 0.5,
                        alignment: Alignment.center,
                      ),
                    ),
                  ] else if (_pickedImage == null) ...[
                    SizedBox(
                      height: size.width * 0.4,
                      width: size.width * 0.4 + 10,
                      child: DottedBorder(
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.image_outlined,
                                size: 80,
                                color: Colors.blue,
                              ),
                              TextButton(
                                onPressed: () {
                                  localImagePicker();
                                },
                                child: const Text("Pick Product Image"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(
                          _pickedImage!.path,
                        ),
                        height: size.width * 0.5,
                        alignment: Alignment.center,
                      ),
                    ),
                  ],
                  if (_pickedImage != null || productNetworkImage != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            localImagePicker();
                          },
                          child: const Text(
                            "Pick another Image",
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            removePickedImage();
                          },
                          child: const Text(
                            "Remove Image",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    )
                  ],
                  const SizedBox(height: 20),
                  DropdownButton(
                    items: AppConstants.categoriesDropDownList,
                    value: _categoryValue,
                    hint: const Text("Choose a Category"),
                    onChanged: (String? value) {
                      setState(() {
                        _categoryValue = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _titleController,
                            key: const ValueKey('Title'),
                            maxLength: 80,
                            maxLines: 2,
                            minLines: 1,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            decoration: const InputDecoration(
                                helperText: 'Products title'),
                            validator: (value) {
                              return MyValidator.uploadProductTexts(
                                value: value,
                                toBeReturnedString:
                                    "Please enter a valid title",
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: TextFormField(
                                  controller: _priceController,
                                  key: const ValueKey('Price\$'),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'^(\d+)?\.?\d{0,2}'),
                                    ),
                                  ],
                                  decoration: const InputDecoration(
                                    hintText: 'Price ',
                                    prefix: SubTitleTextWidget(
                                      label: "₹ ",
                                      color: Colors.blue,
                                      fontSize: 16,
                                    ),
                                  ),
                                  validator: (value) {
                                    return MyValidator.uploadProductTexts(
                                      value: value,
                                      toBeReturnedString: "Price is missing",
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                flex: 1,
                                child: TextFormField(
                                  controller: _quantityController,
                                  key: const ValueKey('Quantity'),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: const InputDecoration(
                                    hintText: 'Qty',
                                  ),
                                  validator: (value) {
                                    return MyValidator.uploadProductTexts(
                                      value: value,
                                      toBeReturnedString: "Quantity is missing",
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _descriptionController,
                            key: const ValueKey('Description'),
                            minLines: 5,
                            maxLines: 8,
                            maxLength: 1000,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                                hintText: "Product Description"),
                            validator: (value) {
                              return MyValidator.uploadProductTexts(
                                value: value,
                                toBeReturnedString: "Description is missing",
                              );
                            },
                            onTap: () {},
                          ),
                        ],
                      ),
                       
                    ),
                  ),
                  const SizedBox(height: kBottomNavigationBarHeight + 30)
                ],
                
              ),
            ),
          ),
        ),
      ),
    );
  }
}
