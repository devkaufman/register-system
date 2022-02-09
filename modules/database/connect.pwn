#include <YSI_Coding\y_hooks>

hook OnGameModeInit()
{
	// Creates a MySQL connection options instance with default values.
	new MySQLOpt: optionID = mysql_init_options();
	mysql_set_option(optionID, AUTO_RECONNECT, true);

	// We associate our link variable with the link function.
	mHandle = mysql_connect("localhost", "root", "", "sa-mp", optionID);
	
	// In case of connection failure, we send a message and close it.
    if(mHandle == MYSQL_INVALID_HANDLE || mysql_errno(mHandle) != 0)
	{
		print("MySQL connection failed.");
		return SendRconCommand("exit");
	}

	// If the connection is successful, we send a message.
	print("MySQL connection is successful.");

	return 1;
}

hook OnGameModeExit()
{
	// We make the players look like they are out of the game in order not to lose the record in case of a crash.
    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(IsPlayerConnected(i))
		{
			call OnPlayerDisconnect(i, 1);
		}
	}

	// We close the MySQL connection.
    mysql_close(mHandle);

    return 1;
}