-- Schema: NN project management
-- Requires MySQL 8.0+, InnoDB

-- Lookup tables for normalization
CREATE TABLE project_statuses (
  id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE, -- planned, active, on_hold, completed, cancelled
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE employment_statuses (
  id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE, -- active, inactive, on_leave
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE roles (
  id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,        -- Foreman, Carpenter, Electrician, etc.
  is_supervisory TINYINT(1) NOT NULL DEFAULT 0, -- Foreman = 1
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE projects (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(50) NOT NULL,
  name VARCHAR(150) NOT NULL,
  client_name VARCHAR(150) NULL,
  location VARCHAR(200) NULL,
  project_status_id TINYINT UNSIGNED NOT NULL,
  start_date DATE NULL,
  end_date DATE NULL,
  budget DECIMAL(15,2) NULL,
  notes TEXT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_projects_code (code),
  KEY idx_projects_status (project_status_id),
  CONSTRAINT fk_projects_status FOREIGN KEY (project_status_id) REFERENCES project_statuses(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE employees (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  email VARCHAR(150) NOT NULL,
  phone VARCHAR(50) NULL,
  role_id SMALLINT UNSIGNED NOT NULL,            -- current primary role
  employment_status_id TINYINT UNSIGNED NOT NULL,
  join_date DATE NULL,
  avatar_url VARCHAR(255) NULL,
  notes TEXT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_employees_email (email),
  KEY idx_employees_role (role_id),
  KEY idx_employees_status (employment_status_id),
  CONSTRAINT fk_employees_role FOREIGN KEY (role_id) REFERENCES roles(id),
  CONSTRAINT fk_employees_status FOREIGN KEY (employment_status_id) REFERENCES employment_statuses(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Optional pivot if employees can hold multiple roles over time.
CREATE TABLE employee_roles (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  employee_id BIGINT UNSIGNED NOT NULL,
  role_id SMALLINT UNSIGNED NOT NULL,
  assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  unassigned_at DATETIME NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_employee_roles_employee FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE,
  CONSTRAINT fk_employee_roles_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
  UNIQUE KEY uq_employee_role_active (employee_id, role_id, unassigned_at),
  KEY idx_employee_roles_active (employee_id, unassigned_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bridge table: supports multi-assign for supervisory roles and (by app logic) single active assignment for others.
CREATE TABLE project_assignments (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  project_id BIGINT UNSIGNED NOT NULL,
  employee_id BIGINT UNSIGNED NOT NULL,
  role_id SMALLINT UNSIGNED NOT NULL,            -- capture role at time of assignment
  assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  unassigned_at DATETIME NULL,                   -- null = active
  is_primary TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_pa_project FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
  CONSTRAINT fk_pa_employee FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE,
  CONSTRAINT fk_pa_role FOREIGN KEY (role_id) REFERENCES roles(id),
  KEY idx_pa_employee_active (employee_id, unassigned_at),  -- helps enforce single active assignment in app
  KEY idx_pa_project_active (project_id, unassigned_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Optional helper view: current active assignments
CREATE OR REPLACE VIEW v_employee_active_assignment AS
SELECT
  pa.id AS assignment_id,
  pa.employee_id,
  pa.project_id,
  pa.role_id,
  pa.assigned_at,
  pa.is_primary
FROM project_assignments pa
WHERE pa.unassigned_at IS NULL;

-- Seed lookup values (adjust as needed)
INSERT INTO project_statuses (name) VALUES
  ('planned'), ('active'), ('on_hold'), ('completed'), ('cancelled');

INSERT INTO employment_statuses (name) VALUES
  ('active'), ('inactive'), ('on_leave');

INSERT INTO roles (name, is_supervisory) VALUES
  ('Foreman', 1),
  ('Carpenter', 0),
  ('Electrician', 0),
  ('Mason', 0);