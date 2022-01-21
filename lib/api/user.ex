defmodule SecretFriends.API.User do
  alias SecretFriends.Worker.UserWorker
  alias SecretFriends.API.SFList

  def new(name, nick) do
    UserWorker.start_link({name, nick})
  end

  def sflists(nick) do
    GenServer.call(nick, :sflists)
  end

  def add_me_to(nick, sflist) do
    GenServer.cast(nick, {:add_me_to, sflist})
  end

  def secret_friend(nick, sflist) do
    sflist
    |> SFList.create_selection()
    |> find_me_in_sflist(nick)
  end

  def secret_friends(nick) do
    nick
    |> sflists()
    |> Enum.map(&{&1, secret_friend(nick, &1)})
  end

  defp find_me_in_sflist(selection, nick) do
    case Enum.find(selection, fn [pair_nick, _] -> pair_nick == nick end) do
      nil -> :not_found
      [^nick, name] -> name
    end
  end

end
