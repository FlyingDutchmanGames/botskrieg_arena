defmodule BotskriegArena.Lua.Games.TicTacToeTest do
  use ExUnit.Case, async: true
  alias BotskriegArena.Lua.LuaGame
  alias TableTopEx.TicTacToe

  setup do
    %{game: TicTacToe.new()}
  end

  describe "for_role/2" do
    test "works", %{game: game} do
      assert %{
               "game" => %{
                 "me" => :x,
                 "board" => [
                   [nil, nil, nil],
                   [nil, nil, nil],
                   [nil, nil, nil]
                 ],
                 "available" => [
                   {0, 0},
                   {0, 1},
                   {0, 2},
                   {1, 0},
                   {1, 1},
                   {1, 2},
                   {2, 0},
                   {2, 1},
                   {2, 2}
                 ]
               }
             } == LuaGame.for_role(game, :x)
    end
  end

  describe "apply" do
    test "works with a valid move", %{game: game} do
      assert {:ok, game} = LuaGame.apply(game, :x, {0, 0})

      assert %{
               "game" => %{
                 "me" => :o,
                 "board" => [
                   [:x, nil, nil],
                   [nil, nil, nil],
                   [nil, nil, nil]
                 ]
               }
             } = LuaGame.for_role(game, :o)
    end
  end
end
