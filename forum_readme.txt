Type: Mod
Name: Sisyphean Deliveries
Summary: Launch an ever-growing tribute of items into space for eternity.
License: MIT
Source: tbc
Download: https://mods.factorio.com/mod/sisyphean_deliveries
Version: 0.1.2
Release: 2018-06-17
Tested-With-Factorio-Version: 0.16.51
Category: General
Website: https://forums.factorio.com/viewtopic.php?f=190&t=60109


[h]Description[/h]
Sisyphus was punished by the ancient Greek gods to carry out a laborious and futile task for eternity. You and your factory are being tested to avoid the same fate. Sisyphean Deliveries requires your factory to launch an ever-growing tribute of items into space for eternity. Will you test your factory with mass rocket production or demand impossible item production from your Make Everything.

After the first rocket is launched the mod will generate a tribute demand, a list of item(s) that must be launched into space on one or more rockets. Each item type requires a full stack and is randomly generated (configurable). The tribute size is configurable and can grow as more tribute demands are completed. Rocket cargo size is configurable via the mod and the mod includes full circuit integration to automate the requesting, loading and launching of items and rockets if desired.
Included are several optional visually displayed target timers and a tribute quantity target that will alert on all players screens.
The mod is designed for multiplayer megabase games.
Via the configuration options you can have the mod test you and your base in different ways:
[list]
	[*]Be a mass rocket launcher with a single random item within each, an alternative to SpaceX or infinite research. An example of this gameplay style is ColonelWill's Sisyphean Deliveries series: https://www.twitch.tv/colonelwill/videos/all
	[*]Demanded to produce 100 random item stacks per rocket, to really give your item production system (ME - Make Everything) a complete test.
	[*]Anywhere in between the above 2 extremes. See the complete Configuration Options below.
[/list]
[attachment=0]compound picture.png[/attachment]


[h]Configuration Option[/h]
Options marked as (StartUp) are applied at the start of a game, but their current value is saved for the duration of the game. If the current value needs to be modified during a game an API command will be available.
All other settings are checked at usage, ie: when a new demand is created or the GUI updates.
[list]
 [*][i]Tribute Demand Growth Rate: >= 0[/i]   ---   The number of tribute demands that must be completed for the tribute size to increase. If set to 0 the tribute size shall start at the Tribute Maximum Size, otherwise, it starts at 1 item per tribute demand.
 [*][i]Tribute Demand Growth Size: > 0[/i]   ---   The number of items the tribute demand grows by on each size increase (Tribute Growth Rate). Will stop growing when it reaches the Tribute Maximum Size.
 [*][i]Tribute Demand Maximum Size: 1-100 [/i]  ---   The maximum number of items that a tribute demand can grow to.
 [*][i]Prevent Duplicate Demand Items: on/off[/i]   ---   Prevent duplicate items from being in the same demand. The setting is ignored if the current tribute demand size is greater than the allowed item types list.
 [*][i]Tribute Freedom Target (StartUp): >= 0[/i]   ---   The starting target number of tribute demands required for freedom and to complete the Sisyphean task. If set to 0 then freedom cannot be obtained. This does not "complete" the game to avoid issues.
 [*][i]Tribute Delivery Target (Minutes): >= 0 [/i]  ---   A visual timer in minutes for meeting each tribute demand (60 ticks per second). 0 disables
 [*][i]Initial Rocket Target (Minutes): >= 0 [/i]  ---   A visual timer in minutes for launching the first rocket to start tribute demands from game start (60 ticks per second). 0 disables
 [*][i]Rocket Cargo Size (StartUp): 1-100[/i]   ---   The number of cargo slots a rocket has.
 [*][i]Tribute Demand Item Types[/i]   ---   A list of types of items that can each be enabled/disabled for inclusion in the random demand item selection process.[/list]


