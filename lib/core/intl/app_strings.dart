import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'sign_in': 'Sign In',
      'sign_in_subtitle': 'Sign in to access your account',
      'email': 'Email',
      'password': 'Password',
      'forgot_password': 'Forgot Password?',
      'dont_have_account': 'Don\'t have an account?',
      'sign_up': 'Sign Up',
      'sign_up_subtitle': 'Sign up to access your account',
      'name': 'Name',
      'confirm_password': 'Confirm Password',
      'already_have_account': 'Already have an account?',
      'reset_password': 'Reset Password',
      'forgot_password_subtitle':
          'Enter the email used for your account and we\'ll send you a code for the confirmation',
      'enter_otp': 'Enter OTP',
      'otp_subtitle': 'we sent a 6 code to your email *****@.com',
      'didnt_get_otp': 'Didn\'t get OTP?',
      'resend': 'Resend',
      'verify': 'Verify',
      'create_new_password': 'Create New Password',
      'create_new_password_subtitle': 'Create a new unique password',
      'congratulations': 'Congratulations !',
      'success_msg':
          'Password Reset successful! You\'ll be redirected to the sign in screen now',
      'terms_conditions':
          'By using the app you agree to our Terms & Conditions and Privacy Policy',
      'no_internet': 'No Internet Connection',
      'server_error': 'Server Error',
    },
  };
}
