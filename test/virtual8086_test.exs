defmodule Virtual8086Test do
  use ExUnit.Case
  doctest Virtual8086

  test "dissassembles single mov from register to register" do
    compiled_binary = File.read!("test/single_instruction")
    assert Virtual8086.disassemble(compiled_binary) == """
    bits 16

    mov cx, bx
    """
  end
end
