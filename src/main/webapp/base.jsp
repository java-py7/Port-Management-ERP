<%
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
    String email = (String) session.getAttribute("userEmail");
    Integer roleId = (Integer) session.getAttribute("roleId");
    String roleName = (String) session.getAttribute("roleName");

    if (userId == null) {
        response.sendRedirect("login");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Port - ${pageTitle}</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/style.css">
</head>

<body>

<div class="sidebar">
    <div class="brand-box">
        <a class="logo-link"><i class="fa fa-anchor port-logo"></i><span>PORT<br><sub class="logo-sub-text"><span style="font-size:10px;">MANAGEMENT ERP</span></sub></span></a>
    </div>

    <nav class="nav flex-column">
    <% if ("Administrator".equals(roleName) || "Port Manager".equals(roleName) || "Ship Operator".equals(roleName) || "Dock Manager".equals(roleName) || "Cargo Handler".equals(roleName)) {%>
	    <a href="<%= request.getContextPath() %>/dashboard" class="nav-link <%= request.getRequestURI().contains("/dashboard") ? "active" : "" %>"><i class="fa fa-house"></i><span>Dashboard</span></a>
	<%}%>
	<% if ("Administrator".equals(roleName)) {%>
	    <a href="<%= request.getContextPath() %>/user" class="nav-link <%= request.getRequestURI().contains("/user") ? "active" : "" %>"><i class="fa fa-users"></i><span>User Management</span></a>
	<%}%>
	<% if ("Administrator".equals(roleName) || "Port Manager".equals(roleName) || "Ship Operator".equals(roleName)) {%>
	    <a href="<%= request.getContextPath() %>/ship" class="nav-link <%= request.getRequestURI().contains("/ship") ? "active" : "" %>"><i class="fa fa-ship"></i><span>Ship Management</span></a>
	<%}%>
	<% if ("Administrator".equals(roleName) || "Port Manager".equals(roleName) || "Dock Manager".equals(roleName)) {%>
	    <a href="<%= request.getContextPath() %>/dock" class="nav-link <%= request.getRequestURI().contains("/dock") ? "active" : "" %>"><i class="fa fa-dharmachakra"></i><span>Dock Management</span></a>
	<%}%>
	<% if ("Administrator".equals(roleName) || "Port Manager".equals(roleName) || "Dock Manager".equals(roleName)) {%>
	    <a href="<%= request.getContextPath() %>/dock-allocation" class="nav-link <%= request.getRequestURI().contains("/dock-allocation") ? "active" : "" %>"><i class="fa fa-list-check"></i><span>Dock Allocation</span></a>
	<%}%>
	<% if ("Administrator".equals(roleName) || "Port Manager".equals(roleName) || "Ship Operator".equals(roleName)) {%>
	    <a href="<%= request.getContextPath() %>/container" class="nav-link <%= request.getRequestURI().contains("/container") ? "active" : "" %>"><i class="fa fa-box"></i><span>Container Management</span></a>
	<%}%>
	<% if ("Administrator".equals(roleName) || "Port Manager".equals(roleName) || "Cargo Handler".equals(roleName)) {%>
	    <a href="<%= request.getContextPath() %>/cargo" class="nav-link <%= request.getRequestURI().contains("/cargo") ? "active" : "" %>"><i class="fa fa-boxes-stacked"></i><span>Cargo Management</span></a>
	<%}%>
	<% if ("Administrator".equals(roleName) || "Port Manager".equals(roleName) || "Cargo Handler".equals(roleName)) {%>
	    <a href="<%= request.getContextPath() %>/cargo-movement" class="nav-link <%= request.getRequestURI().contains("/cargo-movement") ? "active" : "" %>"><i class="fa fa-truck-ramp-box"></i><span>Cargo Movement</span></a>
	<%}%>
	<% if ("Administrator".equals(roleName) || "Port Manager".equals(roleName)) {%>
	    <a href="<%= request.getContextPath() %>/security-log" class="nav-link <%= request.getRequestURI().contains("/security-log") ? "active" : "" %>"><i class="fa fa-shield-halved"></i><span>Security Logs</span></a>
	<%}%>
	<% if ("Administrator".equals(roleName) || "Port Manager".equals(roleName) || "Ship Operator".equals(roleName) || "Dock Manager".equals(roleName) || "Cargo Handler".equals(roleName)) {%>
	    <a href="<%= request.getContextPath() %>/profile" class="nav-link <%= request.getRequestURI().contains("/profile") ? "active" : "" %>"><i class="fa fa-gear"></i><span>Profile</span></a>
	<%}%>
	</nav>
</div>

<div class="main-content">

<div class="top-bar">
    <button id="toggleSidebar" class="btn btn-sm slidbar-btn">
        <i class="fa fa-bars slidbar-icon"></i>
    </button>

    <div class="profile-area">
        <div class="avatar"><i class="fa fa-user"></i></div>
        <div>
            <div style="font-weight:600;"><%= userName %></div>
            <div style="font-size:0.7rem;color:var(--text-muted);"><%= roleName %></div>
        </div>
        <button class="logout-btn" data-bs-toggle="modal" data-bs-target="#logoutModal">Logout 
	        <i class="fa-solid fa-right-from-bracket"></i>
	    </button>
    </div>
</div>

    <jsp:include page="${pageContent}" />

</div>

<!-- MODAL -->
<div class="modal fade" id="logoutModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content glass-modal">

      <!-- HEADER -->
      <div class="modal-header border-0 text-center flex-column">
        <div class="icon-circle mt-1">
            <i class="fa-solid fa-exclamation"></i>
        </div>
        <h5 class="modal-title mt-2">Confirm Logout</h5>
      </div>

      <!-- BODY -->
      <div class="modal-body text-center">
        Are you sure you want to logout?<br>
      </div>

      <!-- FOOTER -->
      <div class="modal-footer border-0 justify-content-center">
    
		    <button class="btn btn-cancel" data-bs-dismiss="modal">Cancel</button>
		
		    <form action="${pageContext.request.contextPath}/logout" method="get" style="display:inline;">
		        <button class="btn btn-danger">Logout</button>
		    </form>
		
		</div>

    </div>
  </div>
</div>
<script>
document.getElementById("toggleSidebar").onclick = function () {
    document.querySelector(".sidebar").classList.toggle("collapsed");
    document.querySelector(".main-content").classList.toggle("collapsed");
};


let currentPage = 1;
let rowsPerPage = 6;

function showPage(page) {
    let rows = document.querySelectorAll(".universal-page tr");

    let totalPages = Math.ceil(rows.length / rowsPerPage);

    if (page < 1) page = 1;
    if (page > totalPages) page = totalPages;

    currentPage = page;

    // Hide all rows
    rows.forEach(row => row.style.display = "none");

    // Show only current page rows
    let start = (page - 1) * rowsPerPage;
    let end = start + rowsPerPage;

    for (let i = start; i < end && i < rows.length; i++) {
        rows[i].style.display = "";
    }

    document.getElementById("pageInfo").innerText =
        "Page " + currentPage + " / " + totalPages;
}

function nextPage() {
    showPage(currentPage + 1);
}

function prevPage() {
    showPage(currentPage - 1);
}

// Run when page loads
window.onload = function () {
    showPage(1);
};



function formatDateTime(dateString) {

    // FIX: convert to ISO format
    dateString = dateString.replace(" ", "T");

    let date = new Date(dateString);

    return date.toLocaleString("en-IN", {
        day: "2-digit",
        month: "short",
        year: "numeric",
        hour: "2-digit",
        minute: "2-digit",
        hour12: true
    });
}

function formatAllDates() {
    document.querySelectorAll(".arrival, .departure").forEach(cell => {
        let raw = cell.innerText.trim();

        if (raw) {
            cell.innerText = formatDateTime(raw);
        }
    });
}

window.addEventListener("load", function () {
    formatAllDates();
});

</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>