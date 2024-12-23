import "Turbine";
import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Turbine.Gameplay";

MyPlugin = class(Turbine.UI.Window);

function MyPlugin:Constructor()
    Turbine.UI.Window.Constructor(self);
	-- Initialize counters
    self.QuestsCompleted = 0;
	
    -- Keep menu and checkbox references
    self.menu = nil;
	self.checkBox0 = nil;
	checkBox1 = nil;
	checkBox2 = nil;
	checkBox3 = nil;
	checkBox4 = nil;
	checkBox4 = nil;
	checkBox5 = nil;
	checkBox6 = nil;
	checkBox7 = nil;
	checkBox8 = nil;
	checkBox9 = nil;
	checkBox10 = nil;
	checkBox11 = nil;
	checkBox12 = nil;
	checkBox13 = nil;
	checkBox14 = nil;
	checkBox15 = nil;

    -- Load the saved state upon initialization
    local initialState0 = self:LoadCheckBoxState("CheckBox0");
    local initialState1 = self:LoadCheckBoxState("CheckBox1");
	local initialState2 = self:LoadCheckBoxState("CheckBox2");
	local initialState3 = self:LoadCheckBoxState("CheckBox3");
	local initialState4 = self:LoadCheckBoxState("CheckBox4");
	local initialState5 = self:LoadCheckBoxState("CheckBox5");
	local initialState6 = self:LoadCheckBoxState("CheckBox6");
	local initialState7 = self:LoadCheckBoxState("CheckBox7");
	local initialState8 = self:LoadCheckBoxState("CheckBox8");
	local initialState9 = self:LoadCheckBoxState("CheckBox9");
	local initialState10 = self:LoadCheckBoxState("CheckBox10");
	local initialState11 = self:LoadCheckBoxState("CheckBox11");
	local initialState12 = self:LoadCheckBoxState("CheckBox12");
	local initialState13 = self:LoadCheckBoxState("CheckBox13");
	local initialState14 = self:LoadCheckBoxState("CheckBox14");
	local initialState15 = self:LoadCheckBoxState("CheckBox15");

	    -- Define resetButton here
    self.resetButton = Turbine.UI.Lotro.Button();
    self.resetButton:SetParent(self.menu);
    self.resetButton:SetText("Begin/Reset");
    self.resetButton:SetSize(100, 30);
    self.resetButton:SetPosition(145, 520);
    self.resetButton:SetEnabled(false);  -- Initially disabled
    self.resetButton:SetVisible(true);
	
	self:LoadResetButtonState();

    -- Create the main window
    self:SetSize(3840, 2160);
    self:SetPosition(0, 0);
    self:SetVisible(true);
	self:SetMouseVisible(false);
	
    -- Monitor player level changes
    self.player = Turbine.Gameplay.LocalPlayer:GetInstance();
    self.player.LevelChanged = function(sender, args)
        self:CheckPlayerLevel();
    end

    -- Update the level change handler
    self.player.LevelChanged = function(sender, args)
        local newLevel = self.player:GetLevel();
        self:SavePlayerLevel(newLevel);
    end

    -- Initial check for player level
    self:CheckPlayerLevel();
	
	-- Create a button to open the menu
	local button = Turbine.UI.Lotro.Button();
	button:SetParent(self);
	button:SetText("Survival");
	button:SetSize(100, 30);
	button:SetPosition(75, 40);
	button.Click = function(sender, args)
		self:OpenMenu();
	end

	-- button tooltip control
	local tooltip = Turbine.UI.Window();
	tooltip:SetSize(170, 15);
	tooltip:SetPosition(15, 25);
	tooltip:SetBackColor(Turbine.UI.Color(1, 0, 0, 0)); -- solid black background
	tooltip:SetVisible(false);

	local tooltipLabel = Turbine.UI.Label();
	tooltipLabel:SetParent(tooltip);
	tooltipLabel:SetSize(170, 15);
	tooltipLabel:SetPosition(1, 5);
	tooltipLabel:SetText("F7 to reset position");
	tooltipLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	tooltipLabel:SetForeColor(Turbine.UI.Color.White);
	tooltipLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	tooltipLabel:SetVisible(true);

	-- Show and move tooltip on mouse enter and move
	button.MouseEnter = function(sender, args)
		tooltip:SetVisible(true);
	end

	-- Hide tooltip on mouse leave
	button.MouseLeave = function(sender, args)
		tooltip:SetVisible(false);
	end

	-- Add the tooltip to the menu
	tooltip:SetParent(button);

	
    -- Initialize the menu window
    self.menu = Turbine.UI.Lotro.Window();
    self.menu:SetSize(600, 550);
    self.menu:SetPosition(500, 500);
    self.menu:SetText("Survival Mode");
    self.menu:SetVisible(false);
	self.menu:Activate(); -- Make the menu active and bring it to the front
	self.menu:SetZOrder(1); -- Bring the menu to the front of the z-order
	
	self.questLabel = Turbine.UI.Label();
    self.questLabel:SetParent(self.menu);
    self.questLabel:SetText("Quests Completed: 0");
    self.questLabel:SetSize(280, 20);
    self.questLabel:SetPosition(390, 500);
	
	-- Load data
	self:LoadData();
	
	-- Set the menu position at startup
	local position = LoadMenuPosition();
	if position then
		self.menu:SetPosition(position.x, position.y);
	end
	
		-- Assume `menu` is the movable menu object
	self.menu.PositionChanged = function(sender, args)
		local x, y = self.menu:GetPosition();
		SaveMenuPosition(x, y);
	end
	
	-- Attach click event to the openMenuButton
	button.Click = function(sender, args)
		self.menu:SetVisible(not self.menu:IsVisible());
	end

	-- Make sure the menu window is brought to the front when shown
	self.menu.Closing = function(sender, args)
		self.menu:SetVisible(false);
	end
	
	-- Move resetButton to menu window and set its parent
	self.resetButton:SetParent(self.menu);
	self.resetButton:SetPosition(145, 520);
				
	local closeButton = Turbine.UI.Lotro.Button();
	closeButton:SetParent(self.menu);
	closeButton:SetText("Close");
	closeButton:SetSize(100, 30);
	closeButton:SetPosition(250, 520);

	closeButton.Click = function(sender, args)
		self.menu:SetVisible(false);
	end
	
		-- Label for the word "No"
	self.infoLabelNo = Turbine.UI.Label();
	self.infoLabelNo:SetParent(self.menu);
	self.infoLabelNo:SetSize(50, 30); -- Adjust size for the word "No"
	self.infoLabelNo:SetPosition(500, 520); -- Position right next to the first label
	self.infoLabelNo:SetText("No");
	self.infoLabelNo:SetForeColor(Turbine.UI.Color(0, 1, 0)); -- Green color
	self.infoLabelNo:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	self.infoLabelNo:SetVisible(true);
	
		-- Label for the word "Yes"
	self.infoLabelYes = Turbine.UI.Label();
	self.infoLabelYes:SetParent(self.menu);
	self.infoLabelYes:SetSize(50, 30); -- Adjust size for the word "No"
	self.infoLabelYes:SetPosition(500, 520); -- Position right next to the first label
	self.infoLabelYes:SetText("Yes");
	self.infoLabelYes:SetForeColor(Turbine.UI.Color(1, 0, 0)); -- Red color
	self.infoLabelYes:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	self.infoLabelYes:SetVisible(false);
				
	-- Attach click event to the Reset button
	self.resetButton.Click = function(sender, args)
		self.checkBox0:SetVisible(true);
		self.checkBox0:SetChecked(true);
		self:SaveCheckBoxState(true);
		self:StartMonitoringHP();
		self:TrackQuestsViaChat(); -- Enable quest tracking at level 1
		self:SaveResetButtonState(false); -- Save the state as hidden
		Turbine.PluginData.Save(Turbine.DataScope.Character, "Survival_GameOver", false);
		self.QuestsCompleted = 0; -- Reset the quest counter to 0
		self.questLabel:SetText("Quests Completed: 0"); -- Update the quest label
		self:SaveData(); -- Save the new state
		local currentLevel = self.player:GetLevel(); -- Get the current player level
		self:SavePlayerLevel(currentLevel); -- Save the current player level
		Turbine.Shell.WriteLine("Survival monitoring active. Goodluck!");
		Turbine.Shell.WriteLine("Name and save reset. No need to relog.");
		self.infoLabelYes:SetVisible(false);
		self.infoLabelNo:SetVisible(true);
		self.resetButton:SetEnabled(false);
	end
				
	-- Get player's name
	local playerName = Turbine.Gameplay.LocalPlayer.GetInstance():GetName();
				
	-- Create a label to display the centered title
	local titleLabel = Turbine.UI.Label();
	titleLabel:SetParent(self.menu);
	titleLabel:SetSize(580, 40); -- Adjust size as needed
	titleLabel:SetPosition(10, 10); -- Adjust position as needed
	titleLabel:SetText("\n\nWelcome to Survival LOTRO, " .. playerName .. "!");
	titleLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); -- Center the title text
	titleLabel:SetForeColor(Turbine.UI.Color.White);
	titleLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	titleLabel:SetVisible(true);

	-- Create a label to display the additional text
	local infoLabel = Turbine.UI.Label();
	infoLabel:SetParent(self.menu);
	infoLabel:SetSize(580, 260); -- Adjust size as needed
	infoLabel:SetPosition(10, 60); -- Position below the title
	infoLabel:SetText("In this mode, if your character's HP reaches zero, it's game over.\nBe cautious and enjoy the challenge! Designed in mind to be played level 1-max level without dying. Death is a failure and should result in starting over.");
	infoLabel:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft); -- Left-align the additional text
	infoLabel:SetForeColor(Turbine.UI.Color.White);
	infoLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	infoLabel:SetVisible(true);
				
	-- Create a label to display the additional text
	local infoLabel = Turbine.UI.Label();
	infoLabel:SetParent(self.menu);
	infoLabel:SetSize(580, 260); -- Adjust size as needed
	infoLabel:SetPosition(150, 110); 
	infoLabel:SetText("Choose your own difficulty honor system");
	infoLabel:SetForeColor(Turbine.UI.Color.White);
	infoLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	infoLabel:SetVisible(true);

	-- Create a label to display the additional text
	local infoLabel = Turbine.UI.Label();
	infoLabel:SetParent(self.menu);
	infoLabel:SetSize(100, 100); -- Adjust size as needed
	infoLabel:SetPosition(250, 275); 
	infoLabel:SetText("Things to know");		
	infoLabel:SetForeColor(Turbine.UI.Color.White);
	infoLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	infoLabel:SetVisible(true);
	
	-- Create a label to display the additional text
	local infoLabel = Turbine.UI.Label();
	infoLabel:SetParent(self.menu);
	infoLabel:SetSize(600, 215); -- Adjust size as needed
	infoLabel:SetPosition(10, 300); 
	infoLabel:SetText("This plugin monitors HP. When it reaches 0 it will trigger a game over screen.\n\nThere are known quests that force kill the player as story characters. Unknown if these triggers a game over at this time.\n\nKinship leaders and people playing survival together can decide a ruleset and everyone follows those rules. Solo players not in a survival kinship do your own rules.\n\nIf your button becomes inactive press F7 twice to reset it's location.\n\nThis plugin is about playing with who you want and how you want to play with set restrictions of choice trying to survive to the best of your ability.\n\nAs of right now, checkboxes don't do anything they're just there for assistance. Maybe this can change in the future.");		
	infoLabel:SetForeColor(Turbine.UI.Color.White);
	infoLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	infoLabel:SetVisible(true);
	
	-- Label for the main text
	local infoLabelText = Turbine.UI.Label();
	infoLabelText:SetParent(self.menu);
	infoLabelText:SetSize(200, 30); -- Adjust size as needed
	infoLabelText:SetPosition(400, 520); -- Position the first part of the text
	infoLabelText:SetText("Game over:");
	infoLabelText:SetForeColor(Turbine.UI.Color.White);
	infoLabelText:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	infoLabelText:SetVisible(true);
	
	-- Create the checkbox (initially hidden)
	self.checkBox0 = Turbine.UI.Lotro.CheckBox();
	self.checkBox0:SetParent(self);
	self.checkBox0:SetText("Hp Monitor active");
	self.checkBox0:SetSize(150, 30);
	self.checkBox0:SetPosition(9001, 9001);  -- Adjusted position
	self.checkBox0:SetChecked(false);	
	self.checkBox0:SetVisible(false);  -- Initially hidden
	
		-- Function to start monitoring player's HP
	function MyPlugin:StartMonitoringHP()
		self.player.MoraleChanged = function(sender, args)
			self:CheckHP();
		end
		self:CheckHP();  -- Initial check
	end
	
	-- Function to stop monitoring player's HP
	function MyPlugin:StopMonitoringHP()
		self.player.MoraleChanged = nil; -- Remove the event handler
		self:StartMonitoringHP(false); -- Save the monitoring state as inactive
	end

	-- Attach the CheckedChanged event handler
	self.checkBox0.CheckedChanged = function(sender, args)
		if self.checkBox0:IsChecked() then
			-- Execute logic when checkbox is checked
			Turbine.Shell.WriteLine("Survival monitoring active. Goodluck!");
			self:StartMonitoringHP(); -- Start monitoring HP
			self:TrackQuestsViaChat(); -- Enable quest tracking at level 1
		else
			self:StopMonitoringHP();
		end
		self:SaveCheckBoxState(isChecked); -- Save the checked state
	end
	
	    -- Check for level mismatch
    local lastLevel = self:LoadPlayerLevel()
    local currentLevel = self.player:GetLevel()
	
	-- Check if the player is already in a game-over state
	if self:IsGameOver() then
		self:ShowGameOverScreen();
		self:SaveGameOverState();
		Turbine.Shell.WriteLine("Survival monitoring inactive.");
		self.infoLabelNo:SetVisible(false);
		self.infoLabelYes:SetVisible(true);
		self.checkBox0:SetChecked(false); -- Uncheck checkBox0
		self:SaveCheckBoxState(false); -- Save the state
		self:StopTrackingQuests(); -- Stop tracking quests
	end
	
	-- Function to check player's HP
	function MyPlugin:CheckHP()
		local currentHP = self.player:GetMorale();
		if currentHP <= 0 or (lastLevel and currentLevel ~= lastLevel) then
			self:ShowGameOverScreen();
			self:SaveGameOverState();
			Turbine.Shell.WriteLine("Survival monitoring inactive.");
			self.infoLabelNo:SetVisible(false);
			self.infoLabelYes:SetVisible(true);
			self.checkBox0:SetChecked(false); -- Uncheck checkBox0
			self:SaveCheckBoxState(false); -- Save the state
			self.checkBox0:SetVisible(false); -- Force UI refresh
			self.checkBox0:SetVisible(true); -- Force UI refresh
			self:StopTrackingQuests(); -- Stop tracking quests
		end
	end
	
	function MyPlugin:TrackQuestsViaChat()
		Turbine.Chat.Received = function(sender, args)
			-- Check if the message is from the system
			if args.Type == Turbine.Chat.System then
				self.isSystemMessage = true;
			else
				self.isSystemMessage = false;
			end

			-- Process the message
			self:CheckForQuestCompletion(args.Message);
		end
	end	

	-- Create a checkbox inside the menu
	checkBox1 = Turbine.UI.Lotro.CheckBox();
	checkBox1:SetParent(self.menu);
	checkBox1:SetText("You May Give But Not Take Anything From Other Players");
	checkBox1:SetPosition(15, 130);
	checkBox1:SetSize(200, 50);
	checkBox1:SetMultiline(true); -- Enable text wrapping
	
	checkBox2 = Turbine.UI.Lotro.CheckBox();
	checkBox2:SetParent(self.menu);
	checkBox2:SetText("Hardened Traveller Active");
	checkBox2:SetPosition(15, 165); -- Adjusted position
	checkBox2:SetSize(200, 30); -- Set the width to accommodate the text 
	checkBox2:SetMultiline(true); -- Enable text wrapping
	
	checkBox3 = Turbine.UI.Lotro.CheckBox();
	checkBox3:SetParent(self.menu);
	checkBox3:SetText("No Grouping With People 6+ Levels Higher Than You");
	checkBox3:SetPosition(15, 190); -- Adjusted position
	checkBox3:SetSize(200, 30); -- Set the width to accommodate the text 
	checkBox3:SetMultiline(true); -- Enable text wrapping
	
	checkBox4 = Turbine.UI.Lotro.CheckBox();
	checkBox4:SetParent(self.menu);
	checkBox4:SetText("No Stable Traveling");
	checkBox4:SetPosition(15, 215); -- Adjusted position
	checkBox4:SetSize(200, 30); -- Set the width to accommodate the text 
	checkBox4:SetMultiline(true); -- Enable text wrapping
	
	checkBox5 = Turbine.UI.Lotro.CheckBox();
	checkBox5:SetParent(self.menu);
	checkBox5:SetText("No Experiance Boosts Of Any Kind");
	checkBox5:SetPosition(15, 240); -- Adjusted position
	checkBox5:SetSize(200, 30); -- Set the width to accommodate the text 
	checkBox5:SetMultiline(true); -- Enable text wrapping

	checkBox6 = Turbine.UI.Lotro.CheckBox();
	checkBox6:SetParent(self.menu);
	checkBox6:SetText("No Mailbox");
	checkBox6:SetPosition(250, 140); -- Adjusted position
	checkBox6:SetSize(200, 30); -- Set the width to accommodate the text 
	checkBox6:SetMultiline(true); -- Enable text wrapping

	checkBox7 = Turbine.UI.Lotro.CheckBox();
	checkBox7:SetParent(self.menu);
	checkBox7:SetText("No Hobbit Gift");
	checkBox7:SetPosition(250, 165); -- Adjusted position
	checkBox7:SetSize(200, 30); -- Set the width to accommodate the text 
	checkBox7:SetMultiline(true); -- Enable text wrapping

	checkBox8 = Turbine.UI.Lotro.CheckBox();
	checkBox8:SetParent(self.menu);
	checkBox8:SetText("No VIP Rewards");
	checkBox8:SetPosition(250, 190); -- Adjusted position
	checkBox8:SetSize(200, 30); -- Set the width to accommodate the text 
	checkBox8:SetMultiline(true); -- Enable text wrapping

	checkBox9 = Turbine.UI.Lotro.CheckBox();
	checkBox9:SetParent(self.menu);
	checkBox9:SetText("No LOTRO Store");
	checkBox9:SetPosition(250, 215); -- Adjusted position
	checkBox9:SetSize(200, 30); -- Set the width to accommodate the text 
	checkBox9:SetMultiline(true); -- Enable text wrapping
	
	checkBox10 = Turbine.UI.Lotro.CheckBox();
	checkBox10:SetParent(self.menu);
	checkBox10:SetText("No Auction House");
	checkBox10:SetPosition(250, 240); -- Adjusted position
	checkBox10:SetSize(200, 30); -- Set the width to accommodate the text 
	checkBox10:SetMultiline(true); -- Enable text wrapping

	checkBox11 = Turbine.UI.Lotro.CheckBox();
	checkBox11:SetParent(self.menu);
	checkBox11:SetText("Play On Legendary Server");
	checkBox11:SetPosition(400, 140); -- Adjusted position
	checkBox11:SetSize(200, 30); -- Set the width to accommodate the text 
	checkBox11:SetMultiline(true); -- Enable text wrapping

	checkBox12 = Turbine.UI.Lotro.CheckBox();
	checkBox12:SetParent(self.menu);
	checkBox12:SetText("No Using Professions For 'EXP Only'");
	checkBox12:SetPosition(400, 165); -- Adjusted position
	checkBox12:SetSize(200, 30); -- Set the width to accommodate the text 
	checkBox12:SetMultiline(true); -- Enable text wrapping
	
	checkBox13 = Turbine.UI.Lotro.CheckBox();
	checkBox13:SetParent(self.menu);
	checkBox13:SetText("No Shared Storage");
	checkBox13:SetPosition(400, 190); -- Adjusted position
	checkBox13:SetSize(200, 30); -- Set the width to accommodate the text 
	checkBox13:SetMultiline(true); -- Enable text wrapping

	checkBox14 = Turbine.UI.Lotro.CheckBox();
	checkBox14:SetParent(self.menu);
	checkBox14:SetText("No Intentionally Getting Mob Tagged");
	checkBox14:SetPosition(400, 215); -- Adjusted position
	checkBox14:SetSize(200, 30); -- Set the width to accommodate the text
	checkBox14:SetMultiline(true); -- Enable text wrapping
	
	checkBox15 = Turbine.UI.Lotro.CheckBox();
	checkBox15:SetParent(self.menu);
	checkBox15:SetText("No One Left Behind");
	checkBox15:SetPosition(400, 240); -- Adjusted position
	checkBox15:SetSize(200, 30); -- Set the width to accommodate the text 
	checkBox15:SetMultiline(true); -- Enable text wrapping
	
	-- checkBox1 tooltip control
	local tooltip = Turbine.UI.Window();
	tooltip:SetSize(300, 65);
	tooltip:SetPosition(35, 165);
	tooltip:SetBackColor(Turbine.UI.Color(1, 0, 0, 0)); -- solid black background
	tooltip:SetVisible(false);

	local tooltipLabel = Turbine.UI.Label();
	tooltipLabel:SetParent(tooltip);
	tooltipLabel:SetSize(280, 60);
	tooltipLabel:SetPosition(10, 5);
	tooltipLabel:SetText("Can't give to other players if they're playing survival unless: Survival Kinships and people playing survival together may trade amongst themselves if they wish.");
	tooltipLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	tooltipLabel:SetForeColor(Turbine.UI.Color.White);
	tooltipLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	tooltipLabel:SetVisible(true);

	-- Show and move tooltip on mouse enter and move
	checkBox1.MouseEnter = function(sender, args)
		tooltip:SetVisible(true);
	end

	-- Hide tooltip on mouse leave
	checkBox1.MouseLeave = function(sender, args)
		tooltip:SetVisible(false);
	end

	-- Add the tooltip to the menu
	tooltip:SetParent(self.menu);
	
	-- checkBox3 tooltip control
	local tooltip = Turbine.UI.Window();
	tooltip:SetSize(300, 65);
	tooltip:SetPosition(35, 240);
	tooltip:SetBackColor(Turbine.UI.Color(1, 0, 0, 0)); -- solid black background
	tooltip:SetVisible(false);

	local tooltipLabel = Turbine.UI.Label();
	tooltipLabel:SetParent(tooltip);
	tooltipLabel:SetSize(280, 60);
	tooltipLabel:SetPosition(10, 5);
	tooltipLabel:SetText("You can group with anyone within 5 levels, whether playing survival or not. If they start to die, do anything it takes to survive.");
	tooltipLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	tooltipLabel:SetForeColor(Turbine.UI.Color.White);
	tooltipLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	tooltipLabel:SetVisible(true);

	-- Show and move tooltip on mouse enter and move
	checkBox3.MouseEnter = function(sender, args)
		tooltip:SetVisible(true);
	end

	-- Hide tooltip on mouse leave
	checkBox3.MouseLeave = function(sender, args)
		tooltip:SetVisible(false);
	end

	-- Add the tooltip to the menu
	tooltip:SetParent(self.menu);

	-- checkbox4 tooltip control
	local tooltip = Turbine.UI.Window();
	tooltip:SetSize(300, 50);
	tooltip:SetPosition(35, 240);
	tooltip:SetBackColor(Turbine.UI.Color(1, 0, 0, 0)); -- solid black background
	tooltip:SetVisible(false);

	local tooltipLabel = Turbine.UI.Label();
	tooltipLabel:SetParent(tooltip);
	tooltipLabel:SetSize(280, 40);
	tooltipLabel:SetPosition(10, 5);
	tooltipLabel:SetText("This mostly refers to swift and mithril travel. Basic travel is up to you.");
	tooltipLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	tooltipLabel:SetForeColor(Turbine.UI.Color.White);
	tooltipLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	tooltipLabel:SetVisible(true);

	-- Show and move tooltip on mouse enter and move
	checkBox4.MouseEnter = function(sender, args)
		tooltip:SetVisible(true);
	end

	-- Hide tooltip on mouse leave
	checkBox4.MouseLeave = function(sender, args)
		tooltip:SetVisible(false);
	end

	-- Add the tooltip to the menu
	tooltip:SetParent(self.menu);
	
	-- checkBox9 tooltip control
	local tooltip = Turbine.UI.Window();
	tooltip:SetSize(300, 50);
	tooltip:SetPosition(270, 240);
	tooltip:SetBackColor(Turbine.UI.Color(1, 0, 0, 0)); -- solid black background
	tooltip:SetVisible(false);

	local tooltipLabel = Turbine.UI.Label();
	tooltipLabel:SetParent(tooltip);
	tooltipLabel:SetSize(280, 40);
	tooltipLabel:SetPosition(10, 5);
	tooltipLabel:SetText("Expansions, Quest Packs, Basic Riding Skill(95 points) and cosmetics are okay.");
	tooltipLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	tooltipLabel:SetForeColor(Turbine.UI.Color.White);
	tooltipLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	tooltipLabel:SetVisible(true);

	-- Show and move tooltip on mouse enter and move
	checkBox9.MouseEnter = function(sender, args)
		tooltip:SetVisible(true);
	end

	-- Hide tooltip on mouse leave
	checkBox9.MouseLeave = function(sender, args)
		tooltip:SetVisible(false);
	end

	-- Add the tooltip to the menu
	tooltip:SetParent(self.menu);
	
	-- checkBox12 tooltip control
	local tooltip = Turbine.UI.Window();
	tooltip:SetSize(300, 65);
	tooltip:SetPosition(425, 190);
	tooltip:SetBackColor(Turbine.UI.Color(1, 0, 0, 0)); -- solid black background
	tooltip:SetVisible(false);

	local tooltipLabel = Turbine.UI.Label();
	tooltipLabel:SetParent(tooltip);
	tooltipLabel:SetSize(280, 60);
	tooltipLabel:SetPosition(10, 5);
	tooltipLabel:SetText("Once your profession is maxed out, you can use it as normal, but not for EXP.");
	tooltipLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	tooltipLabel:SetForeColor(Turbine.UI.Color.White);
	tooltipLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	tooltipLabel:SetVisible(true);

	-- Show and move tooltip on mouse enter and move
	checkBox12.MouseEnter = function(sender, args)
		tooltip:SetVisible(true);
	end

	-- Hide tooltip on mouse leave
	checkBox12.MouseLeave = function(sender, args)
		tooltip:SetVisible(false);
	end

	-- Add the tooltip to the menu
	tooltip:SetParent(self.menu);

	-- checkBox14 tooltip control
	local tooltip = Turbine.UI.Window();
	tooltip:SetSize(300, 50);
	tooltip:SetPosition(420, 240);
	tooltip:SetBackColor(Turbine.UI.Color(1, 0, 0, 0)); -- solid black background
	tooltip:SetVisible(false);

	local tooltipLabel = Turbine.UI.Label();
	tooltipLabel:SetParent(tooltip);
	tooltipLabel:SetSize(280, 40);
	tooltipLabel:SetPosition(10, 5);
	tooltipLabel:SetText("Avoid intentionally tagging mobs for help from high-level players.");
	tooltipLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	tooltipLabel:SetForeColor(Turbine.UI.Color.White);
	tooltipLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	tooltipLabel:SetVisible(true);

	-- Show and move tooltip on mouse enter and move
	checkBox14.MouseEnter = function(sender, args)
		tooltip:SetVisible(true);
	end

	-- Hide tooltip on mouse leave
	checkBox14.MouseLeave = function(sender, args)
		tooltip:SetVisible(false);
	end

	-- Add the tooltip to the menu
	tooltip:SetParent(self.menu);

	-- checkbox15 tooltip control
	local tooltip = Turbine.UI.Window();
	tooltip:SetSize(300, 50);
	tooltip:SetPosition(420, 270);
	tooltip:SetBackColor(Turbine.UI.Color(1, 0, 0, 0)); -- solid black background
	tooltip:SetVisible(false);

	local tooltipLabel = Turbine.UI.Label();
	tooltipLabel:SetParent(tooltip);
	tooltipLabel:SetSize(280, 40);
	tooltipLabel:SetPosition(10, 5);
	tooltipLabel:SetText("If one person dies in your survival based followship(all party members are playing survival) you all die.");
	tooltipLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	tooltipLabel:SetForeColor(Turbine.UI.Color.White);
	tooltipLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	tooltipLabel:SetVisible(true);

	-- Show and move tooltip on mouse enter and move
	checkBox15.MouseEnter = function(sender, args)
		tooltip:SetVisible(true);
	end

	-- Hide tooltip on mouse leave
	checkBox15.MouseLeave = function(sender, args)
		tooltip:SetVisible(false);
	end

	-- Add the tooltip to the menu
	tooltip:SetParent(self.menu);
	
	-- Load the saved state
	self.checkBox0:SetChecked(initialState0);

	-- Save the state when the checkbox is checked or unchecked
	self.checkBox0.CheckedChanged = function(sender, args)
		local newState0 = self.checkBox0:IsChecked();
		self:SaveCheckBoxState("CheckBox0", newState0);
	end

	-- Load the saved state
	checkBox1:SetChecked(initialState1);

	-- Save the state when the checkbox is checked or unchecked
	checkBox1.CheckedChanged = function(sender, args)
		local newState1 = checkBox1:IsChecked();
		self:SaveCheckBoxState("CheckBox1", newState1);
	end
	
	-- Load the saved state
	checkBox2:SetChecked(initialState2);

	-- Save the state when the checkbox is checked or unchecked
	checkBox2.CheckedChanged = function(sender, args)
		local newState2 = checkBox2:IsChecked();
		self:SaveCheckBoxState("CheckBox2", newState2);
	end
	
	-- Load the saved state
	checkBox3:SetChecked(initialState3);

	-- Save the state when the checkbox is checked or unchecked
	checkBox3.CheckedChanged = function(sender, args)
		local newState3 = checkBox3:IsChecked();
		self:SaveCheckBoxState("CheckBox3", newState3);
	end
	
	-- Load the saved state
	checkBox4:SetChecked(initialState4);

	-- Save the state when the checkbox is checked or unchecked
	checkBox4.CheckedChanged = function(sender, args)
		local newState4 = checkBox4:IsChecked();
		self:SaveCheckBoxState("CheckBox4", newState4);
	end
	
	-- Load the saved state
	checkBox5:SetChecked(initialState5);

	-- Save the state when the checkbox is checked or unchecked
	checkBox5.CheckedChanged = function(sender, args)
		local newState5 = checkBox5:IsChecked();
		self:SaveCheckBoxState("CheckBox5", newState5);
	end
	
	-- Load the saved state
	checkBox6:SetChecked(initialState6);

	-- Save the state when the checkbox is checked or unchecked
	checkBox6.CheckedChanged = function(sender, args)
		local newState6 = checkBox6:IsChecked();
		self:SaveCheckBoxState("CheckBox6", newState6);
	end
	
	-- Load the saved state
	checkBox7:SetChecked(initialState7);

	-- Save the state when the checkbox is checked or unchecked
	checkBox7.CheckedChanged = function(sender, args)
		local newState7 = checkBox7:IsChecked();
		self:SaveCheckBoxState("CheckBox7", newState7);
	end
	
	-- Load the saved state
	checkBox8:SetChecked(initialState8);

	-- Save the state when the checkbox is checked or unchecked
	checkBox8.CheckedChanged = function(sender, args)
		local newState8 = checkBox8:IsChecked();
		self:SaveCheckBoxState("CheckBox8", newState8);
	end
	
	-- Load the saved state
	checkBox9:SetChecked(initialState9);

	-- Save the state when the checkbox is checked or unchecked
	checkBox9.CheckedChanged = function(sender, args)
		local newState9 = checkBox9:IsChecked();
		self:SaveCheckBoxState("CheckBox9", newState9);
	end
	
	-- Load the saved state
	checkBox10:SetChecked(initialState10);

	-- Save the state when the checkbox is checked or unchecked
	checkBox10.CheckedChanged = function(sender, args)
		local newState10 = checkBox10:IsChecked();
		self:SaveCheckBoxState("CheckBox10", newState10);
	end
	
	-- Load the saved state
	checkBox11:SetChecked(initialState11);

	-- Save the state when the checkbox is checked or unchecked
	checkBox11.CheckedChanged = function(sender, args)
		local newState11 = checkBox11:IsChecked();
		self:SaveCheckBoxState("CheckBox11", newState11);
	end
	
	-- Load the saved state
	checkBox12:SetChecked(initialState12);

	-- Save the state when the checkbox is checked or unchecked
	checkBox12.CheckedChanged = function(sender, args)
		local newState12 = checkBox12:IsChecked();
		self:SaveCheckBoxState("CheckBox12", newState12);
	end
	
	-- Load the saved state
	checkBox13:SetChecked(initialState13);

	-- Save the state when the checkbox is checked or unchecked
	checkBox13.CheckedChanged = function(sender, args)
		local newState13 = checkBox13:IsChecked();
		self:SaveCheckBoxState("CheckBox13", newState13);
	end
	
	-- Load the saved state
	checkBox14:SetChecked(initialState14);

	-- Save the state when the checkbox is checked or unchecked
	checkBox14.CheckedChanged = function(sender, args)
		local newState14 = checkBox14:IsChecked();
		self:SaveCheckBoxState("CheckBox14", newState14);
	end
	
	-- Load the saved state
	checkBox15:SetChecked(initialState15);

	-- Save the state when the checkbox is checked or unchecked
	checkBox15.CheckedChanged = function(sender, args)
		local newState15 = checkBox15:IsChecked();
		self:SaveCheckBoxState("CheckBox15", newState15);
	end
	
	    -- Load the saved position
    local buttonX, buttonY = self:LoadPosition();
    buttonX = (buttonX and buttonX >= 0 and buttonX <= 3840 - button:GetWidth()) and buttonX or 400; -- Ensure buttonX is within screen bounds
    buttonY = (buttonY and buttonY >= 0 and buttonY <= 2160 - button:GetHeight()) and buttonY or 300; -- Ensure buttonY is within screen bounds
    button:SetPosition(buttonX, buttonY);
    button:SetVisible(true); -- Ensure button is visible


    local dragging = false;
    local dragStartX, dragStartY;
    local buttonStartX, buttonStartY;

    local menu = nil; -- Variable to track the menu window

    button.MouseDown = function(sender, args)
        dragging = true;
        local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
        dragStartX = mouseX - button:GetLeft();
        dragStartY = mouseY - button:GetTop();
        buttonStartX, buttonStartY = button:GetPosition();
        self:SetWantsUpdates(true);  -- Enable updates for smooth dragging
    end

    button.MouseUp = function(sender, args)
        dragging = false;
        self:SetWantsUpdates(false);  -- Disable updates when not dragging
        -- Save the new position when dragging stops
        local newX = button:GetLeft();
        local newY = button:GetTop();
        self:SavePosition(newX, newY);
    end

    button.MouseMove = function(sender, args)
        if dragging then
            local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
            local newX = mouseX - dragStartX;
            local newY = mouseY - dragStartY;
            -- Clamp position to screen bounds (including top and left)
            newX = math.max(0, newX);
            newY = math.max(0, newY);
            newX = math.min(newX, 3840 - button:GetWidth());
            newY = math.min(newY, 2160 - button:GetHeight());
            button:SetPosition(newX, newY);
        end
    end

    self.Update = function(sender, args)
        if dragging then
            local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
            local newX = mouseX - dragStartX;
            local newY = mouseY - dragStartY;
            -- Clamp position to screen bounds (including top and left)
            newX = math.max(0, newX);
            newY = math.max(0, newY);
            newX = math.min(newX, 3840 - button:GetWidth());
            newY = math.min(newY, 2160 - button:GetHeight());
            button:SetPosition(newX, newY);
        end
    end
	
    -- Add a key event to reset the button position
    self:SetWantsKeyEvents(true);
    self.KeyDown = function(sender, args)
        if args.Action == 268435637 then -- Correctly identifying the "F7" key using the Turbine.UI.Lotro.Key enumeration
            button:SetPosition(400, 300); -- Reset to the default position
            self:SavePosition(400, 300); -- Save the reset position
            button:SetVisible(true); -- Ensure button is visible
        end
    end
