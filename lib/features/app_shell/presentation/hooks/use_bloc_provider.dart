import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_hooks/flutter_hooks.dart";

class _BlocProviderHook<B extends BlocBase<Object>> extends Hook<B> {
  const _BlocProviderHook({required this.create});

  final B Function() create;

  @override
  HookState<B, Hook<B>> createState() {
    return _BlocProviderHookState();
  }
}

class _BlocProviderHookState<B extends BlocBase<Object>>
    extends HookState<B, _BlocProviderHook<B>> {
  late final B bloc;

  @override
  void initHook() {
    super.initHook();
    bloc = hook.create();
  }

  @override
  B build(BuildContext context) {
    return bloc;
  }

  @override
  void dispose() {
    super.dispose();
    bloc.close();
  }
}

B useBlocProvider<B extends BlocBase<Object>>(B Function() create) {
  return use(_BlocProviderHook(create: create));
}
