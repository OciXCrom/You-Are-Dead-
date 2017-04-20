#include <amxmodx>

#if AMXX_VERSION_NUM < 183
	#include <dhudmessage>
#endif

#define PLUGIN_VERSION "1.0"

new g_ScreenFade
new g_Message, g_MsgR, g_MsgG, g_MsgB, g_MsgTime
new g_EffectA, g_EffR, g_EffG, g_EffB, g_EffTime

public plugin_init()
{
	register_plugin("You Are Dead!", PLUGIN_VERSION, "OciXCrom")
	register_cvar("YouAreDead", PLUGIN_VERSION, FCVAR_SERVER|FCVAR_SPONLY|FCVAR_UNLOGGED)
	register_event("DeathMsg", "player_killed", "a")
	
	g_Message = register_cvar("youdead_message", "You are dead!") 	/* The message that appears on player's death (default: "You are dead!") */
	g_MsgR = register_cvar("youdead_msgRed", "225") 				/* Message RGB: red amount (default: "225") */
	g_MsgG = register_cvar("youdead_msgGreen", "90")				/* Message RGB: green amount (default: "90") */
	g_MsgB = register_cvar("youdead_msgBlue", "0")					/* Message RGB: blue amount (default: "0") */
	g_MsgTime = register_cvar("youdead_msgTime", "2.5")				/* Message hold time (default: "2.5") */
	
	g_EffectA = register_cvar("youdead_effectAlpha", "255")			/* Effect RGBA: alpha amount (default: "255") */
	g_EffR = register_cvar("youdead_effectR", "0")					/* Effect RGBA: red amount (default: "0") */
	g_EffG = register_cvar("youdead_effectG", "0")					/* Effect RGBA: green amount (default: "0") */
	g_EffB = register_cvar("youdead_effectB", "0")					/* Effect RGBA: blue amount (default: "0") */
	g_EffTime = register_cvar("youdead_effectTime", "3")			/* Effect hold time (default: "3") */
	
	g_ScreenFade = get_user_msgid("ScreenFade")
}

public player_killed()
{
	new id = read_data(2)
	static szMessage[128]
	get_pcvar_string(g_Message, szMessage, charsmax(szMessage))
	
	set_dhudmessage(get_pcvar_num(g_MsgR), get_pcvar_num(g_MsgG), get_pcvar_num(g_MsgB), -1.0, -1.0, 0, 1.0, get_pcvar_float(g_MsgTime), 1.0, 1.0)
	show_dhudmessage(id, szMessage)
	
	message_begin(MSG_ONE, g_ScreenFade, {0, 0, 0}, id)
	write_short(get_pcvar_num(g_EffTime)<<12)
	write_short(get_pcvar_num(g_EffTime)<<12)
	write_short(0x0000)
	write_byte(get_pcvar_num(g_EffR))
	write_byte(get_pcvar_num(g_EffG))
	write_byte(get_pcvar_num(g_EffB))
	write_byte(get_pcvar_num(g_EffectA))
	message_end()
}