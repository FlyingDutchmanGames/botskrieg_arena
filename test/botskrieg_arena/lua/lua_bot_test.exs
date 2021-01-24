defmodule BotskriegArena.Lua.LuaBotTest do
  use ExUnit.Case, async: true

  alias BotskriegArena.Lua.LuaBot

  describe "new/1" do
    test "you can make a new lua bot" do
      assert {:ok, %LuaBot{}} = LuaBot.new("return 1;")
    end
  end
end
