package menu 
{
	import com.bit101.components.PushButton;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author 
	 */
	public class MainMenu extends Sprite
	{
		//ppppu systems
		private var characterManager:CharacterManager;
		private var musicPlayer:MusicPlayer;
		private var userSettings:UserSettings;
		
		//private var characterSubmenu:LockList;
		
		
		private var characterMenu:CharacterMenu;
		private var animationMenu:AnimationMenu;
		
		/*Tells what frame the currently playing animation should be on. The only exception to this are animations that require a 
		 * transition to be accessed.*/
		private var currentFrameForAnimation:int = 0;
		
		private var settingsButton:PushButton;
		private var keyConfig:Config;
		
		//consts
		public static const characterIconSize:Number = 35;
		
		public function MainMenu(charManager:CharacterManager, bgmPlayer:MusicPlayer, settings:UserSettings) 
		{
			characterManager = charManager;
			musicPlayer = bgmPlayer;
			userSettings = settings;
			keyConfig = new Config(userSettings);
		}
		
		public function Initialize():void
		{
			characterMenu = new CharacterMenu();
			addChild(characterMenu);
			
			characterMenu.AddEventListenerToCharList(Event.SELECT, CharacterSelected);
			characterMenu.AddEventListenerToCharList(RightClickedEvent.RIGHT_CLICKED, SetCharacterLock);
			
			settingsButton = new PushButton(this, 0, 640, "", OpenSettingsWindow);
			settingsButton.setSize(32, 32);
			var settingsIcon:SettingsIcon = new SettingsIcon();
			//settingsIcon.width = settingsIcon.height = 24;
			
			settingsButton.addChild(settingsIcon);
			
			animationMenu = new AnimationMenu(this,550);
			//characterMenu
		}
		
		/* Character Menu*/
		//{
		
		public function ToggleSelectedCharacterLock():void
		{
			var index:int = characterMenu.ToggleLockOnSelected();
			characterManager.ToggleLockOnCharacter(index);
		}
		
		public function SwitchToSelectedCharacter():void
		{
			characterManager.SwitchToCharacter(characterMenu.GetSelectedIndex());
		}
		
		//Positive number moves downward, negative moves upward.
		public function MoveCharacterSelector(indexMove:int):void
		{
			characterMenu.MoveListSelector(indexMove);
		}
		
		public function SetCharacterSelectorAndUpdate(index:int ):void
		{
			if (index < characterManager.GetTotalNumOfCharacters())
			{
				characterMenu.SetListSelectorPosition(index);
				characterManager.SwitchToCharacter(index);
				animationMenu.SetAnimationList(characterManager.GetFrameTargetsForCharacter(index));
			}
		}
		
		public function SetupCharacterLocks():void
		{
			//the get all character locks answers the question "Can I switch to this character?"
			var locks:Vector.<Boolean> = characterManager.GetAllCharacterLocks();
			//The lock list item answers the question "Is this character locked?"
			characterMenu.SetCharacterListLocks(locks);
		}
		
		public function AddIconToCharacterMenu(icon:DisplayObject):void
		{
			characterMenu.AddIconToCharacterList(icon);
		}
		
		//Event handlers
		//{
		/*Handler for when the select event is dispatched from the Character sub menu. Updates the character manager to let it know
		 * the character has changed.*/
		private function CharacterSelected(e:Event):void
		{
			characterManager.SwitchToCharacter(e.target.selectedIndex);
			animationMenu.SetAnimationList(characterManager.GetFrameTargetsForCharacter(e.target.selectedIndex));
			
		}
		
		private function SetCharacterLock(e:Event):void
		{
			//Ran into a bug where right clicking on an item still returned -1. Since it seems to be hard to replicate, just do a check
			//on rightClickedIndex.
			if (e.target.rightClickedIndex == -1) 
			{ 
				return;
			}
			characterManager.ToggleLockOnCharacter(e.target.rightClickedIndex);
			userSettings.ChangeCharacterLock(characterManager.GetCharacterById(e.target.rightClickedIndex).GetName(), 
				characterManager.GetCharacterLockById(e.currentTarget.rightClickedIndex));
		}
		
		public function UpdateFrameForAnimationCounter(frame:int):void
		{
			currentFrameForAnimation = frame;
		}
		
		public function OpenSettingsWindow(e:MouseEvent):void
		{
			addChild(keyConfig);
		}
		//}
		
		//}
		
	}

}