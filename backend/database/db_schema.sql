-- Enable UUID generation extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Define ENUM Types first
CREATE TYPE ai_agent_status_enum AS ENUM ('PENDING', 'PROCESSING', 'COMPLETED', 'FAILED');
CREATE TYPE collaborator_role_enum AS ENUM ('COLLABORATOR', 'AUTHENTICATOR', 'CREATOR');

-- Create Tables (NO custom public.users table)

CREATE TABLE projects (
    project_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name varchar(255) NOT NULL,
    description text,
    total_cost numeric(19, 4), -- Use numeric for currency
    budget numeric(19, 4),
    starting_date date,
    estimated_end_date date,
    importance_level integer,
    overdue_level integer,
    created_on timestamptz DEFAULT now(),
    -- References Supabase Auth user
    created_by uuid NOT NULL REFERENCES auth.users(id),
    is_finished boolean DEFAULT false
);

CREATE TABLE project_collaborators (
    proj_collab_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    -- References Supabase Auth user
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    project_id uuid NOT NULL REFERENCES projects(project_id) ON DELETE CASCADE,
    role collaborator_role_enum NOT NULL,
    CONSTRAINT unique_user_project UNIQUE (user_id, project_id)
);

CREATE TABLE ai_file_registries (
    ai_file_reg_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    -- Added project_id based on your last diagram version
    project_id uuid NOT NULL REFERENCES projects(project_id) ON DELETE CASCADE,
    file_name varchar(255),
    file_category varchar(100),
    mime_type varchar(100),
    size_bytes bigint,
    storage_bucket varchar(255),
    storage_path text,
    ai_agent_status ai_agent_status_enum DEFAULT 'PENDING',
    ai_agent_result text,
    confidence_score numeric(5, 2),
    created_on timestamptz DEFAULT now()
    -- Link FROM other tables TO this table's ai_file_reg_id
);

CREATE TABLE project_evidence (
    project_evidence_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id uuid NOT NULL REFERENCES projects(project_id) ON DELETE CASCADE,
    evidence_file_id uuid NOT NULL REFERENCES ai_file_registries(ai_file_reg_id) ON DELETE RESTRICT, -- Link to the file
    project_percentage double precision,
    authenticity_score integer,
    -- References Supabase Auth user
    authenticated_by uuid REFERENCES auth.users(id),
    authenticated_on timestamptz,
    is_valid boolean DEFAULT false
);

-- Consider if sellers need separate auth or if they are just users
CREATE TABLE user_seller (
    seller_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(), -- This ID might be redundant if linked to auth.users
    -- Consider making seller_id reference auth.users(id) if sellers log in via Supabase Auth
    -- seller_id uuid PRIMARY KEY REFERENCES auth.users(id),
    seller_email varchar(255) UNIQUE NOT NULL, -- May be redundant if linked to auth.users
    hashed_password text NOT NULL, -- Only needed if NOT using Supabase Auth for sellers
    created_on timestamptz DEFAULT now(),
    -- References Supabase Auth user (who created this seller record?)
    created_by uuid REFERENCES auth.users(id)
);

CREATE TABLE seller_product (
    product_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    seller_id uuid NOT NULL REFERENCES user_seller(seller_id) ON DELETE CASCADE,
    product_type varchar(100),
    product_name varchar(255) NOT NULL,
    product_cost numeric(19, 4) NOT NULL CHECK (product_cost >= 0),
    created_on timestamptz DEFAULT now(),
    -- References Supabase Auth user (who created this product record?)
    created_by uuid REFERENCES auth.users(id)
);

CREATE TABLE transaction (
    transaction_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id uuid NOT NULL REFERENCES projects(project_id) ON DELETE RESTRICT,
    product_id uuid NOT NULL REFERENCES seller_product(product_id) ON DELETE RESTRICT,
    quantity integer DEFAULT 1 NOT NULL CHECK (quantity > 0),
    created_on timestamptz DEFAULT now(),
    -- References Supabase Auth user (who initiated transaction?)
    created_by uuid REFERENCES auth.users(id)
);

CREATE TABLE project_reports (
    report_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id uuid NOT NULL REFERENCES projects(project_id) ON DELETE CASCADE,
    -- References Supabase Auth user
    reported_by_id uuid REFERENCES auth.users(id),
    details text,
    created_on timestamptz DEFAULT now()
);

CREATE TABLE report_proofs (
   report_proof_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
   report_id uuid NOT NULL REFERENCES project_reports(report_id) ON DELETE CASCADE,
   proof_file_id uuid NOT NULL REFERENCES ai_file_registries(ai_file_reg_id) ON DELETE CASCADE,
   uploaded_on timestamptz DEFAULT now(),
   CONSTRAINT unique_report_proof_file UNIQUE (report_id, proof_file_id)
);

-- Add Indexes for Foreign Keys and commonly queried columns (recommended)
CREATE INDEX IF NOT EXISTS idx_projects_created_by ON projects(created_by);
CREATE INDEX IF NOT EXISTS idx_project_collaborators_user ON project_collaborators(user_id);
CREATE INDEX IF NOT EXISTS idx_project_collaborators_project ON project_collaborators(project_id);
CREATE INDEX IF NOT EXISTS idx_ai_file_registries_project ON ai_file_registries(project_id);
CREATE INDEX IF NOT EXISTS idx_project_evidence_project ON project_evidence(project_id);
CREATE INDEX IF NOT EXISTS idx_project_evidence_file ON project_evidence(evidence_file_id);
CREATE INDEX IF NOT EXISTS idx_project_evidence_auth_by ON project_evidence(authenticated_by);
CREATE INDEX IF NOT EXISTS idx_seller_product_seller ON seller_product(seller_id);
CREATE INDEX IF NOT EXISTS idx_seller_product_created_by ON seller_product(created_by);
CREATE INDEX IF NOT EXISTS idx_transaction_project ON transaction(project_id);
CREATE INDEX IF NOT EXISTS idx_transaction_product ON transaction(product_id);
CREATE INDEX IF NOT EXISTS idx_transaction_created_by ON transaction(created_by);
CREATE INDEX IF NOT EXISTS idx_project_reports_project ON project_reports(project_id);
CREATE INDEX IF NOT EXISTS idx_project_reports_user ON project_reports(reported_by_user_id);
CREATE INDEX IF NOT EXISTS idx_report_proofs_report ON report_proofs(report_id);
CREATE INDEX IF NOT EXISTS idx_report_proofs_file ON report_proofs(proof_file_id);