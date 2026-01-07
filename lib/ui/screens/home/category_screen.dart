import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../blocs/category/category_bloc.dart';
import '../../../blocs/category/category_event.dart';
import '../../../blocs/category/category_state.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/category.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with TickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  late AnimationController _searchAnimationController;
  late Animation<double> _fabScaleAnimation;
  late Animation<double> _searchFadeAnimation;
  String _searchQuery = '';
  bool _isSearching = false;

  // Available icons for categories
  static final List<IconData> _availableIcons = [
    Icons.folder,
    Icons.work,
    Icons.home,
    Icons.person,
    Icons.shopping_cart,
    Icons.book,
    Icons.fitness_center,
    Icons.restaurant,
    Icons.directions_car,
    Icons.phone,
    Icons.email,
    Icons.calendar_today,
    Icons.star,
    Icons.favorite,
    Icons.music_note,
    Icons.camera_alt,
    Icons.sports_esports,
    Icons.pets,
    Icons.school,
    Icons.health_and_safety,
    Icons.attach_money,
    Icons.travel_explore,
    Icons.sports_soccer,
    Icons.palette,
    Icons.computer,
    Icons.smartphone,
    Icons.headphones,
    Icons.coffee,
    Icons.local_florist,
    Icons.fastfood,
    Icons.movie,
    Icons.bubble_chart,
    Icons.lightbulb,
    Icons.psychology,
    Icons.notifications,
    Icons.settings,
    Icons.cloud,
    Icons.security,
    Icons.trending_up,
    Icons.analytics,
    Icons.shopping_bag,
    Icons.local_activity,
    Icons.nightlife,
    Icons.flight,
    Icons.hotel,
    Icons.beach_access,
    Icons.park,
    Icons.spa,
    Icons.business,
    Icons.apartment,
    Icons.store,
    Icons.medical_services,
    Icons.sports_basketball,
    Icons.art_track,
    Icons.science,
    Icons.language,
    Icons.public,
    Icons.map,
    Icons.directions_bike,
    Icons.directions_walk,
    Icons.train,
    Icons.airport_shuttle,
  ];

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(LoadCategories());

    _fabAnimationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);

    _searchAnimationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);

    _fabScaleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut));

    _searchFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _searchAnimationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _searchAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Search
          /*     SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            title: AnimatedBuilder(
              animation: _searchFadeAnimation,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _isSearching ? Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _searchAnimationController, curve: Curves.easeInOut)) : const AlwaysStoppedAnimation(1.0),
                  child: Text(
                    _isSearching ? AppLocalizations.of(context)!.searchCategories : AppLocalizations.of(context)!.categories,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                );
              },
              child: Text(AppLocalizations.of(context)!.categories, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            ),
            actions: [
              AnimatedBuilder(
                animation: _searchFadeAnimation,
                builder: (context, child) {
                  return FadeTransition(opacity: _searchFadeAnimation, child: child);
                },
                child: IconButton(onPressed: _toggleSearch, icon: Icon(_isSearching ? Icons.close : Icons.search)),
              ),
            ],
            bottom: _isSearching
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(60),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.searchCategories,
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),
                  )
                : null,
          ),

       */
          // Categories List
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoading) {
                return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
              } else if (state is CategoryLoaded) {
                final categories = _filterCategories(state.categories);

                if (categories.isEmpty) {
                  if (_searchQuery.isNotEmpty) {
                    return SliverFillRemaining(child: _buildNoResultsState());
                  } else {
                    return SliverFillRemaining(child: _buildEmptyState());
                  }
                }

                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final category = categories[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(verticalOffset: 50.0, child: FadeInAnimation(child: _buildCategoryCard(category))),
                      );
                    }, childCount: categories.length),
                  ),
                );
              } else if (state is CategoryError) {
                return SliverFillRemaining(child: _buildErrorState(state.message));
              }
              return const SliverFillRemaining(child: SizedBox.shrink());
            },
          ),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _fabScaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _fabScaleAnimation.value, child: child);
        },
        child: AnimationConfiguration.synchronized(
          duration: const Duration(milliseconds: 600),
          child: ScaleAnimation(
            scale: 1.0,
            child: FadeInAnimation(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primaryContainer], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
                ),
                child: FloatingActionButton(
                  heroTag: 'category_fab',
                  onPressed: () {
                    _showAddCategoryDialog();
                  },
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Category> _filterCategories(List<Category> categories) {
    if (_searchQuery.isEmpty) return categories;

    return categories.where((category) => category.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  void _toggleSearch() {
    setState(() {
      if (_isSearching) {
        _isSearching = false;
        _searchQuery = '';
        _searchAnimationController.reverse();
        _fabAnimationController.reverse();
      } else {
        _isSearching = true;
        _searchAnimationController.forward();
        _fabAnimationController.forward();
      }
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(Icons.folder_open, size: 64, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 24),
          Text(AppLocalizations.of(context)!.noCategoriesYet, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.noCategoriesYetDescription,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _showAddCategoryDialog,
            icon: const Icon(Icons.add),
            label: Text(AppLocalizations.of(context)!.createCategory),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.noCategoriesFound, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
          const SizedBox(height: 8),
          Text(AppLocalizations.of(context)!.tryAdjustingYourSearchTerms, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.somethingWentWrong, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.error)),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.read<CategoryBloc>().add(LoadCategories()),
            icon: const Icon(Icons.refresh),
            label: Text(AppLocalizations.of(context)!.tryAgain),
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error, foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Category category) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          _showCategoryDetails(category);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(colors: [category.color.withValues(alpha: 0.05), category.color.withValues(alpha: 0.2), Colors.white], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon with animation
                Hero(
                  tag: 'category_icon_${category.id}',
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: category.color,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: category.color.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
                    ),
                    child: Icon(_getIconFromString(category.icon), color: Colors.white, size: 28),
                  ),
                ),

                const SizedBox(width: 16),

                // Category info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(category.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(AppLocalizations.of(context)!.tasksCount(category.tasksCount), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
                      if (category.isDefault) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            AppLocalizations.of(context)!.defaultLabel,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Actions
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        _showEditCategoryDialog(category);
                        break;
                      case 'delete':
                        _showDeleteConfirmation(category);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(children: [Icon(Icons.edit, size: 20), const SizedBox(width: 12), Text(AppLocalizations.of(context)!.editButton)]),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red, size: 20),
                          const SizedBox(width: 12),
                          Text(AppLocalizations.of(context)!.deleteButton, style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCategoryDetails(Category category) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(2)),
            ),

            // Category details
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Hero(
                    tag: 'category_icon_${category.id}',
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: category.color,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: category.color.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
                      ),
                      child: Icon(_getIconFromString(category.icon), color: Colors.white, size: 32),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(category.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(AppLocalizations.of(context)!.tasksCount(category.tasksCount), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
                        if (category.isDefault) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                            child: Text(
                              AppLocalizations.of(context)!.defaultCategory,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showEditCategoryDialog(category);
                      },
                      icon: const Icon(Icons.edit),
                      label: Text(AppLocalizations.of(context)!.editButton),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showDeleteConfirmation(category);
                      },
                      icon: const Icon(Icons.delete),
                      label: Text(AppLocalizations.of(context)!.deleteButton),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  IconData _getIconFromString(String iconName) {
    try {
      return _availableIcons.firstWhere((icon) => icon.codePoint.toString() == iconName, orElse: () => Icons.folder);
    } catch (e) {
      return Icons.folder;
    }
  }

  void _showAddCategoryDialog() {
    _showCategoryDialog(null);
  }

  void _showEditCategoryDialog(Category category) {
    _showCategoryDialog(category);
  }

  void _showCategoryDialog(Category? category) {
    final nameController = TextEditingController(text: category?.name ?? '');
    Color selectedColor = category?.color ?? Colors.blue;
    IconData selectedIcon = category != null ? _getIconFromString(category.icon) : Icons.folder;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(2)),
                ),

                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: selectedColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                        child: Icon(selectedIcon, color: selectedColor, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          category == null ? AppLocalizations.of(context)!.addCategory : AppLocalizations.of(context)!.editCategory,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Form content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Name field
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.categoryName,
                          hintText: AppLocalizations.of(context)!.enterCategoryName,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          prefixIcon: const Icon(Icons.label),
                        ),
                        autofocus: true,
                      ),

                      const SizedBox(height: 16),

                      // Icon selection
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 8),
                          ExpansionTile(
                            title: Text('icon', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                            children: [
                              Container(
                                // constraints: const BoxConstraints(maxHeight: 100),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
                                ),
                                child: GridView.builder(
                                  padding: const EdgeInsets.all(8),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6, childAspectRatio: 1, crossAxisSpacing: 6, mainAxisSpacing: 6),
                                  itemCount: _availableIcons.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final icon = _availableIcons[index];
                                    final isSelected = icon == selectedIcon;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedIcon = icon;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: isSelected ? selectedColor.withValues(alpha: 0.2) : Colors.transparent,
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: isSelected ? selectedColor : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3), width: isSelected ? 2 : 1),
                                        ),
                                        child: Icon(icon, color: isSelected ? selectedColor : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7), size: 18),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Color selection
                      Row(
                        children: [
                          Text(AppLocalizations.of(context)!.color, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () async {
                              final color = await showModalBottomSheet<Color>(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                    child: Wrap(
                                      children: [
                                        ListTile(title: Text(AppLocalizations.of(context)!.pickAColor)),
                                        SingleChildScrollView(
                                          child: ColorPicker(
                                            pickerColor: selectedColor,
                                            onColorChanged: (color) {
                                              setState(() {
                                                selectedColor = color;
                                              });
                                            },
                                            pickerAreaHeightPercent: 0.8,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(AppLocalizations.of(context)!.cancelButton)),
                                            ElevatedButton(onPressed: () => Navigator.of(context).pop(selectedColor), child: Text(AppLocalizations.of(context)!.selectButton)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                              if (color != null) {
                                setState(() {
                                  selectedColor = color;
                                });
                              }
                            },
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: selectedColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Theme.of(context).colorScheme.outline, width: 2),
                                boxShadow: [BoxShadow(color: selectedColor.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))],
                              ),
                              child: Icon(selectedIcon, color: Colors.white, size: 24),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Action buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(AppLocalizations.of(context)!.cancelButton),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            if (nameController.text.trim().isNotEmpty) {
                              if (category == null) {
                                // Add new category
                                final newCategory = Category(
                                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                                  name: nameController.text.trim(),
                                  color: selectedColor,
                                  icon: selectedIcon.codePoint.toString(),
                                  createdAt: DateTime.now(),
                                );
                                context.read<CategoryBloc>().add(AddCategory(newCategory));
                              } else {
                                // Update existing category
                                final updatedCategory = category.copyWith(name: nameController.text.trim(), color: selectedColor, icon: selectedIcon.codePoint.toString());
                                context.read<CategoryBloc>().add(UpdateCategory(updatedCategory));
                              }
                              Navigator.of(context).pop();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: selectedColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 2,
                          ),
                          child: Text(category == null ? AppLocalizations.of(context)!.addButton : AppLocalizations.of(context)!.updateButton),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Category category) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Wrap(
          children: [
            ListTile(title: Text(AppLocalizations.of(context)!.deleteCategory)),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text(AppLocalizations.of(context)!.confirmDeleteCategory(category.name))),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(AppLocalizations.of(context)!.cancelButton),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CategoryBloc>().add(DeleteCategory(category.id));
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(AppLocalizations.of(context)!.deleteButton),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
