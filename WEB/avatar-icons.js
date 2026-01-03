// ============================================
// AVATAR ICONS - Sistema de Iconos por Cargo
// ============================================
// Iconos SVG predeterminados para cada cargo
// No requiere archivos externos ni Supabase Storage

const AVATAR_ICONS = {
    'Gerente': `<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
        <circle cx="50" cy="50" r="50" fill="#5048e5"/>
        <circle cx="50" cy="35" r="15" fill="#fff"/>
        <path d="M 25 75 Q 25 55 50 55 Q 75 55 75 75 Z" fill="#fff"/>
        <circle cx="50" cy="30" r="3" fill="#5048e5"/>
        <path d="M 35 45 L 40 50 L 35 55" stroke="#5048e5" stroke-width="2" fill="none"/>
        <path d="M 65 45 L 60 50 L 65 55" stroke="#5048e5" stroke-width="2" fill="none"/>
    </svg>`,

    'Contador': `<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
        <circle cx="50" cy="50" r="50" fill="#10b981"/>
        <circle cx="50" cy="35" r="15" fill="#fff"/>
        <path d="M 25 75 Q 25 55 50 55 Q 75 55 75 75 Z" fill="#fff"/>
        <rect x="40" y="28" width="20" height="3" fill="#10b981" rx="1"/>
        <circle cx="45" cy="45" r="2" fill="#10b981"/>
        <circle cx="55" cy="45" r="2" fill="#10b981"/>
    </svg>`,

    'Supervisor': `<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
        <circle cx="50" cy="50" r="50" fill="#f59e0b"/>
        <circle cx="50" cy="35" r="15" fill="#fff"/>
        <path d="M 25 75 Q 25 55 50 55 Q 75 55 75 75 Z" fill="#fff"/>
        <path d="M 40 30 L 45 25 L 50 30 L 55 25 L 60 30" stroke="#f59e0b" stroke-width="2" fill="none"/>
        <circle cx="45" cy="42" r="2" fill="#f59e0b"/>
        <circle cx="55" cy="42" r="2" fill="#f59e0b"/>
    </svg>`,

    'Secretaria': `<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
        <circle cx="50" cy="50" r="50" fill="#ec4899"/>
        <circle cx="50" cy="35" r="15" fill="#fff"/>
        <path d="M 25 75 Q 25 55 50 55 Q 75 55 75 75 Z" fill="#fff"/>
        <circle cx="45" cy="42" r="2" fill="#ec4899"/>
        <circle cx="55" cy="42" r="2" fill="#ec4899"/>
        <path d="M 45 48 Q 50 52 55 48" stroke="#ec4899" stroke-width="2" fill="none"/>
    </svg>`,

    'default': `<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
        <circle cx="50" cy="50" r="50" fill="#6366f1"/>
        <circle cx="50" cy="35" r="15" fill="#fff"/>
        <path d="M 25 75 Q 25 55 50 55 Q 75 55 75 75 Z" fill="#fff"/>
        <circle cx="45" cy="42" r="2" fill="#6366f1"/>
        <circle cx="55" cy="42" r="2" fill="#6366f1"/>
    </svg>`
};

/**
 * Obtiene el icono SVG para un cargo específico
 * @param {string} cargo - El cargo del usuario
 * @returns {string} SVG como string
 */
function getAvatarIcon(cargo) {
    return AVATAR_ICONS[cargo] || AVATAR_ICONS['default'];
}

/**
 * Obtiene el icono como Data URL para usar en img src
 * @param {string} cargo - El cargo del usuario
 * @returns {string} Data URL del SVG
 */
function getAvatarDataUrl(cargo) {
    const svg = getAvatarIcon(cargo);
    const encoded = btoa(unescape(encodeURIComponent(svg)));
    return `data:image/svg+xml;base64,${encoded}`;
}

/**
 * Actualiza el avatar en el DOM
 * @param {string} elementId - ID del elemento img
 * @param {string} cargo - Cargo del usuario
 */
function updateAvatarIcon(elementId, cargo) {
    const element = document.getElementById(elementId);
    if (element) {
        element.src = getAvatarDataUrl(cargo);
    }
}

// Exportar para uso global
if (typeof window !== 'undefined') {
    window.AvatarIcons = {
        getIcon: getAvatarIcon,
        getDataUrl: getAvatarDataUrl,
        update: updateAvatarIcon,
        ICONS: AVATAR_ICONS
    };
}
