import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rc0_flutter/app/router/routes.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/features/auth/presentation/providers/register_provider.dart';
import 'package:rc0_flutter/shared/widgets/app_bottom_inset.dart';
import 'package:rc0_flutter/shared/widgets/app_primary_button.dart';
import 'package:rc0_flutter/shared/widgets/app_text_field.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _nicknameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    ref.read(registerProvider.notifier).clearError();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await ref.read(registerProvider.notifier).submit(
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      nickname: _nicknameController.text,
    );
    if (!mounted || !success) {
      return;
    }

    context.go(AppRoutes.home);
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '请输入邮箱';
    }
    final emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
    if (!emailPattern.hasMatch(value.trim())) {
      return '请输入有效的邮箱地址';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('注册')),
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
                        '创建账号',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '加入 RCO，探索影视创作',
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
                        hintText: '3–64 个字符',
                        prefixIcon: Icons.person_outline,
                        textInputAction: TextInputAction.next,
                        enabled: !state.isLoading,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '请输入用户名';
                          }
                          final length = value.trim().length;
                          if (length < 3 || length > 64) {
                            return '用户名长度应为 3–64 个字符';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        controller: _emailController,
                        label: '邮箱',
                        hintText: 'name@example.com',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        enabled: !state.isLoading,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        controller: _nicknameController,
                        label: '昵称（可选）',
                        hintText: '留空则使用用户名',
                        prefixIcon: Icons.badge_outlined,
                        textInputAction: TextInputAction.next,
                        enabled: !state.isLoading,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        controller: _passwordController,
                        label: '密码',
                        hintText: '8–128 个字符',
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        enabled: !state.isLoading,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '请输入密码';
                          }
                          if (value.length < 8 || value.length > 128) {
                            return '密码长度应为 8–128 个字符';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        controller: _confirmPasswordController,
                        label: '确认密码',
                        hintText: '再次输入密码',
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        enabled: !state.isLoading,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '请确认密码';
                          }
                          if (value != _passwordController.text) {
                            return '两次输入的密码不一致';
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
                    label: state.isLoading ? '注册中…' : '注册',
                    onPressed: state.isLoading ? null : _submit,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextButton(
                    onPressed: state.isLoading
                        ? null
                        : () => context.pop(),
                    child: const Text('已有账号？去登录'),
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