end

function MyPlugin:SavePlayerLevel(level)
    Turbine.PluginData.Save(Turbine.DataScope.Character, "PlayerLevel", level);
end

function MyPlugin:LoadPlayerLevel()
    return Turbine.PluginData.Load(Turbine.DataScope.Character, "PlayerLevel");
end



function MyPlugin:CheckForQuestCompletion(message)
    -- Ensure the message comes from the system (not /say, /tell, etc.)
    if not self.isSystemMessage then
        return;
    end

    -- Patterns for quest completion
    local questPattern = "quest completion";

    -- Match money message
    if string.match(message, questPattern) then
        self.QuestsCompleted = self.QuestsCompleted + 1;
        self.questLabel:SetText("Quests Completed: " .. self.QuestsCompleted);
        Turbine.Shell.WriteLine("Quest Completed! Total Quests: " .. self.QuestsCompleted);
		self:SaveData();
    end
end

function MyPlugin:SaveData()
    local data = { QuestsCompleted = self.QuestsCompleted };
    Turbine.PluginData.Save(Turbine.DataScope.Character, "QuestsCompleted", data);
end

function MyPlugin:LoadData()
    local data = Turbine.PluginData.Load(Turbine.DataScope.Character, "QuestsCompleted");
    if data then
        self.QuestsCompleted = data.QuestsCompleted or 0;
    else
        self.QuestsCompleted = 0;
    end
    self.questLabel:SetText("Quests Completed: " .. self.QuestsCompleted);
