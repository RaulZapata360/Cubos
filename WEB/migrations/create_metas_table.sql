-- SQL para crear la tabla de metas (Misiones)

create table public.metas_obra (
  id uuid not null default gen_random_uuid (),
  created_at timestamp with time zone not null default now(),
  updated_at timestamp with time zone null default now(),
  obra_id uuid null, -- Asumiendo que existe una tabla obras, podrías agregar: references public.obras(id)
  tipo text not null, -- 'incoming', 'internal', 'outgoing'
  descripcion text null,
  m3_objetivo numeric not null,
  fecha_inicio date not null default CURRENT_DATE,
  fecha_limite date not null,
  activa boolean not null default true,
  constraint metas_obra_pkey primary key (id)
);

-- Habilitar RLS (Row Level Security) es recomendado
alter table public.metas_obra enable row level security;

-- Política para permitir acceso total (ajustar según tus necesidades de seguridad)
create policy "Enable all access for authenticated users" on public.metas_obra
  as permissive for all
  to authenticated
  using (true)
  with check (true);

-- Índices para mejorar rendimiento
create index metas_obra_obra_id_idx on public.metas_obra (obra_id);
create index metas_obra_activa_idx on public.metas_obra (activa);
