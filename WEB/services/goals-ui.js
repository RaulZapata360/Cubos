/**
 * Goals & Toast System - UI Functions
 * Handles goal modal, toast notifications, and progress bars
 */

// Helper function to get Supabase client
function getSupabaseClient() {
    // Try window.supabase first (initialized in index.html head)
    if (window.supabase && typeof window.supabase.from === 'function') {
        return window.supabase;
    }
    // Fallback to supabaseClient if available
    if (window.supabaseClient && typeof window.supabaseClient.from === 'function') {
        return window.supabaseClient;
    }
    console.error('❌ No Supabase client available');
    return null;
}

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
 * Load materials from Supabase for the current obra
 */
async function loadMaterialsFromSupabase() {
    try {
        const obraId = window.currentObraId;
        if (!obraId) {
            console.warn('⚠️ No obra ID found, cannot load materials');
            return [];
        }

        // Show loading indicator
        const loadingIndicator = document.getElementById('materialLoadingIndicator');
        if (loadingIndicator) {
            loadingIndicator.classList.remove('hidden');
        }

        // Get Supabase client safely
        const supabase = getSupabaseClient();
        if (!supabase) {
            console.error('❌ Supabase client not initialized');
            if (loadingIndicator) loadingIndicator.classList.add('hidden');
            return [];
        }

        const { data, error } = await supabase
            .from('materiales')
            .select('*')
            .eq('obra_id', obraId)
            .order('nombre', { ascending: true });

        if (error) throw error;

        console.log(`📦 ${data?.length || 0} materiales cargados desde Supabase`);
        console.log('Materiales:', data); // Debug: ver los materiales cargados
        window.materials = data || [];

        // Hide loading indicator
        if (loadingIndicator) {
            loadingIndicator.classList.add('hidden');
        }

        return data || [];
    } catch (error) {
        console.error('❌ Error loading materials:', error);
        window.materials = [];

        // Hide loading indicator on error
        const loadingIndicator = document.getElementById('materialLoadingIndicator');
        if (loadingIndicator) {
            loadingIndicator.classList.add('hidden');
        }

        return [];
    }
}

// ==================== GOAL MODAL SYSTEM ====================

/**
 * Open goal creation modal
 */
// ==================== GOAL MODAL SYSTEM ====================

/**
 * Open goal creation modal
 */
// ==================== GOAL MODAL SYSTEM ====================

/**
 * Open goal creation modal
 */
/**
 * Open goal creation modal
 */
window.openGoalModal = async function () {
    const modal = document.getElementById('goalModal');
    if (!modal) return;

    // Reset form
    document.getElementById('goalForm').reset();
    document.getElementById('charCount').textContent = '0/200';

    // Load materials from Supabase
    await loadMaterialsFromSupabase();

    // Initialize Material Select based on default checked type
    const defaultType = document.querySelector('input[name="goalType"]:checked').value;
    updateGoalMaterials(defaultType);

    // Setup Goal Type Change Listeners
    const typeInputs = document.querySelectorAll('input[name="goalType"]');
    typeInputs.forEach(input => {
        input.addEventListener('change', (e) => {
            updateGoalMaterials(e.target.value);
        });
    });

    modal.classList.remove('hidden');
};

/**
 * Update dynamic material selector based on goal type
 * @param {string} type - incoming, outgoing, internal
 */
function updateGoalMaterials(type) {
    const select = document.getElementById('goalMaterial');
    if (!select) return;

    select.innerHTML = '<option value="" class="bg-slate-900 text-text-muted">Cualquier material...</option>';

    // Filter materials from global window.materials loaded from Supabase
    const availableMaterials = window.materials || [];
    let filtered = [];

    // Filter materials by type matching the goal type
    if (availableMaterials.length > 0) {
        filtered = availableMaterials.filter(m => m.tipo === type);
    }

    // Only use fallbacks if absolutely no materials found for that type
    if (filtered.length === 0) {
        console.warn(`⚠️ No materials found for type "${type}", using fallback`);
        if (type === 'incoming') filtered = [{ id: null, nombre: 'Base Estabilizada' }, { id: null, nombre: 'Arena' }, { id: null, nombre: 'Relleno' }];
        else if (type === 'outgoing') filtered = [{ id: null, nombre: 'Escombro' }, { id: null, nombre: 'Basura' }, { id: null, nombre: 'Excedentes' }];
        else if (type === 'internal') filtered = [{ id: null, nombre: 'Tierra' }, { id: null, nombre: 'Ripio' }];
    }

    filtered.forEach(mat => {
        const option = document.createElement('option');
        // Use material ID as value, nombre as display text
        option.value = mat.id || mat.nombre; // Fallback to nombre if no ID
        option.textContent = mat.nombre;
        option.className = 'bg-slate-900 text-white';
        select.appendChild(option);
    });
}

