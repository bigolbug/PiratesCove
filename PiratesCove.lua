--Pirates Cove

local clock = os.clock
local store = {}
local go = true

--Functions
function cls(s)
    sleep(s)
    os.execute("cls")
end
function ranum() -- between 0 and 1
    sleep(.1)
    t = clock()
    return ((t/7)*100000 - math.floor((t/7)*100000))
end
function ynchoice()
    c = ""
    while (c ~= "y" and c ~= "n")
    do
   	 c = io.read()
   	 if (c ~= "y" and c ~= "n") then
   		 print("Please enter a y or n")
   	 end
    end
    return c
end
function numchoice()
    c = ""
    while (tonumber(c) == nil) do
   	 c = io.read()
   	 if (tonumber(c) == nil) then
   		 print("Please enter a number")
   	 end
    end
    return c
end
function Tortuga()
    --Tortuga
    genP()
    print("\nWelcome to Tortuga\n")
    print("You have: ".. player.gold .." gold and "..player.HP.." HP and "..player.attack.." attack")
    print(
   	 "\nHere are your options \n\t1. Lumber (+".. store["lumber"][2].." HP): \t\t$"..store["lumber"][1]
   	 .."\n\t2. Food (+"..store["food"][2].." HP): \t\t$"..store["food"][1]
   	 .."\n\t3. Musket (+"..store["musket"][2].." Attack): \t$"..store["musket"][1]
   	 .."\n\t4. Cannon (+"..store["cannon"][2].." Attack): \t$"..store["cannon"][1]
   	 )
    print("\nWould you like to purchase anything? y or n")
    choice = ynchoice()
    while choice == "y" do
   	 purchase()
   	 print("Would you like to purchase anything else? (y or n)")
   	 choice = ynchoice()
    end    
end
function purchase()
    print("Which item would you like?")
    choice = itemchoice()
    print("How many "..choice.." do you want?") -- Maybe add price here?
    qty = numchoice()
    --check to see if they have enough money
    while (qty*store[choice][1] > player.gold) do
   	 print("You do not have enough gold please enter a lower quantity")
   	 qty = numchoice()
    end
    player.gold = player.gold - qty*store[choice][1]
    print ("You now have "..player.gold.." gold remaining")
    upgrade(choice,qty)
    return nil
end
function itemchoice()
    c = ""
    while (not checkstore(c)) do
   	 c = io.read()
   	 if (not checkstore(c)) then
   		 print("Please enter the name of the item")
   	 end
    end
    return string.lower(c)
end
function checkstore(c)
    for k in pairs(store) do
   	 if string.lower(c) == k then
   		 return true
   	 end
    end
    return false
end
function sleep(n) --seconds
  local t0 = clock()
  while clock() - t0 <= n do end
end
function Sail()
    cls(0)
    
    -- Take gold away for every trip out to sea
    -- Check to see if the player had run out of money
    player.gold = player.gold - 5
    if player.gold < 0 then
   	 go = false
   	 return nil
    end
    
    print("Unfirl the win'ets, matey! We'r set'n sail")
    
    sleep(3+5*ranum())
    
    if (ranum()*10 > 3) then
   	 -- found a ship
   	 ship_a = math.floor(player.attack*.5+ranum()*150)-- the ships attack
   	 ship_hp =  math.floor(player.HP*.5+ranum()*200)-- the ships health
   	 gold_b = 50 + math.floor(ranum()*(ship_a+ship_hp)) -- gold from the battle
   	 
   	 print ("You found a ship and it looks like it has ".. ship_a.." attack and ".. ship_hp.." HP")
   	 print ("You have ".. player.attack.." attack and ".. player.HP.." HP")
   	 print ("Would you like to attack? (y or n)")
   	 c = ynchoice()
   	 if "y" == c then
   		 if Battle(ship_a,ship_hp) then
   			 player.gold = player.gold + gold_b
   			 print ("Congradulations, you just acquired  ".. gold_b .." in gold")
   			 sleep(4)
   		 else
   			 go = false
   		 end
   	 else
   		 print ("sturn about, lets get out of here!")
   		 sleep(4)
   	 end
    else
   	 -- did not find ship have to return to port
   	 print("No ship found, heading back to port")
   	 sleep(3)
    end
