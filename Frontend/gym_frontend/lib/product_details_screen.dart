import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import 'theme.dart';
import 'l10n/app_localizations.dart';
import 'config/api_config.dart';
import 'config/api_client.dart';


class ProductDetailsScreen extends StatefulWidget {
  final dynamic prodId;
  final Map<String, dynamic> user;

  const ProductDetailsScreen({required this.prodId, required this.user, super.key});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  Map<String, dynamic> product = {};
  final TextEditingController _componentSearchController = TextEditingController(); 
  List<Map<String, dynamic>> allComponents = [];
  List<Map<String, dynamic>> requiredComponents = [];
  File? _pickedImage;
  final picker = ImagePicker();

  final TextEditingController stockController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  List<Map<String, TextEditingController>> additionalInfo = [];

  bool _loading = false;
  bool get isAdmin => widget.user['type_account'] == 'admin';
  bool get isNewProduct => widget.prodId == null;

  @override
  void initState() {
    super.initState();
    // Set default stock value for new products
    if (isNewProduct) {
      stockController.text = '0';
    }
    fetchAllComponents();
    if (widget.prodId != null) fetchProduct();
  }

  @override
  void dispose() {
    _componentSearchController.dispose();
    stockController.dispose();
    nameController.dispose();
    categoryController.dispose();
    descController.dispose();
    
    // Dispose additional info controllers
    for (var entry in additionalInfo) {
      entry['key']?.dispose();
      entry['value']?.dispose();
    }
    
    super.dispose();
  }

  int? getProdId() {
    if (widget.prodId == null) return null;
    return widget.prodId is int ? widget.prodId : int.tryParse(widget.prodId.toString());
  }

