defmodule Virtual8086 do
  @moduledoc """
  Documentation for `Virtual8086`.
  """

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
    assembly = ["bits 16\n\n"]

    do_disassemble(assembly, binary_stream)
    |> Enum.join()
  end

  def do_disassemble(assembly, <<>>), do: assembly
  def do_disassemble(assembly, binary_stream) do
    <<instruction::16, rest::binary>> = binary_stream

    decode(<<instruction::16>>)
    |> append_to_assembly(assembly)
    |> do_disassemble(rest)
  end

  def decode(<<34::6, d_field::1, w_field::1, mode::2, register::3, rm::3>>) do
    "mov #{operands(d_field, w_field, mode, register, rm)}\n"
  end

  def decode(<<11::4, w_field::1, register::3, data::8>>) do
    "mov #{operands(w_field, register, data)}\n"
  end

  def append_to_assembly(instruction, assembly) do
    assembly ++ [instruction]
  end

  def operands(0, w_field, mode, register, rm) do
    "#{source_operand(w_field, mode, rm)}, #{destination_operand(w_field, register)}"
  end

  def operands(1, w_field, mode, register, rm) do
    "#{destination_operand(w_field, register)}, #{source_operand(w_field, mode, rm)}"
  end

  def operands(w_field, register, data) do
    "#{destination_operand(w_field, register)}, #{data}"
  end

  def destination_operand(0, register) do
    @byte_registers[binary_digits(register)]
  end

  def destination_operand(1, register) do
    @word_registers[binary_digits(register)]
  end

  def source_operand(0, 3, rm) do
    @byte_registers[binary_digits(rm)]
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
