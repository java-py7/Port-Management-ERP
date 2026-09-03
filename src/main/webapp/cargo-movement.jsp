<%@ page import="java.util.List" %>
<%@ page import="models.CargoMovementPojo" %>
<%@ page import="models.CargoPojo" %>

<%
    List<CargoMovementPojo> list = (List<CargoMovementPojo>) request.getAttribute("movementList");
	List<CargoPojo> cargoList = (List<CargoPojo>) request.getAttribute("cargoList");
%>

<div class="row">

    <!-- MAIN CONTENT -->
<div class="content-area col-lg-11">

        <!-- TOP BAR -->
        <div class="glass-card topbar-glass d-flex justify-content-center align-items-center mb-4">
            <div class="text-center">
                <h3>Cargo Movement</h3>
                <small>Track cargo loading, unloading and transfers</small>
            </div>
        </div>

        <!-- SEARCH -->
        <div class="glass-card search-glass d-flex justify-content-center mb-4">

            <form method="get"
                  action="${pageContext.request.contextPath}/cargo-movement"
                  class="d-flex align-items-center gap-2 flex-no-wrap">

                <input type="text"
                       name="search"
                       class="form-control search-input"
                       placeholder="Search">

                <button type="submit" class="btn btn-primary">Search</button>

                <a href="${pageContext.request.contextPath}/cargo-movement"
                   class="btn btn-secondary clear-btn">Show</a>

                <button type="button"
                        class="btn btn-primary"
                        data-bs-toggle="modal"
                        data-bs-target="#addMovementModal" 
                        style="width:65%">
                    Log Movement
                </button>

            </form>

        </div>

    <!-- TABLE -->
    <div class="table-responsive">

        <table class="table custom-table">
			<thead>
			    <tr>
			        <th>Movement ID</th>
			        <th>Cargo</th>
			        <th>Movement Type</th>
			        <th>Date / Time</th>
			        <th>Handler</th>
			    </tr>
			</thead>

            <tbody class="universal-page">
                <% if(list != null){
                    for(CargoMovementPojo m : list){ %>

                 <tr>
				    <td><%= m.getMovementId() %></td>
				
				    <!-- 🔥 SHOW ID + NAME -->
				    <td>
				        <%= m.getCargoDescription() %>
				    </td>
					<td>
                        <% if ("Load".equals(m.getMovementType())) { %>
                            <span class="status-pill inactive-pill"> Load</span>
                        <% } else if ("Unload".equals(m.getMovementType())) { %>
                            <span class="status-pill active-pill"> Unload</span>
                        <% } else { %>
                            <span class="status-pill pill-yellow"> Transfer</span>
                        <% } %>
                    </td>
				    <td class="arrival">
				        <%= m.getMovementDate() != null 
				            ? m.getMovementDate().replace("T"," ").substring(0,16) 
				            : "-" %>
				    </td>
				
				    <td>
				        <%= m.getHandledBy() != null ? m.getHandledBy() : "-" %>
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
<div class="modal fade user-modal" id="addMovementModal">
    <div class="modal-dialog modal-dialog-centered user-modal-dialog">
        <div class="modal-content glass-modal p-3">

            <div class="d-flex justify-content-between mb-2">
                <h5>Add Cargo Movement</h5>
                <button class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <form action="cargo-movement" method="post">
                <input type="hidden" name="action" value="add">

                <select name="cargoId" id="cargoDropdown" class="form-control user-input mb-2">
                    	<option value="">Select Cargo</option>
                    <%
                    if(cargoList != null){
                        for(CargoPojo c : cargoList){
                    %>
                        <option value="<%= c.getCargoId() %>">
                            ID: <%= c.getCargoId() %> | <%= c.getDescription() %>
                        </option>

                    <% } } %>

                </select>

                <!-- MOVEMENT -->
                <select name="movementType" class="form-control user-input mb-2">
                    <option>Load</option>
                    <option>Unload</option>
                    <option>Transfer</option>
                </select>

                <button class="btn btn-primary w-100">Add</button>
            </form>

        </div>
    </div>
</div>

