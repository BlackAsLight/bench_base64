import { assertEquals } from "@std/assert";
import { encode as JSEncode } from "./js_encoder.ts";
import {
  encode as WatEncode,
  encodeSIMD as WatSIMDEncode,
} from "./wat_encoder.ts";
import {
  encode as WatEncodeOpt,
  encodeSIMD as WatSIMDEncodeOpt,
} from "./wat_encoder_opt.ts";

const decode = function () {
  const decoder = new TextDecoder();
  return decoder.decode.bind(decoder);
}();
const [encode, encodeInto] = function () {
  const encoder = new TextEncoder();
  return [encoder.encode.bind(encoder), encoder.encodeInto.bind(encoder)];
}();

Deno.test("JSEncode", function () {
  for (let i = 0; i <= 24; ++i) {
    const input = new Uint8Array(2 ** i - 1).map(() => Math.random() * 256);
    assertEquals(decode(JSEncode(input)), input.toBase64(), i.toString());
  }
});

Deno.test("WatEncode", function () {
  for (let i = 0; i <= 24; ++i) {
    const input = new Uint8Array(2 ** i - 1).map(() => Math.random() * 256);
    assertEquals(decode(WatEncode(input)), input.toBase64(), i.toString());
  }
});

Deno.test("WatSIMDEncode", function () {
  for (let i = 0; i <= 24; ++i) {
    const input = new Uint8Array(2 ** i - 1).map(() => Math.random() * 256);
    assertEquals(decode(WatSIMDEncode(input)), input.toBase64(), i.toString());
  }
});

Deno.test("WatEncodeOpt", function () {
  for (let i = 0; i <= 24; ++i) {
    const input = new Uint8Array(2 ** i - 1).map(() => Math.random() * 256);
    assertEquals(decode(WatEncodeOpt(input)), input.toBase64(), i.toString());
  }
});

Deno.test("WatSIMDEncodeOpt", function () {
  for (let i = 0; i <= 24; ++i) {
    const input = new Uint8Array(2 ** i - 1).map(() => Math.random() * 256);
    assertEquals(
      decode(WatSIMDEncodeOpt(input)),
      input.toBase64(),
      i.toString(),
    );
  }
});

for (let i = 0; i <= 24; ++i) {
  const input = new Uint8Array(2 ** i - 1).map(() => Math.random() * 256);

  Deno.bench("Native", { group: `Len:${2 ** i - 1}|Buffer` }, function () {
    encodeInto(
      input.toBase64(),
      new Uint8Array(((input.length + 2) / 3 | 0) * 4),
    );
  });

  Deno.bench("JSEncode", { group: `Len:${2 ** i - 1}|Buffer` }, function () {
    JSEncode(input);
  });

  Deno.bench("WatEncode", { group: `Len:${2 ** i - 1}|Buffer` }, function () {
    WatEncode(input);
  });

  Deno.bench(
    "WatSIMDEncode",
    { group: `Len:${2 ** i - 1}|Buffer` },
    function () {
      WatSIMDEncode(input);
    },
  );

  Deno.bench(
    "WatEncodeOpt",
    { group: `Len:${2 ** i - 1}|Buffer` },
    function () {
      WatEncodeOpt(input);
    },
  );

  Deno.bench(
    "WatSIMDEncodeOpt",
    { group: `Len:${2 ** i - 1}|Buffer` },
    function () {
      WatSIMDEncodeOpt(input);
    },
  );
}

for (let i = 0; i <= 24; ++i) {
  const input = new Uint8Array(2 ** i - 1).map(() => Math.random() * 256);

  Deno.bench("Native", { group: `Len:${2 ** i - 1}|String` }, function () {
    input.toBase64();
  });

  Deno.bench("JSEncode", { group: `Len:${2 ** i - 1}|String` }, function () {
    decode(JSEncode(input));
  });

  Deno.bench("WatEncode", { group: `Len:${2 ** i - 1}|String` }, function () {
    decode(WatEncode(input));
  });

  Deno.bench(
    "WatSIMDEncode",
    { group: `Len:${2 ** i - 1}|String` },
    function () {
      decode(WatSIMDEncode(input));
    },
  );

  Deno.bench(
    "WatEncodeOpt",
    { group: `Len:${2 ** i - 1}|String` },
    function () {
      decode(WatEncodeOpt(input));
    },
  );

  Deno.bench(
    "WatSIMDEncodeOpt",
    { group: `Len:${2 ** i - 1}|String` },
    function () {
      decode(WatSIMDEncodeOpt(input));
    },
  );
}
