import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movies/src/features/auth/repository/auth_repository.dart';
import 'package:movies/src/features/auth/repository/firestore_repository.dart' as auth_firestore;
import 'package:movies/src/features/account/repository/firestore_repository.dart' as account_firestore;

@GenerateMocks(
  [
    AuthRepository,
    FirebaseAuth,
    User,
  ],
  customMocks: [
    MockSpec<auth_firestore.FirestoreRepository>(as: #MockFirestoreRepositoryAuth),
    MockSpec<account_firestore.FirestoreRepository>(as: #MockFirestoreRepositoryAccount),
  ],
)
void main() {}
