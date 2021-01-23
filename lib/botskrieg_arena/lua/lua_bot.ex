defmodule BotskriegArena.Lua.LuaBot do
  alias BotskriegArena.Lua
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
end
