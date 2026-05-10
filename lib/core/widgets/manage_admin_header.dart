import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../constants/route_names.dart';

class ManageAdminHeader extends StatefulWidget {
  const ManageAdminHeader({super.key});

  @override
  State<ManageAdminHeader> createState() => _ManageAdminHeaderState();
}

class _ManageAdminHeaderState extends State<ManageAdminHeader> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.card,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Row(
        children: [
          if (!_isSearching) ...[
            const Icon(Icons.school, color: AppColors.primary, size: 36),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Smart Campus',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Facility Management',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
          const Spacer(),
          if (_isSearching)
            Expanded(
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Search facilities...",
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => setState(() => _isSearching = false),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          if (!_isSearching)
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  onPressed: () => setState(() => _isSearching = true),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildLink(BuildContext context, String label, String route) {
    return InkWell(
      onTap: () => context.push(route),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
