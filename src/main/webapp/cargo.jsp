<%@ page import="java.util.List" %>
<%@ page import="models.CargoPojo" %>
<%@ page import="models.ContainerPojo" %>

<%
    List<CargoPojo> list = (List<CargoPojo>) request.getAttribute("cargoList");
    List<ContainerPojo> containerList = (List<ContainerPojo>) request.getAttribute("containerList");
%>

<div class="row">

    <!-- MAIN CONTENT -->
    <div class="content-area col-lg-11">

        <!-- TOP BAR -->
        <div class="glass-card topbar-glass d-flex justify-content-center align-items-center mb-4">
            <div class="text-center">
                <h3>Cargo Management</h3>
                <small>Manage Cargo Operations</small>
            </div>
        </div>

        <!-- SEARCH -->
        <div class="glass-card search-glass d-flex justify-content-center mb-4">

            <form method="get"
                  action="${pageContext.request.contextPath}/cargo"
                  class="d-flex align-items-center gap-2 flex-no-wrap">

                <input type="text"
                       name="search"
                       class="form-control search-input"
                       placeholder="Search">

                <button type="submit" class="btn btn-primary">Search</button>

                <a href="${pageContext.request.contextPath}/cargo"
                   class="btn btn-secondary clear-btn">Show</a>

                <button type="button"
                        class="btn btn-primary"
                        data-bs-toggle="modal"
                        data-bs-target="#addCargoModal">
                    Add
                </button>

            </form>

        </div>

    <!-- TABLE -->
    <div class="table-responsive">

        <table class="table custom-table">
            <thead>
			    <tr>
			        <th>Cargo ID</th>
			        <th>Description</th>
			        <th>Weight</th>
			        <th>Assigned Container</th>
			        <th>Container Type</th>
			        <th>Ship</th>
			        <th>Status</th>
			        <th>Actions</th>
			    </tr>
			</thead>

            <tbody class="universal-page">
                <% if(list != null){
                    for(CargoPojo c : list){ %>

                <tr>
				    <td><%= c.getCargoId() %></td>
				    <td><%= c.getDescription() %></td>
				    <td><%= c.getWeight() %> kg</td>
				
				    <td><%= c.getContainerId() %></td>
				
				    <td><%= c.getContainerType() != null ? c.getContainerType() : "-" %></td>
				
				    <td><%= c.getShipName() != null ? c.getShipName() : "-" %></td>
					
					<td>
                        <% if ("Loaded".equals(c.getStatus())) { %>
                            <span class="status-pill inactive-pill"> Loaded</span>
                        <% } else if ("Unloaded".equals(c.getStatus())) { %>
                            <span class="status-pill active-pill"> Unloaded</span>
                        <% } else { %>
                            <span class="status-pill pill-yellow"> In Transit</span>
                        <% } %>
                    </td>
                    <td>
                        <div class="d-flex gap-1">
							
                            <!-- STATUS -->
                            <form action="cargo" method="post">
                                <input type="hidden" name="action" value="status">
                                <input type="hidden" name="cargoId" value="<%= c.getCargoId() %>">

                                <select name="status" class="form-select user-input" onchange="this.form.submit()">
                                    <option <%= "Loaded".equals(c.getStatus())?"selected":"" %>>Loaded</option>
                                    <option <%= "Unloaded".equals(c.getStatus())?"selected":"" %>>Unloaded</option>
                                    <option <%= "In Transit".equals(c.getStatus())?"selected":"" %>>In Transit</option>
                                </select>
                            </form>
                            
                            <!-- EDIT -->
                            <button class="status-btn edit-btn" title="Edit Cargo"
                                    data-bs-toggle="modal"
                                    data-bs-target="#editCargoModal"
                                    onclick="fillEditCargo(this)"
                                    data-id="<%= c.getCargoId() %>"
                                    data-desc="<%= c.getDescription() %>"
                                    data-weight="<%= c.getWeight() %>"
                                    data-container="<%= c.getContainerId() %>">
                                <i class="bi bi-pencil"></i>
                            </button>

                            <!-- DELETE -->
                            <button class="status-btn inactive-btn" title="Delete Cargo"
                                    data-bs-toggle="modal"
                                    data-bs-target="#deleteCargoModal"
                                    onclick="setDeleteCargo(<%= c.getCargoId() %>)">
                                <i class="bi bi-trash"></i>
                            </button>
							
                        </div>
                    </td>
                </tr>

                <% } } %>
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



<div class="modal fade user-modal" id="addCargoModal">
    <div class="modal-dialog modal-dialog-centered user-modal-dialog">
        <div class="modal-content glass-modal p-3">

            <h5>Add Cargo</h5>

            <form action="cargo" method="post">
                <input type="hidden" name="action" value="add">

                <select name="containerId" class="form-control user-input mb-2" onchange="updatePanel(this)" required>
                    <option value="">Select Container</option>
                    <% if(containerList != null){
                        for(ContainerPojo ct : containerList){ %>
                        <option value="<%= ct.getContainerId() %>">
						    <%= ct.getContainerId() %> - <%= ct.getContainerType() %>
						</option>
                    <% } } %>
                </select>

                <input type="text" name="description" class="form-control user-input mb-2" placeholder="Description" required>

                <input type="number" step="0.01" min="0.01" name="weight" class="form-control user-input mb-2" placeholder="Weight" required>
                <button class="btn btn-primary w-100">Add</button>
            </form>

        </div>
    </div>
</div>

<div class="modal fade user-modal" id="editCargoModal">
    <div class="modal-dialog modal-dialog-centered user-modal-dialog">
        <div class="modal-content glass-modal p-3">

            <div class="d-flex justify-content-between mb-2">
                <h5>Edit Cargo</h5>
                <button class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <form action="cargo" method="post">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="cargoId" id="editCargoId">

                <!-- CONTAINER -->
                <select name="containerId" id="editContainer" class="form-control user-input mb-2">
                    <% for(ContainerPojo ct : containerList){ %>
                        <option value="<%= ct.getContainerId() %>">
                            <%= ct.getContainerId() %> - <%= ct.getContainerType() %>
                        </option>
                    <% } %>
                </select>

                <!-- DESC -->
                <input type="text" name="description" id="editDesc"
                       class="form-control user-input mb-2">

                <!-- WEIGHT -->
                <input type="number" step="0.01" name="weight" id="editWeight"
                       class="form-control user-input mb-2">


                <button class="btn btn-primary w-100">Update</button>
            </form>

        </div>
    </div>
</div>

<div class="modal fade user-modal" id="deleteCargoModal">
    <div class="modal-dialog modal-dialog-centered user-modal-dialog">
        <div class="modal-content glass-modal p-3 text-center">

            <h5 class="text-danger">Delete Cargo?</h5>
			
            <!-- Message -->
            <div class="text-center mb-3">
                Are you sure you want to delete this dock?
            </div>
            
            <form action="cargo" method="post">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="cargoId" id="deleteCargoId">

                <div class="d-flex gap-2 mt-3">
                    <button type="button" class="btn btn-secondary w-50" data-bs-dismiss="modal">
                        Cancel
                    </button>

                    <button class="btn btn-danger w-50">Delete</button>
                </div>
            </form>

        </div>
    </div>
</div>

<script>

function fillEditCargo(btn){

    document.getElementById("editCargoId").value = btn.dataset.id;
    document.getElementById("editDesc").value = btn.dataset.desc;
    document.getElementById("editWeight").value = btn.dataset.weight;
    document.getElementById("editContainer").value = btn.dataset.container;
}

function setDeleteCargo(id){
    document.getElementById("deleteCargoId").value = id;
}
</script>
