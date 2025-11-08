import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_service.dart';
import 'supabase_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());
final supabaseServiceProvider = Provider<SupabaseService>(
  (ref) => SupabaseService.instance,
);
