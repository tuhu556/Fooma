part of 'edit_user_profile_bloc.dart';

@immutable
class UpdateUserProfileEvent extends Equatable {
  const UpdateUserProfileEvent();

  @override
  List<Object> get props => [];
}

class EditUserProfileEvent extends UpdateUserProfileEvent {
  String? name;
  String? birthDate;
  String? phoneNumber;
  String? imageUrl;
  String? bio;

  EditUserProfileEvent({
    this.name,
    this.birthDate,
    this.phoneNumber,
    this.imageUrl,
    this.bio,
  });
}

class EditUserProfileSuccess extends UpdateUserProfileEvent {
  const EditUserProfileSuccess();
}

class EditUserProfileFailed extends UpdateUserProfileEvent {
  final ServerError error;
  const EditUserProfileFailed(this.error);
}
