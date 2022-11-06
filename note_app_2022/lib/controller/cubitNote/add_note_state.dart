part of 'add_note_cubit.dart';

@immutable
abstract class AddNoteState {}

class AddNoteInitial extends AddNoteState {}

class ChangeCurrentWidgetState extends AddNoteState {}

class ChangeSelecedColorState extends AddNoteState {}

//Sign in
class SignInSuccessState extends AddNoteState {}

class SignInErrorState extends AddNoteState {}

//add Note
class AddNoteLoadedState extends AddNoteState {}

class AddNoteSuccessState extends AddNoteState {}

class AddNoteErrorState extends AddNoteState {}

//Load Notes
class LoadNoteLoadedState extends AddNoteState {}

class LoadNoteSuccessState extends AddNoteState {}

class LoadNoteErrorState extends AddNoteState {}

//Load Notes Today
class LoadNoteToDayLoadedState extends AddNoteState {}

class LoadNoteToDaySuccessState extends AddNoteState {}

//image
class GetImageFromDeviceState extends AddNoteState {}

class DeleteImageFromUiState extends AddNoteState {}

//Upload Image To FireBase
class UploadedIamgeSuccessState extends AddNoteState {}

class UploadedIamgeErrorState extends AddNoteState {}

//Delete Image
class DeleteImageFromFirebaseState extends AddNoteState {}

//Delete Note
class DeleteNoteLoadedFromFirebaseState extends AddNoteState {}

class DeleteNoteSuccessFromFirebaseState extends AddNoteState {}

class DeleteNoteErrorFromFirebaseState extends AddNoteState {}

//Equal
class EqualState extends AddNoteState {}

//Mode
class ChangeModeState extends AddNoteState {}

class ChangeMode2State extends AddNoteState {}

//Update
class UpdateLoaded extends AddNoteState {}

class UpdateSuccess extends AddNoteState {}

class UpdateError extends AddNoteState {}

//Search
class CompleteSearchListState extends AddNoteState {}

//Share Photo
class SharePhotoLoadedState extends AddNoteState {}

class SharePhotoSuccessState extends AddNoteState {}

class SharePhotoErrorState extends AddNoteState {}

//Add Tasks
class AddTAsksLoadedState extends AddNoteState {}

class AddTAsksSuccessState extends AddNoteState {}

class AddTAsksErrorState extends AddNoteState {}

//Read Tasks
class GetTAsksLoadedState extends AddNoteState {}

class GetTAsksSuccessState extends AddNoteState {}

class GetTAsksErrorState extends AddNoteState {}

//Update Tasks
class UpdateTAsksLoadedState extends AddNoteState {}

class UpdateTAsksSuccessState extends AddNoteState {}

class UpdateTAsksErrorState extends AddNoteState {}

//Delete Tasks
class DeleteTAsksLoadedState extends AddNoteState {}

class DeleteTAsksSuccessState extends AddNoteState {}

class DeleteTAsksErrorState extends AddNoteState {}
