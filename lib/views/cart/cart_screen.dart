import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../models/cart_item.dart';
import '../../viewmodels/cart_provider.dart';

class CartScreen extends HookWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    
    if (cartProvider.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Carrinho'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 100,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              const Text(
                'Seu carrinho está vazio',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Adicione itens para fazer um pedido',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  context.go('/');
                },
                child: const Text('Ver restaurantes'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(cartProvider.restaurant?.name ?? 'Carrinho'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Limpar carrinho'),
                  content: const Text(
                    'Tem certeza que deseja remover todos os itens do carrinho?',
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Cancelar'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Limpar'),
                      onPressed: () {
                        cartProvider.clear();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Lista de itens
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartProvider.items.length,
              itemBuilder: (context, index) {
                final cartItem = cartProvider.items[index];
                return _CartItemCard(cartItem: cartItem);
              },
            ),
          ),
          
          // Resumo do pedido
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Resumo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildOrderSummaryRow(
                  'Subtotal',
                  'R\$ ${cartProvider.subtotal.toStringAsFixed(2).replaceAll('.', ',')}',
                ),
                const SizedBox(height: 8),
                _buildOrderSummaryRow(
                  'Taxa de entrega',
                  'R\$ ${cartProvider.deliveryFee.toStringAsFixed(2).replaceAll('.', ',')}',
                ),
                const Divider(height: 24),
                _buildOrderSummaryRow(
                  'Total',
                  'R\$ ${cartProvider.total.toStringAsFixed(2).replaceAll('.', ',')}',
                  isBold: true,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implementar fluxo de checkout
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pedido finalizado com sucesso!'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                    cartProvider.clear();
                  },
                  child: const Text('Finalizar pedido'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? null : Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem cartItem;

  const _CartItemCard({
    required this.cartItem,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do Item
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 80,
                height: 80,
                child: CachedNetworkImage(
                  imageUrl: cartItem.menuItem.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Informações do Item
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.menuItem.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (cartItem.observation != null && cartItem.observation!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      cartItem.observation!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        color: AppColors.primary,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          cartProvider.updateItemQuantity(
                            cartItem,
                            cartItem.quantity - 1,
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${cartItem.quantity}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        color: AppColors.primary,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          cartProvider.updateItemQuantity(
                            cartItem,
                            cartItem.quantity + 1,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Preço e Botão de Remover
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'R\$ ${cartItem.totalPrice.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    cartProvider.removeItem(cartItem);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 