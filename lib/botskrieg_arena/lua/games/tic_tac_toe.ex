defimpl BotskriegArena.Lua.LuaGame, for: TableTopEx.TicTacToe do
  def apply!(%@for{} = ttt, marker, {_col, _row} = pos) do
    case @for.make_move(ttt, marker, pos) do
      :ok -> {:ok, ttt}
      err -> err
    end
  end

  def for_role(%@for{} = ttt, marker) when marker in [:x, :o] do
    %{
      "game" => %{
        "me" => marker,
        "board" => @for.board(ttt),
        "available" => @for.available(ttt)
      }
    }
  end
end
