defmodule BotskriegArena.Sandbox.LuaTest do
  use ExUnit.Case, async: true

  alias BotskriegArena.Sandbox.Lua

  test "You can make a new one" do
    assert %Lua.State{} = Lua.init()
  end

  describe "run" do
    test "you can run some lua code in the sandbox" do
      state = Lua.init()
      assert {[2.0], _} = Lua.run(state, "return 1 + 1")
    end

    test "It can't run sandboxed things" do
      state = Lua.init()
      assert {:error, _} = Lua.run(state, "return os.getenv(\"HOME\")")
    end
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
      assert {"c", state} = Lua.read_from_table(state, ["a", "b"])

      {[], state} = Lua.run(state, "hello_table = { hello=\"world\" };")
      assert {"world", _state} = Lua.read_from_table(state, ["hello_table", "hello"])
    end
  end
end
