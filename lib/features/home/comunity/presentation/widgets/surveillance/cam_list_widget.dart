import "package:ciudadano/features/home/comunity/presentation/bloc/surveillance/cam_bloc.dart";
import "package:ciudadano/features/home/comunity/presentation/bloc/surveillance/cam_state.dart";
import "package:ciudadano/features/home/comunity/presentation/widgets/surveillance/cam_card.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class CamListWidget extends StatelessWidget {
  const CamListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CamBloc, CamState>(
      builder: (context, state) {
        if (state is CamLoading || state is CamInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CamError) {
          return Center(child: Text(state.msg));
        }
        final feeds = (state as CamLoaded).feeds;
        return ListView.builder(
          itemCount: feeds.length,
          itemBuilder: (_, i) => CamCard(feed: feeds[i]),
        );
      },
    );
  }
}