[h]API Commands[/h]
API commands to manipulate startup settings and to do ad-hock mod actions, ie: restart the tribute demands after the Tribute Freedom Target is reached.
[spoiler=API Commands]All API Commands will modify the mod's Configuration Options of the current game and will be saved for the remainder of this game. The command will confirm in all player chat what action has been taken.
[list]
	[*][i]sisyphean_target_set NUMBER[/i]   ---   Set the current game Tribute Freedom Target to the specified whole number (integer).
	[*][i]sisyphean_target_change NUMBER[/i]   ---    Change the current game Tribute Freedom Target by the specified whole number (integer), can be a positive or negative number.
	[*][i]sisyphean_regenerate_demand[/i]   ---   Regenerate the current tribute demand. Does not increment tribute count or completed tributes count.
	[*][i]sisyphean_complete_tribute[/i]   ----   Completes the current tribute demand as if it had been provided via rocket.
	[*][i]sisyphean_start[/i]   ---   Starts the tribute demand process. The command is used to start prior to the first satellite launch or restart after the Tribute Freedom Target has been reached and you wish to continue. If continuing you must increase the Tribute Freedom Target first. This command does not affect the completed tributes count.
[/list]

[u]Debug API Commands[/u]
Certain debug commands are included for testing, cheating, etc.
[list]
	[*][i]sisyphean_debug_get_global[/i]   ---  Gets the mods global object (mod save data) and writes it out to file in Factorio's Script Output folder. Used for debugging and support cases.
[/list]
[/spoiler]


[h]Circuit Network Integration[/h]
[spoiler=Circuit Network Integration Details]A number of circuit network connectible entities have been added to support the automation of demanded item loading and rocket launch. At a simple level, all circuitry should be usable in any fashion and recover from any mishaps (early launches) automatically.
		Detailed information on each entity:
		[list]
			[*][i]Rocket Silo Controller[/i] can be placed next to a silo and will be paired to that silo until either is removed. Each rocket silo and rocket silo controller can only support 1 pairing of this type. If it is in the enabled circuit logic state the rocket will be launched if possible.
			[*][i]Rocket Load Receiver[/i] is intended to automate rocket loading with required items. Each rocket load receiver can be placed next to a silo and will be paired with the silo until either is removed. Each rocket silo and rocket load receiver can only support 1 pairing of this type. The rocket load receiver will output the following information signals:
			[list] 
				[*][i]Preparing Rocket[/i] signal when the rocket is being prepared and is not available for loading or launching. In effect the idle state of the Rocket Load Receiver.
				[*][i]Rocket Ready To Load[/i] signal when the rocket is built and can be loaded. This signal is not present when the Rocket Ready To Launch signal is active.
				[*][i]Rocket Ready To Launch[/i] signal when all demanded items are loaded or the rocket is full. A full rocket can be either all slots are at capacity or there are no free slots for the extra demanded items and used slots are either full or at demand level. When there are multiple silos and there are no more items to be reserved (see below) the current rocket is deemed as full.
				[*]When there is a Rocket Ready To Load signal being output the load receiver will reserve and output a single outstanding demanded item and stack size from the current demand to the circuit network, i.e. "Iron Plate" with a value of 100. It will also output a Demand Stack Size signal of the outstanding items for use with filter inserter stack size circuitry. The outstanding items do not include item stacks reserved by other rocket loading controllers and so multiple rocket silos each with their own rocket load receiver can be used without risk of duplicating or splitting item stacks across silos. Once the reserved demanded item is supplied to the rocket, the rockets state shall be re-assessed and if it is still in Rocket Ready To Load a new demanded item will be reserved and broadcast to the circuit network (for when a rocket has multiple inventory slots).
			[/list]
			[*][i]Tribute Demand Receiver[/i] is intended to pass the outstanding demanded items into a circuit network. The receiver will output signals of the demanded items still to be received as tribute. Multiple Receivers can be used and each will output the same real-time information. The tribute demand receiver will also output general tribute information via signals:
			[list]
				[*][i]Demand Target Time Remaining[/i] signal will have a value of how many seconds are left until the current target timer is up. Intended usage is for the creation of audible alarms or for waiting to launch rockets close to the deadline. Remaining seconds value will be either Tribute Delivery Target or Initial Rocket Target if enabled and appropriate, otherwise the signal won't be present.		
			[/list]
		[/list]
		
		Some additional signals have been added to support more advanced and clear circuit logic. They have are free to use for any purpose, although examples are included.
		[list]
			[*][i]Launch Rocket[/i] signal is added by the mod for optional use. Envisaged for use with the Rocket Silo Controller to help make signals clearer when using multiple silos and decider combinators to synchronise rocket launches.
		[/list]
		
		General Notes: 
		[list]
			[*]Care should be taken with inserter stack sizes to avoid the inserter still holding items after a rocket launch and polluting the next rocket with unwanted items. The simplest way to handle this is to have a single filter inserter have its item and stack size set by the Rocket Load Receiver. 
			[*]Factorio's default rocket silo auto-launch feature cannot be used as it will trigger after just 1 item is loaded.
			[*]If multiple silos and rocket load controls are in use they will try and load and launch the rockets as fast as possible. Should you have a rocket inventory size greater than 1 this may lead to wasted inventory space on the later rockets in a demand. More advanced circuit logic could be used to avoid this if desired using the rocket state signals from the rocket load receiver.
			[*]Each rocket silo can only be paired with 1 rocket load receiver and 1 rocket silo controller. Should a neighbouring rocket silo, controller or receiver already be paired then the newly placed entity will not pair with anything. Leaving a tile space between clusters of a silo and their controllers/receivers is advised to avoid any unexpected results when blueprinting or replacing.
			[*]If using multiple silos with rocket load receivers and you launch a partial stack, the partially tributed item will become available for another silo to complete as normal. After each launch the rocket load controllers return to a neutral state and begin the demanded item reserving process again, getting the demand completed as quickly as possible.
		[/list]
