-- ============================================
-- VERIFICAR Y REPARAR POLÍTICAS RLS
-- ============================================

-- Verificar que RLS esté habilitado en todas las tablas
SELECT 
  schemaname,
  tablename,
  rowsecurity as rls_enabled
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;

-- Si alguna tabla muestra 'false', ejecuta esto para habilitarlas:
ALTER TABLE obras ENABLE ROW LEVEL SECURITY;
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE usuario_obra ENABLE ROW LEVEL SECURITY;
ALTER TABLE camiones ENABLE ROW LEVEL SECURITY;
ALTER TABLE movimientos ENABLE ROW LEVEL SECURITY;
ALTER TABLE materiales ENABLE ROW LEVEL SECURITY;
ALTER TABLE historial_diario ENABLE ROW LEVEL SECURITY;

-- Verificar políticas existentes
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;
