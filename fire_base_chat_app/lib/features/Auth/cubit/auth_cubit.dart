// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:chat_app_firebase/features/Auth/data/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  register({
    required String email,
    required String password,
    required String name,
    required String position,
  }) async {
    try {
      emit(RegisterLoading());
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      UserModel userModel = UserModel(
        email: email,
        password: password,
        name: name,
        postiton: position,
      );
      await users.doc(email).set(userModel.toJson());
      emit(RegisterSuccess("Go To Your Email To Verify"));
    } on FirebaseAuthException catch (e) {
      emit(RegisterError(e.code));
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }

  login({required String email, required String password}) async {
    try {
      emit(LoginLoading());
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      emit(LoginError(e.code));
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}