[/spoiler]


[h]FAQ[/h]
[spoiler=End of Game]If targets are set the mod does not end the game in either case of the tribute freedom target being reached or if the initial rocket launch/tribute target time is not met. The mod GUI will show the status result and a message will be shown, but it will not interfere in your game.[/spoiler]
[spoiler=Rocket Launching]Don't use the Auto Launch feature on the Rocket Silo as it will launch after the first item is loaded and not wait until a full stack. This is how Factorio works. Manually launch the rockets until the circuit integration is added.[/spoiler]
[spoiler=Items Demanded]Certain items will never be demanded in tribute regardless of item category mod settings. These items are excluded either to allow inserter loading of the rocket or as they aren't deemed to have value by the gods. The items never demanded are: [list][*]Satellite[*]Rocket Control Unit[*]Rocket Fuel[*]Low Density Structure[*]Used Up Uranium Fuel Cell[*]Blueprint[*]Blueprint Book[*]Deconstruction Planner[/list][/spoiler]
[spoiler=Targets and Visual Alerts]If targets are enabled these will display under the mod's togglable in-game screen. The timers will highlight orange and then red when the timer is within approximately 20% and 10% of the target and alert (open) once on all players screens at each colour change.[/spoiler]


[h]Development[/h]
[spoiler=Version History]
[u]0.1.2 (2018-06-17 - 0.16.51):[/u]
[list]
	[*]Fixed - A large UPS spike occurred when tribute demand items were received in Multiplayer games with many players. The GUI now only updates connected players and when players rejoin they will have their GUI updated immediately to catch up.
	[*]Fixed - Typo in Iron Axe demanded item.
[/list]
[u]0.1.1 (2018-06-05 - 0.16.47):[/u]
[list]
	[*]Fixed - Now handles situation in order reserved validity check if an order's reserving rocket load receiver no longer had a silo, but the order was still reserved (the rocket load controller had released its known reserved order item).
	[*]Fixed - Signal name to translations corrected
	[*]Improved - Rocket Load Receiver will output a Preparing Rocket signal when the rocket is being prepared and is not available for loading or launching.
	[*]Improved - All signals have initial graphics rather than placeholders.
[/list]
[u]0.1.0 (2018-06-03 - 0.16.47):[/u]
[list]
	[*]New Feature - Circuit Network Integration added. Includes the Rocket Silo Controller, Rocket Load Receiver and Tribute Demand Receiver. Rocket Load Receiver outputs the signals: Rocket Ready To Load, Rocket Ready To Launch, the reserved item type from current demand, the reserved item stack size from current demand. Tribute Demand Receiver outputs the signals: Demand Target Time Remaining, items to be received via rocket in total.
	[*]Fixed - Repair Packs, Iron Axe and Steel Axe added to requested items list.
	[*]Fixed - When tribute target is changed via API the item total will increase at the same time, rather than on next rocket launch.
