// ============================================
// SCRIPT DE DIAGNÓSTICO - Pegar en la consola del navegador
// ============================================

console.log('🔍 INICIANDO DIAGNÓSTICO...\n');

// 1. Verificar si Supabase está cargado
console.log('1️⃣ Verificando Supabase...');
if (typeof supabase !== 'undefined') {
    console.log('✅ Supabase library cargada');
} else {
    console.error('❌ Supabase library NO cargada');
}

// 2. Verificar cliente de Supabase
console.log('\n2️⃣ Verificando cliente de Supabase...');
if (typeof supabaseClient !== 'undefined') {
    console.log('✅ supabaseClient existe');
} else {
    console.error('❌ supabaseClient NO existe');
}

// 3. Verificar sesión de usuario
console.log('\n3️⃣ Verificando sesión...');
if (typeof authService !== 'undefined') {
    authService.checkSession().then(session => {
        if (session.authenticated) {
            console.log('✅ Usuario autenticado:', session.user?.email);
            console.log('   Rol:', session.profile?.rol);
            console.log('   Obra ID:', localStorage.getItem('selectedObraId'));
        } else {
            console.error('❌ Usuario NO autenticado');
            console.log('   → Necesitas hacer login primero');
        }
    });
} else {
    console.error('❌ authService NO existe');
}

// 4. Verificar obra seleccionada
console.log('\n4️⃣ Verificando obra seleccionada...');
const obraId = localStorage.getItem('selectedObraId');
const obraNombre = localStorage.getItem('selectedObraNombre');
if (obraId) {
    console.log('✅ Obra seleccionada:', obraNombre, '(ID:', obraId + ')');
} else {
    console.error('❌ NO hay obra seleccionada');
    console.log('   → Necesitas seleccionar una obra');
}

// 5. Verificar conexión a Supabase
console.log('\n5️⃣ Verificando conexión a Supabase...');
if (typeof supabaseClient !== 'undefined') {
    supabaseClient.from('camiones').select('count').limit(1)
        .then(({ data, error }) => {
            if (error) {
                console.error('❌ Error conectando a Supabase:', error.message);
            } else {
                console.log('✅ Conexión a Supabase OK');
            }
        });
}

// 6. Verificar si hay datos en caché
console.log('\n6️⃣ Verificando caché...');
const cacheKeys = Object.keys(localStorage).filter(k => k.startsWith('cache_'));
if (cacheKeys.length > 0) {
    console.log('✅ Hay', cacheKeys.length, 'items en caché');
    console.log('   Keys:', cacheKeys);
} else {
    console.log('⚠️ No hay datos en caché');
}

console.log('\n✅ DIAGNÓSTICO COMPLETO');
console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
console.log('Si ves errores arriba (❌), esos son los problemas.');
console.log('Si todo está OK (✅), el problema es otro.');
