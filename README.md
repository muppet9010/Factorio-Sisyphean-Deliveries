# Factorio-Sisyphean-Deliveries



Sisyphus was punished by the ancient Greek gods to carry out a laborious and futile task for eternity. You and your factory are being tested to avoid the same fate. Sisyphean Deliveries requires your factory to launch an ever-growing tribute of items into space for eternity. Will you test your factory with mass rocket production or demand impossible item production from your Make Everything.

After the first rocket is launched the mod will generate a tribute demand, a list of item(s) that must be launched into space on one or more rockets. Each item type requires a full stack and is randomly generated (configurable). The tribute size is configurable and can grow as more tribute demands are completed. Rocket cargo size is configurable via the mod and the mod includes full circuit integration to automate the requesting, loading and launching of items and rockets if desired.
Included are several optional visually displayed target timers and a tribute quantity target that will alert on all players screens.
The mod is designed for multiplayer megabase games.
Via the configuration options you can have the mod test you and your base in different ways:

- Be a mass rocket launcher with a single random item within each, an alternative to SpaceX or infinite research. An example of this gameplay style is ColonelWill's Sisyphean Deliveries series: https://www.twitch.tv/colonelwill/videos/all
- Demanded to produce 100 random item stacks per rocket, to really give your item production system (ME - Make Everything) a complete test.
- Anywhere in between the above 2 extremes. See the complete Configuration Options below.


