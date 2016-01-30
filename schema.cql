CREATE TABLE IF NOT EXISTS cert_meta (cert_uuid varchar, metadata varchar, PRIMARY KEY (cert_uuid));
CREATE TABLE IF NOT EXISTS cert (uuid varchar, cert_sn int, cert varchar, ca_chain varchar, PRIMARY KEY (uuid));
CREATE TABLE IF NOT EXISTS cn_cert (cn varchar, uuid varchar, cert_sn int, cert varchar, ca_chain varchar, PRIMARY KEY (cn));
CREATE TABLE IF NOT EXISTS ca (uuid varchar, user_uuid varchar, cert varchar, PRIMARY KEY (uuid));
CREATE TABLE IF NOT EXISTS ca_cert (uuid varchar, ca_uuid varchar, cert_uuid varchar, PRIMARY KEY (uuid));
CREATE TABLE IF NOT EXISTS cert_ca (cert_uuid varchar, ca_uuid varchar, PRIMARY KEY (cert_uuid));