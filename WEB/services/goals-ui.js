/**
 * Goals & Toast System - UI Functions
 * Handles goal modal, toast notifications, and progress bars
 */

// ==================== TOAST NOTIFICATION SYSTEM ====================

/**
 * Show toast notification
 * @param {string} type - success, error, warning, info
 * @param {string} title - Toast title
 * @param {string} message - Toast message
 * @param {number} duration - Duration in ms (default 3000)
 */
window.showToast = function (type, title, message, duration = 3000) {
    const container = document.getElementById('toastContainer');
    if (!container) return;

    const colors = {
        success: 'bg-success shadow-success/30',
        error: 'bg-danger shadow-danger/30',
        warning: 'bg-warning shadow-warning/30',
        info: 'bg-primary shadow-primary/30'
    };

    const icons = {
        success: 'check_circle',
        error: 'error',
        warning: 'warning',
        info: 'info'
    };

    const toast = document.createElement('div');
    toast.className = `toast-notification ${colors[type] || colors.info} text-white px-4 py-3 rounded-xl shadow-lg flex items-center gap-3 pointer-events-auto animate-slide-in-right`;
    toast.innerHTML = `
        <span class="material-symbols-outlined text-2xl">${icons[type] || icons.info}</span>
        <div class="flex-1">
            <div class="font-bold text-sm">${title}</div>
            <div class="text-xs text-white/80">${message}</div>
        </div>
        <button onclick="dismissToast(this)" class="text-white/70 hover:text-white transition-colors">
            <span class="material-symbols-outlined text-lg">close</span>
        </button>
    `;

    container.appendChild(toast);

    // Auto-dismiss
    setTimeout(() => {
        toast.classList.remove('animate-slide-in-right');
        toast.classList.add('animate-slide-out-right');
        setTimeout(() => toast.remove(), 300);
    }, duration);
};

/**
 * Dismiss toast notification
 */
window.dismissToast = function (button) {
    const toast = button.closest('.toast-notification');
    if (!toast) return;

    toast.classList.remove('animate-slide-in-right');
    toast.classList.add('animate-slide-out-right');
    setTimeout(() => toast.remove(), 300);
};

// ==================== GOAL MODAL SYSTEM ====================

/**
 * Open goal creation modal
 */
window.openGoalModal = function () {
    const modal = document.getElementById('goalModal');
    if (!modal) return;

    // Set minimum date to today
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('goalDeadline').min = today;

    // Reset form
    document.getElementById('goalForm').reset();
    document.getElementById('charCount').textContent = '0/200';

    modal.classList.remove('hidden');
};

/**
 * Handle goal form submission
 */
if (document.getElementById('goalForm')) {
    document.getElementById('goalForm').addEventListener('submit', async (e) => {
        e.preventDefault();

        const tipo = document.querySelector('input[name="goalType"]:checked').value;
        const descripcion = document.getElementById('goalDescription').value.trim();
        const m3_objetivo = parseFloat(document.getElementById('goalM3').value);
        const fecha_limite = document.getElementById('goalDeadline').value;

        if (!descripcion || !m3_objetivo || !fecha_limite) {
            showToast('error', 'Error', 'Por favor completa todos los campos');
            return;
        }

        try {
            const obraId = window.currentObraId;
            if (!obraId) {
                showToast('error', 'Error', 'No se pudo identificar la obra');
                return;
            }

            const goalData = {
                tipo,
                descripcion,
                m3_objetivo,
                fecha_limite
            };

            await goalsService.createGoal(obraId, goalData);

            showToast('success', 'Meta Creada', `Meta de ${m3_objetivo} m³ registrada`);
            closeAllModals();

            // Reload goals and update UI
            await loadGoals();

        } catch (error) {
            console.error('Error creating goal:', error);
            showToast('error', 'Error', 'No se pudo crear la meta');
        }
    });
}

/**
 * Character counter for description
 */
if (document.getElementById('goalDescription')) {
    document.getElementById('goalDescription').addEventListener('input', (e) => {
        const count = e.target.value.length;
        document.getElementById('charCount').textContent = `${count}/200`;
    });
}

// ==================== PROGRESS BAR SYSTEM ====================

/**
 * Render progress bar for a goal
 * @param {object} goal - Goal object
 * @param {object} progress - Progress data from calculateProgress
 * @returns {string} HTML string for progress bar
 */
window.renderProgressBar = function (goal, progress) {
    if (!goal || !progress) return '';

    const percentage = progress.porcentaje;
    const isComplete = progress.completada;
    const hasDelay = progress.diasRetraso > 0;

    let barColor = 'bg-white';
    if (isComplete) barColor = 'bg-success';
    else if (hasDelay) barColor = 'bg-warning';

    return `
        <div class="mt-3 pt-3 border-t border-white/20">
            <div class="flex items-center justify-between mb-1">
                <span class="text-[11px] text-white/70">${goal.descripcion}</span>
                <span class="text-[11px] font-bold text-white">${percentage}%</span>
            </div>
            <div class="h-2 bg-white/20 rounded-full overflow-hidden">
                <div class="${barColor} h-full transition-all duration-500" style="width: ${percentage}%"></div>
            </div>
            ${isComplete ? `
                <div class="flex items-center gap-1 mt-1">
                    <span class="text-[11px] text-success">✅ Completada</span>
                </div>
            ` : hasDelay ? `
                <div class="flex items-center gap-1 mt-1">
                    <span class="text-[11px] text-warning">⚠️ ${progress.diasRetraso} día${progress.diasRetraso > 1 ? 's' : ''} de retraso</span>
                </div>
            ` : `
                <div class="flex items-center gap-1 mt-1">
                    <span class="text-[11px] text-white/60">${progress.m3Acumulados} / ${progress.m3Objetivo} m³</span>
                </div>
            `}
        </div>
    `;
};

/**
 * Load and display active goals
 */
window.loadGoals = async function () {
    try {
        const obraId = window.currentObraId;
        if (!obraId) return;

        const goals = await goalsService.getActiveGoals(obraId);

        // Update progress bars for each operation type
        for (const tipo of ['incoming', 'internal', 'outgoing']) {
            const goal = goals.find(g => g.tipo === tipo);
            const containerId = `goalProgress-${tipo}`;
            const container = document.getElementById(containerId);

            if (container && goal) {
                const progress = goalsService.calculateProgress(goal, movements || []);
                container.innerHTML = renderProgressBar(goal, progress);
            } else if (container) {
                container.innerHTML = '';
            }
        }

    } catch (error) {
        console.error('Error loading goals:', error);
    }
};

// ==================== CSS ANIMATIONS ====================

// Add CSS animations to document
const style = document.createElement('style');
style.textContent = `
    @keyframes slide-in-right {
        from { transform: translateX(100%); opacity: 0; }
        to { transform: translateX(0); opacity: 1; }
    }

    @keyframes slide-out-right {
        from { transform: translateX(0); opacity: 1; }
        to { transform: translateX(100%); opacity: 0; }
    }

    .animate-slide-in-right {
        animation: slide-in-right 0.3s ease-out;
    }

    .animate-slide-out-right {
        animation: slide-out-right 0.3s ease-in;
    }
`;
document.head.appendChild(style);

console.log('✅ Goals & Toast UI system initialized');
