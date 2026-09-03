<%@ page import="java.util.List" %>
<%@ page import="models.UserPojo" %>
<%@ page import="models.RolePojo" %>
<%
    List<UserPojo> userList = (List<UserPojo>) request.getAttribute("userList");
%>
<div class="row">
        
    <!-- Main Content -->
    <div class="content-area col-lg-11">

        <!-- Top Bar -->
        <div class="glass-card topbar-glass d-flex justify-content-center align-items-center mb-4">
            <div class="text-center">
                <h3>User Management</h3>
                <small>Manage system users and their roles</small>
            </div>
        </div>

        <!-- Search -->
        <div class="glass-card search-glass d-flex justify-content-center mb-4">

    <form method="get"
          action="${pageContext.request.contextPath}/user"
          class="d-flex align-items-center gap-2 flex-no-wrap">

        <input type="text"
               name="search"
               class="form-control search-input"
               placeholder="Search users...">

        <button type="submit" class="btn btn-primary">
            &nbsp;Search&nbsp;
        </button>

        <button type="button"
        class="btn btn-secondary clear-btn"
        onclick="window.location='${pageContext.request.contextPath}/user'">
            &nbsp;&nbsp;Show&nbsp;&nbsp;
        </button>

        <button type="button"
                class="btn btn-primary"
                data-bs-toggle="modal"
                data-bs-target="#addUserModal">
            &nbsp;&nbsp;&nbsp;Add&nbsp;&nbsp;&nbsp;
        </button>

    </form>

