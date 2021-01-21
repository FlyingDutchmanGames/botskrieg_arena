defmodule BotskriegArena.Sandbox.LuaTest do
  use ExUnit.Case, async: true

  alias BotskriegArena.Sandbox.Lua

  test "You can make a new one" do
    assert %Lua.State{} = Lua.init()
  end
end
