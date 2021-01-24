defimpl BotskriegArena.Lua.LuaGame, for: TableTopEx.TicTacToe do
  def apply(%@for{} = ttt, role, {_col, _row} = pos) do
    case @for.make_move(ttt, role, pos) do
      {:ok, ttt} -> {:ok, ttt}
      err -> err
    end
  end

  def for_role(%@for{} = ttt, role) when role in [:x, :o] do
    %{
      "game" => %{
        "me" => role,
        "board" => @for.board(ttt),
        "available" => @for.available(ttt)
      }
    }
  end
end
