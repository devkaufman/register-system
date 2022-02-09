#include <YSI_Coding\y_hooks>

hook OnPlayerConnect(playerid)
{
	// When the user enters the game, we send a query to the database to retrieve the registration status from the username.
	new query[222];
	mysql_format(mHandle, query, sizeof(query), "SELECT * FROM `accounts` WHERE `username` = '%e' LIMIT 1", returnPlayerName(playerid));
	mysql_tquery(mHandle, query, "OnPlayerCheckAccount", "i", playerid);
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	// We query the database to update the data when the user exits the game.
	new query[245];
	format(query, sizeof(query), "UPDATE `accounts` SET `money` = '%i' WHERE `ID` = '%i'", GetPlayerMoney(playerid), AccountInfo[playerid][ID]);
	mysql_query(mHandle, query);
	return 1;
}

global OnPlayerCheckAccount(playerid)
{
	// Is there data in the row? (i.e. is the user registered?)
	if(cache_num_rows() > 0)
	{
		// yes -> Pull the password and salt and show the login dialog.
		cache_get_value(0, "password", AccountInfo[playerid][Password], 65);
		cache_get_value(0, "salt", AccountInfo[playerid][Salt], 17);

		showLoginDialog(playerid);
	}
	else
	{
		// else -> Show the register dialog.
		showRegisterDialog(playerid);
	}
	return 1;
}

global OnPlayerRegister(playerid)
{
	// We are binding our ID variable. (cache_instert_id() = pulls column with AUTO_INCREMENT attribute.)
	AccountInfo[playerid][ID] = cache_insert_id();

	// We are sending an information message.
	SendClientMessage(playerid, 0xFF00FF00, "[w-REG] {FFFFFF}Hesabýnýz veri tabanýna kayýt edildi.");
	return 1;
}

global kickPlayerDelayed(playerid)
{
	return Kick(playerid);
}

global OnLoginTimeout(playerid)
{
	// We kick the player and reset the timer variable.
	AccountInfo[playerid][loginTimer] = 0;
	return delayedKick(playerid, "60 saniye içerisinde þifrenizi girmediðiniz için teklemendiniz.");
}
