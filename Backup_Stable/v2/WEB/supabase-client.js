// ============================================
// SUPABASE CLIENT
// Cliente configurado para interactuar con Supabase
// ============================================

import { supabaseConfig } from './supabase-config.js';

// Importar Supabase desde CDN
const { createClient } = supabase;

// Crear cliente de Supabase
export const supabaseClient = createClient(
    supabaseConfig.url,
    supabaseConfig.anonKey
);

// Helper: Obtener usuario actual
export async function getCurrentUser() {
    const { data: { user }, error } = await supabaseClient.auth.getUser();
    if (error) {
        console.error('Error getting current user:', error);
        return null;
    }
    return user;
}

// Helper: Obtener sesión actual
export async function getCurrentSession() {
    const { data: { session }, error } = await supabaseClient.auth.getSession();
    if (error) {
        console.error('Error getting session:', error);
        return null;
    }
    return session;
}

// Helper: Verificar si usuario está autenticado
export async function isAuthenticated() {
    const session = await getCurrentSession();
    return session !== null;
}

// Helper: Obtener perfil de usuario (con rol)
export async function getUserProfile(userId) {
    const { data, error } = await supabaseClient
        .from('usuarios')
        .select('*')
        .eq('id', userId)
        .single();

    if (error) {
        console.error('Error getting user profile:', error);
        return null;
    }

    return data;
}

// Helper: Verificar rol de usuario
export async function getUserRole() {
    const user = await getCurrentUser();
    if (!user) return null;

    const profile = await getUserProfile(user.id);
    return profile?.rol || null;
}

// Helper: Suscribirse a cambios en tiempo real
export function subscribeToTable(table, callback, filter = null) {
    let subscription = supabaseClient
        .channel(`${table}_changes`)
        .on('postgres_changes',
            {
                event: '*',
                schema: 'public',
                table: table,
                filter: filter
            },
            callback
        )
        .subscribe();

    return subscription;
}

// Helper: Cancelar suscripción
export function unsubscribe(subscription) {
    if (subscription) {
        supabaseClient.removeChannel(subscription);
    }
}

console.log('✅ Supabase client initialized');