  Future<void> fetchAllComponents() async {
    try {
      final res = await ApiClient.get('/api/components');
      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        if (decoded is List) {
          setState(() {
            allComponents = decoded.map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).toList();
          });
        } else {
          showError(AppLocalizations.of(context)!.productDetailsUnexpectedComponentsFormat);
        }
      } else {
        showError('${AppLocalizations.of(context)!.productDetailsFailedToLoadComponents}: ${res.statusCode}');
        print('fetchAllComponents statusCode=${res.statusCode} body=${res.body}');
      }
    } catch (e, st) {
      print('Error in fetchAllComponents: $e\n$st');
      showError(AppLocalizations.of(context)!.productDetailsErrorFetchingComponents);
    }
  }

  Future<void> fetchProduct() async {
    final prodId = getProdId();
    if (prodId == null) return;

    setState(() => _loading = true);
    try {
      final res = await ApiClient.get('/api/products/$prodId');
      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        if (decoded is Map<String, dynamic>) {
          setState(() {
            product = decoded;
            nameController.text = product['name'] ?? '';
            categoryController.text = product['category'] ?? '';
            descController.text = product['description'] ?? '';
            stockController.text = product['stock']?.toString() ?? '0';

            additionalInfo.clear();
            List infos = [];
            if (product['additional_info'] != null) {
              if (product['additional_info'] is List) {
                infos = product['additional_info'];
              } else {
                try {
                  infos = jsonDecode(product['additional_info']);
                } catch (e) {
                  print('Failed to parse additional_info: $e');
                }
              }
            }
            for (var info in infos) {
              if (info is Map) {
                additionalInfo.add({
                  'key': TextEditingController(text: info['key'] ?? ''),
                  'value': TextEditingController(text: info['value'] ?? ''),
                });
              }
            }

            requiredComponents = [];
            if (product['required_components'] is List) {
              requiredComponents = List<Map<String, dynamic>>.from(product['required_components']);
            }
          });
        } else {
          showError(AppLocalizations.of(context)!.productDetailsUnexpectedProductFormat);
          print('fetchProduct unexpected response type: ${decoded.runtimeType}');
        }
      } else {
        showError('${AppLocalizations.of(context)!.productDetailsFailedToLoadProduct}: ${res.statusCode}');
        print('fetchProduct statusCode=${res.statusCode} body=${res.body}');
      }
    } catch (e, st) {
      print('Error in fetchProduct: $e\n$st');
      showError(AppLocalizations.of(context)!.productDetailsErrorFetchingProduct);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void showError(String msg) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void showSuccess(String msg) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.green,
      )
    );
  }

  Future<void> pickImage() async {
    try {
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null && mounted) setState(() => _pickedImage = File(picked.path));
    } catch (e, st) {
      print('Error in pickImage: $e\n$st');
      showError(AppLocalizations.of(context)!.productDetailsErrorPickingImage);
    }
  }

  void addAdditionalInfoEntry() {
    setState(() {
      additionalInfo.add({
        'key': TextEditingController(),
        'value': TextEditingController(),
      });
    });
  }

  void removeAdditionalInfoEntry(int index) {
    if (index >= 0 && index < additionalInfo.length) {
      // Dispose controllers before removing
      additionalInfo[index]['key']?.dispose();
      additionalInfo[index]['value']?.dispose();
      setState(() => additionalInfo.removeAt(index));
    }
  }

  void addRequiredComponent(Map<String, dynamic> comp, int quantity) {
    if (quantity <= 0) return;
    setState(() {
      // Check if the component is already in the list
      final existingIndex = requiredComponents.indexWhere((element) => element['component_id'] == comp['id']);
      if (existingIndex != -1) {
        // Update quantity if component already exists
        requiredComponents[existingIndex]['quantity_required'] += quantity;
      } else {
        // Add new component
        requiredComponents.add({
          'component_id': comp['id'],
          'name': comp['name'],
          'quantity_required': quantity,
          'stock': comp['stock'],
        });
      }
    });
  }


  void removeRequiredComponent(int index) {
    if (index >= 0 && index < requiredComponents.length) {
      setState(() => requiredComponents.removeAt(index));
    }
  }

  void _showAddRequiredComponentDialog() {
  Map<String, dynamic>? selectedComp;
  final qtyController = TextEditingController(text: '1');

  _componentSearchController.clear();
  
  // Initialize filtered list
  List<Map<String, dynamic>> dialogFilteredComponents = List.from(allComponents);

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setStateInDialog) {
          // Set initial selected component if none selected and list is not empty
          if (selectedComp == null && dialogFilteredComponents.isNotEmpty) {
            selectedComp = dialogFilteredComponents.first;
          }

          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.productDetailsAddRequiredComponent),
            content: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
                maxWidth: 400,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _componentSearchController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.productDetailsSearchComponentByReference,
                        hintText: AppLocalizations.of(context)!.productDetailsEnterReference,
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (query) {
                        setStateInDialog(() {
                          final lowerCaseQuery = query.toLowerCase();
                          dialogFilteredComponents = allComponents.where((comp) {
                            final componentRef = (comp['reference'] ?? '').toLowerCase();
                            final componentName = (comp['name'] ?? '').toLowerCase();
                            return componentRef.contains(lowerCaseQuery) || 
                                   componentName.contains(lowerCaseQuery);
                          }).toList();
                          
                          // Reset selection when filtering
                          if (dialogFilteredComponents.isEmpty) {
                            selectedComp = null;
                          } else {
                            // Find if current selection still exists in filtered list by ID comparison
                            final currentId = selectedComp?['id'];
                            final stillExists = dialogFilteredComponents.any((comp) => comp['id'] == currentId);
                            
                            if (!stillExists) {
                              selectedComp = dialogFilteredComponents.first;
                            } else {
                              // Update reference to the item in the new list
                              selectedComp = dialogFilteredComponents.firstWhere((comp) => comp['id'] == currentId);
                            }
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Show dropdown or message based on filtered components
                    if (dialogFilteredComponents.isNotEmpty)
                      DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.productDetailsComponent,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        value: selectedComp?['id'],
                        items: dialogFilteredComponents.map((comp) {
                          return DropdownMenuItem<int>(
                            value: comp['id'],
                            child: Text(
                              '${comp['name'] ?? AppLocalizations.of(context)!.productDetailsUnknown} (${comp['reference'] ?? AppLocalizations.of(context)!.productDetailsNoRef})',
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setStateInDialog(() {
                            selectedComp = dialogFilteredComponents.firstWhere((comp) => comp['id'] == val);
                          });
                        },
                        isExpanded: true,
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          AppLocalizations.of(context)!.productDetailsNoComponentsFound,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    
                    const SizedBox(height: 16),
                    TextField(
                      controller: qtyController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.productDetailsQuantityRequired,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: '1',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  qtyController.dispose();
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              ElevatedButton(
                onPressed: dialogFilteredComponents.isEmpty ? null : () {
                  final qty = int.tryParse(qtyController.text) ?? 0;
                  
                  if (selectedComp == null) {
                    showError(AppLocalizations.of(context)!.productDetailsPleaseSelectComponent);
                    return;
                  }
                  
                  if (qty <= 0) {
                    showError(AppLocalizations.of(context)!.productDetailsQuantityPositive);
                    return;
                  }
                  
                  addRequiredComponent(selectedComp!, qty);
                  qtyController.dispose();
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.productDetailsAdd),
              ),
            ],
          );
        },
      );
    },
  );
}

  Future<void> saveProduct() async {  
    // Enhanced validation
    if (nameController.text.trim().isEmpty) {
      showError(AppLocalizations.of(context)!.productDetailsNameRequired);
      return;
    }

    final stockText = stockController.text.trim();
    if (stockText.isEmpty) {
      showError(AppLocalizations.of(context)!.productDetailsStockRequired);
      return;
    }

    final stock = int.tryParse(stockText);
    if (stock == null) {
      showError(AppLocalizations.of(context)!.productDetailsStockValidNumber);
      return;
    }

    if (stock < 0) {
      showError(AppLocalizations.of(context)!.productDetailsStockCannotBeNegative);
      return;
    }

    setState(() => _loading = true);

    final uri = widget.prodId == null
        ? Uri.parse(ApiConfig.getApiUrl('/api/products'))
        : Uri.parse(ApiConfig.getApiUrl('/api/products/${getProdId()}'));

    try {
      final request = http.MultipartRequest(widget.prodId == null ? 'POST' : 'PUT', uri);
      final token = await ApiClient.getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.fields['name'] = nameController.text.trim();
      request.fields['category'] = categoryController.text.trim();
      request.fields['description'] = descController.text.trim();
      request.fields['stock'] = stock.toString();
      request.fields['user_id'] = widget.user['id'].toString();
      request.fields['additional_info'] = jsonEncode(additionalInfo.map((e) => {
            'key': e['key']!.text.trim(),
            'value': e['value']!.text.trim(),
          }).toList());
      request.fields['required_components'] = jsonEncode(requiredComponents);

      if (_pickedImage != null) {
        final mimeType = lookupMimeType(_pickedImage!.path);
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          _pickedImage!.path,
          contentType: mimeType != null ? MediaType.parse(mimeType) : null,
        ));
      }

      if (widget.prodId != null && _pickedImage == null && product['image_path'] == null) {
        request.fields['remove_image'] = 'true';
      }

      final streamedRes = await request.send();
      final res = await http.Response.fromStream(streamedRes);

      if (res.statusCode == 200 || res.statusCode == 201) {
        final decoded = jsonDecode(res.body);
        if (decoded is Map<String, dynamic>) {
          final successMessage = isNewProduct 
              ? AppLocalizations.of(context)!.productDetailsCreateSuccess 
              : AppLocalizations.of(context)!.productDetailsUpdateSuccess;
          showSuccess(successMessage);
          Navigator.pop(context, decoded);
        } else {
          showError(AppLocalizations.of(context)!.productDetailsUnexpectedResponseFormat);
        }
      } else {
        // Try to parse error message from response
        try {
          final errorDecoded = jsonDecode(res.body);
          final errorMessage = errorDecoded['message'] ?? errorDecoded['error'] ?? AppLocalizations.of(context)!.unknownErrorOccurred;
          showError('${AppLocalizations.of(context)!.productDetailsFailedTo} ${isNewProduct ? AppLocalizations.of(context)!.create : AppLocalizations.of(context)!.save} ${AppLocalizations.of(context)!.productDetailsProduct}: $errorMessage');
        } catch (e) {
          showError('${AppLocalizations.of(context)!.productDetailsFailedTo} ${isNewProduct ? AppLocalizations.of(context)!.create : AppLocalizations.of(context)!.save} ${AppLocalizations.of(context)!.productDetailsProduct}: ${res.statusCode}');
        }
        print('saveProduct statusCode=${res.statusCode} body=${res.body}');
      }
    } catch (e, st) {
      print('Error in saveProduct: $e\n$st');
      showError('${AppLocalizations.of(context)!.productDetailsError} ${isNewProduct ? AppLocalizations.of(context)!.creating : AppLocalizations.of(context)!.productDetailsSaving} ${AppLocalizations.of(context)!.productDetailsProduct}');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> deleteProduct() async {
    final prodId = getProdId();
    if (prodId == null) return;

    // Show confirmation dialog
    bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirmDeleteTitle),
          content: Text(AppLocalizations.of(context)!.productDetailsConfirmDeleteMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(AppLocalizations.of(context)!.delete, style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    setState(() => _loading = true);
    try {
      final res = await ApiClient.delete('/api/products/$prodId');
      if (res.statusCode == 200) {
        showSuccess(AppLocalizations.of(context)!.productDetailsDeleteSuccess);
        Navigator.pop(context, {'deletedId': prodId});
      } else {
        showError('${AppLocalizations.of(context)!.productDetailsFailedToDeleteProduct}: ${res.statusCode}');
        print('deleteProduct statusCode=${res.statusCode} body=${res.body}');
      }
    } catch (e, st) {
      print('Error in deleteProduct: $e\n$st');
      showError(AppLocalizations.of(context)!.productDetailsErrorDeletingProduct);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> produceProduct() async {
  final prodId = getProdId();
  if (prodId == null) return;

  setState(() => _loading = true);
  try {
    final res = await ApiClient.post(
      '/api/products/$prodId/produce',
      {'user_id': widget.user['id']},
    );
    
    if (res.statusCode == 200) {
      showSuccess(AppLocalizations.of(context)!.productDetailsProduceSuccess);
      fetchProduct();
    } else {
      // Try to parse the error response
      try {
        final errorData = jsonDecode(res.body);
        
        // Check if there are insufficient components
        if (errorData['insufficientComponents'] != null && 
            errorData['insufficientComponents'] is List) {
          _showInsufficientStockDialog(
            List<Map<String, dynamic>>.from(errorData['insufficientComponents'])
          );
        } else {
          showError('${AppLocalizations.of(context)!.productDetailsFailedToProduce}: ${res.statusCode}');
        }
      } catch (e) {
        showError('${AppLocalizations.of(context)!.productDetailsFailedToProduce}: ${res.statusCode}');
      }
      print('produceProduct statusCode=${res.statusCode} body=${res.body}');
    }
  } catch (e, st) {
    print('Error in produceProduct: $e\n$st');
    showError(AppLocalizations.of(context)!.productDetailsErrorProducingProduct);
  } finally {
    if (mounted) setState(() => _loading = false);
  }
}

Future<void> sellProduct() async {
  final prodId = getProdId();
  if (prodId == null) return;

  // Check if there's stock to sell
  final currentStock = int.tryParse(stockController.text) ?? 0;
  if (currentStock <= 0) {
    showError(AppLocalizations.of(context)!.productDetailsNoStockToSell);
    return;
  }

  // Show confirmation dialog
  bool? shouldSell = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.productDetailsConfirmSell),
        content: Text(AppLocalizations.of(context)!.productDetailsConfirmSellMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(AppLocalizations.of(context)!.productDetailsConfirm),
          ),
        ],
      );
    },
  );

  if (shouldSell != true) return;

  setState(() => _loading = true);
  try {
    // Update stock by -1
    final newStock = currentStock - 1;
    
    final res = await http.put(
      Uri.parse(ApiConfig.getApiUrl('/api/products/$prodId')),
      headers: {
        'Content-Type': 'application/json',
        ...(await ApiClient.getToken() != null ? {'Authorization': 'Bearer ${await ApiClient.getToken()}'} : {}),
      },
      body: jsonEncode({
        'name': nameController.text.trim(),
        'category': categoryController.text.trim(),
        'description': descController.text.trim(),
        'stock': newStock,
        'user_id': widget.user['id'],
        'additional_info': jsonEncode(additionalInfo.map((e) => {
          'key': e['key']!.text.trim(),
          'value': e['value']!.text.trim(),
        }).toList()),
        'required_components': jsonEncode(requiredComponents),
      }),
    );
    
    if (res.statusCode == 200) {
      showSuccess(AppLocalizations.of(context)!.productDetailsSellSuccess);
      fetchProduct();
    } else {
      showError('${AppLocalizations.of(context)!.productDetailsFailedToSell}: ${res.statusCode}');
      print('sellProduct statusCode=${res.statusCode} body=${res.body}');
    }
  } catch (e, st) {
    print('Error in sellProduct: $e\n$st');
    showError(AppLocalizations.of(context)!.productDetailsErrorSelling);
  } finally {
    if (mounted) setState(() => _loading = false);
  }
}

