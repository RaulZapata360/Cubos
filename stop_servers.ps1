# Script para detener servidores locales
# Este script identifica procesos escuchando en puertos TCP y permite detenerlos.
# Se excluyen procesos críticos del sistema para evitar errores.

# Obtener todas las conexiones TCP que están escuchando
$connections = Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue

$localServers = @()
$systemProcesses = @('System', 'svchost', 'wininit', 'services', 'lsass', 'csrss', 'smss', 'spoolsv', 'Memory Compression', 'Registry', 'Idle')

foreach ($conn in $connections) {
    # Intentar obtener detalles del proceso
    try {
        $process = Get-Process -Id $conn.OwningProcess -ErrorAction Stop
        
        # Omitir procesos del sistema
        if ($process.ProcessName -in $systemProcesses) {
            continue
        }
        
        # Crear objeto personalizado
        $serverInfo = [PSCustomObject]@{
            ProcessId   = $conn.OwningProcess
            ProcessName = $process.ProcessName
            LocalPort   = $conn.LocalPort
            Path        = $process.Path
        }
        
        $localServers += $serverInfo
    }
    catch {
        # El proceso puede haber terminado o no tener acceso
    }
}

# Agrupar por ID de proceso para eliminar duplicados
$uniqueProcesses = $localServers | Sort-Object ProcessId -Unique

if ($uniqueProcesses.Count -eq 0) {
    Write-Host "No se encontraron servidores locales (ajenos al sistema)." -ForegroundColor Yellow
    exit
}

Write-Host "Se encontraron los siguientes procesos de servidor local:" -ForegroundColor Cyan
$uniqueProcesses | Format-Table -Property ProcessId, ProcessName, LocalPort, Path -AutoSize

$confirmation = Read-Host "¿Desea detener TODOS estos servidores? (s/n)"

if ($confirmation -eq 's' -or $confirmation -eq 'y') {
    foreach ($proc in $uniqueProcesses) {
        Write-Host "Deteniendo $($proc.ProcessName) (PID: $($proc.ProcessId))..."
        try {
            Stop-Process -Id $proc.ProcessId -Force -ErrorAction Stop
            Write-Host "  - Detenido exitosamente" -ForegroundColor Green
        }
        catch {
            Write-Host "  - Error al detener: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    Write-Host "Operación completada." -ForegroundColor Green
} else {
    Write-Host "Operación cancelada." -ForegroundColor Yellow
}
