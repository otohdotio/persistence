CREATE TABLE IF NOT EXISTS user (uuid varchar, email varchar, account_status varchar, PRIMARY KEY (uuid));
CREATE TABLE IF NOT EXISTS email (email varchar, user_uuid varchar, verified timestamp, PRIMARY KEY (email));
CREATE TABLE IF NOT EXISTS user_cert (user_uuid varchar, cert_uuid varchar, PRIMARY KEY (user_uuid));
CREATE TABLE IF NOT EXISTS cert (uuid varchar, user_uuid varchar, cert_sn int, cert varchar, ca_chain varchar, PRIMARY KEY (uuid));
CREATE TABLE IF NOT EXISTS ca (uuid varchar, user_uuid varchar, cert varchar, PRIMARY KEY (uuid));
CREATE TABLE IF NOT EXISTS ca_cert (uuid varchar, ca_uuid varchar, cert_uuid varchar, PRIMARY KEY (uuid));
CREATE TABLE IF NOT EXISTS cert_ca (cert_uuid varchar, ca_uuid varchar, PRIMARY KEY (cert_uuid));