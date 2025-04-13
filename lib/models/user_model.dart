class UserModel {
  final String id;
  final String email;
  final String name;
  final String gender;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.gender,
    required this.createdAt,
  });

  // Convert from Supabase User Model to UserModel
  factory UserModel.fromSupabase(Map<String, dynamic> supabaseUser) {
    return UserModel(
      id: supabaseUser['id'],
      email: supabaseUser['email'],
      name: supabaseUser['user_metadata']['name'] ?? '',
      gender: supabaseUser['user_metadata']['gender'] ?? '',
      createdAt: DateTime.parse(supabaseUser['created_at']),
    );
  }

  // Convert from UserModel to Supabase User Model
  Map<String, dynamic> toSupabase() {
    return {
      'id': id,
      'email': email,
      'user_metadata': {'name': name, 'gender': gender},
      'created_at': createdAt.toIso8601String(),
    };
  }
}
