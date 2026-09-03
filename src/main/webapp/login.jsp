<% if(request.getParameter("error") != null) { %>
<script>
    window.onload = function () {
        var myModal = new bootstrap.Modal(document.getElementById('errorModal'));
        myModal.show();

        // 🔥 REMOVE ?error=true AFTER SHOWING MODAL
        if (window.history.replaceState) {
            window.history.replaceState(null, null, window.location.pathname);
        }
    };
</script>
<% } %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Port - Login</title>

<!-- Bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- FontAwesome -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

<style>

/* ===== GLOBAL ===== */
body {
    margin: 0;
    height: 100vh;
    font-family: 'Segoe UI', sans-serif;
    background: url('assets/login_bg.webp') center/cover no-repeat;
    overflow: hidden;
}

/* DARK OVERLAY (matches bluish tone) */
body::before {
    content: "";
    position: absolute;
    inset: 0;
    background: linear-gradient(
        90deg,
        rgba(5,18,38,0.55) 0%,
        rgba(5,18,38,0.35) 40%,
        rgba(5,18,38,0.25) 100%
    );
    backdrop-filter: blur(2px);
}

/* OUTER FRAME */
.frame {
    position: relative;
    z-index: 2;
    margin: 30px;
    height: calc(100vh - 60px);
    border: 1px solid rgba(120,180,255,0.2);
    border-radius: 6px;
    padding: 30px;
    border: 1px solid rgba(120,180,255,0.25);
    box-shadow: 0 0 25px rgba(0,120,255,0.15);
}

/* HEADER */
.header {
    color: #e6f2ff;
    font-weight: 600;
    margin-bottom: 20px;
}

/* LEFT BRAND */
.brand {
    position: absolute;
    left: 300px;
    top: 50%;
    transform: translateY(-50%);
    color: #8fd3ff;
}

.brand h1 {
    font-size: 52px;
    font-weight: 700;
    letter-spacing: 1px;
}

.brand h5 {
    font-size: 28px;
    letter-spacing: 2px;
    color: #d6ecff;
}

.brand p {
    margin-top: 10px;
    color: #9fbfd6;
    font-size: 16px;
}

/* LOGIN CARD */
.login-card {
    position: absolute;
    right: 250px;
    top: 50%;
    transform: translateY(-50%);

    width: 400px;
    padding: 50px 40px;

    border-radius: 16px;

    background: rgba(255,255,255,0.08);
    backdrop-filter: blur(15px);

    border: 1px solid rgba(255,255,255,0.2);

    box-shadow:
        0 0 40px rgba(0,0,0,0.6),
        inset 0 0 20px rgba(255,255,255,0.05);
}

/* TITLE */
.login-card h3 {
    color: #ffffff;
    font-weight: 600;
    text-align: center;
}

.login-card small {
    display: block;
    text-align: center;
    color: #cfe6ff;
    margin-bottom: 25px;
}

/* INPUT GROUP */
.input-box {
    display: flex;
    align-items: center;
    background: rgba(0,0,0,0.4);
    border-radius: 8px;
    padding: 10px 12px;
    margin-bottom: 15px;
}

.input-box i {
    color: #a0bcd4;
    width: 20px;
}

.input-box input {
    flex: 1;
    background: transparent;
    border: none;
    color: white;
    outline: none;
    font-size: 14px;
}

.input-box .eye {
    cursor: pointer;
}

.input-box input::placeholder {
    color: #6c757d;     
}
/* BUTTON */
.login-btn {
    width: 100%;
    padding: 10px;
    border-radius: 8px;
    border: none;
    background: linear-gradient(90deg,#1e6bff,#0052cc);
    color: white;
    font-weight: 500;
}

/* ===== GLASS MODAL ===== */
.glass-modal {
    background: rgba(255,255,255,0.08);
    backdrop-filter: blur(18px);
    border-radius: 16px;
    border: 1px solid rgba(255,255,255,0.2);

    box-shadow:
        0 0 40px rgba(0,0,0,0.6),
        inset 0 0 20px rgba(255,255,255,0.05);

    color: #e6f2ff;
}

/* HEADER */
.glass-modal .modal-header {
    border: none;
}

.glass-modal .modal-title {
    color: #ff6b6b;
    font-weight: 600;
}

/* BODY */
.glass-modal .modal-body {
    color: #cfe6ff;
    font-size: 15px;
}

/* FOOTER */
.glass-modal .modal-footer {
    border: none;
}

/* BUTTON */
.glass-modal .btn-danger {
    background: linear-gradient(90deg,#ff4d4d,#cc0000);
    border: none;
    border-radius: 8px;
    font-weight: 500;
}

/* CLOSE BUTTON FIX */
.btn-close-white {
    filter: invert(1);
}

</style>
</head>

<body>

<div class="frame">

    <!-- LEFT BRAND -->
    <div class="brand">
        <h1><i class="fa-solid fa-anchor"></i> PORT</h1>
        <h5>MANAGEMENT ERP</h5>
        <p>Smart Port. Smooth Operations.</p>
    </div>

    <!-- LOGIN -->
    <div class="login-card">

        <h3>Welcome Back!</h3>
        <small>Please login to your account</small>

        <form action="${pageContext.request.contextPath}/login" method="post">

            <!-- USER -->
            <div class="input-box">
                <i class="fa fa-user"></i>
                <input type="email" placeholder="Email" name="email" required>
            </div>

            <!-- PASSWORD -->
            <div class="input-box">
                <i class="fa fa-lock"></i>
                <input type="password" id="password" placeholder="Password" name="password" required>
                <i class="fa fa-eye-slash eye" id="eye"></i>
            </div>

            <!-- BUTTON -->
            <button type="submit" class="login-btn">Login</button>

        </form>


    </div>

</div>

<!-- ERROR MODAL -->
<div class="modal fade" id="errorModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        
        <!-- 👇 THIS LINE CHANGED -->
        <div class="modal-content glass-modal p-3">

            <div class="modal-header border-0">
                <h5 class="modal-title text-danger">
                    <i class="fa fa-exclamation-triangle"></i> Login Failed
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body text-center">
                Invalid Email or Password
            </div>

            <div class="modal-footer border-0">
                <button class="btn btn-danger w-100" data-bs-dismiss="modal">Try Again</button>
            </div>

        </div>

    </div>
</div>

<script>
document.getElementById("eye").onclick = function () {
    let p = document.getElementById("password");
    if (p.type === "password") {
        p.type = "text";
        this.classList.replace("fa-eye-slash", "fa-eye");
    } else {
        p.type = "password";
        this.classList.replace("fa-eye", "fa-eye-slash");
    }
};
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>