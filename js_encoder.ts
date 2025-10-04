const alphabet = new Uint8Array(64);
const padding = "=".charCodeAt(0);
new TextEncoder()
  .encode("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/")
  .forEach((x, i) => alphabet[i] = x);

export function encode(input: Uint8Array): Uint8Array<ArrayBuffer> {
  const output = new Uint8Array(((input.length + 2) / 3 | 0) * 4);
  let o = 0;
  let i = 2;
  for (; i < input.length; i += 3) {
    const x = input[i - 2] << 16 | input[i - 1] << 8 | input[i];
    output[o++] = alphabet[x >> 18 & 0x3F];
    output[o++] = alphabet[x >> 12 & 0x3F];
    output[o++] = alphabet[x >> 6 & 0x3F];
    output[o++] = alphabet[x & 0x3F];
  }
  switch (i) {
    case input.length + 1: {
      const x = input[i - 2] << 16;
      output[o++] = alphabet[x >> 18 & 0x3F];
      output[o++] = alphabet[x >> 12 & 0x3F];
      output[o++] = padding;
      output[o++] = padding;
      break;
    }
    case input.length: {
      const x = input[i - 2] << 16 | input[i - 1] << 8;
      output[o++] = alphabet[x >> 18 & 0x3F];
      output[o++] = alphabet[x >> 12 & 0x3F];
      output[o++] = alphabet[x >> 6 & 0x3F];
      output[o++] = padding;
      break;
    }
  }
  return output;
}
