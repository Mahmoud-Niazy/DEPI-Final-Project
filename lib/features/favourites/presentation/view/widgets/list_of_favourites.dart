import 'package:ecommerce/core/app_assets/app_assets.dart';
import 'package:ecommerce/core/app_styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../../../../core/widgets/custom_circular_progress_indicator.dart';
import '../../../../../core/widgets/custom_divider.dart';
import '../../../../../core/widgets/shake_transition.dart';
import '../../../../../generated/l10n.dart';
import '../../manager/favourites_cubit/favourites_cubit.dart';
import '../../manager/favourites_cubit/favourites_states.dart';
import 'favourites_item.dart';

class ListOfFavourites extends StatelessWidget {
  const ListOfFavourites({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavouritesCubit, FavouritesStates>(
      buildWhen: (previous, current) =>
          previous != current &&
          (current is GetFavouritesSuccessfullyState ||
              current is GetFavouritesLoadingState ||
              current is AddFavouriteState ||
              current is RemoveFavouriteState),
      builder: (context, state) {
        var allFavourites = FavouritesCubit.get(context).allFavourites;
        if (state is GetFavouritesLoadingState) {
          return const CustomCircularProgressIndicator();
        }
        if (state is GetFavouritesErrorState) {
          return Center(
            child: Text(
              state.error,
            ),
          );
        }
        if (allFavourites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height*.15,
                ),
                Lottie.asset(
                  AppAssets.emptyLottie,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  S.of(context).MyFavourites,
                  style: AppStyles.style20,
                ),
              ],
            ),
          );
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return ShakeTransition(
              duration: Duration(
                seconds: 1 * index + 2,
              ),
              child: FavouritesItem(product: allFavourites[index]),
            );
          },
          separatorBuilder: (context, index) {
            return const CustomDivider();
          },
          itemCount: allFavourites.length,
        );
      },
    );
  }
}
