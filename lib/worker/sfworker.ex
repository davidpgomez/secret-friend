defmodule SecretFriends.Worker.SFWorker do
  alias SecretFriends.Core.SFList

  # start server
  def start() do
    # MFA (module - function - arguments)
    spawn(__MODULE__, :loop, [{SFList.new(), nil}])
  end

  # handle_cast (msg, state) -> {:noreply, new_state}
  @spec handle_cast({:add_friend, any}, {any, any}) ::
          {:noreply, {nonempty_maybe_improper_list, nil}}
  def handle_cast({:add_friend, friend}, {sflist, _selection} = _state) do
    new_sflist = SFList.add_friend(sflist, friend)
    # invalidate previous selection when adding a friend
    {:noreply, {new_sflist, nil}}
  end

  # handle_call (msg, from, state) -> {:reply, response, new_state}
  def handle_call(:create_selection, _from, {sflist, nil} = _state) do
    new_selection = SFList.create_selection(sflist)
    {:reply, new_selection, {sflist, new_selection}}
  end

  # handle_call (msg, from, state) -> {:reply, response, new_state}
  def handle_call(:create_selection, _from, {_sflist, selection} = state) do
    {:reply, selection, state}
  end

  def handle_call(:show, _from, {sflist, _selection} = state) do
    {:reply, sflist, state}
  end

  # Configure process to wait for messages (as it were requests)
  def loop({_sflist, _selection} = state) do
    receive do
      {:cast, msg} ->
        {:noreply, new_state} = handle_cast(msg, state)
        loop(new_state)
      {:call, from, msg} ->
        {:reply, response, new_state} = handle_call(msg, from, state)
        send(from, {:response, response})
        loop(new_state)
    end
  end
end
