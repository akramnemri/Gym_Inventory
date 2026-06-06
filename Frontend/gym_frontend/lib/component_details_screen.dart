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

class ComponentDetailsScreen extends StatefulWidget {
  final dynamic compId;
  final Map<String, dynamic> user;

  const ComponentDetailsScreen({required this.compId, required this.user, super.key});

  @override
  _ComponentDetailsScreenState createState() => _ComponentDetailsScreenState();
}

class _ComponentDetailsScreenState extends State<ComponentDetailsScreen> {
  Map<String, dynamic> component = {};
  File? _pickedImage;
  final picker = ImagePicker();

  final TextEditingController stockController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController dimensionsController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController diameterController = TextEditingController(); // Added diameter controller
  final TextEditingController referenceController = TextEditingController();

  List<Map<String, TextEditingController>> additionalInfo = [];

  bool _loading = false;
  bool get isAdmin => widget.user['type_account'] == 'admin';

  final Map<String, int> typeOptions = {
    'Prime Material': 1,
    'Consumable Pieces': 2,
    'Standard Pieces': 3,
    'Furniture': 4,
  };
  String selectedType = 'Prime Material';

  Map<String, String> getLocalizedTypeOptions(BuildContext context) {
    return {
      'Prime Material': AppLocalizations.of(context)!.componentTypePrimeMaterial,
      'Consumable Pieces': AppLocalizations.of(context)!.componentTypeConsumablePieces,
      'Standard Pieces': AppLocalizations.of(context)!.componentTypeStandardPieces,
      'Furniture': AppLocalizations.of(context)!.componentTypeFurniture,
    };
  }

  @override
  void initState() {
    super.initState();
    if (widget.compId != null) fetchComponent();
  }

  int? getCompId() {
    if (component['id'] != null) {
      return component['id'] is int
          ? component['id']
          : int.tryParse(component['id'].toString());
    }
    if (widget.compId != null) {
      return widget.compId is int ? widget.compId : int.tryParse(widget.compId.toString());
    }
    return null;
  }

