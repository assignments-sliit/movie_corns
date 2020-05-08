/*
 * IT17050272 - D. Manoj Kumar | IT17143950 - G.M.A.S. Bastiansz
 * 
 * This constants.dart file is consisting with all the constant names which are used in overall app
 * such as button names, title names, validators names, progress dialog messages, label names, hint texts,
 * toasts, error messages, prompt messages & image paths. It is easy to mention all constants in one dart file
 * because we happen to use same constants in multiple pages. Therefore, by maintaining this dart file it is
 * easy to mention those constants & it will make the source code more clear
 */

class ButtonConstants {
  static const String LOGIN_BUTTON = "START REVIEWING";
  static const String JOIN_BUTTON = "JOIN MOVIE CORNS";
  static const String EDIT_PROFILE = "EDIT PROFILE";
  static const String DELETE_PROFILE = "DELETE PROFILE";
  static const String LOGIN = "LOGIN";

  static const String ADD_REVIEW = "SUBMIT REVIEW";
  static const String CANCEL_REVIEW = "CANCEL REVIEW";

  static const String OPTION_CANCEL = "CANCEL";
  static const String OPTION_YES = "YES";
  static const String OPTION_DELETE = "DELETE";
  static const String OPTION_UPDATE = "UPDATE";
  static const String OPTION_CLOSE = "CLOSE";
}

class TitleConstants {
  static const String ALL_MOVIES = "All Movies";
  static const String MY_REVIEWS = "My Reviews";
  static const String PROFILE = "Profile";
  static const String LOGIN = "Login to Movie Corns";
  static const String REGISTER = "Register";

  static const String ADD_MOVIE_REVIEW = "Add movie Review";
  static const String NO_REVIEWS = "You have no Reviews. Add some to see them here!";
  static const String ALL_YOUR_REVIEWS = "All Your Reviews";
  static const String UPDATE_MOVIE_REVIEW = "Update Movie Review";

  static const String ALERT_SIGN_OUT = "Sign Out";
  static const String ALERT_WARNING = "Warning!";
  static const String ALERT_ERROR = "Error";
  static const String ALERT_EDIT_PROFILE = "Edit Profile";
}

class ValidatorConstants {
  static const String INVALID_EMAIL_FORMAT = "Email format is ivalid!";
  static const String WEAK_PASSWORD =
      "Password must contain more than 08 charachters";

  static const String INVALID_FIRST_NAME = "Please enter a valid first name.";
  static const String INVALID_LAST_NAME = "Please enter a valid last name.";

  static const String PASSWORDS_DO_NOT_MATCH = "The passwords do not match";

  static const String COMMENT_CANNOT_NULL = "Comment field cannot be empty";
}

class ProgressDialogMesssageConstants {
  static const String LOGGING_IN = "Logging in";
  static const String WELCOME_ABOARD = "Welcome Aboard!";
}

class LabelConstants {
  static const String LABEL_EMAIL = "Email ID";
  static const String LABEL_PASSWORD = "Password";
  static const String LABEL_FIRST_NAME = "First Name*";
  static const String LABEL_LAST_NAME = "Last Name*";
  static const String LABEL_CONFIRM_PASSWORD = "Confirm Password*";

  static const String LABEL_NEW_HERE = "New Here?";
  static const String LABEL_ALREADY_HAVE_ACCOUNT = "Already have an account?";

  static const String LABEL_COMMENT_FIELD = 'Comment';
  static const String LABEL_RATING_FIELD = 'Rate Us';
}

class HintTextConstants {
  static const String HINT_EMAIL = "john.doe@gmail.com";
  static const String HINT_PASSWORD = "*************";
  static const String HINT_FIRST_NAME = "John";
  static const String HINT_LAST_NAME = "Doe";

  static const String HINT_COMMENT_FIELD = "We like to hear from you!";
}

class ToastConstants {
  static const String WELCOME = "Welcome!";
  static const String INCORRECT_PASSWORD = "Incorrect Password!";
  static const String UNKNOWN_AUTH_ERROR = "Unknown Authentication Error";

  static const String ADD_REVIEW_SUCCESS = "Movie Review Added Successfully";
  static const String DELETE_REVIEW_SUCCESS =
      "Movie Review Deleted Successfully";
  static const String UPDATE_REVIEW_SUCCESS =
      "Movie Review Updated Successfully";

  static const String PROFILE_DELETED_SUCCESS =
      "User Profile Deleted Successfully";
  static const String PROFILE_UPDATE_SUCCESS =
      "User Profile Updated Successfully";
}

class FirebaseAuthErrorConstants {
  static const String ERROR_WRONG_PASSWORD = "ERROR_WRONG_PASSWORD";
}

class PromptConstants {
  static const String QUESTION_CONFIRM_SIGN_OUT =
      "Do you really want to sign out of Movie Corns?";

  static const String QUESTION_CONFIRM_ACCOUNT_DELETE =
      "Deleting an account will delete everything! Continue?";

  static const String QUESTION_CONFIRM_REVIEW_DELETE =
      "Do you really want to delete the review?";
}

class NetworkImagesPath {
  static const String PROFILE_AVATAR =
      "https://images.squarespace-cdn.com/content/v1/5b2c320e96e76f7d01013067/1530825643239-9KF07AF9QGKARM6XQKY4/ke17ZwdGBToddI8pDm48kOQScsc5TY8jCuObUFgfhqRZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZUJFbgE-7XRK3dMEBRBhUpydfvc957wEB9Bk1XYZkNiy-OPlMj7dW9OZ3-IR2fYHYSbnS5Sr8t-axcDC25WJZaM/Man-Gentleman-Silhouette-Gray-Free-Illustrations-F-0424.jpg";
  static const String MOVIE_AVATAR =
      "https://www.google.com/url?sa=i&url=http%3A%2F%2Fgearr.scannain.com%2Fmovies%2Fcharlie-lennon-ceol-on-gcroi%2F&psig=AOvVaw2yh_ZWeDf6OwCYaUroCkSU&ust=1588220621163000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCJi9_YHljOkCFQAAAAAdAAAAABAI";
}
