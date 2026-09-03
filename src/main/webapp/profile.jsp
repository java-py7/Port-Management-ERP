<%@ page import="models.UserPojo" %>

<%
    UserPojo user = (UserPojo) request.getAttribute("profileUser");
  	String success = request.getParameter("success");
	String error = request.getParameter("error");
%>

    <div class="content-area col-lg-11">

        <!-- TOP BAR -->
        <div class="glass-card topbar-glass d-flex justify-content-center align-items-center mb-4">
            <div class="text-center">
                <h3>My Profile</h3>
                <small>Manage your account details</small>
            </div>
        </div>

    <!-- MESSAGE -->
    <% if(success != null){ %>
        <div class="alert alert-success"><%= success %></div>
    <% } %>

    <% if(error != null){ %>
        <div class="alert alert-danger"><%= error %></div>
    <% } %>

    <!-- PROFILE CARD -->
    <div class="glass-card p-4">

        <form action="profile" method="post">

            <input type="hidden" name="action" value="updateProfile">

            <!-- NAME -->
            <div class="mb-3 user-field">
                <label class="user-label">Name</label>
                <input type="text"
                       name="name"
                       value="<%= user != null ? user.getName() : "" %>"
                       class="form-control user-input"
                       required>
            </div>

            <!-- EMAIL -->
            <div class="mb-3 user-field">
                <label class="user-label">Email</label>
                <input type="email"
                       name="email"
                       value="<%= user != null ? user.getEmail() : "" %>"
                       class="form-control user-input"
                       required>
            </div>

            <!-- ROLE -->
            <div class="mb-3 user-field">
                <label class="user-label">Role</label>
                <input type="text"
                       value="<%= user != null ? user.getRoleName() : "" %>"
                       class="form-control user-input"
                       readonly>
            </div>

            <!-- BUTTONS -->
            <div class="d-flex gap-2">

                <button type="submit" class="btn btn-primary user-btn w-50">
                    Update Profile
                </button>

                <button type="button"
                        class="btn btn-secondary user-btn w-50"
                        data-bs-toggle="modal"
                        data-bs-target="#passwordModal">
                    Change Password
                </button>

            </div>

        </form>

    </div>

</div>

<div class="modal fade user-modal" id="passwordModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered user-modal-dialog">
        <div class="modal-content glass-modal user-modal-content p-3">

            <!-- HEADER -->
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5>Change Password</h5>
                <button class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <!-- FORM -->
            <form action="profile" method="post">

                <input type="hidden" name="action" value="changePassword">

                <div class="mb-3">
                    <label>New Password</label>
                    <input type="password" name="newPassword" class="form-control user-input" required>
                </div>

                <div class="mb-3">
                    <label>Confirm Password</label>
                    <input type="password" name="confirmPassword" class="form-control user-input" required>
                </div>

                <button class="btn btn-primary w-100 user-btn">
                    Update Password
                </button>

            </form>

        </div>
    </div>
</div>