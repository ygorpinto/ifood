import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../theme/app_colors.dart';

class CustomSearchBar extends HookWidget {
  final String hintText;
  final Function(String) onSearch;
  final Function()? onFilter;
  final bool showFilterButton;
  final EdgeInsetsGeometry? margin;
  
  const CustomSearchBar({
    super.key,
    required this.hintText,
    required this.onSearch,
    this.onFilter,
    this.showFilterButton = true,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();
    final isFocused = useState(false);
    final focusNode = useFocusNode();
    
    useEffect(() {
      void listener() {
        isFocused.value = focusNode.hasFocus;
      }
      
      focusNode.addListener(listener);
      return () => focusNode.removeListener(listener);
    }, [focusNode]);
    
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      height: 50,
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(
            Icons.search,
            color: isFocused.value ? AppColors.primary : Colors.grey,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: textController,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onSubmitted: onSearch,
              onChanged: (value) {
                if (value.isEmpty) {
                  onSearch('');
                }
              },
            ),
          ),
          if (textController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
              onPressed: () {
                textController.clear();
                onSearch('');
              },
            ),
          if (showFilterButton)
            IconButton(
              icon: const Icon(Icons.filter_list, color: AppColors.primary),
              onPressed: onFilter,
            ),
        ],
      ),
    );
  }
} 