defmodule BotskriegArena.LuaTest do
  use ExUnit.Case, async: true
  alias BotskriegArena.Lua

  @infinite_lua_loop """
  while true do
    foo = 1 + 1
  end
  """

  @run_out_of_memory_lua_script """
  i = 0
  some_table = {}
  while true do
    i = i + 1
    some_table[i] = i
  end
  """

  test "You can make a new one" do
    assert %Lua.State{} = Lua.init_sandboxed()
  end

  describe "run_sandboxed" do
    test "you can run some lua code in the sandbox" do
      state = Lua.init_sandboxed()
      assert {[2.0], _} = Lua.run_sandboxed(state, "return 1 + 1")
    end

    test "it can't run sandboxed things" do
      state = Lua.init_sandboxed()

      assert {:error, {:lua_error, {:undef_function, "sandboxed"}, _}} =
               Lua.run_sandboxed(state, "return os.getenv(\"HOME\")")
    end

    test "You can set the max heap size" do
      state = Lua.init_sandboxed()
      # As of Jan 21 2021 there isn't a way to detect if a timeout is from running
      # out of memory or from running out of time, it does blow up when it
      # runs out of memory on the heap though!
      assert {:error, :timeout} =
               Lua.run_sandboxed(state, @run_out_of_memory_lua_script, %{
                 max_reductions: 0,
                 max_heap_size: 1000,
                 timeout: 100
               })
    end

    test "you can exhaust your reductions" do
      state = Lua.init_sandboxed()

      assert {:error, {:reductions, _}} =
               Lua.run_sandboxed(state, @infinite_lua_loop, %{max_reductions: 100})
    end

    test "you can set the timeout" do
      state = Lua.init_sandboxed()

      assert {:error, :timeout} ==
               Lua.run_sandboxed(state, @infinite_lua_loop, %{timeout: 1, max_reductions: 0})
    end
  end

  describe "set_on_table/read_from_table" do
    test "you can set and read from a table from elixir" do
      state = Lua.init_sandboxed()
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

      {[], state} = Lua.run_sandboxed(state, "hello_table = { hello=\"world\" };")
      assert {"world", _state} = Lua.read_from_table(state, ["hello_table", "hello"])
    end
  end
end
