package operations;

import models.UserPojo;

public interface LoginOperations {

	UserPojo loginUser(UserPojo userPojo);   // returns message
    String logoutUser(int userId);         // returns message

}