end

-- Additional function to stop quest tracking
function MyPlugin:StopTrackingQuests()
	Turbine.Chat.Received = nil; -- Remove the event handler for chat messages
end	

-- Function to check the player's level
function MyPlugin:CheckPlayerLevel()
    local playerLevel = self.player:GetLevel();
    if playerLevel == 1 then
        self.resetButton:SetEnabled(true);
    else
        self.resetButton:SetEnabled(false);
    end
end

function MyPlugin:SaveResetButtonState(isVisible)
    Turbine.PluginData.Save(Turbine.DataScope.Character, "ResetButtonState", isVisible);
end

function MyPlugin:LoadResetButtonState()
    Turbine.PluginData.Load(Turbine.DataScope.Character, "ResetButtonState", function(data)
        if data ~= nil then
            self.resetButton:SetEnabled(data);
        else
            self.resetButton:SetEnabled(true); -- Default to visible
        end
    end);
end

-- Function to save checkbox state
function MyPlugin:SaveCheckBoxState(key, state)
    local success, err = pcall(function()
        Turbine.PluginData.Save(Turbine.DataScope.Character, key, state);
    end)
end

-- Function to load checkbox state
function MyPlugin:LoadCheckBoxState(key)
    local success, result = pcall(function()
        return Turbine.PluginData.Load(Turbine.DataScope.Character, key);
    end)
    if success then
        return result ~= nil and result or false; -- Default to unchecked if no saved data
    else
        return false; -- Default to unchecked
    end
