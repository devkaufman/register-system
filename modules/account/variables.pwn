// Create enum for user's data.
enum E_PLAYER
{
	ID,
	Name[MAX_PLAYER_NAME],
	Password[64 + 1],
	Salt[17],
	loginAttemps,
	loginTimer,
	Money
};

// We associate the data with the variable.
new AccountInfo[MAX_PLAYERS][E_PLAYER];
