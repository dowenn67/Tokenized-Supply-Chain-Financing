;; Invoice Verification Contract
;; This contract records and validates invoice documents

(define-constant contract-owner tx-sender)
(define-constant err-supplier-not-verified (err u401))
(define-constant err-buyer-not-verified (err u402))
(define-constant err-owner-only (err u403))
(define-constant err-not-found (err u404))

(define-data-var invoices-count uint u0)

(define-map invoices
  uint
  {
    supplier-id: uint,
    buyer-id: uint,
    amount: uint,
    due-date: uint,
    verified: bool,
    paid: bool,
    financed: bool,
    creation-date: uint
  }
)

;; For simplicity, we'll use internal verification instead of contract calls
;; In a real implementation, you would use contract-call? to other contracts
(define-map verified-suppliers uint bool)
(define-map verified-buyers uint bool)

(define-public (add-verified-supplier (supplier-id uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (map-set verified-suppliers supplier-id true)
    (ok true)
  )
)

(define-public (add-verified-buyer (buyer-id uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (map-set verified-buyers buyer-id true)
    (ok true)
  )
)

(define-public (create-invoice (supplier-id uint) (buyer-id uint) (amount uint) (due-date uint))
  (let
    (
      (invoice-id (var-get invoices-count))
    )
    (begin
      ;; Check if supplier and buyer are verified
      (asserts! (default-to false (map-get? verified-suppliers supplier-id)) err-supplier-not-verified)
      (asserts! (default-to false (map-get? verified-buyers buyer-id)) err-buyer-not-verified)

      (map-insert invoices
        invoice-id
        {
          supplier-id: supplier-id,
          buyer-id: buyer-id,
          amount: amount,
          due-date: due-date,
          verified: false,
          paid: false,
          financed: false,
          creation-date: block-height
        }
      )
      (var-set invoices-count (+ invoice-id u1))
      (ok invoice-id)
    )
  )
)

(define-public (verify-invoice (invoice-id uint))
  (begin
    ;; Only allow contract owner to verify invoices
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)

    ;; Check if invoice exists
    (asserts! (is-some (map-get? invoices invoice-id)) err-not-found)

    ;; Update invoice verification status
    (map-set invoices
      invoice-id
      (merge (unwrap-panic (map-get? invoices invoice-id))
        {
          verified: true
        }
      )
    )
    (ok true)
  )
)

(define-public (mark-invoice-paid (invoice-id uint))
  (begin
    ;; Only allow contract owner to mark as paid
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)

    ;; Check if invoice exists
    (asserts! (is-some (map-get? invoices invoice-id)) err-not-found)

    ;; Update invoice paid status
    (map-set invoices
      invoice-id
      (merge (unwrap-panic (map-get? invoices invoice-id))
        {
          paid: true
        }
      )
    )
    (ok true)
  )
)

(define-public (mark-invoice-financed (invoice-id uint))
  (begin
    ;; Only allow contract owner to mark as financed
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)

    ;; Check if invoice exists
    (asserts! (is-some (map-get? invoices invoice-id)) err-not-found)

    ;; Update invoice financed status
    (map-set invoices
      invoice-id
      (merge (unwrap-panic (map-get? invoices invoice-id))
        {
          financed: true
        }
      )
    )
    (ok true)
  )
)

(define-read-only (get-invoice (invoice-id uint))
  (map-get? invoices invoice-id)
)

(define-read-only (is-invoice-verified (invoice-id uint))
  (match (map-get? invoices invoice-id)
    invoice (get verified invoice)
    false
  )
)

(define-read-only (is-invoice-paid (invoice-id uint))
  (match (map-get? invoices invoice-id)
    invoice (get paid invoice)
    false
  )
)

(define-read-only (is-invoice-financed (invoice-id uint))
  (match (map-get? invoices invoice-id)
    invoice (get financed invoice)
    false
  )
)
