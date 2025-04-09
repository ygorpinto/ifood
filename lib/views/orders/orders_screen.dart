import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../data/repositories/order_repository.dart';
import '../../models/order.dart';

class OrdersScreen extends HookWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderRepository = context.read<OrderRepository>();
    final isLoading = useState(true);
    final orders = useState<List<Order>>([]);

    // Função para carregar os pedidos
    Future<void> loadOrders() async {
      isLoading.value = true;
      try {
        orders.value = await orderRepository.getOrders();
      } finally {
        isLoading.value = false;
      }
    }

    // Carregar pedidos ao iniciar
    useEffect(() {
      loadOrders();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
      ),
      body: isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : orders.value.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 100,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Você ainda não tem pedidos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Faça seu primeiro pedido e ele aparecerá aqui',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadOrders,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: orders.value.length,
                    itemBuilder: (context, index) {
                      final order = orders.value[index];
                      return _OrderCard(order: order);
                    },
                  ),
                ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;

  const _OrderCard({
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho do pedido
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CachedNetworkImage(
                      imageUrl: order.restaurantLogo,
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
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.restaurantName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.formattedDate,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order.status),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          order.status,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'R\$ ${order.totalAmount.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.paymentMethod,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const Divider(height: 32),
            
            // Lista de itens
            ...order.items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${item.quantity}x ${item.name}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    'R\$ ${(item.price * item.quantity).toStringAsFixed(2).replaceAll('.', ',')}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            )),
            
            const SizedBox(height: 16),
            
            // Botões de ação
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implementar funcionalidade de avaliar pedido
                  },
                  icon: const Icon(Icons.star_outline),
                  label: const Text('Avaliar'),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implementar funcionalidade de pedir novamente
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Pedir novamente'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'entregue':
        return AppColors.success;
      case 'em preparo':
        return AppColors.warning;
      case 'em transporte':
        return AppColors.info;
      case 'cancelado':
        return AppColors.error;
      default:
        return AppColors.secondary;
    }
  }
} 