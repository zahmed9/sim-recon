
CREATE TABLE IF NOT EXISTS documents (
	id					int NOT NULL PRIMARY KEY AUTO_INCREMENT,
	creator			char(255),
	title				char(255),
	description		blob,
	version			int,
	created			datetime NOT NULL,
	modified			timestamp NOT NULL
) TYPE=MyISAM;

CREATE TABLE IF NOT EXISTS files (
	id							int,
	fileid					int NOT NULL PRIMARY KEY AUTO_INCREMENT,
	version					int,
	filename					char(255),
	original_filename		char(255),
	submitter				char(255),
	size						int,
	mime_type				char(255),
	created					datetime NOT NULL,
	modified					timestamp NOT NULL
) TYPE=MyISAM;

CREATE TABLE IF NOT EXISTS filecontents (
	fileid					int NOT NULL PRIMARY KEY,
	data						longblob,
	created					datetime NOT NULL,
	modified					timestamp NOT NULL
) TYPE=MyISAM;
