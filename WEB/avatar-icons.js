/**
 * Sistema de Avatares para Cubos V2 - Versión Optimizada
 */

const AVATAR_GALLERY = [
    { id: 'gerente_orig', path: 'assets/avatars/gallery/gerente_original.png', label: 'Gerente Clásico' },
    { id: 'supervisor_orig', path: 'assets/avatars/gallery/supervisor_original.png', label: 'Supervisor Clásico' },
    { id: 'contador_orig', path: 'assets/avatars/gallery/contador_original.png', label: 'Contador Clásico' },
    { id: 'secretaria_orig', path: 'assets/avatars/gallery/secretaria_original.png', label: 'Secretaria Clásica' },
    { id: 'gerente_m_v2', path: 'assets/avatars/gallery/gerente_m_v2.png', label: 'Gerente M Azul' },
    { id: 'gerente_f_v2', path: 'assets/avatars/gallery/gerente_f_v2.png', label: 'Gerente F Azul' },
    { id: 'contador_m_v2', path: 'assets/avatars/gallery/contador_m_v2.png', label: 'Contador M Naranja' },
    { id: 'contador_f_v2', path: 'assets/avatars/gallery/contador_f_v2.png', label: 'Contador F Naranja' }
];

window.AvatarIcons = {
    getUrl: function (id) {
        const found = AVATAR_GALLERY.find(a => a.id === id);
        if (found) return found.path;

        // Fallback para IDs viejos o nombres de cargo
        if (id === 'Gerente') return 'assets/avatars/gallery/gerente_original.png';
        if (id === 'Supervisor') return 'assets/avatars/gallery/supervisor_original.png';
        if (id === 'Contador') return 'assets/avatars/gallery/contador_original.png';
        if (id === 'Secretaria') return 'assets/avatars/gallery/secretaria_original.png';

        return 'assets/avatars/gallery/gerente_original.png'; // Default seguro
    },
    getGallery: function () {
        return AVATAR_GALLERY;
    }
};
