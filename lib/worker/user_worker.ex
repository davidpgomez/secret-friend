defmodule SecretFriends.Worker.UserWorker do
  use GenServer
  alias SecretFriends.Core.User
  alias SecretFriends.API.SFList

  def start_link({_name, nick} = user_args) when is_atom(nick) do
    GenServer.start_link(__MODULE__, user_args, name: nick)
  end

  @impl GenServer
  def init({name, nick}) do
    {:ok, User.new(name, nick)}
  end

  @impl GenServer
  def handle_call(:info, _from, %{name: name, nick: nick} = state) do
    {:reply, {name, nick}, state}
  end

  @impl GenServer
  def handle_call(:sflists, _from, %{sflists: sflists} = state) do
    {:reply, sflists, state}
  end

  @impl GenServer
  def handle_cast({:add_me_to, sflist_name}, %{nick: nick, sflists: sflists} = state) do
    sflists = [sflist_name | sflists]
    # We use API add_friend method to add the friend to the list.
    # This way we also take into account the list locked state
    case SFList.add_friend(sflist_name, nick) do
      :locked -> {:noreply, state}
      name    -> {:noreply, %{state | slists: [name | sflists]}}
    end
  end
end
