# Daifugo! A Japanese Card Game

## About

[Daifugo](https://en.wikipedia.org/wiki/Daifugo) is a japanese card game that includes getting rid of all the cards in your hand to become the Daifugo! If you don't get rid of them, you risk becoming the Daihinmin and giving your best cards to the Daifugo next round. Keep playing with all sorts of different rules and have fun!

This project was started due to the lack of english translated version of daifugo on the android app store. There are quite a few avaiable, but only one that I've found in english. Sadly, it is only supported by what looks like one developer that redid the framework which ended up completely breaking it. So I decided to create my own version. This version is lacking a lot of the rulesets, but I first want to create the ruleset that I am used to first before I start adding rules I don't know about. Eventually, I want to have a completely customizable ruleset that the player can change however they'd like. Later in the README you can see my current progress on add rules, and other features I want to add.

## Roadmap

### Rules
- [x] - 5 Skip
- [x] - 8 Ender
- [ ] - 3 of Spades Pay Back
- [ ] - First Play
- [ ] - Forbidden Last Card
- [ ] - Sequence
- [ ] - Miyako Ochi
- [ ] - Revolution

### QoL
- [ ] - Stats
- [ ] - Saves game (Currently only saves settings that are implemented)
- [ ] - In-game sounds
- [ ] - Customizable Cards
- [ ] - Change term language (Daifugo = President)
- [ ] - Auto Pass
- [ ] - Different amount of players

### Other nice things that probably won't come for a while
- [ ] - In-Game Tutorials
- [ ] - Multiplayer
- [ ] - iOS version
- [ ] - AI uses different strategies
- [ ] - Web version
- [ ] - Google Games integration (leaderboards, achievements, etc.)

## Contact
If you'd like to suggest other rules or help contribute to the project, please feel free to contact me via email or discord.

Email: [jamesmoffett@moonsoftstudios.com](jamesmoffett@moonsoftstudios.com)

Discord: [innocent_traitor](https://discord.gg/vGB9EEqNHF)

## Build this project

1. Download the project, and open in at least Godot v4.2
2. Follow [Exporting for Android](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html) on the Godot Documentation
3. Follow [Gradle Builds for Android](https://docs.godotengine.org/en/stable/tutorials/export/android_gradle_build.html) on the Godot Documentation
4. If you'd like to disable Ads on mobile, simply disable ad_handler.gd from the autoload singletons and turn off the Poing Studios Admob plugin.
5. Build and Export using Godot's export system