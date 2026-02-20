CREATE DATABASE gi_log_db; -- First create the database in postgres

\c gi_log_db postgres localhost 5432; -- Connect to the GI Log database that was created

CREATE TABLE members (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    birth_date DATE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ
);

-- Table to store a members dietary issues
CREATE TABLE members_dietary_issues (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    dietary_issue VARCHAR(50) NOT NULL,
    user_id UUID NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ,
    UNIQUE (user_id, dietary_issue),
    FOREIGN KEY (user_id) REFERENCES members(user_id) ON DELETE CASCADE
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
    CONSTRAINT unique_user_diet UNIQUE (user_id, diet_name),
    FOREIGN KEY (user_id) REFERENCES members(user_id) ON DELETE CASCADE
);

CREATE TYPE product_type AS ENUM('drug', 'supplement');

-- Table to store drugs and supplement data
CREATE TABLE products (
    product_id UUID PRIMARY KEY default gen_random_uuid(),
    product_name VARCHAR(50) UNIQUE NOT NULL,
    product_type PRODUCT_TYPE NOT NULL
);

-- Table to store the drugs and supplements used by each user
CREATE TABLE products_used_by_user(
    products_used_by_user_id UUID PRIMARY KEY default gen_random_uuid(),
    dosage VARCHAR(100) NOT NULL,
    user_id UUID NOT NULL,
    product_id UUID NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ,
    CONSTRAINT unique_user_products UNIQUE (user_id, product_id),
    FOREIGN KEY (user_id) REFERENCES members(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- Table to store what recipes a user cooks/eats
CREATE TABLE recipes (
    recipe_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    recipe_name VARCHAR(50) NOT NULL,
    user_id UUID NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ,
    UNIQUE (user_id, recipe_name),
    FOREIGN KEY (user_id) REFERENCES members(user_id) ON DELETE CASCADE
);

-- Table to store ingredients for a recipe
CREATE TABLE ingredients (
    ingredient_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ingredient_name VARCHAR(50) NOT NULL,
    ingredient_amount VARCHAR(50) NOT NULL,
    recipe_id UUID NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ,
    UNIQUE (recipe_id, ingredient_name),
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE CASCADE
);

CREATE TYPE diet_status AS ENUM('starting diet', 'ending diet');

-- Table to store entries of when a user is starting or ending a diet
CREATE TABLE diet_entries (
    entry_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entered_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    diet_status DIET_STATUS NOT NULL,
    additional_comments TEXT,
    user_id UUID NOT NULL,
    diet_name VARCHAR(50) NOT NULL,
    UNIQUE (user_id, entered_at, diet_name),
    FOREIGN KEY (user_id) REFERENCES members(user_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id, diet_name) REFERENCES diets(user_id, diet_name) ON DELETE CASCADE
);

-- Table to store when a user takes their medication and supplements
CREATE TABLE drug_supplement_entries (
    entry_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entered_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    additional_comments TEXT,
    user_id UUID NOT NULL,
    product_id UUID NOT NULL,
    UNIQUE (user_id, entered_at, product_id),
    FOREIGN KEY (user_id) REFERENCES members(user_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id, product_id) REFERENCES products_used_by_user(user_id, product_id) ON DELETE CASCADE
);

-- Table to store what meals a user eats 
CREATE TABLE meal_entries (
    entry_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entered_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    meal_description TEXT NOT NULL,
    additional_comments TEXT,
    user_id UUID NOT NULL,
    UNIQUE (user_id, entered_at),
    FOREIGN KEY (user_id) REFERENCES members(user_id) ON DELETE CASCADE
);

-- junction table to store the recipes involved with each meal a user has, user could have multiple in one sitting
CREATE TABLE recipes_entered_in_meal (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entry_id UUID NOT NULL,
    recipe_id UUID NOT NULL,
    UNIQUE (entry_id, recipe_id),
    FOREIGN KEY (entry_id) REFERENCES meal_entries(entry_id) ON DELETE CASCADE,
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE CASCADE
);

-- Table to store data on the type of stool
CREATE TABLE stool_types (
    stool_type SMALLINT CHECK(stool_type BETWEEN 1 AND 7) PRIMARY KEY,
    stool_description VARCHAR(100) UNIQUE NOT NULL,
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
    stool_type SMALLINT NOT NULL,
    UNIQUE (user_id, entered_at),
    FOREIGN KEY (user_id) REFERENCES members(user_id) ON DELETE CASCADE,
    FOREIGN KEY (stool_type) REFERENCES stool_types(stool_type) ON DELETE CASCADE
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
    UNIQUE (user_id, entered_at),
    FOREIGN KEY (user_id) REFERENCES members(user_id) ON DELETE CASCADE
);

-- INSERT stool type data
INSERT INTO stool_types (stool_type, stool_description, indication)
VALUES ('1', 'Separate hard lumps', 'Very Constipated'),
       ('2', 'Lumpy and sausage like', 'Slightly Constipated'),
       ('3', 'A sausage shape with cracks in the surface', 'Normal'),
       ('4', 'Like a smooth, soft sausage or snake', 'Normal'),
       ('5', 'Soft blobs with clear-cut edges', 'Lacking fiber'),
       ('6', 'Mushy consistency with ragged edges', 'Inflammation'),
       ('7', 'Liquid consistency with no solid pieces', 'Inflammation and diarrhea');


