defmodule TestSFList do
  use ExUnit.Case
  alias SecretFriends.Core.SFList
  doctest SFList

  test "SFList creation" do
    assert SFList.new() == []
  end

  test "Add friends" do
    sflist =
      SFList.new()
      |> SFList.add_friend("Pepe")
      |> SFList.add_friend("Juana")
      |> SFList.add_friend("Martino")

    assert sflist == ["Martino", "Juana", "Pepe"]
  end

  test "Create selection" do
    selection =
      SFList.new()
      |> SFList.add_friend("Pepe")
      |> SFList.add_friend("Juana")
      |> SFList.add_friend("Martino")
      |> SFList.create_selection()

    assert length(selection) == 3
    assert Enum.all?(selection, fn e -> Enum.at(e, 0) != Enum.at(e, 1) end)
    assert Enum.all?(selection, &(Enum.at(&1, 0) != Enum.at(&1, 1)))
    assert length(Enum.uniq_by(selection, &Enum.at(&1, 0))) == 3
    assert length(Enum.uniq_by(selection, &Enum.at(&1, 1))) == 3
  end
end
