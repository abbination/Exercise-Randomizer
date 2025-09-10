USE exercise;

DELIMITER //

CREATE PROCEDURE load_from_staging ()
BEGIN

	/*Initialize staging info into a temp table to be ready to get ids*/
	CREATE TEMPORARY TABLE get_ids (
		movement VARCHAR(50),
        body_target VARCHAR(25),
        needs_mat BIT,
        `type` VARCHAR(25),
        body_target_id TINYINT,
        type_id TINYINT
    ) AS
		SELECT s.movement,
				s.body_target,
				s.needs_mat,
				s.`type`
		FROM staging AS s;

	/*Insert new body target records*/
	INSERT INTO body_target (`name`)
	SELECT DISTINCT s.body_target
	FROM staging AS s
		LEFT JOIN body_target AS bt ON bt.`name` = s.body_target
	WHERE bt.`name` IS NULL;
    
    /*Update temp table to hold new ids from insert*/
    UPDATE get_ids
	JOIN body_target ON body_target.`name` = get_ids.body_target
	SET get_ids.body_target_id = body_target.body_target_id
	WHERE get_ids.body_target_id IS NULL;
	
    /*Insert new type records*/
	INSERT INTO `type` (`name`)
	SELECT DISTINCT s.`type`
	FROM staging AS s
		LEFT JOIN `type` AS t ON t.`name` = s.`type`
	WHERE t.`name` IS NULL;
    
    /*Update temp table to hold new ids from insert*/
    UPDATE get_ids
	JOIN `type` ON `type`.`name` = get_ids.`type`
	SET get_ids.type_id = `type`.type_id
	WHERE get_ids.type_id IS NULL;
    
    /*Insert into movement table with correct fks*/
    INSERT INTO movement (`name`,
							needs_mat,
                            type_id,
                            body_target_id)
	SELECT gi.`name`,
			gi.needs_mat,
			gi.type_id,
			gi.body_target_id
    FROM get_ids AS gi;
    
    DROP TABLE get_ids;
    
    /*TO DO: add error handling and truncate staging table only if no errors*/

END; //

DELIMITER ;
