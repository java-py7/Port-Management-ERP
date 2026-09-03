<%@ page import="java.util.List" %>
<%@ page import="models.DockAllocationPojo" %>
<%@ page import="models.ShipPojo" %>
<%@ page import="models.DockPojo" %>
<%
    List<DockAllocationPojo> list = (List<DockAllocationPojo>) request.getAttribute("allocationList");
	List<DockPojo> dockList = (List<DockPojo>) request.getAttribute("dockList");
	List<ShipPojo> ships = (List<ShipPojo>) request.getAttribute("shipList");
%>
<div class="row">

    <!-- MAIN CONTENT -->
<div class="content-area">

    <!-- 🔥 HEADER -->
    <div class="glass-card text-center mb-4 p-3">
        <h3>Dock Allocation</h3>
        <small>Assign ships to docks using step-by-step allocation</small>
    </div>

    <!-- 🔥 WIZARD -->
    <div class="glass-card p-4 mb-4">

        <!-- STEPS -->
        <div>
        <div class="step-wrapper">
		    <div class="progress-line"></div>
		
		    <div class="step active">1</div>
		    <div class="step"><small>2</small></div>
		    <div class="step"><small>3</small></div>
		    <div class="step"><small>4</small></div>
		</div>
		</div>

        <!-- FORM -->
        <form action="${pageContext.request.contextPath}/dock-allocation" method="post">
            <input type="hidden" name="action" value="add">

            <!-- STEP 1 -->
            <div class="step-content" id="step1">
                <label class="mb-2">Select Ship</label>
                <select name="shipId" class="form-control user-input">
				    <option value="">Select Ship</option>
				
				    <% 
				    if (ships != null) {
				        for (ShipPojo s : ships) { 
				    %>
				
				        <option value="<%= s.getShipId() %>">
						   <%= s.getShipName() %>
						</option>
				
				    <% } } %>
				
				</select>
                <button type="button" class="btn btn-primary mt-3" onclick="nextStep(2)">Next</button>
            </div>

            <!-- STEP 2 -->
            <div class="step-content d-none" id="step2">
                <label class="mb-2">Select Dock (Available Only)</label>
                <select name="dockId" class="form-control user-input">
				    <option value="">Select Dock</option>
				
				    <%				
				        if (dockList != null) {
				            for (DockPojo d : dockList) {
				    %>
				
				        <option value="<%= d.getDockId() %>">
				            <%= d.getDockName() %>
				        </option>
				
				    <%
				            }
				        }
				    %>
				
				</select>
                <button type="button" class="btn btn-secondary mt-3" onclick="prevStep(1)">Back</button>
                <button type="button" class="btn btn-primary mt-3" onclick="nextStep(3)">Next</button>
            </div>

            <!-- STEP 3 -->
            <div class="step-content d-none" id="step3">

			    <div class="mb-3 user-field">
			        <label  class="mb-2 user-label">Allocation Time</label>
			        <input type="datetime-local" 
			               name="allocationTime" 
			               id="allocationTime"
			               class="form-control user-input" required>
			    </div>
			
			    <div class="d-flex gap-2">
			        <button type="button" class="btn btn-secondary" onclick="prevStep(2)">Back</button>
			        <button type="button" class="btn btn-primary" onclick="validateStep3()">Next</button>
			    </div>
			
			</div>

            <!-- STEP 4 -->
            <div class="step-content d-none text-center" id="step4">

			    <h5 class="mb-3">Confirm Allocation</h5>
			
			    <div class="glass-card p-3 mb-3 text-start">
			
			        <p><strong>Ship:</strong> <span id="confirmShip"></span></p>
			
			        <p><strong>Dock:</strong> <span id="confirmDock"></span></p>
			
			        <p><strong>Allocation Time:</strong> <span id="confirmStart"></span></p>
			
			    </div>
			
			    <div class="d-flex justify-content-center gap-2">
			        <button type="button" class="btn btn-secondary" onclick="prevStep(3)">Back</button>
			        <button type="submit" class="btn btn-success">Confirm Allocation</button>
			    </div>
			
			</div>

        </form>
    </div>
	
	<div class="glass-card p-3 mb-3 d-flex gap-2 justify-content-center">

	    <!-- 🔍 SEARCH -->
	    <input type="text" 
	           id="searchInput"
	           placeholder="Search ship..."
	           class="form-control user-input w-50">
	
	    <!-- 🎯 FILTER -->
	    <select id="filterSelect" class="form-control user-input w-auto">
	        <option value="all">Show All</option>
	        <option value="active">Active Allocations</option>
	        <option value="released">Released History</option>
	    </select>
	
	    <!-- 🔄 BUTTON -->
	    <button class="btn btn-primary" onclick="applyFilter()">Search</button>
	
	</div>

    <!-- 🔥 TABLE -->
    <div class="glass-card p-3 mb-4">
        <h5 class="mb-3">Active Allocations</h5>

        <table class="table custom-table">
            <thead>
                <tr>
                    <th>Allocation ID</th>
                    <th>Ship Name</th>
                    <th>Dock Name</th>
                    <th>Allocated Time</th>
                    <th>Action</th>
                </tr>
            </thead>

            <tbody>
                <% if(list != null){ 
                    for(DockAllocationPojo a : list){ %>

                <tr>
                    <td><%= a.getAllocationId() %></td>
                    <td><%= a.getShipName() %></td>
                    <td><%= a.getDockName() %></td>
                    <td class="arrival"><%= a.getAllocationTime() %></td>
					
					<td>

					    <div class="action-btn d-flex gap-1">
					
					        <!-- EDIT -->
					        <button class="status-btn edit-btn" title="Edit Dock Allocation"
					                data-bs-toggle="modal"
					                data-bs-target="#editAllocationModal"
					                onclick="fillEditAllocation(this)"
					                data-id="<%= a.getAllocationId() %>"
									data-ship="<%= a.getShipId() %>"
									data-dock="<%= a.getDockId() %>"
									data-time="<%= a.getAllocationTime() %>"
									data-shipname="<%= a.getShipName() %>"
									data-dockname="<%= a.getDockName() %>">
					            <i class="bi bi-pencil"></i>
					        </button>
					
					        <!-- DELETE -->
					        <button class="status-btn inactive-btn" title="Delete Dock Allocation"
					                data-bs-toggle="modal"
					                data-bs-target="#deleteAllocationModal"
					                onclick="setDeleteAllocation(<%= a.getAllocationId() %>)">
					            <i class="bi bi-trash"></i>
					        </button>
					
					        <!-- RELEASE -->
					        <% if(a.getReleaseTime() == null || a.getReleaseTime().equals("null")){ %>
					        <form action="${pageContext.request.contextPath}/dock-allocation" method="post">
					            <input type="hidden" name="action" value="release">
					            <input type="hidden" name="allocationId" value="<%= a.getAllocationId() %>">
					            <input type="hidden" name="dockId" value="<%= a.getDockId() %>">
					            <input type="hidden" name="shipId" value="<%= a.getShipId() %>">
					
					            <button type="button"
								        class="status-btn active-btn btn-sm"
								        onclick="openReleaseModal(this)"
								        data-id="<%= a.getAllocationId() %>"
								        data-dock="<%= a.getDockId() %>"
								        data-ship="<%= a.getShipId() %>">
								    Release
								</button>
					        </form>
					        <% } %>
					
					    </div>
					
					</td>
                </tr>

                <% } } %>
            </tbody>
        </table>
    </div>
    
    

		<!-- 🔥 HISTORY TABLE -->
	   <div class="glass-card p-3">
	       <h5 class="mb-3">Released Allocation History</h5>
	
	       <table class="table custom-table history-table">
	           <thead>
	               <tr>
	                   <th>Allocation ID</th>
	                <th>Ship Name</th>
	                <th>Dock Name</th>
	                <th>Allocated Time</th>
	                <th>Released Time</th>
	                <th>Action</th>
	               </tr>
	           </thead>
	
	           <tbody class="universal-page">
	               <% 
		        List<DockAllocationPojo> releasedList = (List<DockAllocationPojo>) request.getAttribute("releasedList");
		
		        if(releasedList != null){
		            for(DockAllocationPojo a : releasedList){ 
		        %>
		
		        <tr>
		            <td><%= a.getAllocationId() %></td>
		
		            <td><%= a.getShipName() %></td>
		
		            <td><%= a.getDockName() %></td>
		            
                    <td class="arrival"><%= a.getAllocationTime() %></td>
					<td class="departure"><%= a.getReleaseTime() %></td>
		            
		            <td>

					    <button class="status-btn edit-btn"
					            data-bs-toggle="modal"
					            data-bs-target="#editReleaseModal"
					            onclick="fillReleaseEdit(this)"
					            data-id="<%= a.getAllocationId() %>"
					            data-release="<%= a.getReleaseTime() %>">
					
					        <i class="bi bi-pencil"></i>
					
					    </button>

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
  

<div class="modal fade user-modal" id="timeErrorModal">
    <div class="modal-dialog modal-dialog-centered user-modal-dialog">
        <div class="modal-content glass-modal user-modal-content p-3">

            <div class="d-flex justify-content-between mb-3">
                <h5 class="text-danger">Invalid Time</h5>
                <button class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div id="timeErrorMsg" class="text-center mb-3"></div>

            <button class="btn btn-primary w-100 user-btn" data-bs-dismiss="modal">
                OK
            </button>

        </div>
    </div>
</div>

<div class="modal fade user-modal" id="deleteAllocationModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered user-modal-dialog">
        <div class="modal-content glass-modal p-3">

            <!-- HEADER -->
            <div class="modal-header border-0">
                <h5 class="text-danger mb-0">Delete Allocation</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <!-- BODY -->
            <div class="modal-body text-center">
                Are you sure you want to delete this allocation?
            </div>

            <!-- FOOTER -->
            <div class="modal-footer border-0 justify-content-center">

                <!-- Cancel -->
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    Cancel
                </button>

                <!-- Delete -->
                <form action="${pageContext.request.contextPath}/dock-allocation" method="post">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="allocationId" id="deleteAllocationId">

                    <button class="btn btn-danger">
                        Delete
                    </button>
                </form>

            </div>

        </div>
    </div>
</div>

<!-- 🔥 EDIT ALLOCATION MODAL -->
<div class="modal fade user-modal" id="editAllocationModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered user-modal-dialog">
        <div class="modal-content glass-modal p-3">

            <!-- HEADER -->
            <div class="d-flex justify-content-between mb-3">
                <h5>Edit Allocation</h5>
                <button class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <!-- FORM -->
            <form action="${pageContext.request.contextPath}/dock-allocation" method="post">

                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="allocationId" id="editAllocationId">

                <!-- SHIP -->
                <div class="mb-2">
                    <label>Select Ship</label>
                    <select name="shipId" id="editShipId" class="form-control user-input" required>

                        <%
                            if (ships != null) {
                                for (ShipPojo s : ships) {
                        %>
                            <option value="<%= s.getShipId() %>">
                                ID: <%= s.getShipId() %>, <%= s.getShipName() %>
                            </option>
                        <% } } %>

                    </select>
                </div>

                <!-- DOCK -->
                <div class="mb-2">
                    <label>Select Dock</label>
                    <select name="dockId" id="editDockId" class="form-control user-input" required>

                        <%
                            if (dockList != null) {
                                for (DockPojo d : dockList) {
                        %>
                            <option value="<%= d.getDockId() %>">
                                <%= d.getDockName() %>
                            </option>
                        <% } } %>

                    </select>
                </div>

                <!-- TIME -->
                <div class="mb-2">
                    <label>Allocation Time</label>
                    <input type="datetime-local" name="allocationTime" id="editAllocationTime"
                           class="form-control user-input" required>
                </div>

                <!-- BUTTON -->
                <button class="btn btn-primary w-100 mt-2">Update Allocation</button>

            </form>

        </div>
    </div>
</div>

<!-- 🔥 RELEASE CONFIRM MODAL -->
<div class="modal fade user-modal" id="releaseModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered user-modal-dialog">
        <div class="modal-content glass-modal user-modal-content p-3 text-center">

            <!-- HEADER -->
            <div class="mb-3">
                <h5 class="text-warning">Confirm Release</h5>
                <p class="mt-4">
                    Note : You Can Not Edit Ship, Dock And Allocation Time After Release!
                </p>
            </div>

            <!-- FORM -->
            <form action="${pageContext.request.contextPath}/dock-allocation" method="post">

                <input type="hidden" name="action" value="release">

                <input type="hidden" name="allocationId" id="releaseAllocationId">
                <input type="hidden" name="dockId" id="releaseDockId">
                <input type="hidden" name="shipId" id="releaseShipId">

                <!-- BUTTONS -->
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-secondary w-50"
                            data-bs-dismiss="modal">
                        Cancel
                    </button>

                    <button type="submit" class="btn btn-danger w-50">
                        Confirm Release
                    </button>
                </div>

            </form>

        </div>
    </div>
</div>

<div class="modal fade user-modal" id="editReleaseModal">
    <div class="modal-dialog modal-dialog-centered user-modal-dialog">
        <div class="modal-content glass-modal p-3">

            <div class="d-flex justify-content-between mb-3">
                <h5>Edit Release Time</h5>
                <button class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <form action="${pageContext.request.contextPath}/dock-allocation" method="post">

                <input type="hidden" name="action" value="editRelease">
                <input type="hidden" name="allocationId" id="editReleaseId">

                <label>Release Time</label>
                <input type="datetime-local"
                       name="releaseTime"
                       id="editReleaseTime"
                       class="form-control user-input mb-2"
                       required>

                <button class="btn btn-primary w-100">Update</button>

            </form>

        </div>
    </div>
</div>

<script>
function prevStep(step){
    nextStep(step);
}

function validateStep3(){

    let start = document.getElementById("allocationTime").value;

    if(!start){
        showError("Please select allocation time");
        return;
    }

    nextStep(4);
}

function showError(msg){
    document.getElementById("timeErrorMsg").innerText = msg;

    let modal = new bootstrap.Modal(document.getElementById("timeErrorModal"));
    modal.show();
}

function nextStep(step){

    document.querySelectorAll(".step-content").forEach(el => el.classList.add("d-none"));
    document.getElementById("step"+step).classList.remove("d-none");

    updateStepUI(step);

    if(step === 4){
        fillConfirmData();
    }
}

function updateStepUI(step){
    document.querySelectorAll(".step").forEach((el, i) => {
        el.classList.remove("active");
        if(i < step) el.classList.add("active");
    });
}

function fillConfirmData(){

    let shipSelect = document.querySelector("select[name='shipId']");
    let dockSelect = document.querySelector("select[name='dockId']");

    let shipText = shipSelect.options[shipSelect.selectedIndex]?.text;
    let dockText = dockSelect.options[dockSelect.selectedIndex]?.text;

    let start = document.getElementById("allocationTime").value;

    document.getElementById("confirmShip").innerText = shipText || "-";
    document.getElementById("confirmDock").innerText = dockText || "-";
    document.getElementById("confirmStart").innerText = formatDate(start);
}

function formatDate(dt){
    if(!dt) return "-";

    let d = new Date(dt);

    return d.toLocaleString("en-IN", {
        day: "2-digit",
        month: "short",
        year: "numeric",
        hour: "2-digit",
        minute: "2-digit"
    });
}

function setDeleteAllocation(id){
    document.getElementById("deleteAllocationId").value = id;
}

function updateStepUI(step){

    let steps = document.querySelectorAll(".step");
    let progress = document.querySelector(".progress-line");

    steps.forEach((el, i) => {
        el.classList.remove("active");

        if(i < step){
            el.classList.add("active");
        }
    });

    // progress width (0 → 100%)
    let percent = ((step - 1) / (steps.length - 1)) * 100;
    progress.style.width = percent + "%";
}

const shipSearch = document.createElement("input");
shipSearch.placeholder = "Search Ship...";
shipSearch.className = "form-control mb-3";

document.querySelector("#shipContainer").before(shipSearch);

const shipItems = document.querySelectorAll(".ship-item");
const noShipFound = document.getElementById("noShipFound");

shipSearch.addEventListener("keyup", function(){

    let keyword = this.value.toLowerCase();
    let count = 0;

    shipItems.forEach(el => {

        let id = el.dataset.shipid;
        let name = el.dataset.shipname;
        let status = el.dataset.status;

        if(id.includes(keyword) || name.includes(keyword) || status.includes(keyword)){
            el.style.display = "block";
            count++;
        } else {
            el.style.display = "none";
        }
    });

    noShipFound.style.display = count === 0 ? "block" : "none";
});

function fillEditAllocation(btn){

    document.getElementById("editAllocationId").value = btn.dataset.id;

    document.getElementById("editShipId").value = btn.dataset.ship;

    document.getElementById("editDockId").value = btn.dataset.dock;

}

function applyFilter(){

    let search = document.getElementById("searchInput").value.toLowerCase();
    let filter = document.getElementById("filterSelect").value;

    let activeRows = document.querySelectorAll("table tbody tr");
    let historyRows = document.querySelectorAll(".history-table tbody tr");

    // 🔥 ACTIVE TABLE
    activeRows.forEach(row => {

        let text = row.innerText.toLowerCase();

        if(filter === "released"){
            row.style.display = "none";
        }
        else if(text.includes(search)){
            row.style.display = "";
        } else {
            row.style.display = "none";
        }
    });

    // 🔥 HISTORY TABLE
    historyRows.forEach(row => {

        let text = row.innerText.toLowerCase();

        if(filter === "active"){
            row.style.display = "none";
        }
        else if(text.includes(search)){
            row.style.display = "";
        } else {
            row.style.display = "none";
        }
    });
}

function openReleaseModal(btn){

    // set values
    document.getElementById("releaseAllocationId").value = btn.dataset.id;
    document.getElementById("releaseDockId").value = btn.dataset.dock;
    document.getElementById("releaseShipId").value = btn.dataset.ship;

    // open modal
    let modal = new bootstrap.Modal(document.getElementById("releaseModal"));
    modal.show();
}

function fillReleaseEdit(btn){

    document.getElementById("editReleaseId").value = btn.dataset.id;

    let time = btn.dataset.release;

    if(time){
        let formatted = time.replace(" ", "T").substring(0,16);
        document.getElementById("editReleaseTime").value = formatted;
    }
}

function fillEditAllocation(btn){

    document.getElementById("editAllocationId").value = btn.dataset.id;
    document.getElementById("editShipId").value = btn.dataset.ship;
    document.getElementById("editDockId").value = btn.dataset.dock;

    // 🔥 FORMAT TIME FOR INPUT
    let time = btn.dataset.time;
    let shipSelect = document.getElementById("editShipId");

    if(![...shipSelect.options].some(o => o.value == btn.dataset.ship)){

        let opt = document.createElement("option");
        opt.value = btn.dataset.ship;
        opt.text = btn.dataset.shipname + " (Current)";
        opt.selected = true;

        shipSelect.appendChild(opt);
    }
    
    let dockSelect = document.getElementById("editDockId");

    if(![...dockSelect.options].some(o => o.value == btn.dataset.dock)){

        let opt = document.createElement("option");
        opt.value = btn.dataset.dock;
        opt.text = btn.dataset.dockname + " (Current)";
        opt.selected = true;

        dockSelect.appendChild(opt);
    }
    
    if(time){
        let formatted = time.replace(" ", "T").substring(0,16);
        document.getElementById("editAllocationTime").value = formatted;
    }
}
</script>