![Sisyphean Deliveries GUI Stages](https://thumbs.gfycat.com/AmusedBrokenArgentineruddyduck.webp)

Configuration Option
==================
Options marked as (StartUp) are applied at the start of a game, but their current value is saved for the duration of the game. If the current value needs to be modified during a game an API command will be available.
All other settings are checked at usage, ie: when a new demand is created or the GUI updates.

- Tribute Demand Growth Rate: >= 0   ---   The number of tribute demands that must be completed for the tribute size to increase. If set to 0 the tribute size shall start at the Tribute Maximum Size, otherwise, it starts at 1 item per tribute demand.
- Tribute Demand Growth Size: > 0   ---   The number of items the tribute demand grows by on each size increase (Tribute Growth Rate). Will stop growing when it reaches the Tribute Maximum Size.
- Tribute Demand Maximum Size: 1-100  ---   The maximum number of items that a tribute demand can grow to.
- Prevent Duplicate Demand Items: on/off   ---   Prevent duplicate items from being in the same demand. The setting is ignored if the current tribute demand size is greater than the allowed item types list.
- Tribute Freedom Target (StartUp): >= 0   ---   The starting target number of tribute demands required for freedom and to complete the Sisyphean task. If set to 0 then freedom cannot be obtained. This does not "complete" the game to avoid issues.
- Tribute Delivery Target (Minutes): >= 0   ---   A visual timer in minutes for meeting each tribute demand (60 ticks per second). 0 disables
- Initial Rocket Target (Minutes): >= 0  ---   A visual timer in minutes for launching the first rocket to start tribute demands from the game start (60 ticks per second). 0 disables
- Rocket Cargo Size (StartUp): 1-100   ---   The number of cargo slots a rocket has.
- Tribute Demand Item Types   ---   A list of types of items that can each be enabled/disabled for inclusion in the random demand item selection process.

API Commands
===================
API commands to manipulate startup settings and to do ad-hock mod actions, ie: restart the tribute demands after the Tribute Freedom Target is reached. All API Commands will modify the mod's Configuration Options of the current game and will be saved for the remainder of this game. The command will confirm in all player chat what action has been taken.

- sisyphean_target_set NUMBER   ---   Set the current game Tribute Freedom Target to the specified whole number (integer).
- sisyphean_target_change NUMBER   ---    Change the current game Tribute Freedom Target by the specified whole number (integer), can be a positive or negative number.
- sisyphean_regenerate_demand   ---   Regenerate the current tribute demand. Does not increment tribute count or completed tributes count.
- sisyphean_complete_tribute   ----   Completes the current tribute demand as if it had been provided via rocket.
- sisyphean_start   ---   Starts the tribute demand process. The command is used to start prior to the first satellite launch or restart after the Tribute Freedom Target has been reached and you wish to continue. If continuing you must increase the Tribute Freedom Target first. This command does not affect the completed tributes count.

Debug API Commands
---------------
Certain debug commands are included for testing, cheating, etc.

- sisyphean_debug_get_global   ---  Gets the mods global object (mod save data) and writes it out to file in Factorio's Script Output folder. Used for debugging and support cases.

Circuit Network Integration
=====================
A number of circuit network connectible entities have been added to support the automation of demanded item loading and rocket launch. At a simple level, all circuitry should be usable in any fashion and recover from any mishaps (early launches) automatically.

Rocket Silo Controller
------------------
Can be placed next to a silo and will be paired to that silo until either is removed. Each rocket silo and rocket silo controller can only support 1 pairing of this type. If it is in the enabled circuit logic state the rocket will be launched if possible.

Rocket Load Receiver
-----------------
Is intended to automate rocket loading with required items. Each rocket load receiver can be placed next to a silo and will be paired with the silo until either is removed. Each rocket silo and rocket load receiver can only support 1 pairing of this type. The rocket load receiver will output the following information signals:

- Preparing Rocket signal --- Shown when the rocket is being prepared and is not available for loading or launching. In effect the idle state of the Rocket Load Receiver.
- Rocket Ready To Load signal --- Shown when the rocket is built and can be loaded. This signal is not present when the Rocket Ready To Launch signal is active.
- Rocket Ready To Launch signal --- Shown when all demanded items are loaded or the rocket is full. A full rocket can be either all slots are at capacity or there are no free slots for the extra demanded items and used slots are either full or at demand level. When there are multiple silos and there are no more items to be reserved (see below) the current rocket is deemed as full.

When there is a Rocket Ready To Load signal being output the load receiver will reserve and output a single outstanding demanded item and stack size from the current demand to the circuit network, i.e. "Iron Plate" with a value of 100. It will also output a Demand Stack Size signal of the outstanding items for use with filter inserter stack size circuitry. The outstanding items do not include item stacks reserved by other rocket loading controllers and so multiple rocket silos each with their own rocket load receiver can be used without risk of duplicating or splitting item stacks across silos. Once the reserved demanded item is supplied to the rocket, the rockets state shall be re-assessed and if it is still in Rocket Ready To Load a new demanded item will be reserved and broadcast to the circuit network (for when a rocket has multiple inventory slots).

Tribute Demand Receiver
-----------
Is intended to pass the outstanding demanded items into a circuit network. The receiver will output signals of the demanded items still to be received as tribute. Multiple Receivers can be used and each will output the same real-time information. The tribute demand receiver will also output general tribute information via signals:

- Demand Target Time Remaining signal --- Will have a value of how many seconds are left until the current target timer is up. Intended usage is for the creation of audible alarms or for waiting to launch rockets close to the deadline. Remaining seconds value will be either Tribute Delivery Target or Initial Rocket Target if enabled and appropriate, otherwise the signal won't be present.

Additional Signals
-----------
Some additional signals have been added to support more advanced and clear circuit logic. They have are free to use for any purpose, although examples are included.

- Launch Rocket signal --- Is added by the mod for optional use. Envisaged for use with the Rocket Silo Controller to help make signals clearer when using multiple silos and decider combinators to synchronise rocket launches.

General Notes
-------------
Care should be taken with inserter stack sizes to avoid the inserter still holding items after a rocket launch and polluting the next rocket with unwanted items. The simplest way to handle this is to have a single filter inserter have its item and stack size set by the Rocket Load Receiver.

Factorio's default rocket silo auto-launch feature cannot be used as it will trigger after just 1 item is loaded rather than full stacks.

If multiple silos and rocket load controls are in use they will try and load and launch the rockets as fast as possible.

Should you have a rocket inventory size greater than 1 this may lead to wasted inventory space on the later rockets in a demand. More advanced circuit logic could be used to avoid this if desired using the rocket state signals from the rocket load receiver.

Each rocket silo can only be paired with 1 rocket load receiver and 1 rocket silo controller. Should a neighbouring rocket silo, controller or receiver already be paired then the newly placed entity will not pair with anything. Leaving a tile space between clusters of a silo and their controllers/receivers is advised to avoid any unexpected results when blueprinting or replacing.

If using multiple silos with rocket load receivers and you launch a partial stack, the partially tributed item will become available for another silo to complete as normal. After each launch the rocket load controllers return to a neutral state and begin the demanded item reserving process again, getting the demand completed as quickly as possible.