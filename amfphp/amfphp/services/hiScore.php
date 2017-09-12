<?php

	class hiScore{
	
		/*** (c) 2008 PIH MCT MM3 ***/
		
		function hiScore(){
			$dbname="db_scores";
			$login ="root";
			$pass = "";
			$handle =mysql_connect("localhost",$login,$pass);
			$db = mysql_select_db($dbname,$handle);
		
		}
		function getHiScores(){
			//
			$sql = "SELECT * FROM t_hiscores ORDER BY score DESC LIMIT 10";
			$result = mysql_query($sql);
			return $result;
		}
		function insertScore($paramObj){
			//
			$naam = addslashes($paramObj['name']);
			$score = addslashes($paramObj['score']);
			
			$sql = "INSERT INTO t_hiscores (name, score) VALUES ('$naam','$score')";
			$result = mysql_query($sql);
			return $result;
		}
	}
?>