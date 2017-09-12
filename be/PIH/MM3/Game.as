package be.PIH.MM3
{

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import flash.text.TextField;
	import flash.ui.Mouse;

	public class Game extends MovieClip
	{

		var myCatcher:catcher;
		var myTrowher:trowher;
		var myDropper:dropper;
		var myDropper2:dropper;
		var menu_mc:menu;
		
		var highScore:insertHighScore;

		var dropSpeed:int;
		var aantal:int;
		var tickTeller:int;
		var tmr:Timer;
		var score:int;
		var level:int;
		var lives:int;
		var xPos:int;
		var xPos2:int;
		var bGameOver:Boolean;

		var conn:NetConnection;
		var resp:Responder;
		var hiScores:Array = new Array();
		var topTen:showTop10;

		public function Game()
		{
			//game opstarten
			//trace("init game");
			//loadSettings();
			
			//hoe sneller de klok gaat, hoe meer donuts er zullen vallen
			tmr = new Timer(1500,0);

			intromc.addEventListener("init",initgameHandler);
		}
		private function initgameHandler(evt:Event):void
		{
			dropSpeed = 1;
			aantal = 1500;
			score = 0;
			lives = 6;
			level = 0;
			bGameOver = false;
			hiScores.splice();
			
			loadSettings();
			
			Mouse.hide();
			//removeChild(intromc);
			intromc.alpha = 0;
			//menu_mc.alpha = 1;
		}
		public function loadSettings():void
		{
			var req:URLRequest = new URLRequest("assets/xml/settings.xml");
			var ldr:URLLoader = new URLLoader();
			ldr.addEventListener(Event.COMPLETE,settingsXMLHandler);
			ldr.load(req);

			tmr.addEventListener(TimerEvent.TIMER, timerHandler);
			tmr.start();
		}
		private function settingsXMLHandler(evt:Event):void
		{
			//trace(evt.target.data);
			var dataXML:XML = XML(evt.target.data);
			Settings.parseXMLFile(dataXML);

			//trace(Settings.serverPath);
			//trace(Settings.titleGame);

			startGame();
		}
		private function startGame():void
		{
			//IntroAnimatie

			//UI opbouwen
			buildUI();

			//Gameplay
			gamePlay();

			//score submitten
			//manageHiScore();
		}
		private function manageHiScore():void
		{
			trace(Settings.serverPath);
			conn = new NetConnection();
			
			conn.connect(Settings.serverPath);

			setScore();
			
			//getScores();

			//conn.close();
		}
		private function getScores():void
		{
			resp = new Responder(resultHandler,faultHandler);
			conn.call("hiScore.getHiScores",resp);
		}
		private function setScore():void
		{
			highScore = new insertHighScore();
			highScore.x = stage.stageWidth/2 - highScore.width/2;
			highScore.y = stage.stageHeight/2 - highScore.height/2;
			addChild(highScore);
			
			removeChild(menu_mc);
			
			highScore.btnSubmit.addEventListener(MouseEvent.CLICK,mouseHandler)
		}
		
		private function mouseHandler(evt:MouseEvent):void
		{
			resp = new Responder(submitHandler,submitfaultHandler);
			
			var paramObj:Object = new Object();
			paramObj.name = highScore.txtNaam.text;
			paramObj.score = Number(menu_mc.txtScore.text);
			conn.call("hiScore.insertScore",resp,paramObj);
		}
		
		private function submitHandler(bool:Boolean):void
		{
			if (bool)
			{
				//score succesvol weggeschreven
				removeChild(highScore);
				getScores();
			}
			else
			{
				//fout in SQL Statement, foute variable benaming...
				trace("fout tijdens wegschrijven");
			}
		}
		private function submitfaultHandler(obj:Object):void
		{
			//fout, bvb file niet gevonden of functie niet gevonden
			trace("fout tijdens invoeren score");
		}
		private function resultHandler(obj:Object):void
		{
			//trace(obj.serverInfo.initialData);
			for (var prop in obj.serverInfo.initialData)
			{
				var resultArray:Array = obj.serverInfo.initialData[prop];
				var speler:Object = new Object();
				speler.id = resultArray[0];
				speler.naam = resultArray[1];
				speler.score = resultArray[2];

				hiScores.push(speler);
				//trace(speler.naam + " " + speler.score);
				
//				var topTen:showTop10 = new showTop10();
//				addChild(topTen);
//				
//				bldRosterGrid(topTen.dgGrid);
//				topTen.dgGrid.dataProvider = new DataProvider(hiScores);
//				topTen.dgGrid.rowCount = topTen.dgGrid.length;

			}
			
				topTen = new showTop10();
				vulRooster();
				
				//topTen.x = stage.stageWidth/2 - topTen.width/2;
				topTen.x = 144;
				topTen.y = 10;
				topTen.btn_PlayAgain.addEventListener(MouseEvent.CLICK,playAgainHandler)
				
				addChild(topTen);
			
			conn.close();
		}
		
		private function vulRooster()
		{
			for(var i:int = 0;i<10;i++)
			{
				var speler:Object = new Object();
				speler = hiScores[i];
				
				//trace(speler.naam + " " + speler.score);
				
				topTen["txt_speler" + i].text = speler.naam;
				//trace(["txt_score" + i]);
				topTen["txt_score" + i].text = "" + speler.score;
			}
		}
		
		private function playAgainHandler(evt:MouseEvent):void
		{
			//trace("geklikt");
		    removeChild(topTen);
			
			intromc.alpha = 1;
		}
		
//		function bldRosterGrid(dg:DataGrid){
//		dg.columns = ["naam", "score"];
//		dg.columns[0].width = 200;
//		dg.columns[1].width = 100;
//		dg.move(stage.stageWidth/2 - dg.width/2,stage.stageHeight/2 - dg.height/2);
//		};
		
		private function faultHandler(obj:Object):void
		{
			trace("gegevens konden niet worden opgehaald");
		}
		private function buildUI():void
		{
			//klasse aanmaken voor catcher, trowher & dropper
			//linken aan de lib symbols
			//toevoegen op stage
			myCatcher = new catcher();
			myTrowher = new trowher();
			myDropper = new dropper();
			myDropper2 = new dropper();

			addChild(myCatcher);
			//addChild(myTrowher);
			addChild(myDropper);
			addChild(myDropper2);
			//positioneren
			myCatcher.x = stage.stageWidth/2 - myCatcher.width/2;
			myCatcher.y = stage.stageHeight - myCatcher.height;
			//myTrowher.x = stage.stageWidth/2 - myTrowher.width/2;
			//myTrowher.y = 40;
			myDropper.x = stage.stageWidth/2 - myTrowher.width/2;
			myDropper.y = -10;
			myDropper2.x = stage.stageWidth/2 - myTrowher.width/2;
			myDropper2.y = -10;
			
			
			menu_mc = new menu();
			menu_mc.x = 580;
			menu_mc.y = 8;
			addChild(menu_mc);
		}
		private function gamePlay()
		{
			//catcher bewegen volgens de muis & keyboard
			stage.addEventListener(MouseEvent.MOUSE_MOVE,moveCatcher);
		}
		private function timerHandler(evt:TimerEvent):void
		{
//			tickTeller++;
//
//			if (aantal==tickTeller)
//			{
				xPos = Math.round(Math.random()*(stage.stageWidth-myTrowher.width));
				var myTween:Tween = new Tween(myDropper,"x",Regular.easeOut,myDropper.x,xPos,.5,true);
				myTween.addEventListener(TweenEvent.MOTION_FINISH,finishHandler);
				
				xPos2 = Math.round(Math.random()*(stage.stageWidth-myTrowher.width));
				var myTween2:Tween = new Tween(myDropper2,"x",Regular.easeOut,myDropper.x,xPos2,.5,true);
				myTween2.addEventListener(TweenEvent.MOTION_FINISH,finishHandler2);
				//trace(tickTeller);
//				tickTeller = 0;

				//myTrowher.x = Math.round(Math.random()*200);
				//myTrowher.y = Math.round(Math.random()*200);

				//myTrowher.x = stage.stageWidth/2 - myTrowher.width/2;
				//myTrowher.y = 40;
			//}
		}
		private function finishHandler(evt:TweenEvent):void
		{
			var myTrowher2:trowher = new trowher();
			myTrowher2.x = xPos;
			myTrowher2.y = myDropper.y;
			myTrowher2.speed = Math.round(Math.random()*5+dropSpeed);
			addChild(myTrowher2);
			myTrowher2.addEventListener(Event.ENTER_FRAME,dropHandler);
			//var x:int = Math.round(Math.random()*(stage.stageWidth-myTrowher.width));
			//var myTween:Tween = new Tween(tempTrowher,"x",Regular.easeOut,tempTrowher.x,x,.5,true);
		}
		
		private function finishHandler2(evt:TweenEvent):void
		{
			var myTrowher2:trowher = new trowher();
			myTrowher2.x = xPos2;
			myTrowher2.y = myDropper.y;
			myTrowher2.speed = Math.round(Math.random()*5+dropSpeed);
			addChild(myTrowher2);
			myTrowher2.addEventListener(Event.ENTER_FRAME,dropHandler);
			//var x:int = Math.round(Math.random()*(stage.stageWidth-myTrowher.width));
			//var myTween:Tween = new Tween(tempTrowher,"x",Regular.easeOut,tempTrowher.x,x,.5,true);
		}
		
		private function dropHandler(evt:Event):void
		{
			var tempTrowher:trowher = evt.target as trowher;

			tempTrowher.y += tempTrowher.speed;

			if (tempTrowher.hitTestObject(myCatcher))
			{
				if(bGameOver == false)
				{
					score++;
				}
				tempTrowher.removeEventListener(Event.ENTER_FRAME,dropHandler);
				removeChild(tempTrowher);
				//trace("opgevangen");
				//trace(tmr.delay);

				controleerLevel();
			}
			if (tempTrowher.y > stage.stageHeight)
			{
				if(bGameOver == false)
				{
					score--;
				}

				tempTrowher.removeEventListener(Event.ENTER_FRAME,dropHandler);
				removeChild(tempTrowher);
				//trace("niet opgevangen");

				verwijderleven();
			}
			menu_mc.txtScore.text = String(score);
		}
		private function controleerLevel():void
		{
			if ((score%10) == 0)
			{
				
				if(dropSpeed < 15)
				{
					dropSpeed++;
				}
				level++;
				menu_mc.txt_gameMessage.text = "level " + level;
				//afblijven van de timer => teveel problemen door bug
//				if(aantal > 100)
//				{
//					//aantal-=50;
//					//tmr.delay = aantal;
//				}
			}
		}
		private function verwijderleven():void
		{
			switch (lives)
			{
				case 0 :
					//gameOver;
					trace("game over");
					bGameOver = true;
					tmr.stop();
					
					gameOver();
					manageHiScore();
					
					break;
				case 1 :
					menu_mc.removeChild(menu_mc.life1);
					break;
				case 2 :
					menu_mc.removeChild(menu_mc.life2);
					break;
				case 3 :
					menu_mc.removeChild(menu_mc.life3);
					break;
				case 4 :
					menu_mc.removeChild(menu_mc.life4);
					break;
				case 5 :
					menu_mc.removeChild(menu_mc.life5);
					break;
				case 6 :
					menu_mc.removeChild(menu_mc.life6);
					break;
			}
			lives--;
		}
		
		private function gameOver():void
		{
			
			menu_mc.txt_gameMessage.text = "Game Over";
			
			removeChild(myDropper);
			removeChild(myDropper2);
			removeChild(myCatcher);
			
			Mouse.show();
		}
		
		private function moveCatcher(evt:Event):void
		{
			//catcher mag niet buiten het scherm
			if (stage.mouseX < (stage.stageWidth - myCatcher.width))
			{
				myCatcher.x = stage.mouseX;
			}
		}
	}
}