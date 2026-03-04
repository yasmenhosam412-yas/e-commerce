import 'package:bloc/bloc.dart';
import 'package:boo/core/models/user_model.dart';
import 'package:boo/core/services/error_handler.dart';
import 'package:boo/services/buyer_service/info_service.dart';
import 'package:meta/meta.dart';

part 'info_state.dart';

class InfoCubit extends Cubit<InfoState> {
  final InfoService infoService;

  InfoCubit(this.infoService) : super(InfoInitial());


  Future<void> updateUserInfo(String image,
      String name,
      String phone,
      String address,
      String location,
      String governorate,)async{
    emit(InfoLoading());
    try{
      final userModel = await infoService.addMoreInfo(image, name, phone, address, location, governorate);
    emit(InfoLoaded(userModel: userModel));
    }catch(e){
      emit(InfoError(error: ErrorHandler.fromException(e).message));
    }

  }
}
