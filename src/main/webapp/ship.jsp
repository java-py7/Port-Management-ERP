<%@ page import="java.util.List" %>
<%@ page import="models.ShipPojo" %>
<%@ page import="models.UserPojo" %>

<%
    List<ShipPojo> shipList = (List<ShipPojo>) request.getAttribute("shipList");
%>

<div class="row">

    <!-- MAIN CONTENT -->
    <div class="content-area col-lg-11">

        <!-- TOP BAR -->
        <div class="glass-card topbar-glass d-flex justify-content-center align-items-center mb-4">
            <div class="text-center">
                <h3>Ship Management</h3>
                <small>Manage ships and their status</small>
            </div>
        </div>

        <!-- SEARCH -->
        <div class="glass-card search-glass d-flex justify-content-center mb-4">

            <form method="get"
                  action="${pageContext.request.contextPath}/ship"
                  class="d-flex align-items-center gap-2 flex-no-wrap">

                <input type="text"
                       name="search"
                       class="form-control search-input"
                       placeholder="Search ships...">

                <button type="submit" class="btn btn-primary">
                    &nbsp;Search&nbsp;
                </button>

                <a href="${pageContext.request.contextPath}/ship"
                   class="btn btn-secondary clear-btn">
                    &nbsp;&nbsp;Show&nbsp;&nbsp;
                </a>

                <button type="button"
                        class="btn btn-primary"
                        data-bs-toggle="modal"
                        data-bs-target="#addShipModal">
                    &nbsp;&nbsp;&nbsp;Add&nbsp;&nbsp;&nbsp;
                </button>

            </form>

        </div>

        <!-- TABLE -->
        <div class="table-responsive">
            <table class="table custom-table">

                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Ship Name</th>
                        <th>Operator</th>
                        <th>Arrival</th>
                        <th>Departure</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>

                <tbody class="universal-page">

                <% if(shipList != null && !shipList.isEmpty()) {
                       for(ShipPojo s : shipList){ %>

                    <tr>
                        <td><%= s.getShipId() %></td>
                        <td><%= s.getShipName() %></td>
                        <td><%= s.getOperatorName() %></td>
                        <td class="arrival"><%= s.getArrivalDate() %></td>
						<td class="departure"><%= s.getDepartureDate() %></td>

                        <!-- STATUS -->
                        <td>
                            <%
                                if ("Anchored".equals(s.getStatus())) {
                            %>
                                <span class="status-pill pill-steelblue"><i class="fa-solid fa-anchor"></i> Anchored</span>
                            <%
                                } else if ("Docked".equals(s.getStatus())) {
                            %>
                                <span class="status-pill pill-green"><i class="fa-solid fa-location-dot"></i> Docked</span>
                            <%
                                } else {
                            %>
                                <span class="status-pill pill-yellow"><i class="fa-solid fa-ship"></i> Departed</span>
                            <%
                                }
                            %>
                        </td>


                        <!-- ACTIONS -->
                        <td>
                            <div class="action-btn">

                                <!-- EDIT -->
                                <button class="status-btn edit-btn" title="Edit Ship"
                                        data-bs-toggle="modal"
                                        data-bs-target="#editShipModal"
                                        onclick="fillEdit(this)"
                                        data-id="<%= s.getShipId() %>"
                                        data-name="<%= s.getShipName() %>"
                                        data-arrival="<%= s.getArrivalDate() %>"
                                        data-departure="<%= s.getDepartureDate() %>"
                                        data-operator="<%= s.getOperatorId() %>">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                

                                <!-- DELETE -->
                                <form action="${pageContext.request.contextPath}/ship" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="shipId" value="<%= s.getShipId() %>">
                                    <button class="status-btn inactive-btn" title="Delete Ship"
									        type="button"
									        data-bs-toggle="modal"
									        data-bs-target="#deleteShipModal"
									        onclick="setDeleteShip(<%= s.getShipId() %>)">
									    <i class="bi bi-trash"></i>
									</button>
                                </form>

                                <!-- STATUS CHANGE -->
                                <div class="action-btn">
									
									<% if (!"Docked".equals(s.getStatus())) { %>
    								<!-- DOCKED -->
								    <form action="${pageContext.request.contextPath}/ship" method="post" style="display:inline;">
								        <input type="hidden" name="action" value="status">
								        <input type="hidden" name="shipId" value="<%= s.getShipId() %>">
								        <input type="hidden" name="status" value="Docked">
								        <button class="status-btn   pill-green" style="padding: 8px 15px;" title="Dock Ship"><i class="fa-solid fa-location-dot"></i></button>
								    </form>
									<% } %>

									<% if (!"Departed".equals(s.getStatus())) { %>
    								<!-- DEPARTED -->
								    <form action="${pageContext.request.contextPath}/ship" method="post" style="display:inline;">
								        <input type="hidden" name="action" value="status">
								        <input type="hidden" name="shipId" value="<%= s.getShipId() %>">
								        <input type="hidden" name="status" value="Departed">
								        <button class="status-btn  pill-yellow" style="padding: 8px 12px;" title="Depart Ship"><i class="fa-solid fa-ship"></i></button>
								    </form>
									<% } %>
								    
									<% if (!"Anchored".equals(s.getStatus())) { %>
    								<!-- ANCHORED -->
								    <form action="${pageContext.request.contextPath}/ship" method="post" style="display:inline;">
								        <input type="hidden" name="action" value="status">
								        <input type="hidden" name="shipId" value="<%= s.getShipId() %>">
								        <input type="hidden" name="status" value="Anchored">
								        <button class="status-btn  pill-steelblue" style="padding: 8px 12px;" title="Anchor Ship"><i class="fa-solid fa-anchor"></i></button>
								    </form>
									<% } %>						
								</div>

                            </div>
                        </td>

                    </tr>

                <% } } else { %>

                    <tr>
                        <td colspan="7" class="text-center text-muted">
                            No ships found.
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


<!-- Add Ship Modal -->
<div class="modal fade user-modal" id="addShipModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered user-modal-dialog">
        <div class="modal-content glass-modal user-modal-content p-3">

            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-3 user-modal-header">
                <h5 class="user-modal-title">Add Ship</h5>
                <button type="button" class="btn-close user-modal-close" data-bs-dismiss="modal"></button>
            </div>

            <!-- Form -->
            <form action="${pageContext.request.contextPath}/ship" method="post" class="user-form" onsubmit="return validateDates(this)">
                <input type="hidden" name="action" value="add">

                <div class="mb-3 user-field">
                    <label class="user-label">Ship Name</label>
                    <input type="text" name="shipName" class="form-control user-input" placeholder="Enter ship name" required>
                </div>

                <div class="mb-3 user-field">
                    <label class="user-label">Arrival Date</label>
                    <input type="datetime-local" name="arrivalDate" class="form-control user-input" required>
                </div>

                <div class="mb-3 user-field">
                    <label class="user-label">Departure Date</label>
                    <input type="datetime-local" name="departureDate" class="form-control user-input" required>
                </div>
				
				<div class="mb-3 user-field">
				    <label class="user-label">Operator</label>
				    <select name="operatorId" class="form-control user-select" required>
				
				        <option value="">Select Operator</option>
				
				        <%
				            List<UserPojo> operators = (List<UserPojo>) request.getAttribute("operators");
				            if (operators != null) {
				                for (UserPojo u : operators) {
				        %>
				            <option value="<%= u.getUserId() %>">
				                <%= u.getName() %>
				            </option>
				        <%
				                }
				            }
				        %>
				
				    </select>
				</div>

                <button type="submit" class="btn btn-primary w-100 user-btn">
                    Add Ship
                </button>
            </form>

        </div>
    </div>
</div>

<!-- Edit Ship Modal -->
<div class="modal fade user-modal" id="editShipModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered user-modal-dialog">
        <div class="modal-content glass-modal user-modal-content p-3">

            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-3 user-modal-header">
                <h5 class="user-modal-title">Edit Ship</h5>
                <button type="button" class="btn-close user-modal-close" data-bs-dismiss="modal"></button>
            </div>

            <!-- Form -->
            <form action="${pageContext.request.contextPath}/ship" method="post" class="user-form" onsubmit="return validateDates(this)">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="shipId" id="editShipId">

                <div class="mb-3 user-field">
                    <label class="user-label">Ship Name</label>
                    <input type="text" name="shipName" id="editShipName" class="form-control user-input" required>
                </div>

                <div class="mb-3 user-field">
                    <label class="user-label">Arrival Date</label>
                    <input type="datetime-local" name="arrivalDate" id="editArrival" class="form-control user-input" required>
                </div>

                <div class="mb-3 user-field">
                    <label class="user-label">Departure Date</label>
                    <input type="datetime-local" name="departureDate" id="editDeparture" class="form-control user-input" required>
                </div>
				
                <div class="mb-3 user-field">
	                <label class="user-label">Operator ID</label>
					<select name="operatorId" id="editOperator" class="form-control user-select" required>
					    <option value="">Select Operator</option>
					
					    <%
					        if (operators != null) {
					            for (UserPojo u : operators) {
					    %>
					        <option value="<%= u.getUserId() %>">
					            <%= u.getName() %>
					        </option>
					    <%
					            }
					        }
					    %>
					</select>
                </div>

                <button type="submit" class="btn btn-primary w-100 user-btn">
                    Update Ship
                </button>
            </form>

        </div>
    </div>
</div>

<div class="modal fade user-modal" id="deleteShipModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered user-modal-dialog">
        <div class="modal-content glass-modal user-modal-content p-3">

            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="text-danger">Delete Ship</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <!-- Message -->
            <div class="text-center mb-3">
                Are you sure you want to delete this ship?
            </div>

            <!-- Form -->
            <form action="${pageContext.request.contextPath}/ship" method="post">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="shipId" id="deleteShipId">

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

<!-- Validation Modal -->
<div class="modal fade user-modal" id="dateErrorModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered user-modal-dialog">
        <div class="modal-content glass-modal user-modal-content p-3">

            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-3 user-modal-header">
                <h5 class="user-modal-title text-danger">Invalid Dates</h5>
                <button type="button" class="btn-close user-modal-close" data-bs-dismiss="modal"></button>
            </div>

            <!-- Message -->
            <div class="text-center mb-3">
                Arrival date must be earlier than departure date.
            </div>

            <!-- Button -->
            <button class="btn btn-primary w-100 user-btn" data-bs-dismiss="modal">
                OK
            </button>

        </div>
    </div>
</div>

<!-- Delete Dock Modal -->
<div class="modal fade user-modal" id="deleteDockModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered user-modal-dialog">
        <div class="modal-content glass-modal user-modal-content p-3">

            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-3 user-modal-header">
                <h5 class="user-modal-title text-danger">Delete Dock</h5>
                <button type="button" class="btn-close user-modal-close" data-bs-dismiss="modal"></button>
            </div>

            <!-- Message -->
            <div class="text-center mb-3">
                Are you sure you want to delete this dock?
            </div>

            <!-- Form -->
            <form action="${pageContext.request.contextPath}/dock" method="post">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="dockId" id="deleteDockId">

                <button type="submit" class="btn btn-danger w-100 user-btn">
                    Delete
                </button>
            </form>

        </div>
    </div>
</div>

<script>
function fillEdit(btn){

    document.getElementById("editShipId").value = btn.dataset.id;
    document.getElementById("editShipName").value = btn.dataset.name;

    // convert datetime to input format
    document.getElementById("editArrival").value = btn.dataset.arrival.replace(" ", "T").substring(0,16);
    document.getElementById("editDeparture").value = btn.dataset.departure.replace(" ", "T").substring(0,16);

    document.getElementById("editOperator").value = btn.dataset.operator;
}

const urlParams = new URLSearchParams(window.location.search);

if (urlParams.get("error") === "invalidDate") {
    var modal = new bootstrap.Modal(document.getElementById('errorModal'));
    modal.show();
}
   
function validateDates(form) {

    let arrival = form.querySelector('[name="arrivalDate"]').value;
    let departure = form.querySelector('[name="departureDate"]').value;

    if (arrival >= departure) {

        var modal = new bootstrap.Modal(document.getElementById('dateErrorModal'));
        modal.show();

        return false; // stop form submit
    }

    return true;
}

function setDeleteShip(id){
    document.getElementById("deleteShipId").value = id;
}
</script>