import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';
import 'package:foodhub/features/social/models/comment_entity.dart';
import 'package:foodhub/features/social/models/method_recipe_entity.dart';
import 'package:foodhub/features/social/models/recipe_entity.dart';
import 'package:foodhub/features/social/repository/interact_recipe_repository.dart';

import '../../../service/networking.dart';
part 'interact_recipe_event.dart';

part 'interact_recipe_state.dart';

class InteractRecipeBloc
    extends Bloc<InteractRecipeEvent, InteractRecipeState> {
  InteractRecipeBloc()
      : super(InteractRecipeState(status: InteractRecipeStatus.SaveInitial));

  @override
  Stream<InteractRecipeState> mapEventToState(
    InteractRecipeEvent event,
  ) async* {
    if (event is SaveRecipeSocial) {
      yield state.copyWith(
          InteractRecipeStatus.SaveProcessing, null, null, null, null, null);
      yield* _mapSaveRecipeToState(event);
    } else if (event is SaveRecipeSocialSuccess) {
      yield state.copyWith(
          InteractRecipeStatus.SaveSuccess, null, null, null, event.code, null);
    } else if (event is SaveRecipeSocialFailed) {
      yield state.copyWith(
          InteractRecipeStatus.SaveFailed, null, null, null, null, event.error);
    } else if (event is UnSaveRecipeSocial) {
      yield state.copyWith(
          InteractRecipeStatus.UnSaveProcessing, null, null, null, null, null);
      yield* _mapUnSaveRecipeToState(event);
    } else if (event is UnSaveRecipeSocialSuccess) {
      yield state.copyWith(InteractRecipeStatus.UnSaveSuccess, null, null, null,
          event.code, null);
    } else if (event is UnSaveRecipeSocialFailed) {
      yield state.copyWith(InteractRecipeStatus.UnSaveFailed, null, null, null,
          null, event.error);
    } else if (event is MyFavoriteSocialRecipe) {
      yield state.copyWith(InteractRecipeStatus.FavoriteProcessing, null, null,
          null, null, null);
      yield* _mapGetMyFavoriteRecipeToState(event);
    } else if (event is GetMyFavoriteRecipeDetailSuccess) {
      yield state.copyWith(InteractRecipeStatus.FavoriteSuccess, null, null,
          event.data, null, null);
    } else if (event is GetMyFavoriteRecipeDetailFailed) {
      yield state.copyWith(InteractRecipeStatus.FavoriteFailed, null, null,
          null, null, event.error);
    }
    //!
    if (event is DeleteMyRecipe) {
      yield state.copyWith(
          InteractRecipeStatus.DeleteProcessing, null, null, null, null, null);
      yield* _mapDeleteMyRecipeState(event);
    } else if (event is DeleteMyRecipeSuccess) {
      yield state.copyWith(
          InteractRecipeStatus.DeleteSuccess, null, null, null, null, null);
    } else if (event is DeleteMyRecipeFailed) {
      yield state.copyWith(InteractRecipeStatus.DeleteFailed, null, null, null,
          null, event.error);
    } //!
    else if (event is ListRecipeComment) {
      yield state.copyWith(InteractRecipeStatus.ListCommentProcessing, null,
          null, null, null, null);
      yield* _mapGetListRecipeCommentToState(event);
    } else if (event is ListRecipeCommentSuccess) {
      yield state.copyWith(InteractRecipeStatus.ListCommentSuccess,
          event.comment, null, null, null, null);
    } else if (event is ListRecipeCommentFailed) {
      yield state.copyWith(InteractRecipeStatus.ListCommentFailed, null, null,
          null, null, event.error);
    }
    //!
    else if (event is CommentRecipe) {
      yield state.copyWith(
          InteractRecipeStatus.CommentProcessing, null, null, null, null, null);
      yield* _mapCommentRecipeState(event);
    } else if (event is CommentSuccess) {
      yield state.copyWith(
          InteractRecipeStatus.CommentSuccess, null, null, null, null, null);
    } else if (event is CommentFailed) {
      yield state.copyWith(InteractRecipeStatus.CommentFailed, null, null, null,
          null, event.error);
    }
    //!
    else if (event is DeleteCommentRecipe) {
      yield state.copyWith(InteractRecipeStatus.DeleteCommentProcessing, null,
          null, null, null, null);
      yield* _mapDeleteCommentRecipeState(event);
    } else if (event is DeleteCommentSuccess) {
      yield state.copyWith(InteractRecipeStatus.DeleteCommentSuccess, null,
          null, null, null, null);
    } else if (event is DeleteCommentFailed) {
      yield state.copyWith(InteractRecipeStatus.DeleteCommentFailed, null, null,
          null, null, event.error);
    }

    //!
    else if (event is EditCommentRecipe) {
      yield state.copyWith(InteractRecipeStatus.EditCommentProcessing, null,
          null, null, null, null);
      yield* _mapEditCommentRecipeState(event);
    } else if (event is EditCommentSuccess) {
      yield state.copyWith(InteractRecipeStatus.EditCommentSuccess, null, null,
          null, null, null);
    } else if (event is EditCommentFailed) {
      yield state.copyWith(InteractRecipeStatus.EditCommentFailed, null, null,
          null, null, event.error);
    }
    //!
    else if (event is ReactRecipe) {
      yield state.copyWith(InteractRecipeStatus.ReactRecipeProcessing, null,
          null, null, null, null);
      yield* _mapReactRecipeState(event);
    } else if (event is ReactRecipeSuccess) {
      yield state.copyWith(InteractRecipeStatus.ReactRecipeSuccess, null, null,
          null, event.code, null);
    } else if (event is ReactRecipeFailed) {
      yield state.copyWith(InteractRecipeStatus.ReactRecipeFailed, null, null,
          null, null, event.error);
    }
    //!
    else if (event is UnReactRecipe) {
      yield state.copyWith(InteractRecipeStatus.UnReactRecipeProcessing, null,
          null, null, null, null);
      yield* _mapUnReactRecipeState(event);
    } else if (event is UnReactRecipeSuccess) {
      yield state.copyWith(InteractRecipeStatus.UnReactRecipeSuccess, null,
          null, null, event.code, null);
    } else if (event is UnReactRecipeFailed) {
      yield state.copyWith(InteractRecipeStatus.UnReactRecipeFailed, null, null,
          null, null, event.error);
    }
    //!
    else if (event is GetMethodRecipe) {
      yield state.copyWith(InteractRecipeStatus.MethodRecipeProcessing, null,
          null, null, null, null);
      yield* _mapGetMethodRecipeToState(event);
    } else if (event is GetMethodRecipeSuccess) {
      yield state.copyWith(InteractRecipeStatus.MethodRecipeSuccess, null,
          event.methodRecipe, null, null, null);
    } else if (event is GetMethodRecipeFailed) {
      yield state.copyWith(InteractRecipeStatus.MethodRecipeFailed, null, null,
          null, null, event.error);
    }
    //!
    else if (event is ReportRecipe) {
      yield state.copyWith(InteractRecipeStatus.ReportRecipeProcessing, null,
          null, null, null, null);
      yield* _mapReportRecipeState(event);
    } else if (event is ReportRecipeSuccess) {
      yield state.copyWith(InteractRecipeStatus.ReportRecipeSuccess, null, null,
          null, null, null);
    } else if (event is ReportRecipeFailed) {
      yield state.copyWith(InteractRecipeStatus.ReportRecipeFailed, null, null,
          null, null, event.error);
    }
    //!
    else if (event is RatingRecipe) {
      yield state.copyWith(InteractRecipeStatus.RatingRecipeProcessing, null,
          null, null, null, null);
      yield* _mapRatingRecipeState(event);
    } else if (event is RatingRecipeSuccess) {
      yield state.copyWith(InteractRecipeStatus.RatingRecipeSuccess, null, null,
          null, null, null);
    } else if (event is RatingRecipeFailed) {
      yield state.copyWith(InteractRecipeStatus.RatingRecipeFailed, null, null,
          null, null, event.error);
    }
  }

  Stream<InteractRecipeState> _mapSaveRecipeToState(
      SaveRecipeSocial event) async* {
    final repository = InteractRecipeRepository();

    try {
      repository.saveRecipe(event.recipeId, (data) {
        if (data is int && (data == 200) || data == 204) {
          add(SaveRecipeSocialSuccess(data));
        } else {
          add(SaveRecipeSocialFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(InteractRecipeStatus.SaveFailed, null, null, null,
          null, ServerError.internalError());
    }
  }

  Stream<InteractRecipeState> _mapUnSaveRecipeToState(
      UnSaveRecipeSocial event) async* {
    final repository = InteractRecipeRepository();

    try {
      repository.unSaveRecipe(event.recipeId, (data) {
        if (data is int && (data == 200) || data == 204) {
          add(UnSaveRecipeSocialSuccess(data));
        } else {
          add(UnSaveRecipeSocialFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(InteractRecipeStatus.UnSaveFailed, null, null, null,
          null, ServerError.internalError());
    }
  }

  Stream<InteractRecipeState> _mapGetMyFavoriteRecipeToState(
      MyFavoriteSocialRecipe event) async* {
    final repository = InteractRecipeRepository();

    try {
      repository.getMyFavoriteRecipe((value) {
        if (value is RecipeResponse) {
          add(GetMyFavoriteRecipeDetailSuccess(value));
        } else {
          add(GetMyFavoriteRecipeDetailFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(InteractRecipeStatus.FavoriteFailed, null, null,
          null, null, ServerError.internalError());
    }
  }

  Stream<InteractRecipeState> _mapDeleteMyRecipeState(
      DeleteMyRecipe event) async* {
    final repository = InteractRecipeRepository();

    try {
      repository.deleteMyRecipe(event.id, (data) {
        if (data is int && (data == 200)) {
          add(const DeleteMyRecipeSuccess());
        } else {
          add(DeleteMyRecipeFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(InteractRecipeStatus.DeleteFailed, null, null, null,
          null, ServerError.internalError());
    }
  }

  Stream<InteractRecipeState> _mapGetListRecipeCommentToState(
      ListRecipeComment event) async* {
    final repository = InteractRecipeRepository();

    try {
      repository.getListRecipeComment(event.RecipeId, event.page, (value) {
        if (value is CommentResponse) {
          add(ListRecipeCommentSuccess(value));
        } else {
          add(ListRecipeCommentFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(InteractRecipeStatus.ListCommentFailed, null, null,
          null, null, ServerError.internalError());
    }
  }

  Stream<InteractRecipeState> _mapCommentRecipeState(
      CommentRecipe event) async* {
    final repository = InteractRecipeRepository();
    final params = state.commentParameters;
    params["recipeId"] = event.recipeId;
    params["content"] = event.content;
    print(params);

    try {
      repository.commentRecipe(params, (data) {
        if (data is int && data == 200) {
          add(const CommentSuccess());
        } else {
          add(CommentFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(InteractRecipeStatus.CommentFailed, null, null, null,
          null, ServerError.internalError());
    }
  }

  Stream<InteractRecipeState> _mapDeleteCommentRecipeState(
      DeleteCommentRecipe event) async* {
    final repository = InteractRecipeRepository();

    try {
      repository.deleteComment(event.recipeId, (data) {
        if (data is int && data == 200 || data == 204) {
          add(const DeleteCommentSuccess());
        } else {
          add(DeleteCommentFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(InteractRecipeStatus.DeleteCommentFailed, null, null,
          null, null, ServerError.internalError());
    }
  }

  Stream<InteractRecipeState> _mapEditCommentRecipeState(
      EditCommentRecipe event) async* {
    final repository = InteractRecipeRepository();

    try {
      repository.editComment(event.content, event.commentId, (data) {
        if (data is int && data == 200) {
          add(const EditCommentSuccess());
        } else {
          add(EditCommentFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(InteractRecipeStatus.EditCommentFailed, null, null,
          null, null, ServerError.internalError());
    }
  }

  Stream<InteractRecipeState> _mapReactRecipeState(ReactRecipe event) async* {
    final repository = InteractRecipeRepository();

    try {
      repository.reactRecipe(event.recipeId, (data) {
        if (data is int && data == 200 || data == 204) {
          add(ReactRecipeSuccess(data));
        } else {
          add(ReactRecipeFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(InteractRecipeStatus.ReactRecipeFailed, null, null,
          null, null, ServerError.internalError());
    }
  }

  Stream<InteractRecipeState> _mapUnReactRecipeState(
      UnReactRecipe event) async* {
    final repository = InteractRecipeRepository();

    try {
      repository.unReactRecipe(event.recipeId, (data) {
        if (data is int && data == 200 || data == 204) {
          add(UnReactRecipeSuccess(data));
        } else {
          add(UnReactRecipeFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(InteractRecipeStatus.UnReactRecipeFailed, null, null,
          null, null, ServerError.internalError());
    }
  }

  Stream<InteractRecipeState> _mapGetMethodRecipeToState(
      GetMethodRecipe event) async* {
    final repository = InteractRecipeRepository();

    try {
      repository.getListMethodRecipe(event.recipeId, (value) {
        if (value is MethodRecipeResponse) {
          add(GetMethodRecipeSuccess(value));
        } else {
          add(GetMethodRecipeFailed(value as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(InteractRecipeStatus.MethodRecipeFailed, null, null,
          null, null, ServerError.internalError());
    }
  }

  Stream<InteractRecipeState> _mapReportRecipeState(ReportRecipe event) async* {
    final repository = InteractRecipeRepository();
    final params = state.reportParameters;
    params["recipeId"] = event.recipeId;
    params["title"] = event.title;
    params["content"] = event.content;
    print(params);

    try {
      repository.reportRecipe(params, (data) {
        if (data is int && data == 200 || data == 204) {
          add(const ReportRecipeSuccess());
        } else {
          add(ReportRecipeFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(InteractRecipeStatus.ReportRecipeFailed, null, null,
          null, null, ServerError.internalError());
    }
  }

  Stream<InteractRecipeState> _mapRatingRecipeState(RatingRecipe event) async* {
    final repository = InteractRecipeRepository();
    final params = state.ratingParameters;
    params["recipeId"] = event.recipeId;
    params["rating"] = event.rating;
    params["comment"] = event.comment;
    print(params);

    try {
      repository.ratingRecipe(params, (data) {
        if (data is int && data == 200 || data == 204) {
          add(const RatingRecipeSuccess());
        } else {
          add(RatingRecipeFailed(data as ServerError));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(InteractRecipeStatus.RatingRecipeFailed, null, null,
          null, null, ServerError.internalError());
    }
  }
}
