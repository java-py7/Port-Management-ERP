<%@ page import="java.util.List" %>
<%@ page import="models.ContainerPojo" %>
<%@ page import="models.ShipPojo" %>

<%
    List<ContainerPojo> list = (List<ContainerPojo>) request.getAttribute("containerList");
	List<models.CargoPojo> cargoList = (List<models.CargoPojo>) request.getAttribute("cargoList");
	List<ShipPojo> ships = (List<ShipPojo>) request.getAttribute("shipList");
%>
<div class="row">

    <!-- MAIN CONTENT -->
    <div class="content-area col-lg-11">

        <!-- TOP BAR -->
        <div class="glass-card topbar-glass d-flex justify-content-center align-items-center mb-4">
            <div class="text-center">
                <h3>Container Management</h3>
                <small>Manage Containers and Assignments</small>
            </div>
        </div>

        <!-- SEARCH -->
        <div class="glass-card search-glass d-flex justify-content-center mb-4">

            <form method="get"
                  action="${pageContext.request.contextPath}/container"
                  class="d-flex align-items-center gap-2 flex-no-wrap">

                <input type="text"
                       name="search"
                       class="form-control search-input"
                       placeholder="Search">

                <button type="submit" class="btn btn-primary">Search</button>

                <a href="${pageContext.request.contextPath}/container"
                   class="btn btn-secondary clear-btn">Show</a>

                <button type="button"
                        class="btn btn-primary"
                        data-bs-toggle="modal"
                        data-bs-target="#addContainerModal">
                    Add
                </button>

            </form>

        </div>
		
		<!-- TABLE -->
        <div class="table-responsive">
            <table class="table custom-table">

                <thead>
                    <tr>
	                    <th>Container ID</th>
	                    <th>Container Type</th>
	                    <th>Assigned Ship</th>
	                    <th>Status</th>
	                    <th>Actions</th>
	                </tr>
                </thead>

                <tbody class="universal-page">

                <% if(list != null){ 
                    for(ContainerPojo c : list){ %>

                <tr>
                    <td><%= c.getContainerId() %></td>
                    <td><%= c.getContainerType() %></td>
                    <td>
                        <%= c.getShipName() != null ? c.getShipName() : "-" %>
                    </td>
					<td>
                        <% if ("Loaded".equals(c.getStatus())) { %>
                            <span class="status-pill inactive-pill"> Loaded</span>
                        <% } else if ("Empty".equals(c.getStatus())) { %>
                            <span class="status-pill active-pill"> Empty</span>
                        <% } else { %>
                            <span class="status-pill pill-yellow"> In Transit</span>
                        <% } %>
                    </td>
                    <td>
                        <div class="d-flex gap-1">

                            <!-- STATUS -->
                            <form action="container" method="post">
                                <input type="hidden" name="action" value="status">
                                <input type="hidden" name="containerId" value="<%= c.getContainerId() %>">

                                <select name="status" class="form-select user-input" onchange="this.form.submit()">
                                    <option <%= "Loaded".equals(c.getStatus())?"selected":"" %>>Loaded</option>
                                    <option <%= "Empty".equals(c.getStatus())?"selected":"" %>>Empty</option>
                                    <option <%= "In Transit".equals(c.getStatus())?"selected":"" %>>In Transit</option>
                                </select>
                            </form>
                            
                            <!-- EDIT -->
                            <button class="status-btn edit-btn" title="Edit Container"
                                    data-bs-toggle="modal"
                                    data-bs-target="#editContainerModal"
                                    onclick="fillEditContainer(this)"
                                    data-id="<%= c.getContainerId() %>"
                                    data-type="<%= c.getContainerType() %>"
                                    data-ship="<%= c.getShipId() %>"
                                    data-status="<%= c.getStatus() %>">
                                <i class="bi bi-pencil"></i>
                            </button>

                            <!-- DELETE -->
                            <button class="status-btn inactive-btn" title="Delete Container"
                                    data-bs-toggle="modal"
                                    data-bs-target="#deleteContainerModal"
                                    onclick="setDeleteContainer(<%= c.getContainerId() %>)">
                                <i class="bi bi-trash"></i>
                            </button>

							
							<button class="status-btn active-btn"
							        data-bs-toggle="modal"
							        data-bs-target="#assignContainerModal"
							        onclick="setAssignContainer(<%= c.getContainerId() %>)">
							    Assign
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


<div class="modal fade user-modal" id="addContainerModal">
    <div class="modal-dialog modal-dialog-centered user-modal-dialog">
        <div class="modal-content glass-modal p-3">

            <h5>Add Container</h5>

            <form action="container" method="post">
                <input type="hidden" name="action" value="add">
				
				<label>Select Container</label>
                <select name="containerType" class="form-control user-input mb-3">
                    <option>Dry</option>
                    <option>Reefer</option>
                    <option>Open Top</option>
                    <option>Tank</option>
                </select>

                <button class="btn btn-primary w-100">Add</button>
            </form>

        </div>
    </div>
</div>

<!-- 🔥 ASSIGN CONTAINER -->
<div class="modal fade user-modal" id="assignContainerModal">
    <div class="modal-dialog modal-dialog-centered user-modal-dialog">
        <div class="modal-content glass-modal p-3">

            <h5>Assign Container to Ship</h5>

            <form action="container" method="post">

                <input type="hidden" name="action" value="assign">
                <input type="hidden" name="containerId" id="assignContainerId">
				
                <select name="shipId" class="form-control user-input mb-3" required>
                	<option value="">Select Ship</option>
                    <% 
                    if(ships != null){
                        for(ShipPojo s : ships){
                    %>
                        <option value="<%= s.getShipId() %>">
                            <%= s.getShipId() %> - <%= s.getShipName() %>
                        </option>
                    <% } } %>

                </select>
                <button class="btn btn-primary w-100">Assign</button>
            </form>

        </div>
    </div>
</div>

<div class="modal fade user-modal" id="editContainerModal">
    <div class="modal-dialog modal-dialog-centered user-modal-dialog">
        <div class="modal-content glass-modal p-3">

            <h5>Edit Container</h5>

            <form action="container" method="post">

                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="containerId" id="editContainerId">

                <!-- TYPE -->
                <label>Select Container</label>
                <select name="containerType" id="editType" class="form-control user-input mb-2" required>
                    <option>Dry</option>
                    <option>Reefer</option>
                    <option>Open Top</option>
                    <option>Tank</option>
                </select>

                <!-- SHIP -->
                <label>Select Ship</label>
                <select name="shipId" id="editShip" class="form-control user-input mb-2" required>
                    <% if(ships != null){
                        for(ShipPojo s : ships){ %>
                        <option value="<%= s.getShipId() %>">
                            <%= s.getShipName() %>
                        </option>
                    <% } } %>
                </select>
                
                <button class="btn btn-primary w-100">Update</button>

            </form>

        </div>
    </div>
</div>

<div class="modal fade user-modal" id="deleteContainerModal">
    <div class="modal-dialog modal-dialog-centered user-modal-dialog">
        <div class="modal-content glass-modal p-3 text-center">

            <!-- HEADER WITH CLOSE BUTTON -->
            <div class="d-flex justify-content-between align-items-center">
                <h5 class="text-danger mb-0">Delete Container?</h5>

                <button type="button"
                        class="btn-close btn-close-white"
                        data-bs-dismiss="modal">
                </button>
            </div>

            <!-- Message -->
            <div class="text-center mb-3 mt-2">
                Are you sure you want to delete this Container?
            </div>

            <form action="container" method="post">

                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="containerId" id="deleteContainerId">

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

<div class="modal fade user-modal" id="viewContainerModal">
    <div class="modal-dialog modal-dialog-centered user-modal-dialog">
        <div class="modal-content glass-modal p-3">

            <!-- HEADER -->
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5>Container Details</h5>
                <button type="button" class="btn-close user-modal-close" data-bs-dismiss="modal"></button>
            </div>

            <p><b>ID:</b> <span id="viewId"></span></p>
            <p><b>Status:</b> <span id="viewStatus"></span></p>

            <p><b>Cargo Items:</b></p>
            <ul id="cargoList">
			    <li>Click to load cargo</li>
			</ul>

        </div>
    </div>
</div>

<script>
function setAssignContainer(id){
    document.getElementById("assignContainerId").value = id;
}

function fillEditContainer(btn){

    document.getElementById("editContainerId").value = btn.dataset.id;
    document.getElementById("editType").value = btn.dataset.type;
    document.getElementById("editShip").value = btn.dataset.ship;
}

function setDeleteContainer(id){
    document.getElementById("deleteContainerId").value = id;
}

function viewContainer(btn){

    let containerId = btn.dataset.id;

    document.getElementById("viewId").innerText = containerId;
    document.getElementById("viewStatus").innerText = btn.dataset.status;

    let list = document.getElementById("cargoList");
    list.innerHTML = "<li>Loading...</li>";

    fetch("container?action=getCargo&containerId=" + containerId)
    .then(res => res.json())
    .then(data => {

        list.innerHTML = "";

        if(data.length === 0){
            list.innerHTML = "<li>No cargo found</li>";
            return;
        }

        data.forEach(c => {
            let li = document.createElement("li");
            li.innerText = c.description + " - " + c.weight + " kg";
            list.appendChild(li);
        });
    })
    .catch(err => {
        list.innerHTML = "<li>Error loading cargo</li>";
        console.error(err);
    });
}
</script>