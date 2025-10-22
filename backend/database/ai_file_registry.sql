CREATE TABLE ai_file_registry (
    -- Primary Key and Identification
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),

    -- Timestamps
    created_at timestamptz NOT NULL DEFAULT now(),

    -- File Metadata
    file_name text NOT NULL,
    file_category text NOT NULL,  -- e.g., 'Image', 'Video', 'Document', 'Text', 'Other'
    mime_type text,               -- e.g., 'image/jpeg'
    size_bytes bigint,            -- File size for auditing

    -- Storage Location
    storage_bucket text NOT NULL, -- Name of the Supabase Storage bucket (e.g., 'images')
    storage_path text NOT NULL,   -- The full path/key to the file within the bucket

    -- AI Processing Status and Results
    ai_agent_status text NOT NULL DEFAULT 'PENDING',  -- Status: PENDING, PROCESSING, COMPLETED, FAILED
    ai_agent_result jsonb                             -- Structured data for the AI's analysis output (e.g., tags, summary)
);

-- Optional: Create an index to speed up common lookups by category
CREATE INDEX idx_ai_file_registry_category ON ai_file_registry (file_category);