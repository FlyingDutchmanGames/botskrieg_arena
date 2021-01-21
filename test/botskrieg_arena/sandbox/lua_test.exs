defmodule BotskriegArena.Sandbox.LuaTest do
  use ExUnit.Case, async: true

  alias BotskriegArena.Sandbox.Lua

  test "You can make a new one" do
    assert %Lua.State{} = Lua.init()
  end

  describe "set_on_table/read_from_table" do
    test "you can set and read from a table from elixir" do
      state = Lua.init()
      assert {nil, state} = Lua.read_from_table(state, ["foo"])
      state = Lua.set_on_table(state, ["foo"], "bar")
      assert {"bar", state} = Lua.read_from_table(state, ["foo"])

      state =
        state
        |> Lua.set_on_table(["foo"], %{})
        |> Lua.set_on_table(["foo", "bar"], "baz")

      assert {"baz", state} = Lua.read_from_table(state, ["foo", "bar"])

      state = Lua.set_on_table(state, ["a"], %{"b" => "c", "d" => "e"})
      assert {[{"b", "c"}, {"d", "e"}], state} = Lua.read_from_table(state, ["a"])
      assert {"c", _state} = Lua.read_from_table(state, ["a", "b"])
    end
  end
end
