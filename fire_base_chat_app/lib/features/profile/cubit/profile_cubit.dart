import 'dart:developer';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:chat_app_firebase/core/database/cachhelper.dart';
import 'package:chat_app_firebase/features/Auth/data/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  Future getUser() async {
    try {
      emit(GetProfileLoading());
      var user = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get();
      UserModel userModel = UserModel.fromJson(user.data()!);
      emit(GetProfileSuccess(userModel));
    } catch (e) {
      emit(GetProfileError(e.toString()));
      log(e.toString());
    }
  }

  String? path;
  File? profileImage;
  String? url;
  SupabaseClient supabase = Supabase.instance.client;
  pickImage() async {
    emit(PickProfileImageLoading());
    XFile? xFileImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (xFileImage != null) {
      profileImage = File(xFileImage.path);
      emit(PickProfileImageSuccess(profileImage!));
    } else {
      emit(PickProfileImageError("No Image Selected"));
    }
  }

  uploadImageToSupabase() async {
    try {
      path = basename(profileImage!.path);
      DateTime date = DateTime.now();
      await supabase.storage
          .from("chat_app")
          .upload("${path!}_$date", profileImage!);
      url = supabase.storage.from('chat_app').getPublicUrl("${path!}_$date");
      // ignore: avoid_print
      print(path);
      // ignore: avoid_print
      print(url);
      return url;
    } catch (e) {
      log(e.toString());
    }
  }

  updateImageProfile() async {
    try {
      emit(UpdateProfileImageLoading());
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .update({'image': await uploadImageToSupabase()});
      await CacheHelper.saveData(key: 'image', value: url!);
      emit(UpdateProfileImageSuccess());
    } catch (e) {
      emit(UpdateProfileImageError(e.toString()));
      log(e.toString());
    }
  }
}
