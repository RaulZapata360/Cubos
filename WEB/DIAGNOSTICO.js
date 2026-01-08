// ============================================
// DIAGNÓSTICO DE DATOS - Sistema de Conteo
// ============================================
// Ejecuta estas funciones en la consola del navegador para diagnosticar problemas

// 1. Verificar movimientos cargados
window.checkMovements = function () {
    console.group('📊 DIAGNÓSTICO: Movimientos');
    console.log('Total de movimientos:', movements ? movements.length : 0);

    if (movements && movements.length > 0) {
        console.log('Primer movimiento:', movements[0]);
        console.log('Estructura de camión en movimiento:', movements[0].camiones);

        // Verificar si todos los movimientos tienen información de camión
        const withTruckInfo = movements.filter(m => m.camiones).length;
        const withoutTruckInfo = movements.filter(m => !m.camiones).length;

        console.log(`✅ Con info de camión: ${withTruckInfo}`);
        console.log(`❌ Sin info de camión: ${withoutTruckInfo}`);

        // Mostrar campos disponibles en camiones
        if (movements[0].camiones) {
            console.log('Campos disponibles en camiones:', Object.keys(movements[0].camiones));
        }
    } else {
        console.warn('⚠️ No hay movimientos cargados');
    }
    console.groupEnd();
};

// 2. Verificar camiones cargados
window.checkTrucks = function () {
    console.group('🚛 DIAGNÓSTICO: Camiones');
    console.log('Total de camiones:', trucks ? trucks.length : 0);

    if (trucks && trucks.length > 0) {
        console.log('Primer camión:', trucks[0]);
        console.log('Campos disponibles:', Object.keys(trucks[0]));

        // Agrupar por tipo
        const byType = {};
        trucks.forEach(t => {
            const tipo = t.tipo_registrado || 'sin_tipo';
            byType[tipo] = (byType[tipo] || 0) + 1;
        });
        console.log('Camiones por tipo:', byType);
    } else {
        console.warn('⚠️ No hay camiones cargados');
    }
    console.groupEnd();
};

// 3. Verificar análisis de rendimiento
window.checkPerformance = function () {
    console.group('📈 DIAGNÓSTICO: Rendimiento');

    if (!movements || movements.length === 0) {
        console.warn('⚠️ No hay movimientos para analizar');
        console.groupEnd();
        return;
    }

    const statsMap = {};
    movements.forEach(m => {
        const truckId = m.camion_id;
        if (!statsMap[truckId]) {
            const truckInfo = m.camiones || m.camion || {};
            statsMap[truckId] = {
                id: truckId,
                name: truckInfo.nombre || 'N/A',
                patente: truckInfo.patente || 'N/A',
                capacidad: truckInfo.capacidad || 'N/A',
                tipo_registrado: truckInfo.tipo_registrado || 'N/A',
                trips: 0
            };
        }
        statsMap[truckId].trips++;
    });

    const truckStats = Object.values(statsMap);
    console.log('Estadísticas de camiones:', truckStats);
    console.table(truckStats);

    // Verificar cuántos tienen patente
    const withPatente = truckStats.filter(t => t.patente !== 'N/A').length;
    const withoutPatente = truckStats.filter(t => t.patente === 'N/A').length;

    console.log(`✅ Con patente: ${withPatente}`);
    console.log(`❌ Sin patente: ${withoutPatente}`);

    console.groupEnd();
};

// 4. Verificar consulta de movimientos
window.testMovementsQuery = async function () {
    console.group('🔍 DIAGNÓSTICO: Consulta de Movimientos');

    try {
        const today = new Date().toISOString().split('T')[0];
        console.log('Consultando movimientos para:', today);
        console.log('Obra ID:', currentObraId);

        const { data, error } = await supabaseClient
            .from('movimientos')
            .select(`
                *,
                camiones (nombre, patente, capacidad, tipo_registrado)
            `)
            .eq('obra_id', currentObraId)
            .eq('fecha', today)
            .order('timestamp', { ascending: false });

        if (error) {
            console.error('❌ Error en consulta:', error);
        } else {
            console.log('✅ Consulta exitosa');
            console.log('Total de movimientos:', data.length);
            if (data.length > 0) {
                console.log('Primer movimiento:', data[0]);
                console.log('Info de camión:', data[0].camiones);
            }
        }
    } catch (err) {
        console.error('❌ Error:', err);
    }

    console.groupEnd();
};

// 5. Ejecutar diagnóstico completo
window.runFullDiagnostic = function () {
    console.clear();
    console.log('🔧 INICIANDO DIAGNÓSTICO COMPLETO...\n');
    checkMovements();
    checkTrucks();
    checkPerformance();
    testMovementsQuery();
    console.log('\n✅ DIAGNÓSTICO COMPLETO');
};

console.log('✅ Funciones de diagnóstico cargadas. Ejecuta runFullDiagnostic() para ver el estado completo.');
