import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../model/addstyle.dart';
import '../../model/meniitem.dart';
import '../../model/statcic_menucategory.dart';
import '../../provider/addsytleprovider.dart';
import '../../provider/menuprovidercategory.dart';
import '../../provider/provider.dart';
import '../../l10n/l10n_extension.dart';
import '../../repo/service.dart';
import '../../repo/gemini_service.dart';

class AddUpdateMenuItemScreen extends StatefulWidget {
  final bool isEdit;
  final MenuItem? menuItem;
  const AddUpdateMenuItemScreen({
    super.key,
    required this.isEdit,
    this.menuItem,
  });
  @override
  State<AddUpdateMenuItemScreen> createState() =>
      _AddUpdateMenuItemScreenState();
}

class _AddUpdateMenuItemScreenState extends State<AddUpdateMenuItemScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemDescController = TextEditingController();
  final TextEditingController _salesPriceController = TextEditingController(
    text: '0',
  );
  final TextEditingController _taxController = TextEditingController(text: '0');
  final TextEditingController _taxableAmountController = TextEditingController(
    text: '0',
  );
  final TextEditingController _costPriceController = TextEditingController();
  final TextEditingController _displayOrderController = TextEditingController(
    text: '0',
  );
  final TextEditingController _minQtyController = TextEditingController(
    text: '0',
  );
  final TextEditingController _aiDescriptionController =
      TextEditingController();
  List<MenuCategory> itemCategoryList = [];
  late List<AddedStyle> allStyleList;
  MenuCategory? _selectedCategory;
  String? _selectedUnit;
  double _selectedTaxType = 0.0;
  String title = "Add";
  // Image upload state
  Uint8List? _pickedImageBytes;
  String? _base64Image;
  final ImagePicker _picker = ImagePicker();
  // --- New lists for selection dialogs ---
  final List<Map<String, dynamic>> _foodTags = [];
  final List<Map<String, dynamic>> _addOns = [];
  final Set<String> _selectedPrintLocations = {};
  final List<MenuItemListPrice> _unitPricingList = [];
  final List<String> _availablePrintLocations = [
    'Kitchen',
    'Bar',
    'Bakery',
    'Sushi Bar',
  ];
  // All available tags/addons (new data for selection)
  // These are now fetched from providers in the build method.
  final Map<String, double> _taxTypeMap = {
    'NONE': 0.0,
    'VAT': 1.0,
    'GST': 2.0,
    'Service Tax': 3.0,
  };
  bool _isExclusiveTax = false;
  bool _isFavorite = false;
  bool _isConsumable = true;
  bool _maintainStock = false;
  final GeminiService _geminiService = GeminiService();
  final List<Map<String, String>> _chatMessages = [];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Load data from providers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ItemStyleProvider>().loadStyles();
      context.read<MenuCategoryProvider>().loadCategories();
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (image != null) {
        final Uint8List bytes = await image.readAsBytes();
        setState(() {
          _pickedImageBytes = bytes;
          _base64Image = base64Encode(bytes);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _applyAIResponse(Map<String, dynamic> ai) {
    if (ai["price"] != null) {
      _costPriceController.text = ai["price"].toString();
    }
    if (ai["cost_price"] != null) {
      _costPriceController.text = ai["cost_price"].toString();
    }

    if (ai["sale_price"] != null) {
      _salesPriceController.text = ai["sale_price"].toString();
    }

    if (ai["tax"] != null) {
      _taxController.text = ai["tax"].toString();
    }
    if (ai["tax_amount"] != null) {
      _taxController.text = ai["tax_amount"].toString();
    }

    if (ai["quantity"] != null) {
      _minQtyController.text = ai["quantity"].toString();
    }
    if (ai["min_qty"] != null) {
      _minQtyController.text = ai["min_qty"].toString();
    }

    if (ai["description"] != null) {
      _itemDescController.text = ai["description"];
    }
    if (ai["item_description"] != null) {
      _itemDescController.text = ai["item_description"];
    }

    if (ai["item_name"] != null) {
      _itemNameController.text = ai["item_name"];
    }

    // Handle Category
    if (ai["category_id"] != null) {
      final catId = ai["category_id"].toString();
      final categories = context.read<MenuCategoryProvider>().categories;
      final match = categories.where((c) => c.id == catId).firstOrNull;
      if (match != null) {
        _selectedCategory = match;
      }
    }

    // Handle Unit
    if (ai["base_unit"] != null) {
      _selectedUnit = ai["base_unit"].toString();
    }

    // Handle Food Tags
    if (ai["food_tags"] != null && ai["food_tags"] is List) {
      final tagIds = (ai["food_tags"] as List)
          .map((e) => e.toString())
          .toList();
      final allStyles = context.read<ItemStyleProvider>().allStyles;
      _foodTags.clear();
      for (var id in tagIds) {
        final match = allStyles.where((s) => s.id == id).firstOrNull;
        if (match != null) {
          _foodTags.add({
            'id': int.tryParse(match.id) ?? 0,
            'name': match.childOption,
          });
        }
      }
    }

    // Handle Add-ons
    if (ai["add_ons"] != null && ai["add_ons"] is List) {
      final addonIds = (ai["add_ons"] as List)
          .map((e) => e.toString())
          .toList();
      final allAddons = context
          .read<MenuCategoryProvider>()
          .categories
          .where((c) => c.isAddons)
          .toList();
      _addOns.clear();
      for (var id in addonIds) {
        final match = allAddons.where((c) => c.id == id).firstOrNull;
        if (match != null) {
          _addOns.add({'id': int.tryParse(match.id) ?? 0, 'name': match.title});
        }
      }
    }
  }

  void _showAIChatSheet() {
    final TextEditingController chatInputController = TextEditingController();

    // Prepare context for Gemini
    final categories = context
        .read<MenuCategoryProvider>()
        .categories
        .where((c) => !c.isAddons)
        .map((c) => "ID: ${c.id}, Name: ${c.title}")
        .join("\n");
    final units = context
        .read<MenuItemProvider>()
        .unitName
        .map((u) => "ID: ${u['id']}, Name: ${u['name']}")
        .join("\n");
    final tags = context
        .read<ItemStyleProvider>()
        .allStyles
        .map((s) => "ID: ${s.id}, Name: ${s.childOption} (${s.styleHeading})")
        .join("\n");
    final addons = context
        .read<MenuCategoryProvider>()
        .categories
        .where((c) => c.isAddons)
        .map((c) => "ID: ${c.id}, Name: ${c.title}")
        .join("\n");

    final systemContext =
        """
Categories:
$categories

Units:
$units

Food Tags:
$tags

Add-ons:
$addons
""";

    _geminiService.startNewChat(systemContext);
    _chatMessages.clear();
    _chatMessages.add({
      'role': 'ai',
      'text':
          'Hello! I am your AI assistant. What menu item would you like to add today?',
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.white),
                    const SizedBox(width: 10),
                    const Text(
                      'Chat with Gemini AI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _chatMessages.length,
                  itemBuilder: (context, index) {
                    final msg = _chatMessages[index];
                    final isUser = msg['role'] == 'user';
                    return Align(
                      alignment: isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUser
                              ? Colors.deepPurple[50]
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(msg['text'] ?? ''),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  left: 16,
                  right: 16,
                  top: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: chatInputController,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: () async {
                          final text = chatInputController.text.trim();
                          if (text.isEmpty) return;

                          setModalState(() {
                            _chatMessages.add({'role': 'user', 'text': text});
                            chatInputController.clear();
                          });

                          final response = await _geminiService.sendMessage(
                            text,
                          );
                          final message = response['message'] as String?;
                          final isComplete =
                              response['is_complete'] as bool? ?? false;
                          final partialData =
                              response['data'] as Map<String, dynamic>?;

                          setModalState(() {
                            if (message != null) {
                              _chatMessages.add({
                                'role': 'ai',
                                'text': message,
                              });
                            }
                          });

                          // Update form fields in real-time if data is provided
                          if (partialData != null) {
                            setState(() {
                              _applyAIResponse(partialData);
                            });
                          }
                          if (isComplete) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Saving item as requested..."),
                                ),
                              );
                              Navigator.pop(context);
                              // Automatically save the item
                              await _saveItem();
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAISection() {
    return _buildSectionCard(
      title: 'AI Assistant',
      child: Column(
        children: [
          _buildCompactTextField(
            context: context,
            controller: _aiDescriptionController,
            label: 'Describe Item',
            hint:
                'e.g., A spicy chicken burger with cheese and fries for 500 rupees',
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _autoFillWithAI,
            icon: const Icon(Icons.auto_awesome, size: 18),
            label: const Text('Fill & Save with AI'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 36),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _autoFillWithAI() async {
    if (_aiDescriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please describe the item for AI")),
      );
      return;
    }

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final data = await MenuItems().getAIResponse(
        _aiDescriptionController.text,
      );
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        _applyAIResponse(data);
        // If item name was provided by AI, update it
        if (data["item_name"] != null && _itemNameController.text.isEmpty) {
          _itemNameController.text = data["item_name"];
        }

        // Automatically hit save button after filling
        await _saveItem();
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        log(e.toString());
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("AI Error: ${e.toString()}")));
      }
    }
  }

  Future<void> _saveItem() async {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a category')));
      return;
    }

    var token = "EB2F0F66-5369-41A8-A5CA-5B4C0A96721A";
    final success = await context.read<MenuItemProvider>().saveNewItem(
      token: token,
      itemName: _itemNameController.text,
      itemDescription: _itemDescController.text,
      categoryId: int.tryParse(_selectedCategory!.id) ?? 0,
      baseUnit: int.tryParse(_selectedUnit ?? '1') ?? 1,
      salesPrice: double.tryParse(_salesPriceController.text) ?? 0.0,
      costPrice: double.tryParse(_costPriceController.text) ?? 0.0,
      taxType: _selectedTaxType,
      taxAmount: double.tryParse(_taxController.text) ?? 0.0,
      taxableAmount: double.tryParse(_taxableAmountController.text) ?? 0.0,
      foodTags: _foodTags.map((e) => e['id'] as int).toList(),
      addOns: _addOns.map((e) => e['id'] as int).toList(),
      isFavorite: _isFavorite,
      isConsumable: _isConsumable,
      maintainStock: _maintainStock,
      displayOrder: _displayOrderController.text,
      minQty: double.tryParse(_minQtyController.text) ?? 0.0,
      prStringLocation: _selectedPrintLocations,
      unitpricing: _unitPricingList,
      itemImage: _base64Image ?? '',
    );

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item saved successfully!')),
        );
      }
    } else {
      if (mounted) {
        final error = context.read<MenuItemProvider>().errorMessage;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error ?? 'Failed to save item')));
      }
    }
  }

  // 2. Compact Image Upload (Used in Mobile View)
  Widget _buildCompactImageUpload() {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!, width: 1),
        image: _pickedImageBytes != null
            ? DecorationImage(
                image: MemoryImage(_pickedImageBytes!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      margin: const EdgeInsets.only(top: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _pickImage,
          borderRadius: BorderRadius.circular(8),
          child: _pickedImageBytes != null
              ? const SizedBox.shrink()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 32,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Upload',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // 7. Larger Image Upload (Used in Tablet View)
  Widget _buildTabletImageUpload() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!, width: 2),
        image: _pickedImageBytes != null
            ? DecorationImage(
                image: MemoryImage(_pickedImageBytes!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _pickImage,
          borderRadius: BorderRadius.circular(10),
          child: _pickedImageBytes != null
              ? const SizedBox.shrink()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 40,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Upload Image',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _itemNameController.dispose();
    _itemDescController.dispose();
    _salesPriceController.dispose();
    _taxController.dispose();
    _taxableAmountController.dispose();
    _costPriceController.dispose();
    _displayOrderController.dispose();
    _minQtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isTablet = MediaQuery.of(context).size.width > 600;
    title = widget.isEdit ? l10n.edit : l10n.add;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$title ${l10n.menu_item}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        // Reduced vertical padding of AppBar
        toolbarHeight: kToolbarHeight * 0.9,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: _showAIChatSheet,
            tooltip: 'Chat with AI',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _autoFillWithAI();
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12), // Reduced from 16
              child: isTablet ? _buildTabletLayout() : _buildMobileLayout(),
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    final l10n = context.l10n;
    var unitList = context.read<MenuItemProvider>().unitName;
    final categories = context
        .watch<MenuCategoryProvider>()
        .categories
        .where((element) => !element.isAddons)
        .toList();

    final availableTags = context.watch<ItemStyleProvider>().allStyles;
    final availableAddOns = context
        .watch<MenuCategoryProvider>()
        .categories
        .where((element) => element.isAddons)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAISection(),
        const SizedBox(height: 10),
        // Image & Basic Info Section
        _buildSectionCard(
          title: 'Basic Information',
          child: Column(
            children: [
              Row(
                children: [
                  _buildCompactImageUpload(),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      children: [
                        _buildCompactTextField(
                          context: context,
                          controller: _itemNameController,
                          label: l10n.item_name,
                          hint: '', // 'Enter item name',
                        ),
                        const SizedBox(height: 4),
                        _buildCompactTextField(
                          context: context,
                          controller: _itemDescController,
                          label: l10n.item_description,
                          hint: '', //Enter description',
                          // maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: _buildCategoryDropdown(
                      label: l10n.category,
                      value: _selectedCategory,
                      items: categories,

                      onChanged: (val) =>
                          setState(() => _selectedCategory = val!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildUnitDropdown(
                      label: l10n.unit,
                      value: _selectedUnit ??= unitList.first['id'].toString(),
                      items: unitList,
                      onChanged: (val) => setState(() => _selectedUnit = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: _buildCompactTextField(
                      context: context,
                      controller: _displayOrderController,
                      label: 'Display Order',
                      hint: '0',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildCompactTextField(
                      context: context,
                      controller: _minQtyController,
                      label: 'Min Qty',
                      hint: '0',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Pricing Section
        _buildSectionCard(
          title: 'Pricing & Tax',
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildCompactTextField(
                      context: context,
                      controller: _salesPriceController,
                      label: l10n.sales_price,
                      hint: "", //'0',
                      keyboardType: TextInputType.number,
                      onChanged: (value) => context
                          .read<MenuItemProvider>()
                          .updateSalePrice(value),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildCompactTextField(
                      context: context,
                      controller: _costPriceController,
                      label: 'Cost Price',
                      hint: '0',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              _buildCompactSwitch(
                title: 'Is Exclusive Tax',
                value: _isExclusiveTax,
                onChanged: (val) => setState(() => _isExclusiveTax = val),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: _buildCompactDropdown(
                      label: l10n.tax_type,
                      value: _taxTypeMap.entries
                          .firstWhere((e) => e.value == _selectedTaxType)
                          .key,
                      items: _taxTypeMap.keys.toList(),
                      onChanged: (val) =>
                          setState(() => _selectedTaxType = _taxTypeMap[val]!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildCompactTextField(
                      context: context,
                      controller: _taxController,
                      label: 'Tax',
                      hint: '0',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              _buildCompactTextField(
                context: context,
                controller: _taxableAmountController,
                label: 'Taxable Amount',
                hint: '0',
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        // Tags & Add-ons Section
        _buildSectionCard(
          title: 'Tags & Add-ons',
          child: Column(
            children: [
              _buildCompactTagSection(
                label: 'Food Tags',
                tags: _foodTags,
                onRemove: (tag) => setState(() => _foodTags.remove(tag)),
                onAdd: () => _showAddSelectionDialog(
                  type: 'Food Tag',
                  currentItems: _foodTags,
                  availableItems: availableTags
                      .map(
                        (e) => {
                          'id': int.tryParse(e.id) ?? 0,
                          'name': e.styleHeading,
                        },
                      )
                      .toList(),
                  onAdd: (tag) => setState(() => _foodTags.add(tag)),
                ),
              ),
              const SizedBox(height: 6),
              _buildCompactTagSection(
                label: 'Add-ons',
                tags: _addOns,
                onRemove: (tag) => setState(() => _addOns.remove(tag)),
                onAdd: () => _showAddSelectionDialog(
                  type: 'Add-on',
                  currentItems: _addOns,
                  availableItems: availableAddOns
                      .map(
                        (e) => {'id': int.tryParse(e.id) ?? 0, 'name': e.title},
                      )
                      .toList(),
                  onAdd: (addon) => setState(() => _addOns.add(addon)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        // Options Section
        _buildSectionCard(
          title: 'Options',
          child: Column(
            spacing: 6,
            children: [
              _buildCompactSwitch(
                title: 'Is Consumable Item',
                value: _isConsumable,
                onChanged: (val) => setState(() => _isConsumable = val),
              ),
              _buildCompactSwitch(
                title: 'Maintain Stock',
                value: _maintainStock,
                onChanged: (val) => setState(() => _maintainStock = val),
              ),
              _buildCompactSwitch(
                title: 'Is Favorite',
                value: _isFavorite,
                onChanged: (val) => setState(() => _isFavorite = val),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Print Locations Section
        _buildSectionCard(
          title: 'Print Locations',
          child: _buildCompactPrintLocationSection(
            label: 'Locations',
            locations: _selectedPrintLocations,
            onRemove: (loc) =>
                setState(() => _selectedPrintLocations.remove(loc)),
            onAdd: () => _showAddSelectionDialog(
              type: 'Print Location',
              currentItems: _selectedPrintLocations
                  .map((e) => {'id': e, 'name': e})
                  .toList(),
              availableItems: _availablePrintLocations
                  .map((e) => {'id': e, 'name': e})
                  .toList(),
              onAdd: (loc) =>
                  setState(() => _selectedPrintLocations.add(loc['name'])),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Unit Pricing Section
        _buildSectionCard(
          title: 'Unit Pricing',
          child: Column(
            children: [
              ..._unitPricingList.map((up) => _buildUnitPricingTile(up)),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _showAddUnitPricingDialog,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Unit Pricing'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amberAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 36),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    final l10n = context.l10n;
    var unitList = context.read<MenuItemProvider>().unitName;
    final categories = context
        .watch<MenuCategoryProvider>()
        .categories
        .where((element) => !element.isAddons)
        .toList();

    final availableTags = context.watch<ItemStyleProvider>().allStyles;
    final availableAddOns = context
        .watch<MenuCategoryProvider>()
        .categories
        .where((element) => element.isAddons)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAISection(),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column: Basic Info, Tags & Add-ons
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  // Basic Information Section
                  _buildSectionCard(
                    title: 'Basic Information',
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Item Name & Description
                            Expanded(
                              child: Column(
                                children: [
                                  _buildCompactTextField(
                                    context: context,
                                    controller: _itemNameController,
                                    label: l10n.item_name,
                                    hint: 'Enter item name',
                                  ),
                                  const SizedBox(height: 6),
                                  _buildCompactTextField(
                                    context: context,
                                    controller: _itemDescController,
                                    label: l10n.item_description,
                                    hint: 'Enter description',
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            _buildTabletImageUpload(),
                            const SizedBox(width: 6),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Category & Unit
                        Row(
                          children: [
                            Expanded(
                              child: _buildCategoryDropdown(
                                label: l10n.category,
                                value: _selectedCategory,
                                items: categories,

                                onChanged: (val) =>
                                    setState(() => _selectedCategory = val!),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildUnitDropdown(
                                label: l10n.unit,
                                value: _selectedUnit ??= unitList.first['id']
                                    .toString(),
                                items: unitList,
                                onChanged: (val) =>
                                    setState(() => _selectedUnit = val!),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: _buildCompactTextField(
                                context: context,
                                controller: _displayOrderController,
                                label: 'Display Order',
                                hint: '0',
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildCompactTextField(
                                context: context,
                                controller: _minQtyController,
                                label: 'Min Qty',
                                hint: '0',
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Tags & Add-ons Section
                  _buildSectionCard(
                    title: 'Tags & Add-ons',
                    child: Column(
                      children: [
                        _buildCompactTagSection(
                          label: 'Food Tags',
                          tags: _foodTags,
                          onRemove: (tag) =>
                              setState(() => _foodTags.remove(tag)),
                          onAdd: () => _showAddSelectionDialog(
                            type: 'Food Tag',
                            currentItems: _foodTags,
                            availableItems: availableTags
                                .map(
                                  (e) => {
                                    'id': int.tryParse(e.id) ?? 0,
                                    'name': e.styleHeading,
                                  },
                                )
                                .toList(),
                            onAdd: (tag) => setState(() => _foodTags.add(tag)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildCompactTagSection(
                          label: 'Add-ons',
                          tags: _addOns,
                          onRemove: (tag) =>
                              setState(() => _addOns.remove(tag)),
                          onAdd: () => _showAddSelectionDialog(
                            type: 'Add-on',
                            currentItems: _addOns,
                            availableItems: availableAddOns
                                .map(
                                  (e) => {
                                    'id': int.tryParse(e.id) ?? 0,
                                    'name': e.title,
                                  },
                                )
                                .toList(),
                            onAdd: (addon) =>
                                setState(() => _addOns.add(addon)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Right Column: Pricing & Tax, Options
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  // Pricing & Tax Section
                  _buildSectionCard(
                    title: 'Pricing & Tax',
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildCompactTextField(
                                context: context,
                                controller: _salesPriceController,
                                label: l10n.sales_price,
                                hint: '0',
                                keyboardType: TextInputType.number,
                                onChanged: (value) => context
                                    .read<MenuItemProvider>()
                                    .updateSalePrice(value),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildCompactTextField(
                                context: context,
                                controller: _costPriceController,
                                label: l10n.cost_price,
                                hint: "", // '0',
                                keyboardType: TextInputType.number,
                                onChanged: (value) {},
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildCompactSwitch(
                          title: 'Is Exclusive Tax',
                          value: _isExclusiveTax,
                          onChanged: (val) =>
                              setState(() => _isExclusiveTax = val),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildCompactDropdown(
                                label: l10n.tax_type,
                                value: _taxTypeMap.entries
                                    .firstWhere(
                                      (e) => e.value == _selectedTaxType,
                                    )
                                    .key,
                                items: _taxTypeMap.keys.toList(),
                                onChanged: (val) => setState(
                                  () => _selectedTaxType = _taxTypeMap[val]!,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildCompactTextField(
                                context: context,
                                controller: _taxController,
                                label: 'Tax',
                                hint: '0',
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildCompactTextField(
                          context: context,
                          controller: _taxableAmountController,
                          label: 'Taxable Amount',
                          hint: '0',
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Options Section
                  _buildSectionCard(
                    title: 'Options',
                    child: Column(
                      children: [
                        _buildCompactSwitch(
                          title: 'Is Consumable Item',
                          value: _isConsumable,
                          onChanged: (val) =>
                              setState(() => _isConsumable = val),
                        ),
                        const SizedBox(height: 8),
                        _buildCompactSwitch(
                          title: 'Maintain Stock',
                          value: _maintainStock,
                          onChanged: (val) =>
                              setState(() => _maintainStock = val),
                        ),
                        const SizedBox(height: 8),
                        _buildCompactSwitch(
                          title: 'Is Favorite',
                          value: _isFavorite,
                          onChanged: (val) => setState(() => _isFavorite = val),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Print Locations Section
                  _buildSectionCard(
                    title: 'Print Locations',
                    child: _buildCompactPrintLocationSection(
                      label: 'Locations',
                      locations: _selectedPrintLocations,
                      onRemove: (loc) =>
                          setState(() => _selectedPrintLocations.remove(loc)),
                      onAdd: () => _showAddSelectionDialog(
                        type: 'Print Location',
                        currentItems: _selectedPrintLocations
                            .map((e) => {'id': e, 'name': e})
                            .toList(),
                        availableItems: _availablePrintLocations
                            .map((e) => {'id': e, 'name': e})
                            .toList(),
                        onAdd: (loc) => setState(
                          () => _selectedPrintLocations.add(loc['name']),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Unit Pricing Section
                  _buildSectionCard(
                    title: 'Unit Pricing',
                    child: Column(
                      children: [
                        ..._unitPricingList.map(
                          (up) => _buildUnitPricingTile(up),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: _showAddUnitPricingDialog,
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add Unit Pricing'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amberAccent,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 36),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Action Buttons - Reduced vertical padding
  Widget _buildActionButtons() {
    return Container(
      height: 80, // Reduced height from 100
      padding: const EdgeInsets.all(12), // Reduced from 16
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('Back to List'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xff061D2D),
                  side: const BorderSide(
                    color: Color(0xff061D2D),
                    width: 1.5,
                  ), // Thinner border
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ), // Reduced padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Reduced radius
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // Reset all fields
                  _itemNameController.clear();
                  _itemDescController.clear();
                  _salesPriceController.text = '0';
                  _taxController.text = '0';
                  _costPriceController.clear();
                  setState(() {
                    _selectedCategory = null;
                    _selectedUnit = '1';
                    _selectedTaxType = 0.0;
                    _foodTags.clear();
                    _addOns.clear();
                    _isExclusiveTax = false;
                    _isFavorite = false;
                    _isConsumable = true;
                    _maintainStock = false;
                    _pickedImageBytes = null;
                    _base64Image = null;
                    _displayOrderController.text = '0';
                    _minQtyController.text = '0';
                    _taxableAmountController.text = '0';
                    _selectedPrintLocations.clear();
                    _unitPricingList.clear();
                  });
                },
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Reset'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xff061D2D),
                  side: const BorderSide(color: Color(0xff061D2D), width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: context.watch<MenuItemProvider>().isLoading
                    ? null
                    : () => _saveItem(),
                icon: context.watch<MenuItemProvider>().isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.save, size: 18),
                label: Text(
                  context.watch<MenuItemProvider>().isLoading
                      ? 'Saving...'
                      : 'Save',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff061D2D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Replaced _showAddDialog with a selection dialog
  void _showAddSelectionDialog({
    required String type,
    required List<Map<String, dynamic>> currentItems,
    required List<Map<String, dynamic>> availableItems,
    required Function(Map<String, dynamic>) onAdd,
  }) {
    // Filter out items already selected
    final List<Map<String, dynamic>> filteredItems = availableItems
        .where((item) => !currentItems.any((c) => c['id'] == item['id']))
        .toList();

    Map<String, dynamic>? selectedItem;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Select $type', style: const TextStyle(fontSize: 16)),
            content: SizedBox(
              width: 300,
              child: filteredItems.isEmpty
                  ? Text(
                      'No more ${type.toLowerCase()}s available to add.',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    )
                  : DropdownButtonFormField<Map<String, dynamic>>(
                      initialValue: selectedItem,
                      decoration: InputDecoration(
                        labelText: 'Choose a ${type.toLowerCase()}',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: filteredItems.map((Map<String, dynamic> item) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: item,
                          child: Text(item['name']),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedItem = val;
                        });
                      },
                    ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: selectedItem != null
                    ? () {
                        onAdd(selectedItem!);
                        Navigator.pop(context);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff061D2D),
                ),
                child: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddUnitPricingDialog() {
    final unitList = context.read<MenuItemProvider>().unitName;
    String? selectedUnitId = unitList.isNotEmpty
        ? unitList.first['id'].toString()
        : null;
    final salesPriceController = TextEditingController();
    final costPriceController = TextEditingController();
    final taxAmountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text(
              'Add Unit Pricing',
              style: TextStyle(fontSize: 16),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildUnitDropdown(
                    label: 'Unit',
                    value: selectedUnitId,
                    items: unitList,
                    onChanged: (val) => setState(() => selectedUnitId = val),
                  ),
                  const SizedBox(height: 10),
                  _buildCompactTextField(
                    context: context,
                    controller: salesPriceController,
                    label: 'Sales Price',
                    hint: '0',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  _buildCompactTextField(
                    context: context,
                    controller: costPriceController,
                    label: 'Cost Price',
                    hint: '0',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  _buildCompactTextField(
                    context: context,
                    controller: taxAmountController,
                    label: 'Tax Amount',
                    hint: '0',
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedUnitId != null) {
                    final newUP = MenuItemListPrice(
                      ukId: '0',
                      itemId: '0',
                      unitId: selectedUnitId!,
                      salesPrice:
                          double.tryParse(salesPriceController.text) ?? 0.0,
                      costPrice:
                          double.tryParse(costPriceController.text) ?? 0.0,
                      taxAmount:
                          double.tryParse(taxAmountController.text) ?? 0.0,
                      taxableAmount:
                          double.tryParse(salesPriceController.text) ?? 0.0,
                    );
                    this.setState(() {
                      _unitPricingList.add(newUP);
                    });
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff061D2D),
                ),
                child: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUnitPricingTile(MenuItemListPrice up) {
    final unitList = context.read<MenuItemProvider>().unitName;
    final unitName = unitList.firstWhere(
      (u) => u['id'].toString() == up.unitId,
      orElse: () => {'name': 'Unknown'},
    )['name'];
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unitName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Sales: ${up.salesPrice} | Cost: ${up.costPrice} | Tax: ${up.taxAmount}',
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 18, color: Colors.redAccent),
            onPressed: () => setState(() => _unitPricingList.remove(up)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactPrintLocationSection({
    required String label,
    required Set<String> locations,
    required Function(String) onRemove,
    required VoidCallback onAdd,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13)),
            ElevatedButton.icon(
              style: ButtonStyle(
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                backgroundColor: WidgetStateProperty.all(Colors.amberAccent),
                foregroundColor: WidgetStateProperty.all(Colors.white),
                elevation: WidgetStateProperty.all(4),
                minimumSize: WidgetStateProperty.all(const Size(0, 0)),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              label: const Text('Add', style: TextStyle(fontSize: 12)),
              icon: const Icon(Icons.add, size: 14),
              onPressed: onAdd,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(6),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: locations.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'No $label Added.',
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                )
              : Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: locations.map((loc) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F4F8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            loc,
                            style: const TextStyle(
                              color: Color(0xff061D2D),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 3),
                          InkWell(
                            onTap: () => onRemove(loc),
                            child: const Icon(
                              Icons.close,
                              size: 12,
                              color: Color(0xff061D2D),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}

// 1. Reduced Section Card Padding
Widget _buildSectionCard({required String title, required Widget child}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8), // Slightly smaller radius
      border: Border.all(color: Colors.grey[300]!),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(
            alpha: 0.03,
          ), // Subtle shadow for depth
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    padding: const EdgeInsets.all(10), // Reduced from 12
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14, // Slightly larger font for better hierarchy
            fontWeight: FontWeight.w700,
            color: Color(0xff061D2D),
          ),
        ),
        const SizedBox(height: 8), // Reduced from 10
        child,
      ],
    ),
  );
}

// 3. Compact Text Field (Used in both) - Reduced spacing and content padding
Widget _buildCompactTextField({
  required BuildContext context,
  required TextEditingController controller,
  required String label,
  required String hint,
  int maxLines = 1,
  TextInputType? keyboardType,
  Function(dynamic value)? onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label),
      TextField(
        controller: controller,
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        onChanged: onChanged,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
        ),
      ),
    ],
  );
}

// 4. Compact Dropdown (Used in both) - Reduced spacing and content padding
Widget _buildCategoryDropdown({
  required String label,
  required value,
  required List<MenuCategory> items,
  required Function(MenuCategory?) onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<MenuCategory>(
            value: value,
            isExpanded: true,
            isDense: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            borderRadius: BorderRadius.circular(6),
            style: const TextStyle(fontSize: 13, color: Colors.black87),
            items: items.map((MenuCategory item) {
              return DropdownMenuItem<MenuCategory>(
                value: item,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(item.title),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    ],
  );
}

Widget _buildUnitDropdown({
  required String label,
  required String? value,
  required List<Map<String, dynamic>> items,
  required Function(String?) onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            isDense: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            borderRadius: BorderRadius.circular(6),
            style: const TextStyle(fontSize: 13, color: Colors.black87),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item['id'].toString(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(item['name']),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    ],
  );
}

Widget _buildCompactDropdown({
  required String label,
  required String? value,
  required List<String> items,
  required Function(String?) onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            isDense: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            borderRadius: BorderRadius.circular(6),
            style: const TextStyle(fontSize: 13, color: Colors.black87),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item.toString(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(item),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    ],
  );
}

// 5. Compact Tag Section (Used in both) - Reduced padding, smaller font for 'Add' button
Widget _buildCompactTagSection({
  required String label,
  required List<Map<String, dynamic>> tags,
  required Function(Map<String, dynamic>) onRemove,
  required VoidCallback onAdd,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          ElevatedButton.icon(
            style: ButtonStyle(
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              backgroundColor: WidgetStateProperty.all(Colors.amberAccent),
              foregroundColor: WidgetStateProperty.all(Colors.white),
              elevation: WidgetStateProperty.all(4),
              minimumSize: WidgetStateProperty.all(const Size(0, 0)),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            label: const Text('Add', style: TextStyle(fontSize: 12)),
            icon: const Icon(Icons.add),
            onPressed: onAdd,
          ),
        ],
      ),
      const SizedBox(height: 4),
      Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: tags.isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'No $label Added.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                    height: 0.8,
                  ),
                ),
              )
            : Wrap(
                spacing: 5,
                runSpacing: 5,
                children: tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F4F8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tag['name'],
                          style: const TextStyle(
                            color: Color(0xff061D2D),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 3),
                        InkWell(
                          onTap: () => onRemove(tag),
                          child: const Icon(
                            Icons.close,
                            size: 12,
                            color: Color(0xff061D2D),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
      ),
    ],
  );
}

// 6. Compact Switch (Used in both) - Reduced padding
Widget _buildCompactSwitch({
  required String title,
  required bool value,
  required Function(bool) onChanged,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      color: Colors.grey[50],
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey[300]!),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        Transform.scale(
          scale: 0.8,
          child: Switch(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.amber,
          ),
        ),
      ],
    ),
  );
}
