import 'package:check_disposable_email/check_disposable_email.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Disposable Email Checker',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      home: const EmailCheckerPage(),
    );
  }
}

class EmailCheckerPage extends StatefulWidget {
  const EmailCheckerPage({super.key});

  @override
  State<EmailCheckerPage> createState() => _EmailCheckerPageState();
}

class _EmailCheckerPageState extends State<EmailCheckerPage> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  EmailValidationResult? _validationResult;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an email address'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _validationResult = null;
    });

    // Simulate a small delay for better UX
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        final result = Disposable.instance.validateEmail(_emailController.text);
        setState(() {
          _validationResult = result;
          _isLoading = false;
        });
        _animationController.forward(from: 0.0);
        FocusScope.of(context).unfocus();
      }
    });
  }

  void _extractDomain() {
    final domain = Disposable.instance.extractDomain(_emailController.text);
    if (domain != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Extracted Domain: $domain'),
          backgroundColor: Colors.deepPurple,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not extract domain from email'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade400,
              Colors.purple.shade300,
              Colors.pink.shade300,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // Header Section
                _buildHeader(),
                const SizedBox(height: 40),
                // Email Input Card
                _buildInputCard(),
                const SizedBox(height: 30),
                // Action Buttons
                _buildActionButtons(),
                const SizedBox(height: 30),
                // Validation Result Card
                if (_validationResult != null)
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: _buildResultCard(),
                    ),
                  ),
                const SizedBox(height: 20),
                // Feature Showcase
                _buildFeatureShowcase(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            Icons.email_outlined,
            size: 60,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Email Validator',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Check if your email is disposable or valid',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildInputCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Email Address',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Enter email address (e.g., user@gmail.com)',
              prefixIcon: const Icon(Icons.email, color: Colors.deepPurple),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.deepPurple,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            onSubmitted: (_) => _validateEmail(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildGradientButton(
            onPressed: _isLoading ? null : _validateEmail,
            label: _isLoading ? 'Validating...' : 'Validate Email',
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.check_circle_outline, size: 20),
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade600, Colors.purple.shade400],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildGradientButton(
            onPressed: _extractDomain,
            label: 'Extract Domain',
            icon: const Icon(Icons.domain, size: 20),
            gradient: LinearGradient(
              colors: [Colors.pink.shade400, Colors.pink.shade300],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGradientButton({
    required VoidCallback? onPressed,
    required String label,
    required Widget icon,
    required Gradient gradient,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    if (_validationResult == null) return const SizedBox.shrink();

    final result = _validationResult!;
    final isSuccess = result.isValid;
    final isDisposable = result.isDisposable;
    final isFormatInvalid = !result.isFormatValid;

    Color cardColor;
    IconData icon;
    String title;
    String message;

    if (isSuccess) {
      cardColor = Colors.green;
      icon = Icons.check_circle;
      title = 'Valid Email';
      message = 'This email address is valid and not disposable.';
    } else if (isDisposable) {
      cardColor = Colors.orange;
      icon = Icons.warning;
      title = 'Disposable Email';
      message = 'This email uses a disposable/temporary domain.';
    } else {
      cardColor = Colors.red;
      icon = Icons.error;
      title = 'Invalid Email';
      message = result.errorMessage ?? 'Email format is invalid.';
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cardColor.withValues(alpha: 0.8),
            cardColor.withValues(alpha: 0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cardColor.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          if (result.domain != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.domain, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Domain: ${result.domain}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (result.errorMessage != null && isFormatInvalid) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      result.errorMessage!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          _buildDetailRow('Format Valid', result.isFormatValid),
          _buildDetailRow('Disposable', result.isDisposable),
          _buildDetailRow('Overall Valid', result.isValid),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: value ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value ? 'Yes' : 'No',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureShowcase() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.star, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Features',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFeatureItem(
            Icons.speed,
            'Fast Performance',
            'O(1) lookup with optimized Set-based checking',
          ),
          _buildFeatureItem(
            Icons.text_fields,
            'Case Insensitive',
            'Handles uppercase, lowercase, and mixed case',
          ),
          _buildFeatureItem(
            Icons.verified,
            'Format Validation',
            'RFC 5322 compliant email format checking',
          ),
          _buildFeatureItem(
            Icons.info_outline,
            'Detailed Results',
            'Get comprehensive validation information',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
