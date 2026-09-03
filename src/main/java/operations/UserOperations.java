package operations;

import java.util.List;

import models.UserPojo;

public interface UserOperations {

	void addUser(UserPojo userPojo);
	void updateUser(UserPojo userPojo);
	void setUserStatus(UserPojo userPojo);
	List<UserPojo> showUser();
	List<UserPojo> searchUser(String keyword);
	
}