[/list]
[u]0.0.7 (2018-05-25 - 0.16.45):[/u]
[list]
	[*]Fixed - Nuclear fuel as a tribute demand item was under Standard Factory Buildings list and not Uranium.
	[*]Fixed - Mod setting text for tribute demand item list "Standard Factory Buildings" clarified to be "Standard Factory Buildings & Intermediate Products".
	[*]Fixed - sisyphean_complete_tribute API command marks each demanded item as completed in addition to the tribute demand as a whole.
	[*]Fixed - When "Prevent Duplicate Demand Items" is enabled if there are fewer items in the allowed item list than the current tribute demand size the option is ignored for the items above the allowed item list size. In this scenario, it ensures a full-sized tribute demand is made and that at least one of every item is included before the duplicates are allowed in. 
	[*]Improved - Don't include Rocket Part components or satellites in demands as they can't be loaded by inserters into the rocket.
	[*]Improved - Add localised help string to the API commands for use with "/h COMMAND". Also simplified API command descriptions and documentation.
	[*]Improved - update status messages to be more self-descriptive and rely less on hover text. avoid repeated explanations for streamers.
	[*]Improved - Science packs can be included in the demand list via a mod option, the default is on.
	[*]Improved - Added percentage of tributes made, total tributed and projected items with the percentage into the Tributes Made counter GUI section.
	[*]Improved - Added mod global set commands to support debugging issues if required.
	[*]Code - reworked win/lost and new demand logic to avoid rare cases the mod got in an undesirable state when continued after a win/lost condition.
	[*]Code - Change timer function to return a flag saying positive or negative and just prefix a "-" if minus, rather than manipulate the time section values. Keeps all aw time values positive for simpler use.
	[*]Code - migration process changed to behave better cross multiple version changes.
[/list]
[u]0.0.6 (2018-05-17 - 0.16.43):[/u]
[list]
	[*]Fixed - when there are duplicated items if the stack is oversupplied across multiple rockets all later instances of that item are incorrectly completed. 2 stacks demanded and supplied as 1/2 stack, followed by 1 stack. On the second rocket launch, both demands for stack 1 and 2 are completed.
	[*]Fixed - GUI not scrolling when over 50 item demand size and resolved the GUI recreating more than needed, causing it to scroll back to the top.
	[*]Fixed - the mod menu after failing a target shows correct text
	[*]Improved - Demand order items in GUI ordered by status (partial completed, not completed, completed) then by item name. So the first ones on the list are outstanding and duplicates of an equal completed state are next to each other.
	[*]Improved - Added padding to secondary timer values to be double digits, i.e. minute value when the primary value is hours; 1:5 hours = 1:05 hours
	[*]Code - Timer display text and number handling simplified.
	[*]Improved - API Commands confirm the action done in the global text (positive or negative outcome)
[/list]
[u]0.0.5 (2018-05-16 - 0.16.41):[/u]
[list]
	[*]Improved - Timers show as PRIMARY:SECONDARY rather than decimals, i.e. 3:27 hours
[/list]
[u]0.0.4 (2018-05-15 - 0.16.41):[/u]
[list]
	[*]Fixed - target timer issue affecting 2 or more hours being displayed wrong.
	[*]Improved - Updated GUI refresh to be once a second, rather than every 10
[/list]
[u]0.0.3 (2018-05-14 - 0.16.41):[/u]
[list]
	[*]Fixed Duplicate Item Prevention option to take effect, rather than being forced permanently on.
	[*]Red warning text made brighter so stands out.
	[*]GUI alignment standardised
	[*]Change tribute demand warning to be 2 stage, orange for 20-10% time left, red for 10-0% time left. re-pop tribute demand window on a change to both warning states.
	[*]Change first rocket warning to be 2 stage, orange for 20-10% time left, red for 10-0% time left. re-pop tribute demand window on a change to both warning states.
	[*]Tribute demand items on hover to be on the item frame plus the item image and text. Resolve current on-hover dead spot issue. Still a tiny dead zone between the image and text, but all GUI elements have the on-hover.
	[*]Timers need to show the time in hours, minutes or seconds based on current quantity. currently just shows the minutes.
	[*]Tested with Big Bags mod and demands are 1 stack of its increased size, i.e. 500 solar panels.
	[*]Tribute Demand Growth size configurable.
	[*]Tribute Freedom Target and both delivery targets show a centred themed message to make it very apparent you've won/lost. This message should not end the game in any way though.
	[*]Change tribute demand list supplied quantity to be colour coded based on the number supplied. The default color for none or some, green for all. Should resolve very wide labels for 3 digit stack sizes when supplied and make the demand screen less cluttered when multiple demands. On hover still shows exact supplied out of total required (stack size).
