drop database nameframe;

REVOKE ALL ON nameframe.* FROM 'nameframe'@'localhost';

drop database nameframecom;

REVOKE ALL ON nameframecom.* FROM 'nameframe'@'localhost';

drop user 'nameframe'@'localhost';
