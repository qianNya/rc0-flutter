import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rc0_flutter/app/router/routes.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/features/auth/presentation/providers/login_provider.dart';
import 'package:rc0_flutter/shared/widgets/app_bottom_inset.dart';
import 'package:rc0_flutter/shared/widgets/app_primary_button.dart';
import 'package:rc0_flutter/shared/widgets/app_text_field.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    ref.read(loginProvider.notifier).clearError();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await ref.read(loginProvider.notifier).submit(
      username: _usernameController.text,
      password: _passwordController.text,
    );
    if (!mounted || !success) {
      return;
    }

    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('登录')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RCO',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '登录你的账号，开始创作',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      AppTextField(
                        controller: _usernameController,
                        label: '用户名',
                        hintText: '请输入用户名',
                        prefixIcon: Icons.person_outline,
                        textInputAction: TextInputAction.next,
                        enabled: !state.isLoading,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '请输入用户名';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        controller: _passwordController,
                        label: '密码',
                        hintText: '请输入密码',
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        enabled: !state.isLoading,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '请输入密码';
                          }
                          return null;
                        },
                      ),
                      if (state.error != null) ...[
                        const SizedBox(height: AppSpacing.lg),
                        AppFormErrorBanner(message: state.error!),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            AppBottomInset(
              color: theme.scaffoldBackgroundColor,
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  AppPrimaryButton(
                    label: state.isLoading ? '登录中…' : '登录',
                    onPressed: state.isLoading ? null : _submit,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextButton(
                    onPressed: state.isLoading
                        ? null
                        : () => context.push(AppRoutes.register),
                    child: const Text('还没有账号？去注册'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
