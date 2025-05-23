;; Supplier Verification Contract
;; This contract validates and manages supplier information

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u403))
(define-constant err-not-found (err u404))

(define-data-var suppliers-count uint u0)

(define-map suppliers
  uint
  {
    name: (string-ascii 100),
    address: (string-ascii 100),
    verified: bool,
    verification-date: uint,
    credit-score: uint
  }
)

(define-public (register-supplier (name (string-ascii 100)) (address (string-ascii 100)))
  (let
    (
      (supplier-id (var-get suppliers-count))
    )
    (begin
      (map-insert suppliers
        supplier-id
        {
          name: name,
          address: address,
          verified: false,
          verification-date: u0,
          credit-score: u0
        }
      )
      (var-set suppliers-count (+ supplier-id u1))
      (ok supplier-id)
    )
  )
)

(define-public (verify-supplier (supplier-id uint) (credit-score uint))
  (begin
    ;; Only allow contract owner to verify suppliers
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)

    ;; Check if supplier exists
    (asserts! (is-some (map-get? suppliers supplier-id)) err-not-found)

    ;; Update supplier verification status
    (map-set suppliers
      supplier-id
      (merge (unwrap-panic (map-get? suppliers supplier-id))
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

(define-read-only (get-supplier (supplier-id uint))
  (map-get? suppliers supplier-id)
)

(define-read-only (is-supplier-verified (supplier-id uint))
  (match (map-get? suppliers supplier-id)
    supplier (get verified supplier)
    false
  )
)
