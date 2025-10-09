This repo contains a few implementations of a base64 encoder and compares their performance to the native [`Uint8Array.toBase64()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Uint8Array/toBase64).

Since `Uint8Array.toBase64()` returns a string result, this benchmark compares the performance of a string and a uint8array as the desired result.

Excluding the native version, the implementation that provided the best performance was the wat simd version, which can be found in `wat_encoder.wat`.

If your desired result is a string then the native version outperformed the wat simd version by a factor of 7. If your desired result is a uint8array then the wat version outperformed the native version by a factor of 1.23.

`TextEncoder` and `TextDecoder` seem to have quite poor performance so picking an implementation that can skip their use seems to provide the best results. Ultimately it would be best for the native version to get an option for the result to by a Uint8Array instead of a string.

To run this benchmark yourself, you'll need to install Deno, Wabt, and Binaryen and then just `deno task bench`.
