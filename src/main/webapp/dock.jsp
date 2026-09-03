<%@ page import="java.util.List" %>
<%@ page import="models.DockPojo" %>

<%
    List<DockPojo> dockList = (List<DockPojo>) request.getAttribute("dockList");
%>

<div class="row">

    <div class="content-area col-lg-11">

        <!-- TOP BAR -->
        <div class="glass-card topbar-glass d-flex justify-content-center align-items-center mb-4">
            <div class="text-center">
                <h3>Dock Management</h3>
                <small>Manage docks and their availability</small>
            </div>
        </div>

        <!-- SEARCH -->
        <div class="glass-card search-glass d-flex justify-content-center mb-4">

            <form method="get"
                  action="${pageContext.request.contextPath}/dock"
                  class="d-flex align-items-center gap-2 flex-no-wrap">

                <input type="text"
                       name="search"
                       class="form-control search-input"
                       placeholder="Search">

                <button type="submit" class="btn btn-primary">Search</button>

                <a href="${pageContext.request.contextPath}/dock"
                   class="btn btn-secondary clear-btn">Show</a>

                <button type="button"
                        class="btn btn-primary"
                        data-bs-toggle="modal"
                        data-bs-target="#addDockModal">
                    Add
                </button>

            </form>

        </div>

        <!-- TABLE -->
        <div class="table-responsive">
            <table class="table custom-table">

                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Dock Name</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>

                <tbody class="universal-page">

                <% if(dockList != null && !dockList.isEmpty()) {
                       for(DockPojo d : dockList){ %>

                    <tr>
                        <td><%= d.getDockId() %></td>
                        <td><%= d.getDockName() %></td>

                        <!-- STATUS -->
                        <td>
                            <% if ("Available".equals(d.getStatus())) { %>
                                <span class="status-pill active-pill"><i class="bi-check-circle"></i> Available</span>
                            <% } else if ("Occupied".equals(d.getStatus())) { %>
                                <span class="status-pill inactive-pill"><i class="bi-x-circle"></i> Occupied</span>
                            <% } else { %>
                                <span class="status-pill pill-yellow"><i class="fas fa-wrench"></i> Under Maintenance</span>
                            <% } %>
                        </td>

                        <!-- ACTIONS -->
                        <td>
                            <div class="action-btn">

                                <!-- EDIT -->
                                <button class="status-btn edit-btn" title="Edit Dock"
                                        data-bs-toggle="modal"
                                        data-bs-target="#editDockModal"
                                        onclick="fillDockEdit(this)"
                                        data-id="<%= d.getDockId() %>"
                                        data-name="<%= d.getDockName() %>"
                                        data-status="<%= d.getStatus() %>">
                                    <i class="bi bi-pencil"></i>
                                </button>

                                <!-- DELETE -->
                                <form action="${pageContext.request.contextPath}/dock" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="dockId" value="<%= d.getDockId() %>">
                                    <button class="status-btn inactive-btn" title="Delete Dock"
									        type="button"
									        data-bs-toggle="modal"
									        data-bs-target="#deleteDockModal"
									        onclick="setDeleteDock(<%= d.getDockId() %>)">
									    <i class="bi bi-trash"></i>
									</button>
                                </form>

                                <!-- STATUS BUTTONS -->
                                <% if (!"Under Maintenance".equals(d.getStatus())) { %>
                                <form action="${pageContext.request.contextPath}/dock" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="status">
                                    <input type="hidden" name="dockId" value="<%= d.getDockId() %>">
                                    <input type="hidden" name="status" value="Under Maintenance">
                                    <button class="status-btn pill-yellow" style="padding: 8px 12px;" title="Dock Under Maintenance"><i class="fas fa-wrench"></i></button>
                                </form>
                                <% } %>
                                
                                <% if (!"Available".equals(d.getStatus())) { %>
                                <form action="${pageContext.request.contextPath}/dock" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="status">
                                    <input type="hidden" name="dockId" value="<%= d.getDockId() %>">
                                    <input type="hidden" name="status" value="Available">
                                    <button class="status-btn active-btn" title="Dock Available"><i class="bi-check-circle"></i></button>
                                </form>
                                <% } %>

                                <% if (!"Occupied".equals(d.getStatus())) { %>
                                <form action="${pageContext.request.contextPath}/dock" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="status">
                                    <input type="hidden" name="dockId" value="<%= d.getDockId() %>">
                                    <input type="hidden" name="status" value="Occupied">
                                    <button class="status-btn inactive-btn" title="Dock Occupied"><i class="bi-x-circle"></i></button>
                                </form>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                <% } } else { %>
                    <tr>
                        <td colspan="4" class="text-center text-muted">
                            No docks found.
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


<div class="modal fade user-modal" id="addDockModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered user-modal-dialog">
        <div class="modal-content glass-modal user-modal-content p-3">

            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-3 user-modal-header">
                <h5 class="user-modal-title">Add Dock</h5>
                <button type="button" class="btn-close user-modal-close" data-bs-dismiss="modal"></button>
            </div>

            <!-- Form -->
            <form action="${pageContext.request.contextPath}/dock" method="post" class="user-form">
                <input type="hidden" name="action" value="add">

                <div class="mb-3 user-field">
                    <label class="user-label">Dock Name</label>
                    <input type="text" name="dockName" class="form-control user-input" placeholder="Enter dock name" required>
                </div>

                <button type="submit" class="btn btn-primary w-100 user-btn">
                    Add Dock
                </button>
            </form>

        </div>
    </div>
</div>

<div class="modal fade user-modal" id="editDockModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered user-modal-dialog">
        <div class="modal-content glass-modal user-modal-content p-3">

            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-3 user-modal-header">
                <h5 class="user-modal-title">Edit Dock</h5>
                <button type="button" class="btn-close user-modal-close" data-bs-dismiss="modal"></button>
            </div>

            <!-- Form -->
            <form action="${pageContext.request.contextPath}/dock" method="post" class="user-form">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="dockId" id="editDockId">

                <div class="mb-3 user-field">
                    <label class="user-label">Dock Name</label>
                    <input type="text" name="dockName" id="editDockName" class="form-control user-input" required>
                </div>

                <button type="submit" class="btn btn-primary w-100 user-btn">
                    Update Dock
                </button>
            </form>

        </div>
    </div>
</div>

<div class="modal fade user-modal" id="deleteDockModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered user-modal-dialog">
        <div class="modal-content glass-modal user-modal-content p-3">

            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="text-danger">Delete Dock</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <!-- Message -->
            <div class="text-center mb-3">
                Are you sure you want to delete this dock?
            </div>

            <!-- Form -->
            <form action="${pageContext.request.contextPath}/dock" method="post">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="dockId" id="deleteDockId">

                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-secondary w-50" data-bs-dismiss="modal">
                        Cancel
                    </button>

                    <button type="submit" class="btn btn-danger w-50">
                        Delete
                    </button>
                </div>
            </form>

        </div>
    </div>
</div>

<script>
function fillDockEdit(btn){
    document.getElementById("editDockId").value = btn.dataset.id;
    document.getElementById("editDockName").value = btn.dataset.name;
}

function setDeleteDock(id){
    document.getElementById("deleteDockId").value = id;
}
</script>