end

-- Function to save the menu position
function SaveMenuPosition(x, y)
    -- Save position to persistent storage
    Turbine.PluginData.Save(Turbine.DataScope.Character, "MenuPosition", {x = x, y = y});
end

-- Function to load the menu position
function LoadMenuPosition()
    local position = Turbine.PluginData.Load(Turbine.DataScope.Character, "MenuPosition");
    return position;
end


function MyPlugin:SavePosition(x, y)
    Turbine.PluginData.Save(Turbine.DataScope.Character, "Survival_ButtonPosition", { x = x, y = y });
end

function MyPlugin:LoadPosition()
    local position = Turbine.PluginData.Load(Turbine.DataScope.Character, "Survival_ButtonPosition");
    if position then
        return position.x, position.y;
    else
        return nil, nil;
    end
end

-- Function to save the game-over state
function MyPlugin:SaveGameOverState()
    Turbine.PluginData.Save(Turbine.DataScope.Character, "Survival_GameOver", true);
end

-- Function to check if the game-over state is set
function MyPlugin:IsGameOver()
    local state = Turbine.PluginData.Load(Turbine.DataScope.Character, "Survival_GameOver");
    if state == true then
        self.checkBox0:SetChecked(false); -- Uncheck checkBox0
        self:SaveCheckBoxState("CheckBox0", false); -- Save the state
        self.checkBox0:SetVisible(false); -- Force UI refresh
        self.checkBox0:SetVisible(true); -- Force UI refresh
		self:StopTrackingQuests(); -- Stop tracking quests
    end
    return state == true;