end
function Battle(s_a,s_hp) -- (ship attack and hp)
    cls(0)
    print("You have engaged in a battle with the ship")
    sleep(1)
    while (player.HP > 0 and s_hp > 0) do
   	 if ranum()>.5 then
   		 --We attack
   		 s_hp = attack(s_hp)
   	 else
   		 --They attack
   		 defend(s_a)
   	 end
   	 sleep(4)
    end
    if player.HP <= 0 then
   	 return false
    else
   	 return true
    end
end
function attack(s_hp)   	 
    hit = math.floor(player.attack*ranum()*.5)
    print("You fire a shot and the ship has sustained ".. hit.. " damage")
    s_hp = s_hp - hit
    print("\tThe ship has "..s_hp.." remaining")
    return s_hp
end
function defend(s_a)
    hit = math.floor(s_a*ranum()*.5)
    print("The ship fired a shot and you sustained ".. hit.. " damage")
    player.HP = player.HP - hit
    print("\tYour ship has "..player.HP.." remaining")
    return nil
end
function genP()
    store = {
   	 food = {math.floor(5+ranum()*15),1,"HP"},
   	 lumber = {math.floor(10+ranum()*100),7,"HP"},
   	 musket = {math.floor(5+ranum()*50),10,"attack"},
   	 cannon = {math.floor(20+ranum()*100),30,"attack"}
    }
end
function upgrade(item,qty)
    player[store[item][3]] = player[store[item][3]] + store[item][2]*qty
end

cls(0)
print("Welcome to Pirates Cove")
cls(3)

--PLAYER
player = {}
print("What be yur name?")
player["name"] = io.read()
print("\n\tWelcome, "..player.name..", to pirates cove.\n\tYour adventure starts at Tortuga...")
player["HP"] = 100
player["attack"] = 50
player["gold"] = 100
cls(5)

while go == true
do
    Tortuga()
   	 cls(0)
    Sail()
   	 cls(0)
end

--The End
cls(0)
print ("Game Over")
cls(5)
print ("\tCredits... \n\n\tWritten by Mark MacLean\n\tDate: Year 2020")
sleep(5)



--[[ This section is the scrap yard. I keep unused code here for future use / reference

print("\n\n     	There are two trade routes we can go to")
    print("     	one is highly trafficed with lots of valuable")
    print("     	cargo. This route is know as the heavry lane")
    print("     	This route is patrolled frequently by the ")
    print("     	Royal navy")
    print("\n     	The other route is less frequented and so ")
    print("     	is not partrolled as much. There is less risk")
    print("     	but less reward. This lane is known as the ")
    print("     	light lane\n\n ")
    
    print("Would you rather go to the heavy route? (Y or N)")
    choice = ynchoice()
    if choice == "y" then
   	 print("Sailing in the Heavy Lane")
   	 sleep(2*ranum())
   	 if ranum() > .3 then
   		 print("Ship on the horizon!")
   	 else
   		 print("No ship found")
   	 end
    else
   	 print("Sailing in the Light lane")
   	 sleep(4*ranum())
   	 if ranum() > .6 then
   		 print("Ship on the horizon!")
   	 else
   		 print("No ship found")
   	 end
   	 
    end

function Attack()
    -- ATTACK
    print("Do you want to attack? (Y or N)")
    attach = io.read()

    if attach == "Y" then
   	 print("A ship! On the horizon")
   	 print("Attack!!")
   	 random_number = ranum()
   	 HP = HP - random_number
   	 if random_number >= 4 then
   		 print("Success!" )
   		 print("You have "..HP.." HP")
   	 else
   		 print("Game Over")
   	 end
    end
end

if item == "lumber" or item == "food" then
   	 
    else
   	 player.attack = player.attack + store[item][2]*qty
    end

--]]