void _showInsufficientStockDialog(List<Map<String, dynamic>> insufficientComponents) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 28,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.productDetailsProductionFailed,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.productDetailsInsufficientStockMessage,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.error.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.productDetailsMissingComponents,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...insufficientComponents.map((comp) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.extension,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    comp['name'] ?? AppLocalizations.of(context)!.productDetailsUnknownComponent,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.only(left: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.productDetailsRequiredQuantity(comp['required']?.toString() ?? '0'),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.productDetailsAvailableQuantity(comp['available']?.toString() ?? '0'),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.productDetailsShortage(comp['shortage']?.toString() ?? '0'),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.error,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(AppLocalizations.of(context)!.productDetailsClose),
          ),
        ],
      );
    },
  );
}

  Widget _buildAdditionalInfoCard(int index) {
    final entry = additionalInfo[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: entry['key'],
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.productDetailsKey),
              enabled: isAdmin,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: entry['value'],
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.productDetailsValue),
              enabled: isAdmin,
            ),
          ),
          
        ],
      ),
    );
  }

  Widget _buildRequiredComponentCard(int index) {
    final rc = requiredComponents[index];
    final qtyController = TextEditingController(text: rc['quantity_required']?.toString() ?? '');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(rc['name'] ?? AppLocalizations.of(context)!.productDetailsUnknownComponent),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.productDetailsQuantityRequired),
              enabled: isAdmin,
              onChanged: (val) {
                rc['quantity_required'] = int.tryParse(val) ?? 0;
              },
            ),
          ),
          
        ],
      ),
    );
  }

  BoxDecoration? _getBackgroundDecoration(BuildContext context) {
    final ext = Theme.of(context).extension<CustomThemeExtension>();
    if (ext?.backgroundGradient != null) {
      return BoxDecoration(gradient: ext!.backgroundGradient);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
  Widget imageWidget = const Icon(Icons.fitness_center, size: 100);
  if (_pickedImage != null) {
    imageWidget = Image.file(_pickedImage!, height: 100);
  } else if (product['image_path'] != null && product['image_path'].toString().isNotEmpty) {
    imageWidget = Image.network(
      ApiConfig.getUploadUrl(product['image_path']),
      height: 100,
      errorBuilder: (_, __, ___) => const Icon(Icons.fitness_center, size: 100),
    );
  }

  return Scaffold(
    appBar: AppBar(
      leading: BackButton(
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          AppLogo(),
          const SizedBox(width: 8),
          Text(isNewProduct ? AppLocalizations.of(context)!.productDetailsAddProduct : AppLocalizations.of(context)!.productDetailsDetails),
        ],
      ),
      actions: [
        if (!isNewProduct)
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: AppLocalizations.of(context)!.productsRefresh,
            onPressed: fetchProduct,
          ),
      ],
    ),
    body: Container(
      decoration: _getBackgroundDecoration(context),
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: imageWidget),
                    if (isAdmin)
                      Center(
                        child: ElevatedButton(
                          onPressed: pickImage,
                          child: Text(AppLocalizations.of(context)!.productDetailsChooseImage),
                        ),
                      ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.productDetailsName,
                        hintText: AppLocalizations.of(context)!.productDetailsEnterProductName,
                      ),
                      enabled: isAdmin,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: categoryController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.productDetailsCategory,
                        hintText: AppLocalizations.of(context)!.productDetailsEnterProductCategory,
                      ),
                      enabled: isAdmin,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.productDetailsDescription,
                        hintText: AppLocalizations.of(context)!.productDetailsEnterProductDescription,
                      ),
                      enabled: isAdmin,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: stockController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.productDetailsStock,
                              hintText: AppLocalizations.of(context)!.productDetailsEnterStockQuantity,
                            ),
                            enabled: isAdmin,
                            readOnly: !isAdmin,
                          ),
                        ),
                        if (!isNewProduct) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: produceProduct,
                              icon: const Icon(Icons.add_circle, size: 18),
                              label: Text(AppLocalizations.of(context)!.productDetailsProduce),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: sellProduct,
                              icon: const Icon(Icons.remove_circle, size: 18),
                              label: Text(AppLocalizations.of(context)!.productDetailsSell),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(AppLocalizations.of(context)!.productDetailsAdditionalInfo, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ...List.generate(additionalInfo.length, _buildAdditionalInfoCard),
                    if (isAdmin)
                      Center(
                        child: ElevatedButton(
                          onPressed: addAdditionalInfoEntry,
                          child: Text(AppLocalizations.of(context)!.productDetailsAddInfo),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Text(AppLocalizations.of(context)!.productDetailsRequiredComponents, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ...List.generate(requiredComponents.length, _buildRequiredComponentCard),
                    if (isAdmin)
                      Center(
                        child: ElevatedButton(
                          onPressed: _showAddRequiredComponentDialog,
                          child: Text(AppLocalizations.of(context)!.productDetailsAddComponent),
                        ),
                      ),
                    const SizedBox(height: 16),
                    if (isAdmin)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: saveProduct,
                              child: Text(isNewProduct ? AppLocalizations.of(context)!.create : AppLocalizations.of(context)!.save),
                            ),
                          ),
                          if (!isNewProduct) ...[
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: deleteProduct,
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ],
                      ),
                  ],
                ),
              ),
            ),
    ),
  );
}
}