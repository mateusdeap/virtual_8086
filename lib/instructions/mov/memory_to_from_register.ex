defmodule Instructions.Mov.MemoryToFromRegister do
  @behaviour Instruction

  @impl Instruction
  def decode(<<d_field::1, w_field::1, 0b0::2, register::3, rm::3, rest::bits>>) do
    %{assembly: "mov #{operands(d_field, w_field, 0b0, register, rm)}\n", remaining_binary: rest}
  end
  def decode(<<d_field::1, w_field::1, 0b1::2, register::3, rm::3, disp_lo::8, rest::bits>>) do
    %{assembly: "mov #{operands(d_field, w_field, 0b1, register, rm, disp_lo)}\n", remaining_binary: rest}
  end

  def operands(0b1, w_field, mode, register, rm) do
    "#{destination_operand(w_field, register)}, #{source_operand(mode, rm)}"
  end

  def operands(0b1, w_field, mode, register, rm, displacement) do
    "#{destination_operand(w_field, register)}, #{source_operand(mode, rm, displacement)}"
  end

  def destination_operand(0b0, register) do
    Virtual8086.byte_registers[BinaryUtilities.binary_digits(register)]
  end

  def destination_operand(0b1, register) do
    Virtual8086.word_registers[BinaryUtilities.binary_digits(register)]
  end

  def source_operand(0b0, rm) do
    Virtual8086.effective_addresses_memory_mode_no_displacement[BinaryUtilities.binary_digits(rm)]
  end

  def source_operand(0b1, rm, displacement) do
    effective_addresses_with_8_bit_displacement(rm, displacement)
  end

  defp effective_addresses_with_8_bit_displacement(rm, displacement) do
    "[#{Virtual8086.effective_addresses_memory_mode_8_bit_displacement[BinaryUtilities.binary_digits(rm)]} + #{displacement}]"
  end
end
