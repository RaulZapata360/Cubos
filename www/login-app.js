// Login Authentication System
// Simple role-based authentication with sessionStorage

const users = {
    contador: {
        username: 'contador',
        password: '1234',
        role: 'counter',
        redirect: 'index.html'
    },
    jefe: {
        username: 'jefe',
        password: 'admin',
        role: 'boss',
        redirect: 'boss.html'
    }
};

class LoginManager {
    constructor() {
        this.init();
    }

    init() {
        // Check if already logged in
        this.checkExistingSession();

        // Attach event listeners
        this.attachEventListeners();
    }

    checkExistingSession() {
        const userRole = sessionStorage.getItem('userRole');
        const username = sessionStorage.getItem('username');

        if (userRole && username) {
            // User is already logged in, redirect to appropriate page
            const redirect = userRole === 'counter' ? 'index.html' : 'boss.html';
            window.location.href = redirect;
        }
    }

    attachEventListeners() {
        const form = document.getElementById('loginForm');
        const buttons = document.querySelectorAll('.role-btn');

        // Handle form submission
        buttons.forEach(button => {
            button.addEventListener('click', (e) => {
                e.preventDefault();
                const requestedRole = button.dataset.role;
                this.handleLogin(requestedRole);
            });
        });

        // Also handle Enter key
        form.addEventListener('submit', (e) => {
            e.preventDefault();
        });

        // Clear error on input
        const inputs = form.querySelectorAll('input');
        inputs.forEach(input => {
            input.addEventListener('input', () => {
                this.hideError();
            });
        });
    }

    handleLogin(requestedRole) {
        const username = document.getElementById('username').value.trim();
        const password = document.getElementById('password').value;

        // Find user
        const user = Object.values(users).find(u => u.username === username);

        if (!user) {
            this.showError('Usuario no encontrado');
            return;
        }

        if (user.password !== password) {
            this.showError('Contraseña incorrecta');
            return;
        }

        if (user.role !== requestedRole) {
            this.showError(`Este usuario no tiene acceso como ${requestedRole === 'counter' ? 'Contador' : 'Jefe'}`);
            return;
        }

        // Successful login
        this.login(user);
    }

    login(user) {
        // Save session
        sessionStorage.setItem('userRole', user.role);
        sessionStorage.setItem('username', user.username);

        // Show success feedback
        const buttons = document.querySelectorAll('.role-btn');
        buttons.forEach(btn => btn.disabled = true);

        // Redirect after short delay
        setTimeout(() => {
            window.location.href = user.redirect;
        }, 300);
    }

    showError(message) {
        const errorElement = document.getElementById('errorMessage');
        errorElement.textContent = message;
        errorElement.classList.add('show');

        // Shake animation
        setTimeout(() => {
            errorElement.classList.remove('show');
        }, 3000);
    }

    hideError() {
        const errorElement = document.getElementById('errorMessage');
        errorElement.classList.remove('show');
    }
}

// Logout function (can be called from other pages)
function logout() {
    sessionStorage.clear();
    window.location.href = 'login.html';
}

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    new LoginManager();
});
