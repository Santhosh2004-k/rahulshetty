<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Login — Demo</title>
  <style>
    :root{
      --bg:#f0f2f5;
      --card:#ffffff;
      --accent:#3b82f6;
      --muted:#6b7280;
      --danger:#ef4444;
      --success:#16a34a;
      --shadow: 0 8px 24px rgba(15,23,42,0.08);
      font-family: "Segoe UI", Roboto, Arial, sans-serif;
    }
    html,body{height:100%;margin:0;background:linear-gradient(180deg,#eef2ff 0%,var(--bg) 100%);}
    .wrap{
      height:100%;
      display:flex;
      align-items:center;
      justify-content:center;
      padding:24px;
    }
    .card{
      width:360px;
      background:var(--card);
      border-radius:12px;
      padding:20px;
      box-shadow:var(--shadow);
      box-sizing:border-box;
    }
    .brand{
      display:flex;
      align-items:center;
      gap:12px;
      margin-bottom:14px;
    }
    .logo{
      width:44px;height:44px;border-radius:8px;background:linear-gradient(135deg,var(--accent),#7c3aed);display:inline-block;
      box-shadow:0 4px 12px rgba(59,130,246,0.18);
    }
    h1{font-size:20px;margin:0;color:#0f172a;}
    p.subtitle{margin:6px 0 18px;color:var(--muted);font-size:13px;}
    label{display:block;font-size:13px;color:#111827;margin-bottom:6px;}
    .input{
      width:100%;padding:10px 12px;border-radius:8px;border:1px solid #e6e6e9;font-size:15px;box-sizing:border-box;
      background:#fff;color:#0b1220;
    }
    .field{margin-bottom:12px;}
    .row{
      display:flex;align-items:center;justify-content:space-between;margin-bottom:12px;
    }
    .small{
      font-size:13px;color:var(--muted);
    }
    .actions{display:grid;grid-template-columns:1fr auto;gap:8px;margin-top:4px;}
    button.primary{
      background:var(--accent);color:white;padding:10px 14px;border-radius:8px;border:none;font-size:15px;cursor:pointer;
      box-shadow:0 6px 18px rgba(59,130,246,0.18);
    }
    button.ghost{background:transparent;border:1px solid #e6e6e9;padding:10px 14px;border-radius:8px;font-size:15px;cursor:pointer;}
    .help{font-size:13px;color:var(--muted);margin-top:12px;text-align:center;}
    .error{color:var(--danger);font-size:13px;margin-top:6px;}
    .success{color:var(--success);font-size:13px;margin-top:6px;}
    .pw-row{display:flex;gap:8px;align-items:center;}
    .show-btn{background:transparent;border:none;color:var(--accent);cursor:pointer;font-size:13px;padding:6px;}
    .remember{display:flex;gap:8px;align-items:center;}
  </style>
</head>
<body>
  <div class="wrap">
    <form class="card" id="loginForm" autocomplete="off" novalidate>
      <div class="brand">
        <span class="logo" aria-hidden="true"></span>
        <div>
          <h1>Welcome back</h1>
          <p class="subtitle">Sign in to continue to your dashboard</p>
        </div>
      </div>

      <div class="field">
        <label for="email">Email</label>
        <input id="email" class="input" type="email" placeholder="you@example.com" required>
        <div id="emailError" class="error" style="display:none"></div>
      </div>

      <div class="field">
        <label for="password">Password</label>
        <div class="pw-row">
          <input id="password" class="input" type="password" placeholder="Enter password" required style="flex:1;">
          <button type="button" class="show-btn" id="togglePw" aria-pressed="false">Show</button>
        </div>
        <div id="pwError" class="error" style="display:none"></div>
      </div>

      <div class="row">
        <label class="remember">
          <input id="remember" type="checkbox" aria-label="Remember me"> <span class="small">Remember me</span>
        </label>
        <a href="#" class="small" id="forgot">Forgot?</a>
      </div>

      <div id="formMessage" role="status" aria-live="polite"></div>

      <div class="actions">
        <button class="primary" type="submit">Sign in</button>
        <button type="button" class="ghost" id="demoCreds">Demo</button>
      </div>

      <p class="help">Don't have an account? <a href="#" id="signup">Sign up</a></p>
    </form>
  </div>

  <script>
    // ----- Demo credentials (for client-side demo only) -----
    // DO NOT use this approach for real authentication in production.
    const DEMO_USER = {
      email: "user@example.com",
      password: "Password123"
    };

    // Elements
    const form = document.getElementById('loginForm');
    const emailInput = document.getElementById('email');
    const pwInput = document.getElementById('password');
    const rememberInput = document.getElementById('remember');
    const emailError = document.getElementById('emailError');
    const pwError = document.getElementById('pwError');
    const formMessage = document.getElementById('formMessage');
    const togglePw = document.getElementById('togglePw');
    const demoBtn = document.getElementById('demoCreds');

    // Load remembered email
    window.addEventListener('DOMContentLoaded', () => {
      const saved = localStorage.getItem('rememberedEmail');
      if (saved) {
        emailInput.value = saved;
        rememberInput.checked = true;
      }
    });

    // Toggle show/hide password
    togglePw.addEventListener('click', () => {
      const isHidden = pwInput.type === 'password';
      pwInput.type = isHidden ? 'text' : 'password';
      togglePw.textContent = isHidden ? 'Hide' : 'Show';
      togglePw.setAttribute('aria-pressed', String(isHidden));
    });

    // Demo fill
    demoBtn.addEventListener('click', () => {
      emailInput.value = DEMO_USER.email;
      pwInput.value = DEMO_USER.password;
    });

    // Simple validators
    function validateEmail(value) {
      // basic RFC-like check
      const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      return re.test(value);
    }
    function validatePassword(value) {
      return value.length >= 8; // simple length rule
    }

    function clearErrors() {
      emailError.style.display = 'none';
      pwError.style.display = 'none';
      formMessage.textContent = '';
      formMessage.className = '';
    }

    // Submit handler
    form.addEventListener('submit', (e) => {
      e.preventDefault();
      clearErrors();

      const email = emailInput.value.trim();
      const password = pwInput.value;

      let valid = true;
      if (!validateEmail(email)) {
        emailError.textContent = 'Please enter a valid email address.';
        emailError.style.display = 'block';
        valid = false;
      }
      if (!validatePassword(password)) {
        pwError.textContent = 'Password must be at least 8 characters.';
        pwError.style.display = 'block';
        valid = false;
      }

      if (!valid) return;

      // Simulated authentication (client-only)
      // Replace this with a fetch() to your backend API in real usage.
      if (email === DEMO_USER.email && password === DEMO_USER.password) {
        formMessage.textContent = 'Login successful! Redirecting…';
        formMessage.className = 'success';

        // Remember email if asked
        if (rememberInput.checked) {
          localStorage.setItem('rememberedEmail', email);
        } else {
          localStorage.removeItem('rememberedEmail');
        }

        // Demo: redirect after short pause (change to your app page)
        setTimeout(() => {
          // In a real app you'd redirect to a dashboard: location.href = '/dashboard';
          alert('Welcome! (Demo redirect)'); 
          // For demo keep on same page — replace above with location.href if needed.
        }, 700);
      } else {
        formMessage.textContent = 'Invalid credentials. Try demo credentials: user@example.com / Password123';
        formMessage.className = 'error';
      }
    });

    // Accessibility / small helpers
    document.getElementById('forgot').addEventListener('click', (ev) => {
      ev.preventDefault();
      alert('Forgot password flow — implement backend reset link.');
    });
    document.getElementById('signup').addEventListener('click', (ev) => {
      ev.preventDefault();
      alert('Signup flow — implement registration page.');
    });
  </script>
</body>
</html>
