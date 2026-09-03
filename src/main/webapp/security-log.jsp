<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="models.SecurityLogPojo" %>

<%
    List<SecurityLogPojo> list = (List<SecurityLogPojo>) request.getAttribute("securityLogList");

    String log_username = request.getAttribute("username") != null ? (String) request.getAttribute("username") : "";
    String selectedRole = request.getAttribute("role") != null ? (String) request.getAttribute("role") : "";
    String fromDate = request.getAttribute("fromDate") != null ? (String) request.getAttribute("fromDate") : "";
    String toDate = request.getAttribute("toDate") != null ? (String) request.getAttribute("toDate") : "";
%>
<div class="row">

    <!-- MAIN CONTENT -->
    <div class="content-area col-lg-11">

        <!-- TOP BAR (same as user.jsp) -->
        <div class="glass-card topbar-glass d-flex justify-content-center align-items-center mb-4">
            <div class="text-center">
                <h3>Security Log</h3>
                <small>Monitor user login and logout activity</small>
            </div>
        </div>

        <!-- SEARCH BAR (same style) -->
        <div class="glass-card search-glass d-flex justify-content-center mb-4">

            <form method="get"
                  action="${pageContext.request.contextPath}/security-log"
                  class="d-flex align-items-center gap-2 flex-no-wrap">

                <input type="text"
                       name="username"
                       value="<%= log_username %>"
                       class="form-control search-input"
                       placeholder="Search">

                <select name="role" class="form-control search-input">
				    <option value="" <%= "".equals(selectedRole) ? "selected" : "" %>>All Roles</option>
				
				    <option value="Administrator" <%= "Administrator".equals(selectedRole) ? "selected" : "" %>>Administrator</option>
				
				    <option value="Port Manager" <%= "Port Manager".equals(selectedRole) ? "selected" : "" %>>Port Manager</option>
				
				    <option value="Ship Operator" <%= "Ship Operator".equals(selectedRole) ? "selected" : "" %>>Ship Operator</option>
				
				    <option value="Dock Manager" <%= "Dock Manager".equals(selectedRole) ? "selected" : "" %>>Dock Manager</option>
				
				    <option value="Cargo Handler" <%= "Cargo Handler".equals(selectedRole) ? "selected" : "" %>>Cargo Handler</option>
				</select>

                <input type="date" name="fromDate" value="<%= fromDate %>" class="form-control search-input">
                <input type="date" name="toDate" value="<%= toDate %>" class="form-control search-input">

                <button type="submit" name="action" value="search" class="btn btn-primary">
                    &nbsp;Search&nbsp;
                </button>

                <a href="security-log?action=show" class="btn btn-secondary clear-btn">
                    &nbsp;&nbsp;Show&nbsp;&nbsp;
                </a>

                <button type="submit"
				        name="action"
				        value="export"
				        class="btn btn-success">
				    Export
				</button>

            </form>

        </div>

        <!-- TABLE (same as user.jsp) -->
        <div class="table-responsive">
            <table class="table custom-table">

                <thead>
                    <tr>
                        <th>Log ID</th>
                        <th>Username</th>
                        <th>Role</th>
                        <th>Entry Time</th>
                        <th>Exit Time</th>
                        <th>Duration</th>
                    </tr>
                </thead>

                <tbody class="universal-page">

                <% if(list != null && !list.isEmpty()) {
                       for(SecurityLogPojo s : list){ %>

                    <tr>
                        <td><%= s.getLogId() %></td>
                        <td><%= s.getUsername() %></td>
                        <td><%= s.getRoleName() %></td>
                        <td class="arrival"><%= s.getEntryTime() %></td>
                            <%
                                if (s.getExitTime() == null || "null".equals(s.getExitTime())) {
                            %>
                            	<td>
	                                <span class="status-pill active-pill">
	                                    <i class="bi bi-check-circle"></i> Active
	                                </span>
	                            </td>
                            <%
                                } else {
                            %>
								<td class="departure">
								
							<%
                                    out.print(s.getExitTime());
                            %>
                            	</td>
                            <%
                                }
                            %>
                            
                        <td>
                            <%
                                if (s.getExitTime() == null) {
                            %>
                                <span class="status-pill active-pill">
                                    Running
                                </span>
                            <%
                                } else {
                                    out.print(s.getDuration());
                                }
                            %>
                        </td>

                    </tr>

                <% } } else { %>

                    <tr>
                        <td colspan="7" class="text-center text-muted">
                            No security logs found.
                        </td>
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