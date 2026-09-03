package models;

import java.util.List;

import implementor.UserImplementor;	
import implementor.LoginImplementor;
import implementor.ProfileImplementor;

public class UserPojo {
	
	private int userId;
	private String name;
	private String email;
	private String password;
	private String status;
	private int roleId;
	private String roleName;
	private String searchUser;
	
	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public int getRoleId() {
		return roleId;
	}

	public void setRoleId(int roleId) {
		this.roleId = roleId;
	}

	public String getRoleName() {
		return roleName;
	}

	public void setRoleName(String roleName) {
		this.roleName = roleName;
	}

	public String getSearchUser() {
		return searchUser;
	}

	public void setSearchUser(String searchUser) {
		this.searchUser = searchUser;
	}

	public void addUser(UserPojo userPojo) {
		new UserImplementor().addUser(userPojo);
	}
	
	public void updateUser(UserPojo userPojo) {
		new UserImplementor().updateUser(userPojo);;
	}
	
	public void setUserStatus(UserPojo userPojo) {
		new UserImplementor().setUserStatus(userPojo);
	}
	
	public static List<UserPojo> showUser() {
	    return new UserImplementor().showUser();
	}
	
	public static List<UserPojo> searchUsers(String keyword) {
	    return new UserImplementor().searchUser(keyword);
	}

	public UserPojo loginUser(UserPojo userPojo) {
	    return new LoginImplementor().loginUser(userPojo);
	}
	
	public String logoutUser(int userId) {
	    return new LoginImplementor().logoutUser(userId);
	}
	
	public List<UserPojo> getOperators() {
	    return new UserImplementor().getOperators();
	}
	
	// PROFILE METHODS (MVC2)

	public UserPojo getUserById(int userId) {
	    return new ProfileImplementor().getUserById(userId);
	}

	public boolean updateProfile(UserPojo userPojo, int roleId, String roleName) {
	    return new ProfileImplementor().updateProfile(userPojo, roleId, roleName);
	}
}
