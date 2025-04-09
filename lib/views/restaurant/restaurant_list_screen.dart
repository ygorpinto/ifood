import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/common/search_bar.dart';
import '../../core/widgets/restaurant/restaurant_card.dart';
import '../../data/repositories/restaurant_repository.dart';
import '../../models/restaurant.dart';

class RestaurantListScreen extends HookWidget {
  final String? category;

  const RestaurantListScreen({
    super.key,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    final restaurantRepository = context.read<RestaurantRepository>();
    final searchQuery = useState('');
    final isLoading = useState(true);
    final restaurants = useState<List<Restaurant>>([]);
    final filteredRestaurants = useState<List<Restaurant>>([]);

    // Função para carregar os dados
    Future<void> loadData() async {
      isLoading.value = true;
      try {
        if (category != null) {
          restaurants.value = await restaurantRepository.getRestaurantsByCategory(category!);
        } else {
          restaurants.value = await restaurantRepository.getRestaurants();
        }

        // Aplicando a busca (se houver)
        if (searchQuery.value.isNotEmpty) {
          filteredRestaurants.value = restaurants.value
              .where((restaurant) => restaurant.name
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()))
              .toList();
        } else {
          filteredRestaurants.value = restaurants.value;
        }
      } finally {
        isLoading.value = false;
      }
    }

    // Função para buscar restaurantes
    void searchRestaurants(String query) {
      searchQuery.value = query;
      if (query.isEmpty) {
        filteredRestaurants.value = restaurants.value;
      } else {
        filteredRestaurants.value = restaurants.value
            .where((restaurant) => restaurant.name
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    }

    // Carregar dados ao iniciar
    useEffect(() {
      loadData();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: Text(category ?? 'Restaurantes'),
      ),
      body: Column(
        children: [
          CustomSearchBar(
            hintText: 'Buscar em ${category ?? "restaurantes"}',
            onSearch: searchRestaurants,
            onFilter: () {
              // Implementar filtro
            },
          ),
          Expanded(
            child: isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: loadData,
                    child: filteredRestaurants.value.isEmpty
                        ? Center(
                            child: Text(
                              searchQuery.value.isEmpty
                                  ? 'Nenhum restaurante encontrado'
                                  : 'Nenhum resultado para "${searchQuery.value}"',
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredRestaurants.value.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: RestaurantCard(
                                  restaurant: filteredRestaurants.value[index],
                                  isHorizontal: true,
                                ),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }
} 