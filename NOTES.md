Scene View:
Game Handler - Handle turn order, tracks points for each player
UI - Handles displaying name labels for players, and buttons for the player to pass or play
Main Player - Has a deck in which they can play from
AI Players - Has decks in which they will also play

Card Sort - Spade, Club, Diamond, Heart

AI Logic (for now): Pick the greatest amount of the same lowest value card and then play it


Settings -
Terms Language (In-game terms to be used, japanese to english) (Daifugo, Fugo, Heimen, Hinmen, Daihinmin = President, Vice-President, Citizen, Poor, Begger)
Auto Pass (Automatically pass if you have no valid cards to play)

Game Rules -
5 Skip - Skips the next player(s) if a 5 is played
8 Ender - Immediately end the hand if a 8 is played
First Play - Who starts the hand? (Daihinmin, Daifugo, 3 of Spades, etc.)
Forbidden Last Card - Players not allowed to go out on this card (2, Joker, Pair, 8, etc.)
Sequence - Three or more cards in a sequence (ex. 3-4-5, 6-7-8, etc.)
Miyako Ochi - If the Daifugo does not win the hand, they will automatically be demoted to Daihinmin


Bugs:
If 2 or more cards are played together, and it becomes the players turn, it will highlight cards of higher ranking, even if you don't have enough to play that card
AI does not try to play as many of the same card if they are starting the turn
Build instructions needs to be updated
