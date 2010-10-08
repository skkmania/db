--
--  grant on shogi84b
--
GRANT SELECT,INSERT        ON TABLE boards TO "www-data";
GRANT SELECT,INSERT,DELETE ON TABLE new_boards TO "www-data";
GRANT SELECT,INSERT        ON TABLE moves TO "www-data";
GRANT SELECT,INSERT,DELETE ON TABLE new_moves TO "www-data";
GRANT SELECT,INSERT        ON TABLE users TO "www-data";
GRANT SELECT,INSERT,DELETE        ON TABLE user_logins TO "www-data";
GRANT SELECT,INSERT        ON TABLE kifs TO "www-data";
GRANT SELECT,INSERT        ON TABLE kifu_data TO "www-data";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE board_comments TO "www-data";
GRANT SELECT,INSERT,UPDATE ON TABLE board_points TO "www-data";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE boardp_users TO "www-data";
GRANT SELECT,INSERT,UPDATE ON TABLE move_comments TO "www-data";
GRANT SELECT,INSERT,UPDATE ON TABLE move_points TO "www-data";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE tmp_move_points TO "www-data";
GRANT SELECT,INSERT,UPDATE ON TABLE move_point_user TO "www-data";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE tmp_move_point_user TO "www-data";
GRANT SELECT,INSERT,UPDATE ON TABLE moves_user TO "www-data";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE kifread TO "www-data";
GRANT SELECT,usage,update  ON SEQUENCE black_bid TO "www-data";
GRANT SELECT,usage,update  ON SEQUENCE white_bid TO "www-data";
GRANT SELECT,usage,update  ON SEQUENCE kifs_kid_seq TO "www-data";

