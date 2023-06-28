defmodule Instructions.Mov.RegisterToRegister do
  @behaviour Instruction

  alias BinaryUtilities

  @impl Instruction
  def decode(<<d_field::1, w_field::1, mode::2, register::3, rm::3, rest::bits>>) do
    %{assembly: "mov #{operands(d_field, w_field, mode, register, rm)}\n", remaining_binary: rest}
  end

  def operands(0b1, w_field, mode, register, rm) do
    "#{destination_operand(w_field, register)}, #{source_operand(w_field, mode, rm)}"
  end

  def operands(0b0, w_field, mode, register, rm) do
    "#{source_operand(w_field, mode, rm)}, #{destination_operand(w_field, register)}"
  end

  def destination_operand(0b0, register) do
    Virtual8086.byte_registers[BinaryUtilities.binary_digits(register)]
  end

  def destination_operand(0b1, register) do
    Virtual8086.word_registers[BinaryUtilities.binary_digits(register)]
  end

  def source_operand(0b0, 0b011, rm) do
    Virtual8086.byte_registers[BinaryUtilities.binary_digits(rm)]
  end

  def source_operand(0b1, 0b011, rm) do
    Virtual8086.word_registers[BinaryUtilities.binary_digits(rm)]
  end
end