CREATE DATABASE gi_log_db; -- First create the database in postgres

\c gi_log_db postgres localhost 5432; -- Connect to the GI Log database that was created

CREATE TABLE members (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    birth_date DATE,
    dietary_issues TEXT [], -- List of dietary issues known by user,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ
);

CREATE TABLE admins (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    birth_date DATE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ
);

-- Table to log what diets a user is on
CREATE TABLE diets (
    diet_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    diet_name VARCHAR(50) NOT NULL,
    user_id UUID NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ,
    CONSTRAINT unique_user_diet UNIQUE (user_id, diet_id),
    FOREIGN KEY (user_id) REFERENCES members(user_id) ON DELETE CASCADE
);

CREATE TYPE product_type AS ENUM('drug', 'supplement');

-- Table to store what medication and supplements a user takes
CREATE TABLE drugs_and_supplements (
    drugs_and_supplements_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    drugs_and_supplements_name VARCHAR(50) NOT NULL,
    dosage VARCHAR(100) NOT NULL,
    product_type PRODUCT_TYPE NOT NULL,
    user_id UUID NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ,
    CONSTRAINT unique_user_medications UNIQUE (user_id, drugs_and_supplements_id),
    FOREIGN KEY (user_id) REFERENCES members(user_id) ON DELETE CASCADE
);

-- Table to store what recipes a user cooks/eats
CREATE TABLE recipes (
    recipe_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    recipe_name VARCHAR(50) NOT NULL,
    ingredients JSON NOT NULL,
    user_id UUID NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ,
    FOREIGN KEY (user_id) REFERENCES members(user_id) ON DELETE CASCADE
);

CREATE TYPE diet_status AS ENUM('starting diet', 'ending diet');

-- Table to store entries of when a user is starting or ending a diet
CREATE TABLE diet_entries (
    entry_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entered_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    diet_status DIET_STATUS NOT NULL,
    additional_comments TEXT,
    user_id UUID NOT NULL,
    diet_id UUID NOT NULL,
    FOREIGN KEY (user_id) REFERENCES members(user_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id, diet_id) REFERENCES diets(user_id, diet_id)
);

-- Table to store when a user takes their medication and supplements
CREATE TABLE drug_supplement_entries (
    entry_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entered_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    additional_comments TEXT,
    user_id UUID NOT NULL,
    drugs_and_supplements_id UUID NOT NULL,
    FOREIGN KEY (user_id) REFERENCES members(user_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id, drugs_and_supplements_id) REFERENCES drugs_and_supplements(user_id, drugs_and_supplements_id)
);

-- Table to store what meals a user eats 
CREATE TABLE meal_entries (
    entry_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entered_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    meal_description TEXT NOT NULL,
    additional_comments TEXT,
    user_id UUID NOT NULL,
    FOREIGN KEY (user_id) REFERENCES members(user_id) ON DELETE CASCADE
);

-- junction table to store the recipes involved with each meal a user has, user could have multiple in one sitting
CREATE TABLE recipes_entered_in_meal (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entry_id UUID,
    recipe_id UUID,
    FOREIGN KEY (entry_id) REFERENCES meal_entries(entry_id) ON DELETE CASCADE,
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE CASCADE
);

-- Table to store data on the type of stool
CREATE TABLE stool_types (
    stool_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    stool_type VARCHAR(10) NOT NULL,
    stool_description VARCHAR(100) NOT NULL,
    indication VARCHAR(50) NOT NULL
);

-- Table to store the types of stool a user is having
CREATE TABLE stool_entries (
    entry_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entered_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    stool_color VARCHAR(50) NOT NULL,
    blood_present BOOLEAN NOT NULL,
    additional_comments TEXT,
    user_id UUID NOT NULL,
    stool_id UUID NOT NULL,
    FOREIGN KEY (user_id) REFERENCES members(user_id) ON DELETE CASCADE,
    FOREIGN KEY (stool_id) REFERENCES stool_types(stool_id) ON DELETE CASCADE
);

-- Table to store the mental and physical health of users 
CREATE TABLE health_entries (
    entry_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entered_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    emotional_scale_rating SMALLINT NOT NULL CHECK (emotional_scale_rating BETWEEN 1 AND 10),
    stomach_pain_scale_rating SMALLINT NOT NULL CHECK (stomach_pain_scale_rating BETWEEN 1 AND 10),
    anxiety_scale_rating SMALLINT NOT NULL CHECK (anxiety_scale_rating BETWEEN 1 AND 10),
    stress_scale_rating SMALLINT NOT NULL CHECK (stress_scale_rating BETWEEN 1 AND 10),
    depression_scale_rating SMALLINT NOT NULL CHECK (depression_scale_rating BETWEEN 1 AND 10),
    mental_health_log TEXT NOT NULL,
    physical_health_log TEXT NOT NULL,
    additional_comments TEXT,
    user_id UUID NOT NULL,
    FOREIGN KEY (user_id) REFERENCES members(user_id) ON DELETE CASCADE
);

-- INSERT stool type data
INSERT INTO stool_types (stool_type, stool_description, indication)
VALUES ('TYPE 1', 'Separate hard lumps', 'Very Constipated'),
       ('TYPE 2', 'Lumpy and sausage like', 'Slightly Constipated'),
       ('TYPE 3', 'A sausage shape with cracks in the surface', 'Normal'),
       ('TYPE 4', 'Like a smooth, soft sausage or snake', 'Normal'),
       ('TYPE 5', 'Soft blobs with clear-cut edges', 'Lacking fiber'),
       ('TYPE 6', 'Mushy consistency with ragged edges', 'Inflammation'),
       ('TYPE 7', 'Liquid consistency with no solid pieces', 'Inflammation and diarrhea');


