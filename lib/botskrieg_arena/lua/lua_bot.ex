defmodule BotskriegArena.Lua.LuaBot do
  alias BotskriegArena.{Lua, Lua.LuaGame}
  defstruct [:compiled_code, :state]

  @spec new(String.t()) :: {:ok, %__MODULE__{}} | Lua.compilation_failure()
  def new(source_code) do
    state = Lua.init_sandboxed()

    case Lua.compile(source_code, state) do
      {:ok, compiled_code, state} ->
        {:ok, %__MODULE__{compiled_code: compiled_code, state: state}}

      {:error, error, warnings} ->
        {:error, error, warnings}
    end
  end

  @spec run(%__MODULE__{}, LuaGame.t(), TableTopEx.role()) :: {:ok, any()} | :error
  def run(%__MODULE__{compiled_code: code, state: state} = bot, game, role) do
    state =
      game
      |> LuaGame.for_role(role)
      |> Enum.reduce(state, fn {key, value}, state ->
        Lua.set_on_table(state, [key], value)
      end)

    case Lua.run_sandboxed(state, code) do
      {:error, _state} -> :error
      {result, _state} -> {:ok, result, bot}
    end
  end
end
