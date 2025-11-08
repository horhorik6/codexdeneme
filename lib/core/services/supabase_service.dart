import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/premium_model.dart';
import '../utils/error_handler.dart';

class SupabaseService {
  SupabaseService._();

  static SupabaseClient? _client;

  static bool get isConfigured => _client != null;

  static SupabaseClient? get client => _client;

  static Future<void> initialize() async {
    final url = dotenv.env['SUPABASE_URL'];
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'];
    if (url == null || url.isEmpty || anonKey == null || anonKey.isEmpty) {
      return;
    }

    if (_client != null) return;

    final supabase = await Supabase.initialize(url: url, anonKey: anonKey);
    _client = supabase.client;
  }

  static SupabaseService get instance => SupabaseService._();

  Future<bool> isUserPremium({required String deviceId}) async {
    final client = _client;
    if (client == null) {
      return false;
    }

    try {
      final response = await client
          .from('premium_members')
          .select<Map<String, dynamic>>('is_premium')
          .eq('device_id', deviceId)
          .maybeSingle();
      return (response?['is_premium'] as bool?) ?? false;
    } on PostgrestException catch (error, stackTrace) {
      ErrorHandler.log(error, stackTrace);
      return false;
    }
  }

  Future<List<PremiumContent>> fetchPremiumContent() async {
    final client = _client;
    if (client == null) {
      return _fallbackContent();
    }

    try {
      final response = await client
          .from('premium_content')
          .select<List<Map<String, dynamic>>>(
            'id, title, description, image_url, published_at, tag',
          )
          .order('published_at', ascending: false);
      return response.map(PremiumContent.fromJson).toList();
    } on PostgrestException catch (error, stackTrace) {
      ErrorHandler.log(error, stackTrace);
      return _fallbackContent();
    }
  }

  Future<String?> fetchFeaturedVideoId() async {
    final client = _client;
    if (client == null) {
      return null;
    }

    try {
      final response = await client
          .from('premium_videos')
          .select<Map<String, dynamic>>('video_id')
          .order('published_at', ascending: false)
          .limit(1)
          .maybeSingle();
      return response?['video_id'] as String?;
    } on PostgrestException catch (error, stackTrace) {
      ErrorHandler.log(error, stackTrace);
      return null;
    }
  }

  Stream<PremiumContent> subscribeToLiveInsights() {
    final client = _client;
    if (client == null) {
      return const Stream.empty();
    }

    final controller = StreamController<PremiumContent>.broadcast();
    final channel = client.channel('premium_insights')
      ..onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'premium_content',
        callback: (payload) {
          final record = payload.newRecord;
          if (record != null) {
            controller.add(PremiumContent.fromJson(record));
          }
        },
      )
      ..subscribe();

    controller.onCancel = () => client.removeChannel(channel);

    return controller.stream;
  }

  List<PremiumContent> _fallbackContent() {
    return const <PremiumContent>[
      PremiumContent(
        id: 'preview-1',
        title: 'Premium taktik raporu (örnek)',
        description:
            'Supabase bağlantısı yapılana kadar örnek analizler gösterilir. Üyelik sonrası gerçek zamanlı taktik raporları açılır.',
        tag: 'Önizleme',
      ),
      PremiumContent(
        id: 'preview-2',
        title: 'Maç önü veri kartı (örnek)',
        description:
            'Topa sahip olma trendleri, yaratılan gol beklentisi ve oyuncu sıcaklık haritaları premium üyeler için hazır.',
        tag: 'Veri',
      ),
    ];
  }
}