</div>
        <!-- Table -->
        <div class="table-responsive">
            <table class="table custom-table">
                <thead>
                    <tr>
                        <th>Id</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody class="user-table-body universal-page">
                <% if(userList != null && !userList.isEmpty()) { 
                                   for(UserPojo u : userList){ %>
                	<tr>
                       <td><%= u.getUserId() %></td>
                       <td><%= u.getName() %></td>
                       <td><%= u.getEmail() %></td>
                       <td><%= u.getRoleName() %></td>
                	   <td>
							<%
							    if ("Active".equals(u.getStatus())) {
							%>
							        <span class="status-pill active-pill">
							            <i class="fas fa-unlock"></i> Active
							        </span>
							<%
							    } else {
							%>
							        <span class="status-pill inactive-pill">
							            <i class="fas fa-lock"></i> Inactive
							        </span>
							<%
							    }
							%>
						</td>		
                		<td>
                            <div class="action-btn icon-box">
                                <button class="status-btn edit-btn" title="Edit User"
								        onclick="fillEdit(this)"
								        data-bs-toggle="modal"
								        data-bs-target="#editUserModal"
								        data-id="<%= u.getUserId() %>"
								        data-name="<%= u.getName() %>"
								        data-email="<%= u.getEmail() %>"
								        data-role="<%= u.getRoleId() %>">
								    <i class="bi bi-pencil"></i>
								</button>
                                <%
								    if ("Active".equals(u.getStatus())) {
								%>
                                <form action="${pageContext.request.contextPath}/user" method="post" style="display:inline;">
								    <input type="hidden" name="action" value="deactivate">
								    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
								    <button type="submit" class="status-btn inactive-btn" style="padding: 8px 12px;" title="Deactivate User">
								        <i class="fas fa-lock"></i>
								    </button>
								</form>
								<%
								    } else {
								%>
                                <form action="${pageContext.request.contextPath}/user" method="post" style="display:inline;">
								    <input type="hidden" name="action" value="activate">
								    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
								    <button type="submit" class="status-btn active-btn" style="padding: 8px 12px;" title="Activate User">
								        <i class="fas fa-unlock"></i>
								    </button>
								</form>
								<%
								    }
								%>
                            </div>
                        </td>
                    </tr>
                <%   }
                   } else { %>
                    <tr>
                        <td colspan="6" class="text-center text-muted">No users found.</td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
		
                            
                            
        <!-- Pagination -->
        <div class="d-flex justify-content-end mt-3">
		    <ul class="pagination custom-pagination" id="pagination">
		        <li class="page-item">
		            <a class="page-link" href="#" onclick="prevPage()">Prev</a>
		        </li>
		
		        <li class="page-item disabled">
		            <span class="page-link" id="pageInfo">Page 1</span>
		        </li>
		
		        <li class="page-item">
		            <a class="page-link" href="#" onclick="nextPage()">Next</a>
		        </li>
		    </ul>
		</div>

    </div>
</div>

<!-- Add User Modal -->
<div class="modal fade user-modal" id="addUserModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered user-modal-dialog">
        <div class="modal-content glass-modal user-modal-content p-3">

            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-3 user-modal-header">
                <h5 class="user-modal-title">Add User</h5>
                <button type="button" class="btn-close user-modal-close" data-bs-dismiss="modal"></button>
            </div>

            <!-- Form -->
            <form action="${pageContext.request.contextPath}/user" method="post" class="user-form">
                <input type="hidden" name="action" value="add">
                <div class="mb-3 user-field">
                    <label class="user-label">Name</label>
                    <input type="text" name="name" class="form-control user-input" placeholder="Enter name" required>
                </div>

                <div class="mb-3 user-field">
                    <label class="user-label">Email</label>
                    <input type="email" name="email" class="form-control user-input" placeholder="Enter email" required>
                </div>
                
				<div class="mb-3 user-field position-relative">
                    <label class="user-label">Password</label>	    
					    <input type="password" 
					           name="password" 
					           class="form-control user-input" 
					           id="addPassword" 
					           placeholder="Enter password">
					
					    <i class="fa fa-eye-slash toggle-add-eye"
					       onclick="toggleAddPassword()"
					       style="position:absolute; right:15px; top:42px; cursor:pointer;">
					    </i>
                </div>
                
                <div class="mb-3 user-field">
                    <label class="user-label">Role</label>
                    <select name="roleId" class="form-control user-select" required>
                        <option value="">Select Role</option>
                        <option value="1">Administrator</option>
                        <option value="2">Port Manager</option>
                        <option value="3">Ship Operator</option>
                        <option value="4">Dock Manager</option>
                        <option value="5">Cargo Handler</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary w-100 user-btn">
                    Add User
                </button>
            </form>

        </div>
    </div>
</div>

<!-- Edit User Modal -->
<div class="modal fade user-modal" id="editUserModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered user-modal-dialog">
        <div class="modal-content glass-modal user-modal-content p-3">

            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-3 user-modal-header">
                <h5 class="user-modal-title">Edit User</h5>
                <button type="button" class="btn-close user-modal-close" data-bs-dismiss="modal"></button>
            </div>

            <!-- Form -->
            <form action="${pageContext.request.contextPath}/user" method="post" class="user-form">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="userId" id="editUserId">
                <div class="mb-3 user-field">
                    <label class="user-label">Name</label>
                    <input type="text" name="name" class="form-control user-input" id="editName" placeholder="Enter name" required>
                </div>

                <div class="mb-3 user-field">
                    <label class="user-label">Email</label>
                    <input type="email" name="email" class="form-control user-input" id="editEmail" placeholder="Enter email" required>
                </div>

	            <div class="mb-3 user-field position-relative">		
	                <label class="user-label">Password</label>		    
				    <input type="password" 
				           name="password" 
				           class="form-control user-input" 
				           id="editPassword" 
				           placeholder="New password">
				
				    <i class="fa fa-eye-slash toggle-edit-eye"
				       onclick="toggleEditPassword()"
				       style="position:absolute; right:15px; top:42px; cursor:pointer;">
				    </i>
				</div>

                <div class="mb-3 user-field">
                    <label class="user-label">Role</label>
                    <select name="roleId" id="editRole" class="form-control user-select" required>
                        <option value="">Select Role</option>
                        <option value="1">Administrator</option>
                        <option value="2">Port Manager</option>
                        <option value="3">Ship Operator</option>
                        <option value="4">Dock Manager</option>
                        <option value="5">Cargo Handler</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary w-100 user-btn">
                    Update User
                </button>
            </form>

        </div>
    </div>
</div>

<script>
function fillEdit(btn){
    console.log("ID:", btn.dataset.id); // DEBUG

    document.getElementById("editUserId").value = btn.dataset.id;
    document.getElementById("editName").value = btn.dataset.name;
    document.getElementById("editEmail").value = btn.dataset.email;
    document.getElementById("editRole").value = btn.dataset.role;
}

function toggleEditPassword(){
    let pass = document.getElementById("editPassword");
    let icon = document.querySelector(".toggle-edit-eye");

    if(pass.type === "password"){
        pass.type = "text";
        icon.classList.remove("fa-eye-slash");
        icon.classList.add("fa-eye");
    } else {
        pass.type = "password";
        icon.classList.remove("fa-eye");
        icon.classList.add("fa-eye-slash");
    }
}

function toggleAddPassword(){
    let pass = document.getElementById("addPassword");
    let icon = document.querySelector(".toggle-add-eye");

    if(pass.type === "password"){
        pass.type = "text";
        icon.classList.remove("fa-eye-slash");
        icon.classList.add("fa-eye");
    } else {
        pass.type = "password";
        icon.classList.remove("fa-eye");
        icon.classList.add("fa-eye-slash");
    }
}

</script>