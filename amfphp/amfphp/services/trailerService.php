<?php

	class trailerService{
	
		/*** (c) 2008 PIH MCT MM3 ***/
		
		function trailerService(){
			$dbname="db_trailer";
			$login ="root";
			$pass = "";
			$handle =mysql_connect("localhost",$login,$pass);
			
			$db = mysql_select_db($dbname,$handle);
		
		}
		function getAllTrailers(){
			//
			$sql = "SELECT * FROM t_trailers ORDER BY id ASC";
			$result = mysql_query($sql);
			return $result;
		}
		function updateTrailer($paramObj){
			
			$id = addslashes($paramObj['id']);
			$title = addslashes($paramObj['title']);
			$description = addslashes($paramObj['description']);
			$thumb = addslashes($paramObj['thumb']);
			$video = addslashes($paramObj['video']);
			
			$descriptionU = utf8_decode($description);
			$titleU = utf8_decode($title);
			
			$sql = "UPDATE  t_trailers SET title='$titleU', description='$descriptionU', thumb='$thumb', video='$video' WHERE id='$id'";
			$result = mysql_query($sql);
			return $result;
		}
		function savePNG($filename,$byteArray){
				$map = dirname(__FILE__) . '/../../images/';
				$pngData = $byteArray->data;
				file_put_contents($map . $filename, $pngData);
		}
	}
?>