import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_error_widget.dart';
import 'package:elmotamizon/common/widgets/shimmer_container_widget.dart';
import 'package:elmotamizon/constants/assets.dart';
import 'package:elmotamizon/features/home/details/cubit/voice_note_cubit/voice_note_cubit.dart';
import 'package:elmotamizon/features/home/details/models/voice_note_model.dart';
import 'package:elmotamizon/features/home/details/view/widgets/book_text.dart';
import 'package:elmotamizon/features/home/details/view/widgets/custom_title.dart';
import 'package:elmotamizon/features/home/details/view/widgets/voice_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class VoiceNote extends StatelessWidget {
  const VoiceNote({
    super.key,
    required this.id,
  });
  final int id;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          instance<VoiceNoteCubit>()..loadFirstVoiceNotePage(id),
      child: BlocBuilder<VoiceNoteCubit, BaseState<VoiceNoteModel>>(
        builder: (context, state) {
          if (state.status == Status.failure) {
            return DefaultErrorWidget(errorMessage: state.errorMessage ?? '');
          }
          if (state.status == Status.loading) {
            return Column(
              children: List.generate(3, (index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: ShimmerContainerWidget(height: 20.h,width: double.infinity,),
              ),),
            );
          }
          final voiceNote = state.items;
          return Column(
            spacing: 10.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTitle(title: AppStrings.voiceNotes.tr()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5.h,
                children: voiceNote.asMap().entries.map((entry) {
                  final index = entry.key;
                  return VoicePlayer(
                      // url: "https://onlinetestcase.com/wp-content/uploads/2023/06/100-KB-MP3.mp3",
                     voiceNote: voiceNote[index],
                  );
                  return BookText(
                    havePerfix: true,
                    havePostfix:
                    !(voiceNote[index].isFree == 0 ? false : true),
                    haveTime: true,
                    perfixIcon: Assets.assetsIconsRecord,
                    postfixIcon: Assets.assetsIconsLock,
                    text: voiceNote[index].name ?? "",
                    time: "06:00", //voiceNote[index]["time"],
                    color: (voiceNote[index].isFree == 0 ? false : true)
                        ? Colors.black
                        : null,
                  );
                }).toList(),
              ),
              if(context.read<VoiceNoteCubit>().hasMore)
                Gap(10.h),
              if(context.read<VoiceNoteCubit>().hasMore)
                GestureDetector(
                  onTap: () {
                    context.read<VoiceNoteCubit>().loadMoreVoiceNotePage(id);
                  },
                  child: Text(
                    AppStrings.loadMore2.tr(),
                    style: getBoldStyle(
                      fontSize: 15.sp,
                      color: ColorManager.primary,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
