-- GLOBAL INVEST AFRICA — schéma de démonstration Supabase
-- Ne traite aucun paiement et ne constitue pas un registre financier de production.
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null default '',
  role text not null default 'member' check (role in ('member','manager','admin')),
  created_at timestamptz not null default now()
);

create table if not exists public.demo_operations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  category text not null,
  description text not null default '',
  budget numeric(14,2) not null check (budget >= 0),
  duration_days integer not null default 30 check (duration_days between 1 and 365),
  status text not null default 'preparation' check (status in ('preparation','active','closed')),
  is_demo boolean not null default true check (is_demo = true),
  created_by uuid references auth.users(id),
  created_at timestamptz not null default now()
);

create table if not exists public.demo_activity (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  action text not null,
  details jsonb not null default '{}'::jsonb,
  is_demo boolean not null default true check (is_demo = true),
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.demo_operations enable row level security;
alter table public.demo_activity enable row level security;

-- Un utilisateur peut lire et modifier son propre profil, mais pas promouvoir son rôle.
create policy "profiles_select_own"
on public.profiles for select to authenticated
using (auth.uid() = id);

create policy "profiles_insert_own_member"
on public.profiles for insert to authenticated
with check (auth.uid() = id and role = 'member');

create policy "profiles_update_own_name"
on public.profiles for update to authenticated
using (auth.uid() = id)
with check (auth.uid() = id and role = 'member');

-- Opérations de démonstration lisibles par les utilisateurs connectés.
create policy "demo_operations_read_authenticated"
on public.demo_operations for select to authenticated
using (is_demo = true);

-- Les écritures d'opérations sont volontairement désactivées côté client.
-- Ajouter ultérieurement une API serveur et une vérification de rôle admin.
-- Ne pas ajouter de politique d'écriture publique.

create policy "demo_activity_read_own"
on public.demo_activity for select to authenticated
using (auth.uid() = user_id);

create policy "demo_activity_insert_own"
on public.demo_activity for insert to authenticated
with check (auth.uid() = user_id and is_demo = true);

-- Créer un profil membre lors d'une nouvelle inscription.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, display_name, role)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'display_name', ''),
    'member'
  );
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();

-- Exemple d'opérations fictives. Exécuter une seule fois.
insert into public.demo_operations (name, category, description, budget, duration_days, status)
values
('Essentiels beauté & soins','Cosmétiques','Stock fictif de soins et produits de beauté.',180000,30,'active'),
('Collection mode femme','Mode femme','Vêtements, sacs et accessoires fictifs.',250000,30,'active'),
('Parfums & accessoires','Accessoires','Scénario fictif de parfums et petits accessoires.',120000,30,'preparation'),
('Mode urbaine mixte','Mixte','Scénario fictif de chaussures et vêtements.',300000,30,'preparation');
