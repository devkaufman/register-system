/*

    This game mode coded by kaufman (https://github.com/devkaufman)
     - Starting Date: 09.02.2002
     - End Date: 00.00.0000

    Copying and sharing without specifying the source is prohibited.
    This game mode is coded in modular form. You can access all cores from the file.
    Libraries belonging to other people are used in game mode.
    Links to these libraries are next to them.

*/

// We define libraries.
#include <a_samp>
#include <a_mysql>                          // https://github.com/pBlueG/SA-MP-MySQL
#include <sscanf2>                          // https://github.com/Y-Less/sscanf
#include <YSI_Visual\y_dialog>              // https://github.com/pawn-lang/YSI-Includes
#include <zcmd>                             // https://github.com/Southclaws/zcmd

// Settings and macros
#define global%0(%1) forward%0(%1); public%0(%1)
#pragma warning disable 239, 214, 217

// Cores of the MySQL system
#include "./modules/database/variables.pwn"
#include "./modules/database/connect.pwn"

// Cores of the accounts
#include "./modules/account/variables.pwn"
#include "./modules/account/callbacks.pwn"
#include "./modules/account/functions.pwn"

main() { }

public OnGameModeInit()
{
    return 1;
}

returnPlayerName(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}