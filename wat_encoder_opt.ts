import {
  encode as e,
  encodeSIMD as eSIMD,
  memory,
} from "./wat_encoder_opt.wasm";

const buffer = new Uint8Array(memory.buffer);

export function encode(input: Uint8Array): Uint8Array<ArrayBuffer> {
  if (((input.length + 2) / 3 | 0) * 4 > 2 ** 16 * 342 - 64) {
    throw new RangeError("Input too Big!");
  }
  const i = buffer.length - input.length;
  buffer.set(input, i);
  return buffer.slice(64, e(i));
}

export function encodeSIMD(input: Uint8Array): Uint8Array<ArrayBuffer> {
  if (((input.length + 2) / 3 | 0) * 4 > 2 ** 16 * 342 - 64) {
    throw new RangeError("Input too Big!");
  }
  const i = buffer.length - input.length;
  buffer.set(input, i);
  return buffer.slice(64, eSIMD(i));
}