end

-- Function to display the game-over screen
function MyPlugin:ShowGameOverScreen()  
    -- Create a full-screen semi-transparent overlay
    local overlay = Turbine.UI.Window();
    overlay:SetSize(3840, 2160);
    overlay:SetPosition(0, 0);
    overlay:SetBackColor(Turbine.UI.Color(0.5, 0, 0, 0)); -- Semi-transparent black
    overlay:SetVisible(true);
    overlay:SetZOrder(100); -- Ensure it appears on top

    -- Create the game-over message
    local gameOverLabel = Turbine.UI.Label();
    gameOverLabel:SetParent(overlay);
    gameOverLabel:SetSize(1920, 200);
    gameOverLabel:SetPosition(0, (1080 - 200) / 2); -- Center vertically
    gameOverLabel:SetText("Game Over");
    gameOverLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    gameOverLabel:SetForeColor(Turbine.UI.Color(1, 0, 0)); -- Red color
    gameOverLabel:SetFont(Turbine.UI.Lotro.Font.TrajanProBold36);

    -- Add a "Try again" button
    local closeButton = Turbine.UI.Lotro.Button();
    closeButton:SetParent(overlay);
    closeButton:SetText("Try again");
    closeButton:SetSize(150, 40);
    closeButton:SetPosition((1920 - 150) / 2, (1080 - 200) / 2 + 220); -- Position below the text
    closeButton.Click = function(sender, args)
        overlay:SetVisible(false); -- Hide the overlay
        overlay = nil; -- Allow it to be garbage-collected
    end
end

myPlugin = MyPlugin();