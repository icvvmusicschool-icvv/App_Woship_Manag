import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class LoginAuthenticationScreen extends StatefulWidget {
  const LoginAuthenticationScreen({super.key});

  @override
  State<LoginAuthenticationScreen> createState() =>
      _LoginAuthenticationScreenState();
}

class _LoginAuthenticationScreenState extends State<LoginAuthenticationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  // Mock credentials
  static const _mockCredentials = [
    {'email': 'admin@ministerio.com', 'password': 'Admin@123', 'role': 'admin'},
    {
      'email': 'musico@ministerio.com',
      'password': 'Musico@123',
      'role': 'musician',
    },
    {
      'email': 'tecnico@ministerio.com',
      'password': 'Tecnico@123',
      'role': 'technical',
    },
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu e-mail';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor, insira um e-mail válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira sua senha';
    }
    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final matched = _mockCredentials.firstWhere(
      (c) => c['email'] == email && c['password'] == password,
      orElse: () => {},
    );

    if (!mounted) return;

    if (matched.isNotEmpty) {
      HapticFeedback.lightImpact();
      Navigator.of(
        context,
        rootNavigator: true,
      ).pushNamed('/dashboard-home-screen');
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Credenciais inválidas. Use:\nadmin@ministerio.com / Admin@123\nmusico@ministerio.com / Musico@123\ntecnico@ministerio.com / Tecnico@123';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom -
                      4.h,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 4.h),
                      _MinistryLogoHeader(theme: theme),
                      SizedBox(height: 4.h),
                      _LoginForm(
                        formKey: _formKey,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        obscurePassword: _obscurePassword,
                        isLoading: _isLoading,
                        errorMessage: _errorMessage,
                        onTogglePassword: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        onValidateEmail: _validateEmail,
                        onValidatePassword: _validatePassword,
                        onLogin: _handleLogin,
                        theme: theme,
                      ),
                      const Spacer(),
                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MinistryLogoHeader extends StatelessWidget {
  final ThemeData theme;
  const _MinistryLogoHeader({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'music_note',
              color: theme.colorScheme.onPrimary,
              size: 10.w,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'Ministério de Louvor',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 0.5.h),
        Text(
          'Bem-vindo de volta! Faça login para continuar.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onTogglePassword;
  final String? Function(String?) onValidateEmail;
  final String? Function(String?) onValidatePassword;
  final VoidCallback onLogin;
  final ThemeData theme;

  const _LoginForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isLoading,
    required this.errorMessage,
    required this.onTogglePassword,
    required this.onValidateEmail,
    required this.onValidatePassword,
    required this.onLogin,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email field
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            enabled: !isLoading,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'E-mail',
              hintText: 'seu@email.com',
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: CustomIconWidget(
                  iconName: 'email_outlined',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 22,
                ),
              ),
            ),
            validator: onValidateEmail,
          ),
          SizedBox(height: 2.h),
          // Password field
          TextFormField(
            controller: passwordController,
            obscureText: obscurePassword,
            enabled: !isLoading,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => onLogin(),
            decoration: InputDecoration(
              labelText: 'Senha',
              hintText: '••••••••',
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: CustomIconWidget(
                  iconName: 'lock_outline',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 22,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: onTogglePassword,
                icon: CustomIconWidget(
                  iconName: obscurePassword ? 'visibility_off' : 'visibility',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 22,
                ),
              ),
            ),
            validator: onValidatePassword,
          ),
          SizedBox(height: 1.h),
          // Forgot password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: isLoading
                  ? null
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Funcionalidade de recuperação de senha em breve.',
                          ),
                        ),
                      );
                    },
              child: Text(
                'Esqueci minha senha?',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 1.h),
          // Error message
          errorMessage != null
              ? Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomIconWidget(
                        iconName: 'error_outline',
                        color: theme.colorScheme.error,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          errorMessage!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          SizedBox(height: 2.h),
          // Login button
          SizedBox(
            height: 6.h,
            child: ElevatedButton(
              onPressed: isLoading ? null : onLogin,
              child: isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: theme.colorScheme.onPrimary,
                      ),
                    )
                  : Text(
                      'Entrar',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
