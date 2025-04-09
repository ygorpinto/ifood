import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/restaurant/menu_item_card.dart';
import '../../data/repositories/restaurant_repository.dart';
import '../../models/menu_item.dart';
import '../../models/restaurant.dart';

class RestaurantDetailScreen extends HookWidget {
  final int restaurantId;

  const RestaurantDetailScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  Widget build(BuildContext context) {
    final restaurantRepository = context.read<RestaurantRepository>();
    final isLoading = useState(true);
    final restaurant = useState<Restaurant?>(null);
    final menu = useState<List<MenuCategory>>([]);
    final selectedCategoryIndex = useState(0);
    final scrollController = useScrollController();

    // Função para carregar os dados
    Future<void> loadData() async {
      isLoading.value = true;
      try {
        restaurant.value = await restaurantRepository.getRestaurantById(restaurantId);
        if (restaurant.value != null) {
          final restaurantMenu = await restaurantRepository.getRestaurantMenu(restaurantId);
          menu.value = restaurantMenu.categories;
        }
      } finally {
        isLoading.value = false;
      }
    }

    // Carregar dados ao iniciar
    useEffect(() {
      loadData();
      return null;
    }, []);

    if (isLoading.value || restaurant.value == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes do restaurante'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          // AppBar com imagem de fundo
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: restaurant.value!.coverUrl,
                fit: BoxFit.cover,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {},
              ),
            ],
          ),
          // Informações do restaurante
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: CachedNetworkImage(
                            imageUrl: restaurant.value!.logoUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant.value!.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              restaurant.value!.category,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: AppColors.starColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  restaurant.value!.rating.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Informações de entrega
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoItem(
                        Icons.timer,
                        '${restaurant.value!.deliveryTime} min',
                        'Tempo de entrega',
                      ),
                      _buildInfoItem(
                        Icons.delivery_dining,
                        'R\$ ${restaurant.value!.deliveryFee.toStringAsFixed(2).replaceAll('.', ',')}',
                        'Taxa de entrega',
                      ),
                      _buildInfoItem(
                        Icons.attach_money,
                        'R\$ ${restaurant.value!.minimumOrder.toStringAsFixed(2).replaceAll('.', ',')}',
                        'Pedido mínimo',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    restaurant.value!.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                ],
              ),
            ),
          ),
          // Menu tabs
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                dividerColor: Colors.transparent,
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.grey,
                tabs: menu.value
                    .map((category) => Tab(text: category.name))
                    .toList(),
                onTap: (index) {
                  selectedCategoryIndex.value = index;
                },
              ),
              MediaQuery.of(context).padding.top,
            ),
          ),
          // Menu items
          if (menu.value.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = menu.value[selectedCategoryIndex.value];
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    
                    final itemIndex = index - 1;
                    if (itemIndex < category.items.length) {
                      return MenuItemCard(
                        menuItem: category.items[itemIndex],
                        restaurant: restaurant.value!,
                      );
                    }
                    return null;
                  },
                  childCount: menu.value[selectedCategoryIndex.value].items.length + 1,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final double topPadding;

  _SliverAppBarDelegate(this.tabBar, this.topPadding);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
} 