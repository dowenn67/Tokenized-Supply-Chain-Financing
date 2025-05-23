;; Funding Contract
;; This contract manages early payment financing

(define-constant contract-owner tx-sender)
(define-constant err-invoice-not-verified (err u401))
(define-constant err-invoice-already-financed (err u402))
(define-constant err-not-funder (err u403))
(define-constant err-not-found (err u404))
(define-constant err-invalid-status (err u405))
(define-constant err-invoice-mark-failed (err u406))
(define-constant err-mint-failed (err u407))
(define-constant err-repayment-calc-failed (err u408))
(define-constant err-burn-failed (err u409))

;; Define the fungible token
(define-fungible-token supply-chain-token)

(define-data-var financing-count uint u0)

(define-map financing-records
  uint
  {
    invoice-id: uint,
    amount: uint,
    interest-rate: uint,
    maturity-date: uint,
    status: (string-ascii 20),
    funder: principal,
    supplier: principal,
    creation-date: uint
  }
)

;; For simplicity, we'll use internal verification instead of contract calls
(define-map verified-invoices uint bool)
(define-map financed-invoices uint bool)

(define-public (add-verified-invoice (invoice-id uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-not-funder)
    (map-set verified-invoices invoice-id true)
    (ok true)
  )
)

(define-public (request-financing (invoice-id uint) (amount uint) (interest-rate uint) (maturity-date uint) (supplier principal))
  (let
    (
      (financing-id (var-get financing-count))
    )
    (begin
      ;; Check if invoice exists and is verified but not already financed
      (asserts! (default-to false (map-get? verified-invoices invoice-id)) err-invoice-not-verified)
      (asserts! (not (default-to false (map-get? financed-invoices invoice-id))) err-invoice-already-financed)

      ;; Only allow contract owner to request financing (simplified)
      (asserts! (is-eq tx-sender contract-owner) err-not-funder)

      (map-insert financing-records
        financing-id
        {
          invoice-id: invoice-id,
          amount: amount,
          interest-rate: interest-rate,
          maturity-date: maturity-date,
          status: "requested",
          funder: tx-sender,
          supplier: supplier,
          creation-date: block-height
        }
      )
      (var-set financing-count (+ financing-id u1))
      (ok financing-id)
    )
  )
)

(define-public (approve-financing (financing-id uint))
  (let
    (
      (financing-record (unwrap! (map-get? financing-records financing-id) err-not-found))
    )
    (begin
      ;; Only allow the funder who created the request to approve it
      (asserts! (is-eq tx-sender (get funder financing-record)) err-not-funder)

      ;; Check if the status is "requested"
      (asserts! (is-eq (get status financing-record) "requested") err-invalid-status)

      ;; Update financing status
      (map-set financing-records
        financing-id
        (merge financing-record
          {
            status: "approved"
          }
        )
      )

      ;; Mark invoice as financed
      (map-set financed-invoices (get invoice-id financing-record) true)

      ;; Mint tokens to the supplier
      (unwrap! (ft-mint? supply-chain-token (get amount financing-record) (get supplier financing-record)) err-mint-failed)

      (ok true)
    )
  )
)

(define-public (repay-financing (financing-id uint))
  (let
    (
      (financing-record (unwrap! (map-get? financing-records financing-id) err-not-found))
      (repayment-amount (unwrap! (get-repayment-amount-internal financing-id) err-repayment-calc-failed))
    )
    (begin
      ;; Only allow the supplier to repay
      (asserts! (is-eq tx-sender (get supplier financing-record)) err-not-funder)

      ;; Check if the status is "approved"
      (asserts! (is-eq (get status financing-record) "approved") err-invalid-status)

      ;; Burn tokens from the supplier (repayment)
      (unwrap! (ft-burn? supply-chain-token repayment-amount tx-sender) err-burn-failed)

      ;; Update financing status
      (map-set financing-records
        financing-id
        (merge financing-record
          {
            status: "repaid"
          }
        )
      )

      (ok true)
    )
  )
)

(define-read-only (get-financing (financing-id uint))
  (map-get? financing-records financing-id)
)

(define-read-only (get-repayment-amount (financing-id uint))
  (get-repayment-amount-internal financing-id)
)

(define-private (get-repayment-amount-internal (financing-id uint))
  (match (map-get? financing-records financing-id)
    financing-record
      (let
        (
          (principal-amount (get amount financing-record))
          (interest-rate (get interest-rate financing-record))
          ;; Calculate interest: principal * rate / 10000 (for basis points)
          (interest-amount (/ (* principal-amount interest-rate) u10000))
        )
        (ok (+ principal-amount interest-amount))
      )
    err-not-found
  )
)
