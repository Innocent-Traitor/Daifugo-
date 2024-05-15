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


MVP:
Be able to play the game from the beginning, and it actually works


Things Left To Do:
Trading at the beginning of the round
^ This works for the player to submit the cards they want to trade, needs to work for bots
Bots will just submit their lowest ranking cards if they are daifugo or fugo
once the player submits theirs, give like a .5 second timeout, remove those cards and give the traded cards
the traded cards will also be kept in the trading cards dictionary thingy

FUCK GODOT WHEN IT DOES THE SHIT WHEN YOU CONNECT A SIGNAL AND IT JUST FUCKING OBLITERATES THE PAST 5 FUNCTIONS YOU MADE


Bugs:
Sometimes if there are two jokers, only one gets moved over to the top of the hand and the other is at the bottom
If 2 or more cards are played together, and it becomes the players turn, it will highlight cards of higher ranking, even if you don't have enough to play that card
AI does not try to play as many of the same card if they are starting the turn
