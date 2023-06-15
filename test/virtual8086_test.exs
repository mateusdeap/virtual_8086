defmodule Virtual8086Test do
  use ExUnit.Case
  doctest Virtual8086

  test "greets the world" do
    assert Virtual8086.hello() == :world
  end
end
