import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common/search_bar.dart';
import '../../core/widgets/restaurant/category_card.dart';
import '../../core/widgets/restaurant/restaurant_card.dart';
import '../../data/repositories/restaurant_repository.dart';
import '../../models/category.dart';
import '../../models/restaurant.dart';
import '../../viewmodels/auth_provider.dart';
import '../../viewmodels/theme_provider.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final themeProvider = context.read<ThemeProvider>();
    final restaurantRepository = context.read<RestaurantRepository>();
    
    final searchQuery = useState('');
    final isLoading = useState(true);
    final categories = useState<List<Category>>([]);
    final featuredRestaurants = useState<List<Restaurant>>([]);
    final popularRestaurants = useState<List<Restaurant>>([]);
    final filteredRestaurants = useState<List<Restaurant>>([]);
    
    // Função para carregar os dados
    Future<void> loadData() async {
      isLoading.value = true;
      try {
        categories.value = await restaurantRepository.getCategories();
        featuredRestaurants.value = await restaurantRepository.getFeaturedRestaurants();
        
        final allRestaurants = await restaurantRepository.getRestaurants();
        // Simulando restaurantes populares (ordenados por rating)
        popularRestaurants.value = List<Restaurant>.from(allRestaurants)
          ..sort((a, b) => b.rating.compareTo(a.rating));
        
        // Aplicando a busca (se houver)
        if (searchQuery.value.isNotEmpty) {
          filteredRestaurants.value = allRestaurants
              .where((restaurant) => restaurant.name
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()))
              .toList();
        } else {
          filteredRestaurants.value = [];
        }
      } finally {
        isLoading.value = false;
      }
    }
    
    // Função para buscar restaurantes
    void searchRestaurants(String query) {
      searchQuery.value = query;
      loadData();
    }
    
    // Carregar dados ao iniciar
    useEffect(() {
      loadData();
      return null;
    }, []);
    
    // Build da seção de categorias
    Widget buildCategorySection() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Categorias',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.value.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: CategoryCard(category: categories.value[index]),
                );
              },
            ),
          ),
        ],
      );
    }
    
    // Build da seção de restaurantes em destaque
    Widget buildFeaturedRestaurantsSection() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Destaques',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 230,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: featuredRestaurants.value.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 280,
                  margin: const EdgeInsets.only(right: 16),
                  child: RestaurantCard(
                    restaurant: featuredRestaurants.value[index],
                  ),
                );
              },
            ),
          ),
        ],
      );
    }
    
    // Build da seção de restaurantes populares
    Widget buildPopularRestaurantsSection() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Mais Populares',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: popularRestaurants.value.length > 5 
                ? 5 
                : popularRestaurants.value.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: RestaurantCard(
                  restaurant: popularRestaurants.value[index],
                  isHorizontal: true,
                ),
              );
            },
          ),
        ],
      );
    }
    
    // Build da seção de resultados de busca
    Widget buildSearchResultsSection() {
      if (searchQuery.value.isEmpty) {
        return const SizedBox.shrink();
      }
      
      if (filteredRestaurants.value.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'Nenhum restaurante encontrado',
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      }
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Resultados para "${searchQuery.value}"',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filteredRestaurants.value.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: RestaurantCard(
                  restaurant: filteredRestaurants.value[index],
                  isHorizontal: true,
                ),
              );
            },
          ),
        ],
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('iFood'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Perfil'),
                  content: Text('Olá, ${authProvider.user?.name ?? 'Usuário'}!'),
                  actions: [
                    TextButton(
                      child: const Text('Fechar'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: const Text('Sair'),
                      onPressed: () {
                        authProvider.logout();
                        context.go('/login');
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadData,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    CustomSearchBar(
                      hintText: 'Buscar restaurantes',
                      onSearch: searchRestaurants,
                      onFilter: () {
                        // Implementar filtro
                      },
                    ),
                    const SizedBox(height: 24),
                    if (searchQuery.value.isEmpty) ...[
                      buildCategorySection(),
                      const SizedBox(height: 24),
                      buildFeaturedRestaurantsSection(),
                      const SizedBox(height: 24),
                      buildPopularRestaurantsSection(),
                    ] else ...[
                      buildSearchResultsSection(),
                    ],
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }
} 