defprotocol BotskriegArena.Lua.LuaGame do
  @spec for_role(any(), TableTopEx.role()) :: %{optional(String.t()) => any()}
  def for_role(game, role)

  @spec apply!(any(), TableTopEx.role(), any()) :: {:ok, any()} | {:error, String.t() | atom()}
  def apply!(game, role, commands)
end
