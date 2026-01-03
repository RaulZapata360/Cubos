// Avatar Icons System - Role-based profile pictures
const AVATAR_PATHS = {
    'Gerente': 'assets/avatars/gerente.png',
    'Contador': 'assets/avatars/contador.png',
    'Supervisor': 'assets/avatars/supervisor.png',
    'Secretaria': 'assets/avatars/secretaria.png',
    'default': 'https://ui-avatars.com/api/?name=User&background=5048e5&color=fff&size=256'
};

/**
 * Get avatar URL for a given cargo/role
 * @param {string} cargo - User's role (Gerente, Contador, Supervisor, Secretaria)
 * @returns {string} - URL to avatar image
 */
function getAvatarUrl(cargo) {
    return AVATAR_PATHS[cargo] || AVATAR_PATHS['default'];
}

/**
 * Update avatar image element with role-based icon
 * @param {string} elementId - ID of the img element to update
 * @param {string} cargo - User's role
 */
function updateAvatarIcon(elementId, cargo) {
    const element = document.getElementById(elementId);
    if (element) {
        element.src = getAvatarUrl(cargo);
    }
}

// Export for use in other scripts
if (typeof window !== 'undefined') {
    window.AvatarIcons = {
        getUrl: getAvatarUrl,
        update: updateAvatarIcon,
        PATHS: AVATAR_PATHS
    };
}
