// ============================================
// AUTHENTICATION SERVICE
// Maneja login, logout y sesiones
// ============================================

import { supabaseClient, getCurrentUser, getUserProfile } from './supabase-client.js';

class AuthService {
    constructor() {
        this.currentUser = null;
        this.currentProfile = null;
    }

    // Login con email y password
    async login(email, password) {
        try {
            const { data, error } = await supabaseClient.auth.signInWithPassword({
                email: email.trim(),
                password: password
            });

            if (error) {
                console.error('Login error:', error);
                return { success: false, error: error.message };
            }

            // Obtener perfil del usuario
            const profile = await getUserProfile(data.user.id);

            if (!profile) {
                await this.logout();
                return { success: false, error: 'Perfil de usuario no encontrado' };
            }

            this.currentUser = data.user;
            this.currentProfile = profile;

            // Guardar en sessionStorage para persistencia
            sessionStorage.setItem('userRole', profile.rol);
            sessionStorage.setItem('userName', profile.nombre_completo);
            sessionStorage.setItem('userEmail', profile.email);

            return {
                success: true,
                user: data.user,
                profile: profile,
                rol: profile.rol
            };

        } catch (error) {
            console.error('Login exception:', error);
            return { success: false, error: 'Error al iniciar sesión' };
        }
    }

    // Logout
    async logout() {
        try {
            const { error } = await supabaseClient.auth.signOut();

            if (error) {
                console.error('Logout error:', error);
            }

            // Limpiar datos locales
            this.currentUser = null;
            this.currentProfile = null;
            sessionStorage.clear();
            localStorage.removeItem('selectedObraId');
            localStorage.removeItem('selectedObraNombre');

            return { success: true };

        } catch (error) {
            console.error('Logout exception:', error);
            return { success: false, error: 'Error al cerrar sesión' };
        }
    }

    // Verificar sesión actual
    async checkSession() {
        try {
            const user = await getCurrentUser();

            if (!user) {
                return { authenticated: false };
            }

            const profile = await getUserProfile(user.id);

            if (!profile) {
                await this.logout();
                return { authenticated: false };
            }

            this.currentUser = user;
            this.currentProfile = profile;

            return {
                authenticated: true,
                user: user,
                profile: profile,
                rol: profile.rol
            };

        } catch (error) {
            console.error('Check session error:', error);
            return { authenticated: false };
        }
    }

    // Obtener usuario actual
    getUser() {
        return this.currentUser;
    }

    // Obtener perfil actual
    getProfile() {
        return this.currentProfile;
    }

    // Obtener rol actual
    getRole() {
        return this.currentProfile?.rol || sessionStorage.getItem('userRole');
    }

    // Verificar si es jefe
    isJefe() {
        return this.getRole() === 'jefe';
    }

    // Verificar si es contador
    isContador() {
        return this.getRole() === 'contador';
    }

    // Redirigir según rol
    redirectByRole() {
        const rol = this.getRole();

        if (rol === 'jefe') {
            window.location.href = 'boss.html';
        } else if (rol === 'contador') {
            window.location.href = 'site-selector.html';
        } else {
            window.location.href = 'login.html';
        }
    }

    // Verificar autenticación y redirigir si no está autenticado
    async requireAuth(requiredRole = null) {
        const session = await this.checkSession();

        if (!session.authenticated) {
            window.location.href = 'login.html';
            return false;
        }

        if (requiredRole && session.rol !== requiredRole) {
            this.redirectByRole();
            return false;
        }

        return true;
    }
}

// Exportar instancia única
export const authService = new AuthService();

// Hacer disponible globalmente para debugging
window.authService = authService;

console.log('✅ Auth service initialized');
