;; Buyer Verification Contract
;; This contract validates and manages buyer information

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u403))
(define-constant err-not-found (err u404))

(define-data-var buyers-count uint u0)

(define-map buyers
  uint
  {
    name: (string-ascii 100),
    address: (string-ascii 100),
    verified: bool,
    verification-date: uint,
    credit-score: uint
  }
)

(define-public (register-buyer (name (string-ascii 100)) (address (string-ascii 100)))
  (let
    (
      (buyer-id (var-get buyers-count))
    )
    (begin
      (map-insert buyers
        buyer-id
        {
          name: name,
          address: address,
          verified: false,
          verification-date: u0,
          credit-score: u0
        }
      )
      (var-set buyers-count (+ buyer-id u1))
      (ok buyer-id)
    )
  )
)

(define-public (verify-buyer (buyer-id uint) (credit-score uint))
  (begin
    ;; Only allow contract owner to verify buyers
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)

    ;; Check if buyer exists
    (asserts! (is-some (map-get? buyers buyer-id)) err-not-found)

    ;; Update buyer verification status
    (map-set buyers
      buyer-id
      (merge (unwrap-panic (map-get? buyers buyer-id))
        {
          verified: true,
          verification-date: block-height,
          credit-score: credit-score
        }
      )
    )
    (ok true)
  )
)

(define-read-only (get-buyer (buyer-id uint))
  (map-get? buyers buyer-id)
)

(define-read-only (is-buyer-verified (buyer-id uint))
  (match (map-get? buyers buyer-id)
    buyer (get verified buyer)
    false
  )
)
