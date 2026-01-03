/**
 * Sistema de Avatares para Cubos V2
 * Centraliza la lógica de iconos de perfil para toda la aplicación.
 */

const AVATAR_PATHS = {
    // Definiciones básicas para compatibilidad
    'Gerente': 'assets/avatars/gallery/gerente_m.png',
    'Contador': 'assets/avatars/gallery/contador_f.png',
    'Supervisor': 'assets/avatars/gallery/supervisor_m.png',
    'Secretaria': 'assets/avatars/gallery/secretaria_f.png',
    'default': 'https://ui-avatars.com/api/?name=User&background=5048e5&color=fff&size=256'
};

// Galería completa de iconos disponibles
const AVATAR_GALLERY = [
    { id: 'gerente_m', path: 'assets/avatars/gallery/gerente_m.png', label: 'Gerente M' },
    { id: 'gerente_f', path: 'assets/avatars/gallery/gerente_f.png', label: 'Gerente F' },
    { id: 'contador_m', path: 'assets/avatars/gallery/contador_m.png', label: 'Contador M' },
    { id: 'contador_f', path: 'assets/avatars/gallery/contador_f.png', label: 'Contador F' },
    { id: 'supervisor_m', path: 'assets/avatars/gallery/supervisor_m.png', label: 'Supervisor M' },
    { id: 'supervisor_f', path: 'assets/avatars/gallery/supervisor_f.png', label: 'Supervisor F' },
    { id: 'secretaria_m', path: 'assets/avatars/gallery/secretaria_m.png', label: 'Secretario' },
    { id: 'secretaria_f', path: 'assets/avatars/gallery/secretaria_f.png', label: 'Secretaria' }
];

window.AvatarIcons = {
    /**
     * Obtiene la URL de un avatar por ID o Cargo
     */
    getUrl: function (idOrCargo) {
        // Primero buscar en la galería por ID
        const fromGallery = AVATAR_GALLERY.find(a => a.id === idOrCargo);
        if (fromGallery) return fromGallery.path;

        // Luego buscar en el mapeo de cargos
        return AVATAR_PATHS[idOrCargo] || AVATAR_PATHS['default'];
    },

    /**
     * Obtiene todos los iconos de la galería
     */
    getGallery: function () {
        return AVATAR_GALLERY;
    }
};
