defmodule BotskriegArena.Lua.LuaBotTest do
  use ExUnit.Case, async: true
  alias BotskriegArena.Lua.LuaBot

  @middle_square_tic_tac_toe_ai """
  return 1, 1;
  """

  describe "new/1" do
    test "you can make a new lua bot" do
      assert {:ok, %LuaBot{}} = LuaBot.new("return 1;")
    end
  end

  describe "run/3" do
    test "You can run a turn of a game" do
      game = TableTopEx.TicTacToe.new()
      {:ok, %LuaBot{} = bot} = LuaBot.new(@middle_square_tic_tac_toe_ai)
      assert {:ok, result, %LuaBot{}} = LuaBot.run(bot, game, :x)
      assert result == [1.0, 1.0]
    end
  end
end
