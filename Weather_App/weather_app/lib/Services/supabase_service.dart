import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:weather_app/Models/user_models.dart';
import 'package:weather_app/Models/city_models.dart';

class SupabaseService {
  final _supabase = Supabase.instance.client;

  // Get current user from session
  UserModel? getCurrentUser() {
    final session = _supabase.auth.currentSession;
    if (session?.user == null) return null;

    return UserModel(
      id: session!.user.id,
      email: session.user.email!,
    );
  }

  // Sign up new user
  Future<UserModel> signUp(String email, String password) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Sign up failed - no user returned');
      }

      return UserModel(
        id: response.user!.id,
        email: response.user!.email!,
      );
    } on AuthException catch (e) {
      // Pass through auth exceptions with their messages
      throw AuthException(e.message);
    } catch (e) {
      throw Exception('Sign up failed: ${e.toString()}');
    }
  }

  // Sign in existing user
  Future<UserModel?> signIn(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Sign in failed - no user returned');
      }

      return UserModel(
        id: response.user!.id,
        email: response.user!.email!,
      );
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }

  // Get favorite cities for current user
  Future<List<CityModel>> getFavoriteCities() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      
      if (userId == null) {
        throw Exception('User not logged in');
      }

      final response = await _supabase
          .from('favorite_cities')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((city) => CityModel.fromJson(city))
          .toList();
    } catch (e) {
      throw Exception('Failed to load cities: ${e.toString()}');
    }
  }

  // Add favorite city
  Future<CityModel> addFavoriteCity(CityModel city) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      
      if (userId == null) {
        throw Exception('User not logged in');
      }

      final response = await _supabase
          .from('favorite_cities')
          .insert({
            'user_id': userId,
            'city_name': city.cityName,
            'lat': city.lat,
            'lon': city.lon,
          })
          .select()
          .single();

      return CityModel.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        // Unique constraint violation
        throw Exception('City already added to favorites');
      }
      throw Exception('Failed to add city: ${e.message}');
    } catch (e) {
      throw Exception('Failed to add city: ${e.toString()}');
    }
  }

  // Remove favorite city
  Future<void> removeFavoriteCity(String cityId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      
      if (userId == null) {
        throw Exception('User not logged in');
      }

      await _supabase
          .from('favorite_cities')
          .delete()
          .eq('id', cityId)
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to remove city: ${e.toString()}');
    }
  }
}