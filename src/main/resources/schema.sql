CREATE SCHEMA IF NOT EXISTS dbportfolio;

SET NAMES 'UTF8';
SET TIMEZONE TO 'America/Bogota';

DROP TABLE IF EXISTS dbportfolio.twopasswordverifications;
DROP TABLE IF EXISTS dbportfolio.resetpasswordverifications;
DROP TABLE IF EXISTS dbportfolio.accountverifications;
DROP TABLE IF EXISTS dbportfolio.usersevents;
DROP TABLE IF EXISTS dbportfolio.usersroles;
DROP TABLE IF EXISTS dbportfolio.users;
DROP TABLE IF EXISTS dbportfolio.roles;
DROP TABLE IF EXISTS dbportfolio.events;

CREATE TABLE dbportfolio.users
(
    id BIGINT NOT NULL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(50) DEFAULT NULL,
    address VARCHAR(100) DEFAULT NULL,
    phone VARCHAR(30) DEFAULT NULL,
    enabled boolean DEFAULT false,
    non_locked boolean DEFAULT true,
    using_mfa boolean DEFAULT false,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    image_url VARCHAR(255) DEFAULT NULL,
    CONSTRAINT uq_user_email UNIQUE (email)
);

CREATE TABLE dbportfolio.roles
(
    id  BIGINT NOT NULL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    permission VARCHAR(255) NOT NULL,
    CONSTRAINT uq_roles_name UNIQUE (name)
);

CREATE TABLE dbportfolio.usersroles
(
    id  BIGINT NOT NULL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES dbportfolio.users (id)  ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (role_id) REFERENCES dbportfolio.roles (id)  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE dbportfolio.events
(
    id BIGINT NOT NULL PRIMARY KEY,
    type VARCHAR(50) NOT NULL CHECK(TYPE IN ('LOGIN_ATTEMPT', 'LOGIN_ATTEMPT_FAILURE', 'LOGIN_ATTEMPT_SUCCESS', 'PROFILE_UPDATE', 'PROFILE_PICTURE_UPDATE', 'ROLE_UPDATE', 'ACCOUNT_SETTINGS_UPDATE', 'PASSWORD_UPDATE', 'MFA_UPDATE')),
    description VARCHAR(255) NOT NULL,
    CONSTRAINT uq_events_type UNIQUE (type)
);

CREATE TABLE dbportfolio.usersevents
(
    id BIGINT NOT NULL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    event_id BIGINT NOT NULL,
    device VARCHAR(100) DEFAULT NULL,
    ip_address VARCHAR(100) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES dbportfolio.users (id)  ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (event_id) REFERENCES dbportfolio.events (id)  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE dbportfolio.accountverifications
(
    id BIGINT NOT NULL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    url VARCHAR(255) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES dbportfolio.users (id)  ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT uq_accountverifications_user_id UNIQUE (user_id),
    CONSTRAINT uq_accountverifications_url UNIQUE (url)
);

CREATE TABLE  dbportfolio.resetpasswordverifications
(
    id BIGINT NOT NULL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    url VARCHAR(255) NOT NULL,
    expiration_date TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES dbportfolio.users (id)  ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT uq_resetpasswordverifications_user_id UNIQUE (user_id),
    CONSTRAINT uq_resetpasswordverifications_url UNIQUE (url)
);

CREATE TABLE  dbportfolio.twopasswordverifications
(
    id BIGINT NOT NULL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    code VARCHAR(10) NOT NULL,
    expiration_date TIMESTAMP NOT NULL,    
    FOREIGN KEY (user_id) REFERENCES dbportfolio.users (id)  ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT uq_twopasswordverifications_user_id UNIQUE (user_id),
    CONSTRAINT uq_twopasswordverifications_code UNIQUE (code)
);