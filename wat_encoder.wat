(module
  (memory (export "memory") 342)
  (global $len i32 (i32.const 22413312)) ;; 2 ** 16 * 342

  (global $padding i32 (i32.const 61))

  (data
    (i32.const 0)
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
  )

  (func (export "encode") (param $i i32) (result i32)
    (call $encode (local.get $i) (i32.const 64))
  )

  (func (export "encodeSIMD") (param $i i32) (result i32)
    (local $o i32)
    (local $x v128)
    (local $len i32)

    (local.set $o (i32.const 64))
    (local.set $len (i32.sub (global.get $len) (i32.const 16)))

    (loop $next (if (i32.lt_u (local.get $i) (local.get $len)) (then
      (;;) (v128.load (local.get $i))
      (;;) (v128.const i64x2 0 0)
      (;;) (i8x16.shuffle 2 1 0 0 5 4 3 3 8 7 6 6 11 10 9 9 (;;) (;;))
      (local.set $x (;;))

      (call $store (local.get $o) (local.get $x) (i32.const 18))
      (call $store
        (i32.add (local.get $o) (i32.const 1))
        (local.get $x)
        (i32.const 12)
      )
      (call $store
        (i32.add (local.get $o) (i32.const 2))
        (local.get $x)
        (i32.const 6)
      )
      (call $store
        (i32.add (local.get $o) (i32.const 3))
        (local.get $x)
        (i32.const 0)
      )

      (local.set $o (i32.add (local.get $o) (i32.const 16)))
      (local.set $i (i32.add (local.get $i) (i32.const 12)))
      (br $next)
    )))

    (;;) (call $encode (local.get $i) (local.get $o))
  )

  (func $store (param $o i32) (param $x v128) (param $shr i32) (result i32)
    (local $y v128)

    (;;) (v128.and
      (i32x4.shr_u (local.get $x) (local.get $shr))
      (v128.const i32x4 0x3F 0x3F 0x3F 0x3F)
    )
    (local.set $y (;;))

    (i32.store8
      (local.get $o)
      (i32.load8_u (i32x4.extract_lane 0 (local.get $y)))
    )
    (i32.store8
      (i32.add (local.get $o) (i32.const 4))
      (i32.load8_u (i32x4.extract_lane 1 (local.get $y)))
    )
    (i32.store8
      (i32.add (local.get $o) (i32.const 8))
      (i32.load8_u (i32x4.extract_lane 2 (local.get $y)))
    )
    (i32.store8
      (i32.add (local.get $o) (i32.const 12))
      (i32.load8_u (i32x4.extract_lane 3 (local.get $y)))
    )

    (return (i32.add (local.get $o) (i32.const 4)))
  )

  (func $encode (param $i i32) (param $o i32) (result i32)
    (local $x i32)

    (local.set $i (i32.add (local.get $i) (i32.const 2)))

    (loop $next (if (i32.lt_u (local.get $i) (global.get $len)) (then
      (;;) (i32.load8_u (i32.sub (local.get $i) (i32.const 2)))
      (;;) (i32.shl (;;) (i32.const 16))
      (;;) (i32.load8_u (i32.sub (local.get $i) (i32.const 1)))
      (;;) (i32.shl (;;) (i32.const 8))
      (;;) (i32.load8_u (local.get $i))
      (;;) (i32.or (;;) (i32.or (;;) (;;)))
      (local.set $x (;;))
      (local.set $i (i32.add (local.get $i) (i32.const 3)))

      (i32.store8
        (local.get $o)
        (i32.load8_u
          (i32.and (i32.shr_u (local.get $x) (i32.const 18)) (i32.const 63))
        )
      )
      (i32.store8
        (i32.add (local.get $o) (i32.const 1))
        (i32.load8_u
          (i32.and (i32.shr_u (local.get $x) (i32.const 12)) (i32.const 63))
        )
      )
      (i32.store8
        (i32.add (local.get $o) (i32.const 2))
        (i32.load8_u
          (i32.and (i32.shr_u (local.get $x) (i32.const 6)) (i32.const 63))
        )
      )
      (i32.store8
        (i32.add (local.get $o) (i32.const 3))
        (i32.load8_u (i32.and (local.get $x) (i32.const 63)))
      )

      (local.set $o (i32.add (local.get $o) (i32.const 4)))
      (br $next)
    )))

    (if (i32.eq (local.get $i) (i32.add (global.get $len) (i32.const 1))) (then
      (;;) (i32.load8_u (i32.sub (local.get $i) (i32.const 2)))
      (;;) (i32.shl (;;) (i32.const 16))
      (local.set $x (;;))

      (i32.store8
        (local.get $o)
        (i32.load8_u
          (i32.and (i32.shr_u (local.get $x) (i32.const 18)) (i32.const 63))
        )
      )
      (i32.store8
        (i32.add (local.get $o) (i32.const 1))
        (i32.load8_u
          (i32.and (i32.shr_u (local.get $x) (i32.const 12)) (i32.const 63))
        )
      )
      (i32.store8
        (i32.add (local.get $o) (i32.const 2))
        (global.get $padding)
      )
      (i32.store8
        (i32.add (local.get $o) (i32.const 3))
        (global.get $padding)
      )

      (return (i32.add (local.get $o) (i32.const 4)))
    ))
    (if (i32.eq (local.get $i) (global.get $len)) (then
      (;;) (i32.load8_u (i32.sub (local.get $i) (i32.const 2)))
      (;;) (i32.shl (;;) (i32.const 16))
      (;;) (i32.load8_u (i32.sub (local.get $i) (i32.const 1)))
      (;;) (i32.shl (;;) (i32.const 8))
      (;;) (i32.or (;;) (;;))
      (local.set $x (;;))

      (i32.store8
        (local.get $o)
        (i32.load8_u
          (i32.and (i32.shr_u (local.get $x) (i32.const 18)) (i32.const 63))
        )
      )
      (i32.store8
        (i32.add (local.get $o) (i32.const 1))
        (i32.load8_u
          (i32.and (i32.shr_u (local.get $x) (i32.const 12)) (i32.const 63))
        )
      )
      (i32.store8
        (i32.add (local.get $o) (i32.const 2))
        (i32.load8_u
          (i32.and (i32.shr_u (local.get $x) (i32.const 6)) (i32.const 63))
        )
      )
      (i32.store8
        (i32.add (local.get $o) (i32.const 3))
        (global.get $padding)
      )

      (return (i32.add (local.get $o) (i32.const 4)))
    ))

    (;;) (local.get $o)
  )
)
