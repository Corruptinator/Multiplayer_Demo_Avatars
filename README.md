# Godot Multiplayer Demo: Avatars
A personal learning project in implementing Avatar Multiplayer Nodes in Godot.

The goal of the project: To implement Remote Controllable Avatar Nodes that when despawned or queue_free()'d from instance it will not cause the network code to crash the game.

![Demoscreen](https://github.com/Corruptinator/Multiplayer_Demo_Avatars/blob/master/demoscreen.png)

To get started:

1) Open up Godot and load up the project, do it again to have two engine instances running to test out the multiplayer.
2) Press Play on both two open engines to run the two multiplayer games.
3) press "E" to spawn the player.

This is where I start to have problems. One one hand when two game instances are running and at the same network port hitting the respawn button spawns the same player on both ends of the game.
If i were to spawn the player in the game first before bringing in the second instance of the game, then I get errors.

I'll post the issue shortly to explain what issues I've run into.
