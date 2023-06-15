defmodule Virtual8086 do
  @moduledoc """
  Documentation for `Virtual8086`.
  """

  @mov 100010

  @opcode_map %{
    @mov => "mov"
  }

  @byte_registers %{
    000 => "al",
    001 => "cl",
    010 => "dl",
    011 => "bl",
    100 => "ah",
    101 => "ch",
    110 => "dh",
    111 => "bh",
  }

  @word_registers %{
    000 => "ax",
    001 => "cx",
    010 => "dx",
    011 => "bx",
    100 => "sp",
    101 => "bp",
    110 => "si",
    111 => "di",
  }

  def disassemble(binary_stream) do
    <<opcode::6, d_field::1, w_field::1, mode::2, register::3, rm::3>> = binary_stream

    """
    bits #{bit_size(binary_stream)}

    #{instruction(opcode)} #{operands(d_field, w_field, mode, register, rm)}
    """
  end

  def operands(0, w_field, mode, register, rm) do
    "#{source_operand(w_field, mode, rm)}, #{destination_operand(w_field, register)}"
  end

  def instruction(opcode) do
    @opcode_map[binary_digits(opcode)]
  end

  def destination_operand(1, register) do
    @word_registers[binary_digits(register)]
  end

  def source_operand(1, 3, rm) do
    @word_registers[binary_digits(rm)]
  end

  def binary_digits(binary_string) do
    binary_string
    |> Integer.digits(2)
    |> Integer.undigits()
  end
end