[/list]
[u]0.0.2 (2018-05-04 - 0.16.39):[/u]
[list]
	[*]fixed implemented API command debug_completed_orders_set
	[*]enhancement moved to getter and setter functions for global.state "orders_completed" and "order_target" to ensure GUI updates are triggered on all modifications
	[*]added massive item type; rocket silo
	[*]added option to prevent duplicate items in demand
	[*]added optional tribute start timer to GUI, turns red when less than 20%~ time remaining and alerts all players
	[*]added optional tribute demand target time shown in the GUI, turns red when less than 20%~ time remaining and alerts all players
	[*]added completed time to demand when done (but not currently used in a visible list)
	[*]all API commands made safe for running at any time
[/list]
[u]0.0.1 (2018-05-03 - 0.16.39):[/u]
[list]
	[*]initial version
[/list]
[/spoiler]

[spoiler=Known Bugs and Issues]
[list]
	[*]Instant Construct and De-Construct via Creative Mod cause errors.
	[*]Rare cases when controller and receiver entities placed by bots won't connect to neighbouring silo.
[/list]
[/spoiler]

[spoiler=Planned Minor Enhancements]
[list]
	[*]unlock new circuit items and signals with the rocket silo technology
	[*]Demand Receiver to have signals for outstanding item tributes and number of items demanded in current demand.
	[*]Option to have a demand made up of identical items or different items. Prevent Duplicate only applies if set to different items.
	[*]Tribute Report API command that will output a nicely formatted and clean list of items tributed and summary total information. An enhanced version of sisyphean_debug_get_global designed for getting statistics out, rather than for debugging purposes.
	[*]Controllers and Loaders don't de-activate when marked for deconstruction or re-activate when unmarked for deconstruction.
	[*]Demand Receiver to have signals for tributes made, tribute target, items tributed, and item tribute target.
[/list]
[/spoiler]

[spoiler=Planned Major Features]
[list]
	 [*]Add demand for a person. See what can be done around them being a sacrifice and if we can detect named player as in the rocket.
	 [*]Technology to increase rocket cargo size.
	 [*]Allow viewing of completed demands including how quickly they were completed.
	 [*]Make status a different background colour so white text on grey/dark orange or red stands out better on stream. Need to use a background image as a coloured background for this.
	 [*]Reward option based around returning a quantity of random science or returning space science. Options to control quantity ranges.
[/list]
[/spoiler]

[spoiler=Exploratory Concepts and Suggestions]
[list]
	[*]Replace mod name with an image in GUI on the top bar.
	[*]Change item types to be sub-group driven rather than hardcoded to allow support of mod items. This would mean mod items using stock sub-groups are included by default and mod specific sub-groups would have to be coded and configured separately. Review impact on stock game items as some current categories are cross sub-group i.e. uranium products.
	[*]Move source code to git hub and open up.
	[*]Make use of event "on_runtime_mod_setting_changed" to detect when mod settings are changed and move away from startup settings, see if any settings should be cached as variables rather than obtained on the fly. Also, move some of the global state inspection to this.
	[*]Make a non-rocket launch option where items are deposited in a *building*. Could allow for additional tiering of item types and an infinite supply challenge type mode where you start supplying simple items early on.
	[*]Support for multiple forces competing. Options to have identical targets for each force. Freedom target is the end win condition. Scoreboard to show all forces progression.
	[*]use pcall to handle error scenarios. Should an error occur output log the global contents and report an onscreen error. Stop all events and timed registrations to avoid further errors or global state corruption. Have a way to recover the mods state from the current global information, which may have been fixed via script.
	[*]Add a "reset" debug command to return the mod to its game start state; destroy GUI, events and commands. wipe global. launch mod startup code to re-initialise everything.
	[*]Convert the GUI elements all to constants with a mapped structure and separate out to util functions, etc. the add GUI element returns the created element and name is optional.
	[*]Support for multiple concurrent demands (order slots). Different Rocket Silo(s) can be assigned to a specific demand slot.
	[*]Check if non admins can run the commands and if so address if possible.
[/list]
[/spoiler]

[spoiler=Concepts and Suggestions Not Being Pursued]
[list]
	[*]All player chat tribute demand announcement - on quick demand completion would cause frequent chat messages and considered spam by some.
[/list]
[/spoiler]

[spoiler=Translations and Graphic]
[list]
	[*]If you can assist with graphics for the mod or translations into non-English please PM me.
	[*]All current graphics are temporary.
[/list]
[/spoiler]