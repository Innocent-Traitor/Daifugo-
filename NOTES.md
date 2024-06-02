Scene View:
Game Handler - Handle turn order, tracks points for each player
UI - Handles displaying name labels for players, and buttons for the player to pass or play
Main Player - Has a deck in which they can play from
AI Players - Has decks in which they will also play

Card Sort - Spade, Club, Diamond, Heart

Settings -
Terms Language (In-game terms to be used, japanese to english) (Daifugo, Fugo, Heimen, Hinmen, Daihinmin = President, Vice-President, Citizen, Poor, Begger)
Auto Pass (Automatically pass if you have no valid cards to play)

Game Rules -
3 of Spades Pay Back - If a single joker is played, a 3 of spades can be played over the Joker
5 Skip - Skips the next player(s) if a 5 is played
8 Ender - Immediately end the hand if a 8 is played
First Play - Who starts the hand? (Daihinmin, Daifugo, 3 of Spades, etc.)
Forbidden Last Card - Players not allowed to go out on this card (2, Joker, Pair, 8, etc.)
Sequence - Three or more cards in a sequence (ex. 3-4-5, 6-7-8, etc.)
Miyako Ochi - If the Daifugo does not win the hand, they will automatically be demoted to Daihinmin
Revolution - If 4 of the same valued cards are played, the value of cards are reversed


Bugs:
If 2 or more cards are played together, and it becomes the players turn, it will highlight cards of higher ranking, even if you don't have enough to play that card - Might have to use something similar to the algorithm the bots use to find cards that they can play (it's gonna suck)
If a player has finished the game, it does not properly adjust the passing order


Rules:
You toggle the rules in the settings menu. In the game handler, there is a function that will run checks of any card that is discarded for the rules. If it fits one of the rules, it will then execute those rules. These rules functions are in a class script that will run only if the rule is enabled.


Build instructions needs to be updated


3 Main things to save:
 - Settings - This can be loaded at the launch of app, and saved when closing the settings menu
 - Stats - This can be loaded when opening the stats menu, and saved at the end of every round
 - Current Game - Loaded when continuing into a game at app startup, and saved when exiting the main scene for any reason (Close Game, Minimize Game, go to main menu)
https://docs.godotengine.org/en/stable/classes/class_mainloop.html - For Noticiations when game is paused or unpaused in Android