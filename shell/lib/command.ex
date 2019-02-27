defmodule Command do
  @callback init(term)
  :: {:ok, term}
  | {:error, term}

  @callback handle_prompt(term)
  :: Stting.t()
  | [String.t()]

  @callback handle_input(String.t(), state)
  :: {:ok, state}
  | {:error, term, state}
  when state: var

  def run(module, args) do
    case apply(module, :init, [args]) do
      {:ok, state} -> loop(module, state)

      error -> error
    end
  end

  def loop(module, state) do
    pid = apply(module, :handle_prompt, [state])
    |> get_input()

    process_input(pid, module, state)
    |> next(module, state)
  end

  def get_input(prompt) do
    command = self()
    spawn(fn->
      input = IO.gets(prompt) |> String.trim()
      send(command, {:input, input})
    end)
  end

  def process_input(pid, module, state) do
    receive do
      {:input, input} ->
        apply(module, :handle_input, [input, state])
    after
      :timer.seconds(10) ->
        Process.exit(pid, :kill)
        {:exit, :timeout, state}
    end
  end

  def next(:ok, module, state) do
    loop(module, state)
  end

  def next({:ok, state}, module, _) do
    loop(module, state)
  end

  def next({:exit, response, _}, _, _) do
    response
  end
end
