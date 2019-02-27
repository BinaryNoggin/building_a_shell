defmodule ShellTest do
  use ExUnit.Case
  doctest Shell

  test "greets the world" do
    assert Shell.hello() == :world
  end
end
