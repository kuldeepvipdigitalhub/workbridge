DROP DATABASE workbridge;

CREATE DATABASE workbridge OWNER wbuser;

UPDATE user SET role='kuld' WHERE email='your@email.com';

ALTER TABLE project ADD COLUMN category VARCHAR(100);

ALTER TABLE payment ADD COLUMN method VARCHAR(50);
ALTER TABLE payment ADD COLUMN status VARCHAR(20);

ALTER TABLE payment ADD COLUMN total_amount INTEGER;
ALTER TABLE payment ADD COLUMN commission INTEGER;



ALTER TABLE payment ADD COLUMN developer_amount INTEGER;

ALTER TABLE payment ADD COLUMN amount INTEGER;

CREATE TABLE deliverable (
id SERIAL PRIMARY KEY,
project_id INTEGER REFERENCES project(id),
developer_id INTEGER REFERENCES "user"(id),
file VARCHAR(200),
github_link VARCHAR(300),
live_link VARCHAR(300),
notes TEXT,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE deliverable OWNER TO wbuser;