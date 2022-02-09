showLoginDialog(playerid)
{
	inline Login(pid, dialogid, response, listitem, string: inputtext[])
	{
		#pragma unused pid, dialogid, response, listitem, inputtext

		// If the "Esc" key is pressed during the login dialog, we do not kick the player.
		if(!response) return Kick(playerid);
        
		// We are reworking the encrypted password for testing purposes.
		new hash[64 + 1];
		SHA256_PassHash(inputtext, AccountInfo[playerid][Salt], hash, sizeof(hash));

		// Is the entered password correct?
		if(strcmp(hash, AccountInfo[playerid][Password]) == 0)
		{
			// We load the user's data.
			cache_get_value_int(0, "id", AccountInfo[playerid][ID]);
			cache_get_value_int(0, "money", AccountInfo[playerid][Money]);

			// We eliminate the time because the login was successful.
			KillTimer(AccountInfo[playerid][loginTimer]);
			AccountInfo[playerid][loginTimer] = 0;

  			// We are sending an information message.
  			SendClientMessage(playerid, 0xFF00FF00, "[w-REG] {FFFFFF}Giriþ baþarýyla tamamlandý, verileriniz yüklendi.");
 		}
		else
		{
			// We show the dialog again because the password was entered incorrectly.
			showLoginDialog(playerid);
            
			// We send an information message that an incorrect password has been entered.
			SendClientMessage(playerid, 0xFF00FF00, "[w-REG] {FFFFFF}Eksik veya yanlýþ bir þifre girdiniz.");

			// We're increasing the user's login attempt.
			AccountInfo[playerid][loginAttemps]++;

			// When the wrong login attempt reaches 3, we kick the user.
			if(AccountInfo[playerid][loginAttemps] >= 3)
			{
				delayedKick(playerid, "Hatalý þifre denemesi aþýmý");
			}
		}

	}

	// If there is no reaction within 60 seconds when the login dialog appears, we direct it to the OnLoginTimeout callback.
	AccountInfo[playerid][loginTimer] = SetTimerEx("OnLoginTimeout", 6 * 1000, false, "i", playerid);

	// Login dialog (written using y_dialog include.)
	new string[230 + MAX_PLAYER_NAME];
	format(string, sizeof(string), "{FFFFFF}Hoþ geldin {00FF00}%s{FFFFFF},\n\
    veri tabanında kulanıcı ismine rastladık. Giriş yapmak için aşağıdaki kutucuğa şifreni girmelisin.\n\n\
    \t{0000FF}- {FFFFFF}Şifrenizi unuttuysanız www.bilmemne.com üzerinden bildirebilirsiniz."returnPlayerName(playerid));
	Dialog_ShowCallback(playerid, using inline Login, DIALOG_STYLE_PASSWORD, "Giriş Yap, string, "Giriş", "Çıkış");

    return 1;
}

showRegisterDialog(playerid)
{
    inline Register(pid, dialogid, response, listitem, string: inputtext[])
    {
        #pragma unused pid, dialogid, response, listitem, inputtext

        // If the "Esc" key is pressed during the login dialog, we do not kick the player.
        if(!response) return Kick(playerid);
        
        // If the entered password is shorter than 8 characters, we send an error message.
        if(strlen(inputtext) < 8)
        {
            showRegisterDialog(playerid);
            SendClientMessage(playerid, 0xFF00FF00, "[w-REG] {FFFFFF}Girdiðiniz þifre en az 8 karakter uzunluðunda olmalýdýr.");
        }
        else
        {
            // We encrypt the user password to store it securely in the database.
            for(new i = 0; i < 16; i++) AccountInfo[playerid][Salt][i] = random(94) + 33;
            SHA256_PassHash(inputtext, AccountInfo[playerid][Salt], AccountInfo[playerid][Password], 65);

            // We are sending a query to the database to register the user.
            new query[181];
            mysql_format(mHandle, query, sizeof(query), "INSERT INTO `accounts` (`username`, `password`, `salt`) VALUES ('%e', '%s', '%e')", returnPlayerName(playerid), AccountInfo[playerid][Password], AccountInfo[playerid][Salt]);
            mysql_tquery(mHandle, query, "OnPlayerRegister", "i", playerid);
        }
    }

    // Register dialog (written using y_dialog include.)
    new string[340 + MAX_PLAYER_NAME];
    format(string, sizeof(string),
    "{FFFFFF}Hoþ geldin {00FF00}%s{FFFFFF},\n\
    veri tabanýnda kullanýcý ismine rastlanmadý. Kayýt olmak için aþaðýdaki kutucuða þifre girmelisin.\n\n\
    \t{0000FF}- {FFFFFF}Gireceðiniz þifre en az 8 karakter içermelidir.\n\
    \t{0000FF}- {FFFFFF}Þifrenizi not etmeyi ihmal etmeyiniz.\n\
    \t{0000FF}- {FFFFFF}Þifrenizi yetkililer dahil kimseyle paylaþmayýnýz.", returnPlayerName(playerid));
    Dialog_ShowCallback(playerid, using inline Register, DIALOG_STYLE_PASSWORD, "Kayýt Ol", string, "Kayýt", "Çýkýþ");

    return 1;
}

delayedKick(playerid, reason[])
{
    format(reason, 128, "[wREG] {FFFFFF}%s", reason);
    SendClientMessage(playerid, 0xFF0000FF, reason);

    return SetTimerEx("kickPlayerDelayed", 500, false, "i", playerid);
}
