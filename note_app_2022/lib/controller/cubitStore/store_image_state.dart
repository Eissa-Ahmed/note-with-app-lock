part of 'store_image_cubit.dart';

@immutable
abstract class StoreImageState {}

class StoreImageInitial extends StoreImageState {}

//login User
class LogInUserLoadedSate extends StoreImageState {}

class LogInUserSuccessSate extends StoreImageState {}

//Helper Text
class HlperTextState extends StoreImageState {}

//Image From Device
class ImageFromDeviceState extends StoreImageState {}

//Video From Device
class VideoFromDeviceState extends StoreImageState {}

//Upload Image
class UploadedIamgeStoreLoadedState extends StoreImageState {}

class UploadedIamgeStoreSuccessState extends StoreImageState {}

class UploadedIamgeStoreErrorState extends StoreImageState {}

//Upload Video
class UploadedVideoStoreLoadedState extends StoreImageState {}

class UploadedVideoStoreSuccessState extends StoreImageState {}

class UploadedVideoStoreErrorState extends StoreImageState {}

//Save Image Private

class SaveImagePrivateLoadedState extends StoreImageState {}

class SaveImagePrivateSuccessState extends StoreImageState {}

class SaveImagePrivateErrorState extends StoreImageState {}

//Save Video Private

class SaveVideoPrivateLoadedState extends StoreImageState {}

class SaveVideoPrivateSuccessState extends StoreImageState {}

class SaveVideoPrivateErrorState extends StoreImageState {}

//Delete Iamge From FireBase
class DeleteImageFromFireBaseState extends StoreImageState {}

//Share Photo
class SharePhotoLoadedState extends StoreImageState {}

class SharePhotoSuccessState extends StoreImageState {}

class SharePhotoErrorState extends StoreImageState {}

//Delete Iamge From All
class DeleteIamgeFromAllLoadedState extends StoreImageState {}

class DeleteIamgeFromAllSuccessState extends StoreImageState {}

class DeleteIamgeFromAllErrorState extends StoreImageState {}

//Download Image To Device
class DownloadImageToDeviceLoadedState extends StoreImageState {}

class DownloadImageToDeviceSuccessState extends StoreImageState {}

class DownloadImageToDeviceErrorState extends StoreImageState {}

//GoToAnotherPhoto
class GoToAnotherPhoto extends StoreImageState {}

//Hide/Show Images
class HideImagesState extends StoreImageState {}

class ShowImagesState extends StoreImageState {}

//Play Video
class PlayVideoLoadedState extends StoreImageState {}

class PlayVideoSuccessState extends StoreImageState {}

//Button Play
class ButtonPlayState extends StoreImageState {}

//init List Video
class InitListVideoState extends StoreImageState {}

//Puase Video Navigator
class PuaseVideoNavigatorState extends StoreImageState {}

//screenFromVideo
class ScreenFromVideoState extends StoreImageState {}

class DeleteImageAndVideoFromFirebaseState extends StoreImageState {}

//Delete Video From FireStore
class DeleteVideoFromFireStoreLoaded extends StoreImageState {}

class DeleteVideoFromFireStoreSuccess extends StoreImageState {}

class DeleteVideoFromFireStoreError extends StoreImageState {}
