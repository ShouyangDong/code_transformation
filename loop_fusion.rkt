#lang rosette

(define (merge-loops A B)
  (define (synthesize-code)
    (define i (fresh-constant 'i 'Int))
    (define j (fresh-constant 'j 'Int))
    (define i-limit (* 512 512)) ; 合并后的循环上限
    (define loop-body `(set! B ,(+ 'i (* 512 'j)) (+ (select A ,(+ 'i (* 512 'j))) 1.0)))
    `(for (int ,i 0 ,i-limit ++ ,i)
       ,@loop-body))

  (define (verify-code code)
    (define input `(,A ,B))
    (define output `(for (int i 0 512 ++ i)
                      (for (int j 0 512 ++ j)
                        (set! ,B (+ (select ,A (+ (* 512 ,i) ,j)) 1.0)))))
    (define (check-input-output input output)
      (define (check-equality a b)
        (equal? a b))
      (check-equality (eval code input) output))
    (assert (check-input-output input output)))

  (define (synthesize)
    (define code (synthesize-code))
    (define result (verify-code code))
    (match result
      ['unsat code]
      ['sat (synthesize)]))

  (synthesize))

(define A (fresh-constant 'A 'Array))
(define B (fresh-constant 'B 'Array))

(merge-loops A B)
