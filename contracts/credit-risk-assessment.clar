;; Credit Risk Assessment Contract
;; This contract evaluates payment reliability

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u403))

(define-map risk-scores
  { entity-id: uint, entity-type: (string-ascii 10) }
  {
    risk-score: uint,
    assessment-date: uint,
    payment-history-score: uint,
    financial-stability-score: uint,
    market-sector-risk: uint
  }
)

(define-public (assess-risk (entity-id uint) (entity-type (string-ascii 10))
                           (payment-history-score uint) (financial-stability-score uint)
                           (market-sector-risk uint))
  (let
    (
      ;; Calculate weighted risk score (lower is better)
      ;; 50% payment history, 30% financial stability, 20% market sector
      (weighted-payment (/ (* payment-history-score u50) u100))
      (weighted-financial (/ (* financial-stability-score u30) u100))
      (weighted-market (/ (* market-sector-risk u20) u100))
      (combined-risk-score (+ weighted-payment (+ weighted-financial weighted-market)))
    )
    (begin
      ;; Only allow contract owner to assess risk
      (asserts! (is-eq tx-sender contract-owner) err-owner-only)

      (map-set risk-scores
        { entity-id: entity-id, entity-type: entity-type }
        {
          risk-score: combined-risk-score,
          assessment-date: block-height,
          payment-history-score: payment-history-score,
          financial-stability-score: financial-stability-score,
          market-sector-risk: market-sector-risk
        }
      )
      (ok combined-risk-score)
    )
  )
)

(define-read-only (get-risk-score (entity-id uint) (entity-type (string-ascii 10)))
  (map-get? risk-scores { entity-id: entity-id, entity-type: entity-type })
)

(define-read-only (is-credit-worthy (entity-id uint) (entity-type (string-ascii 10)) (threshold uint))
  (match (map-get? risk-scores { entity-id: entity-id, entity-type: entity-type })
    risk-data (<= (get risk-score risk-data) threshold)
    false
  )
)