  Future<void> fetchComponent() async {
    final compId = getCompId();
    if (compId == null) return;

    setState(() => _loading = true);
    try {
      final res = await ApiClient.get('/api/components/$compId');
      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        if (decoded is Map<String, dynamic>) {
          component = decoded;

          // Load main fields
          nameController.text = component['name'] ?? '';
          lengthController.text = component['length']?.toString() ?? '0';
          weightController.text = component['weight']?.toString() ?? '0';
          stockController.text = component['stock']?.toString() ?? '0';
          descController.text = component['description'] ?? '';
          dimensionsController.text = component['dimensions'] ?? '';
          heightController.text = component['height']?.toString() ?? '0';
          diameterController.text = component['diameter']?.toString() ?? '0'; // Load diameter
          referenceController.text = component['reference'] ?? '';
          selectedType = typeOptions.entries.firstWhere(
            (e) => e.value == (component['type_id'] ?? 1),
            orElse: () => MapEntry('Prime Material', 1),
          ).key;

          // Load additional info
          additionalInfo.clear();
          List infos = [];
          if (component['additional_info'] != null) {
            if (component['additional_info'] is List) {
              infos = component['additional_info'];
            } else {
              try {
                infos = jsonDecode(component['additional_info']);
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
        } else {
          showError(AppLocalizations.of(context)!.componentDetailsUnexpectedFormat);
          print('fetchComponent unexpected response type: ${decoded.runtimeType}');
        }
      } else {
        showError('${AppLocalizations.of(context)!.componentDetailsFailedToLoad}: ${res.statusCode}');
        print('fetchComponent statusCode=${res.statusCode} body=${res.body}');
      }
    } catch (e, st) {
      print('Error in fetchComponent: $e\n$st');
      showError(AppLocalizations.of(context)!.componentDetailsErrorFetching);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void showError(String msg) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> pickImage() async {
    try {
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null && mounted) setState(() => _pickedImage = File(picked.path));
    } catch (e, st) {
      print('Error in pickImage: $e\n$st');
      showError(AppLocalizations.of(context)!.componentDetailsErrorPicking);
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
      setState(() => additionalInfo.removeAt(index));
    }
  }

  void incrementStock() {
    int val = int.tryParse(stockController.text) ?? 0;
    setState(() => stockController.text = (val + 1).toString());
  }

  void decrementStock() {
    int val = int.tryParse(stockController.text) ?? 0;
    if (val > 0) setState(() => stockController.text = (val - 1).toString());
  }

  bool _validateForm() {
  if (nameController.text.trim().isEmpty) {
    showError(AppLocalizations.of(context)!.componentDetailsNameRequired);
    return false;
  }
  if (selectedType.isEmpty) {
    showError(AppLocalizations.of(context)!.componentDetailsTypeRequired);
    return false;
  }
  // Add more validations if needed for other required fields
  return true;
}

  Future<void> saveComponent() async {
    if (!_validateForm()) return;
    setState(() => _loading = true);

    final uri = widget.compId == null
        ? Uri.parse(ApiConfig.getApiUrl('/api/components'))
        : Uri.parse(ApiConfig.getApiUrl('/api/components/${getCompId()}'));

    try {
      final request = http.MultipartRequest(widget.compId == null ? 'POST' : 'PUT', uri);
      final token = await ApiClient.getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.fields['name'] = nameController.text;
      request.fields['type_id'] = typeOptions[selectedType].toString();
      request.fields['length'] = lengthController.text;
      request.fields['weight'] = weightController.text;
      request.fields['description'] = descController.text;
      request.fields['stock'] = stockController.text;
      request.fields['user_id'] = widget.user['id'].toString();
      request.fields['dimensions'] = dimensionsController.text;
      request.fields['height'] = heightController.text;
      request.fields['diameter'] = diameterController.text; // Send diameter
      request.fields['reference'] = referenceController.text;
      request.fields['additional_info'] = jsonEncode(additionalInfo.map((e) => {
            'key': e['key']!.text,
            'value': e['value']!.text,
          }).toList());

      if (_pickedImage != null) {
        final mimeType = lookupMimeType(_pickedImage!.path);
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          _pickedImage!.path,
          contentType: mimeType != null ? MediaType.parse(mimeType) : null,
        ));
      }

      if (widget.compId != null && _pickedImage == null && component['image_path'] == null) {
        request.fields['remove_image'] = 'true';
      }

      final streamedRes = await request.send();
      final res = await http.Response.fromStream(streamedRes);

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        if (decoded is Map<String, dynamic>) {
          // Show success message
          final action = widget.compId == null 
            ? AppLocalizations.of(context)!.componentDetailsCreatedSuccess
            : AppLocalizations.of(context)!.componentDetailsUpdatedSuccess;
          showError(action);
          
          // Update local component data if editing existing component
          if (widget.compId != null) {
            setState(() {
              component = decoded;
            });
          }
          
          // Return result to parent screen for refresh
          Navigator.pop(context, decoded);
        } else {
          showError(AppLocalizations.of(context)!.componentDetailsUnexpectedResponse);
        }
      } else {
        // Handle validation errors from backend
        try {
          final decoded = jsonDecode(res.body);
          final message = decoded['message'] ?? '${AppLocalizations.of(context)!.componentDetailsFailedToSave}: ${res.statusCode}';
          showError(message);
        } catch (e) {
          showError('${AppLocalizations.of(context)!.componentDetailsFailedToSave}: ${res.statusCode}');
        }
        print('saveComponent statusCode=${res.statusCode} body=${res.body}');
      }
    } catch (e, st) {
      print('Error in saveComponent: $e\n$st');
      showError(AppLocalizations.of(context)!.componentDetailsErrorSaving);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> deleteComponent() async {
    final compId = getCompId();
    if (compId == null) return;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.componentDetailsConfirmDeleteTitle),
        content: Text(AppLocalizations.of(context)!.componentDetailsConfirmDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.delete, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _loading = true);
    try {
      final res = await ApiClient.delete('/api/components/$compId');
      if (res.statusCode == 200) {
        showError(AppLocalizations.of(context)!.componentDetailsDeletedSuccess);
        // Return deletion result to parent screen for refresh
        Navigator.pop(context, {'deletedId': compId});
      } else {
        showError('${AppLocalizations.of(context)!.componentDetailsFailedToDelete}: ${res.statusCode}');
        print('deleteComponent statusCode=${res.statusCode} body=${res.body}');
      }
    } catch (e, st) {
      print('Error in deleteComponent: $e\n$st');
      showError(AppLocalizations.of(context)!.componentDetailsErrorDeleting);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
  
  Future<bool> _onWillPop() async {
    // Check if there are unsaved changes (only for admins who can edit)
    if (!isAdmin) return true;
    
    // Simple check for changes - you can make this more sophisticated
    bool hasChanges = nameController.text != (component['name'] ?? '') ||
                     stockController.text != (component['stock']?.toString() ?? '0') ||
                     diameterController.text != (component['diameter']?.toString() ?? '0') || // Check diameter
                     // Add more field checks as needed
                     false;

    if (!hasChanges) return true;

    // Show confirmation dialog for unsaved changes
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.componentDetailsUnsavedChanges),
        content: Text(AppLocalizations.of(context)!.componentDetailsUnsavedMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.componentDetailsStay),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.componentDetailsLeave, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;
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
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.componentDetailsKey),
              enabled: isAdmin,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: entry['value'],
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.componentDetailsValue),
              enabled: isAdmin,
            ),
          ),
          if (isAdmin)
            IconButton(
              onPressed: () => removeAdditionalInfoEntry(index),
              icon: const Icon(Icons.remove_circle, color: Colors.red),
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
    Widget imageWidget = const Icon(Icons.extension, size: 100);
    if (_pickedImage != null) {
      imageWidget = Image.file(_pickedImage!, height: 100);
    } else if (component['image_path'] != null && component['image_path'].toString().isNotEmpty) {
      imageWidget = Image.network(
        ApiConfig.getUploadUrl(component['image_path']),
        height: 100,
        errorBuilder: (_, __, ___) => const Icon(Icons.extension, size: 100),
      );
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.pop(context);
              }
            },
          ),
          title: Row(
            children: [
              AppLogo(),
              const SizedBox(width: 8),
              Text(widget.compId == null 
                ? AppLocalizations.of(context)!.componentDetailsAdd 
                : AppLocalizations.of(context)!.componentDetailsTitle),
            ],
          ),
          actions: [
            if (widget.compId != null)
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: AppLocalizations.of(context)!.componentDetailsRefresh,
                onPressed: fetchComponent,
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
                                onPressed: pickImage, child: Text(AppLocalizations.of(context)!.componentDetailsChooseImage))),
                      const SizedBox(height: 16),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: AppLocalizations.of(context)!.componentDetailsName),
                        enabled: isAdmin,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedType,
                        decoration: InputDecoration(labelText: AppLocalizations.of(context)!.componentDetailsType),
                        items: getLocalizedTypeOptions(context).entries
                            .map((entry) => DropdownMenuItem(
                              value: entry.key, // Keep English key as value
                              child: Text(entry.value), // Display localized text
                            ))
                            .toList(),
                        onChanged: isAdmin
                            ? (val) {
                                if (val != null) setState(() => selectedType = val);
                              }
                            : null,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: lengthController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: AppLocalizations.of(context)!.componentDetailsLength),
                        enabled: isAdmin,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: weightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: AppLocalizations.of(context)!.componentDetailsWeight),
                        enabled: isAdmin,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: dimensionsController,
                        decoration: InputDecoration(labelText: AppLocalizations.of(context)!.componentDetailsDimensions),
                        enabled: isAdmin,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: heightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: AppLocalizations.of(context)!.componentDetailsHeight),
                        enabled: isAdmin,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: diameterController, // New TextField for diameter
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: AppLocalizations.of(context)!.componentDetailsDiameter), // Localized label
                        enabled: isAdmin,
                      ),
                      const SizedBox(height: 8),
                  TextField(
  controller: referenceController,
  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.componentDetailsReference),
  enabled: isAdmin,
),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: stockController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.componentDetailsStock),
                              enabled: true,
                            ),
                          ),
                          IconButton(onPressed: decrementStock, icon: const Icon(Icons.remove)),
                          IconButton(onPressed: incrementStock, icon: const Icon(Icons.add)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: descController,
                        decoration: InputDecoration(labelText: AppLocalizations.of(context)!.componentDetailsDescription),
                        enabled: isAdmin,
                      ),
                      const SizedBox(height: 16),
                      Text(AppLocalizations.of(context)!.componentDetailsAdditionalInfo, style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...List.generate(additionalInfo.length, _buildAdditionalInfoCard),
                      if (isAdmin)
                        Center(
                          child: ElevatedButton(onPressed: addAdditionalInfoEntry, child: Text(AppLocalizations.of(context)!.componentDetailsAddInfo)),
                        ),
                      const SizedBox(height: 16),
                      Row(
  children: [
    Expanded(
        child: ElevatedButton(
            onPressed: saveComponent, child: Text(AppLocalizations.of(context)!.componentDetailsSave))),
    const SizedBox(width: 8),
    if (isAdmin) // Only admins can delete
      Expanded(
          child: ElevatedButton(
              onPressed: component['id'] != null ? deleteComponent : null,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(AppLocalizations.of(context)!.componentDetailsDelete))),
  ],
),
                    ],
                  ),
                ),
              ),
      ),
    ));
  }
}