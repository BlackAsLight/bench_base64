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
    (local $x1 v128)
    (local $x2 v128)
    (local $x3 v128)
    (local $len i32)

    (local.set $o (i32.const 64))
    (local.set $len (i32.sub (global.get $len) (i32.const 48)))

    (loop $next (if (i32.lt_u (local.get $i) (local.get $len)) (then
      (local.set $x1 (v128.load (local.get $i)))
      (local.set $x2 (v128.load (i32.add (local.get $i) (i32.const 16))))
      (local.set $x3 (v128.load (i32.add (local.get $i) (i32.const 32))))
      (local.set $i (i32.add (local.get $i) (i32.const 48)))

      (;;) (i8x16.shuffle 6 5 4 0 9 8 7 0 12 11 10 0 15 14 13 0
        (local.get $x3)
        (v128.const i64x2 0 0)
      )
      (;;) (i8x16.shuffle 10 9 8 0 13 12 11 0 16 15 14 0 19 18 17 0
        (local.get $x2)
        (local.get $x3)
      )
      (;;) (i8x16.shuffle 14 13 12 0 17 16 15 0 20 19 18 0 23 22 21 0
        (local.get $x1)
        (local.get $x2)
      )
      (;;) (i8x16.shuffle 2 1 0 0 5 4 3 0 8 7 6 0 11 10 9 0
        (local.get $x1)
        (v128.const i64x2 0 0)
      )

      (local.set $o (call $encodeSIMD (;;) (local.get $o)))
      (local.set $o (call $encodeSIMD (;;) (local.get $o)))
      (local.set $o (call $encodeSIMD (;;) (local.get $o)))
      (local.set $o (call $encodeSIMD (;;) (local.get $o)))

      (br $next)
    )))

    (;;) (call $encode (local.get $i) (local.get $o))
  )

  (func $encodeSIMD (param $x v128) (param $o i32) (result i32)
    (;;) (v128.and
      (i32x4.shr_u (local.get $x) (i32.const 18))
      (v128.const i32x4 0x3F 0x3F 0x3F 0x3F)
    )
    (;;) (v128.and
      (i32x4.shr_u (local.get $x) (i32.const 4))
      (v128.const i32x4 0x3F00 0x3F00 0x3F00 0x3F00)
    )
    (;;) (v128.and
      (i32x4.shl (local.get $x) (i32.const 10))
      (v128.const i32x4 0x3F0000 0x3F0000 0x3F0000 0x3F0000)
    )
    (;;) (v128.and
      (i32x4.shl (local.get $x) (i32.const 24))
      (v128.const i32x4 0x3F000000 0x3F000000 0x3F000000 0x3F000000)
    )
    (local.set $x (v128.or (v128.or (;;) (;;)) (v128.or (;;) (;;))))

    (i32.store8
      (local.get $o)
      (i32.load8_u (i8x16.extract_lane_u 0 (local.get $x)))
    )
    (i32.store8
      (i32.add (local.get $o) (i32.const 1))
      (i32.load8_u (i8x16.extract_lane_u 1 (local.get $x)))
    )
    (i32.store8
      (i32.add (local.get $o) (i32.const 2))
      (i32.load8_u (i8x16.extract_lane_u 2 (local.get $x)))
    )
    (i32.store8
      (i32.add (local.get $o) (i32.const 3))
      (i32.load8_u (i8x16.extract_lane_u 3 (local.get $x)))
    )
    (i32.store8
      (i32.add (local.get $o) (i32.const 4))
      (i32.load8_u (i8x16.extract_lane_u 4 (local.get $x)))
    )
    (i32.store8
      (i32.add (local.get $o) (i32.const 5))
      (i32.load8_u (i8x16.extract_lane_u 5 (local.get $x)))
    )
    (i32.store8
      (i32.add (local.get $o) (i32.const 6))
      (i32.load8_u (i8x16.extract_lane_u 6 (local.get $x)))
    )
    (i32.store8
      (i32.add (local.get $o) (i32.const 7))
      (i32.load8_u (i8x16.extract_lane_u 7 (local.get $x)))
    )
    (i32.store8
      (i32.add (local.get $o) (i32.const 8))
      (i32.load8_u (i8x16.extract_lane_u 8 (local.get $x)))
    )
    (i32.store8
      (i32.add (local.get $o) (i32.const 9))
      (i32.load8_u (i8x16.extract_lane_u 9 (local.get $x)))
    )
    (i32.store8
      (i32.add (local.get $o) (i32.const 10))
      (i32.load8_u (i8x16.extract_lane_u 10 (local.get $x)))
    )
    (i32.store8
      (i32.add (local.get $o) (i32.const 11))
      (i32.load8_u (i8x16.extract_lane_u 11 (local.get $x)))
    )
    (i32.store8
      (i32.add (local.get $o) (i32.const 12))
      (i32.load8_u (i8x16.extract_lane_u 12 (local.get $x)))
    )
    (i32.store8
      (i32.add (local.get $o) (i32.const 13))
      (i32.load8_u (i8x16.extract_lane_u 13 (local.get $x)))
    )
    (i32.store8
      (i32.add (local.get $o) (i32.const 14))
      (i32.load8_u (i8x16.extract_lane_u 14 (local.get $x)))
    )
    (i32.store8
      (i32.add (local.get $o) (i32.const 15))
      (i32.load8_u (i8x16.extract_lane_u 15 (local.get $x)))
    )

    (;;) (i32.add (local.get $o) (i32.const 16))
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
