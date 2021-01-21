defmodule BotskriegArena.Sandbox.Lua do
  defmodule State do
    defstruct [:lua_state]
  end

  @type code :: String.t()
  @type table_path :: [String.t(), ...]

  @spec init() :: %State{}
  def init do
    %State{lua_state: :luerl_sandbox.init()}
  end

  @spec run(%State{}, code()) :: {any(), %State{}}
  def run(%State{lua_state: lua_state} = state, code) do
    {result, new_state} = :luerl_sandbox.run(code, lua_state)
    {result, %State{state | lua_state: new_state}}
  end

  @spec set_on_table(%State{}, table_path(), any()) :: %State{}
  def set_on_table(%State{lua_state: lua_state} = state, path, value) do
    new_state = :luerl.set_table(path, value, lua_state)
    %State{state | lua_state: new_state}
  end

  @spec read_from_table(%State{}, table_path) :: {any(), %State{}}
  def read_from_table(%State{lua_state: lua_state} = state, path) do
    {result, new_state} = :luerl.get_table(path, lua_state)
    {result, %State{state | lua_state: new_state}}
  end
end