/**
 * Handle goal form submission
 */
if (document.getElementById('goalForm')) {
    document.getElementById('goalForm').addEventListener('submit', async (e) => {
        e.preventDefault();

        const nombre = document.getElementById('goalTitle').value.trim();
        const tipo = document.querySelector('input[name="goalType"]:checked').value;
        const descripcion = document.getElementById('goalDescription').value.trim();
        const m3_objetivo = parseFloat(document.getElementById('goalM3').value);
        const dias_plazo = parseInt(document.getElementById('goalDeadlineDays').value);
        const materialSelectValue = document.getElementById('goalMaterial').value;

        if (!nombre || !descripcion || !m3_objetivo || !dias_plazo) {
            showToast('error', 'Error', 'Por favor completa todos los campos requeridos');
            return;
        }

        // Calculate Deadline Date: Today + Days
        const today = new Date();
        const deadlineDate = new Date(today);
        deadlineDate.setDate(today.getDate() + dias_plazo);
        const fecha_limite = deadlineDate.toISOString().split('T')[0];

        try {
            const obraId = window.currentObraId;
            if (!obraId) {
                showToast('error', 'Error', 'No se pudo identificar la obra');
                return;
            }

            // Determine if materialSelectValue is an ID (UUID) or a name (fallback)
            let material_objetivo_id = null;
            let material_objetivo = null;

            if (materialSelectValue) {
                // Check if it's a UUID (simple check: contains dashes and is 36 chars)
                const isUUID = materialSelectValue.length === 36 && materialSelectValue.includes('-');

                if (isUUID) {
                    material_objetivo_id = materialSelectValue;
                    // Find the material name from window.materials
                    const material = window.materials?.find(m => m.id === materialSelectValue);
                    material_objetivo = material?.nombre || null;
                } else {
                    // It's a fallback name
                    material_objetivo = materialSelectValue;
                }
            }

            const goalData = {
                nombre,
                tipo,
                descripcion,
                m3_objetivo,
                fecha_limite,
                material_objetivo,
                material_objetivo_id
            };

            await goalsService.createGoal(obraId, goalData);

            showToast('success', 'Meta Creada', `Meta "${nombre}" registrada`);
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
 * Render progress bar for a goal (Small version for cards)
 */
window.renderProgressBar = function (goal, progress) {
    if (!goal || !progress) return '';

    const percentage = progress.porcentaje;
    const isComplete = progress.completada;
    const hasDelay = progress.diasRetraso > 0;

    let barColor = 'bg-white';
    if (isComplete) barColor = 'bg-emerald-500 shadow-[0_0_10px_rgba(16,185,129,0.5)]';
    else if (hasDelay) barColor = 'bg-amber-500 shadow-[0_0_10px_rgba(245,158,11,0.5)]';
    else if (goal.tipo === 'incoming') barColor = 'bg-emerald-400';
    else if (goal.tipo === 'outgoing') barColor = 'bg-rose-400';
    else barColor = 'bg-blue-400';

    return `
        <div class="mt-4 pt-3 border-t border-white/10">
            <div class="flex items-center justify-between mb-2">
                <span class="text-[10px] uppercase font-bold text-white/60 tracking-wider truncate max-w-[120px]">${goal.descripcion}</span>
                <span class="text-[10px] font-black text-white">${percentage}%</span>
            </div>
            <div class="h-1.5 bg-slate-900/50 rounded-full overflow-hidden border border-white/5">
                <div class="${barColor} h-full transition-all duration-1000 ease-out" style="width: ${percentage}%"></div>
            </div>
            ${isComplete ? `
                <div class="flex items-center gap-1 mt-1.5 justify-end">
                    <span class="text-[9px] uppercase font-bold text-emerald-400 tracking-wider">Misión Completada</span>
                </div>
            ` : hasDelay ? `
                <div class="flex items-center gap-1 mt-1.5 justify-end">
                    <span class="text-[9px] uppercase font-bold text-amber-400 tracking-wider">⚠️ ${progress.diasRetraso} días retraso</span>
                </div>
            ` : `
                <div class="flex items-center gap-1 mt-1.5 justify-end">
                    <span class="text-[9px] font-medium text-white/40 tracking-wider">${progress.m3Acumulados} / ${progress.m3Objetivo} m³</span>
                </div>
            `}
        </div>
    `;
};

/**
 * Render Active Mission Card (Donut Chart)
 */
function renderMissionCard(goal, progress) {
    const card = document.getElementById('activeMissionCard');
    if (!card || !goal || !progress) {
        if (card) card.classList.add('hidden');
        return;
    }

    // Colors mapping
    const themeColors = {
        incoming: '#10b981', // emerald-500
        outgoing: '#f43f5e', // rose-500
        internal: '#3b82f6'  // blue-500
    };
    const color = themeColors[goal.tipo] || '#3b82f6';

    // Update Texts
    document.getElementById('missionTitle').textContent = goal.descripcion || 'MISIÓN ACTIVA';
    document.getElementById('missionProgressM3').textContent = progress.m3Acumulados.toFixed(1);
    document.getElementById('missionRemainingM3').textContent = Math.max(0, progress.m3Objetivo - progress.m3Acumulados).toFixed(1);
    document.getElementById('missionPercent').textContent = `${Math.round(progress.porcentaje)}%`;

    // Update Donut Chart Gradient
    const chart = document.getElementById('missionDonutChart');
    const p = Math.min(progress.porcentaje, 100);
    chart.style.background = `conic-gradient(${color} 0% ${p}%, rgba(255,255,255,0.05) ${p}% 100%)`; // Conic gradient for industrial look

    // Update Deadline Text
    const deadlineEl = document.getElementById('missionDeadlineText');
    if (progress.diasRetraso > 0) {
        deadlineEl.innerHTML = `<span class="text-rose-500">RETRASO: ${progress.diasRetraso} DÍAS</span>`;
    } else {
        const today = new Date();
        const deadline = new Date(goal.fecha_limite + 'T23:59:59'); // End of day
        const diffTime = deadline - today;
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
        deadlineEl.innerHTML = `Plazo: <span class="text-white">${diffDays} días</span>`;
    }

    // Show Card
    card.classList.remove('hidden');
}

/**
 * Load and display active goals
 */
window.loadGoals = async function () {
    try {
        const obraId = window.currentObraId;
        if (!obraId) return;

        const goals = await goalsService.getActiveGoals(obraId); // Get active goals only

        let activeGoalForCard = null;

        // Update progress bars for each operation type and find main active goal
        for (const tipo of ['incoming', 'internal', 'outgoing']) {
            const goal = goals.find(g => g.tipo === tipo);
            const containerId = `goalProgress-${tipo}`;
            const container = document.getElementById(containerId);

            if (container && goal) {
                const progress = goalsService.calculateProgress(goal, movements || []);
                container.innerHTML = renderProgressBar(goal, progress);

                // Prioritize finding an incomplete active goal for the big card
                if (!activeGoalForCard || (activeGoalForCard.completada && !progress.completada)) {
                    activeGoalForCard = { goal, progress };
                }
            } else if (container) {
                container.innerHTML = '';
            }
        }

        // Render the main Active Mission Card
        if (activeGoalForCard) {
            renderMissionCard(activeGoalForCard.goal, activeGoalForCard.progress);
        } else if (goals.length > 0) {
            // Fallback: Show the first one available even if complete
            const firstGoal = goals[0];
            const progress = goalsService.calculateProgress(firstGoal, movements || []);
            renderMissionCard(firstGoal, progress);
        } else {
            renderMissionCard(null, null); // Hide card
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
