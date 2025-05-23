import { describe, it, expect, beforeEach } from "vitest"

// Mock Clarity contract environment
const mockContractEnv = {
  blockHeight: 100,
  txSender: "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM",
  contractOwner: "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM",
  
  // Mock storage
  storage: {
    financingRecords: new Map(),
    financingCount: 0,
    tokenBalances: new Map(),
  },
  
  // Mock contract calls to other contracts
  contractCalls: {
    isInvoiceVerified: (invoiceId) => {
      // For testing, assume all invoices with ID > 0 are verified
      return invoiceId > 0
    },
    isInvoiceFinanced: (invoiceId) => {
      // For testing, assume no invoices are initially financed
      return false
    },
    markInvoiceFinanced: (invoiceId) => {
      // Mock successful call
      return { value: true }
    },
  },
  
  // Mock contract functions
  requestFinancing: function (invoiceId, amount, interestRate, maturityDate, supplier) {
    // Check if invoice is verified and not already financed
    if (!this.contractCalls.isInvoiceVerified(invoiceId)) {
      return { error: 401 }
    }
    if (this.contractCalls.isInvoiceFinanced(invoiceId)) {
      return { error: 402 }
    }
    
    // Check if caller is a funder (contract owner in this mock)
    if (this.txSender !== this.contractOwner) {
      return { error: 403 }
    }
    
    const financingId = this.storage.financingCount
    
    this.storage.financingRecords.set(financingId, {
      invoiceId,
      amount,
      interestRate,
      maturityDate,
      status: "requested",
      funder: this.txSender,
      supplier,
      creationDate: this.blockHeight,
    })
    
    this.storage.financingCount++
    return { value: financingId }
  },
  
  approveFinancing: function (financingId) {
    if (!this.storage.financingRecords.has(financingId)) {
      return { error: 404 }
    }
    
    const financing = this.storage.financingRecords.get(financingId)
    
    // Check if caller is the funder
    if (financing.funder !== this.txSender) {
      return { error: 403 }
    }
    
    // Check if status is "requested"
    if (financing.status !== "requested") {
      return { error: 405 }
    }
    
    // Mark invoice as financed
    const markInvoiceResult = this.contractCalls.markInvoiceFinanced(financing.invoiceId)
    if (markInvoiceResult.error) {
      return { error: 406 }
    }
    
    financing.status = "approved"
    this.storage.financingRecords.set(financingId, financing)
    
    // Mint tokens to supplier
    this.ftMint(financing.amount, financing.supplier)
    
    return { value: true }
  },
  
  repayFinancing: function (financingId) {
    if (!this.storage.financingRecords.has(financingId)) {
      return { error: 404 }
    }
    
    const financing = this.storage.financingRecords.get(financingId)
    
    // Check if caller is the supplier
    if (financing.supplier !== this.txSender) {
      return { error: 403 }
    }
    
    // Check if status is "approved"
    if (financing.status !== "approved") {
      return { error: 405 }
    }
    
    // Calculate repayment amount
    const repaymentAmount = financing.amount + Math.floor((financing.amount * financing.interestRate) / 10000)
    
    // Check if supplier has enough tokens
    const supplierBalance = this.getTokenBalance(financing.supplier)
    if (supplierBalance < repaymentAmount) {
      return { error: 409 }
    }
    
    // Burn tokens from supplier
    this.ftBurn(repaymentAmount, financing.supplier)
    
    financing.status = "repaid"
    this.storage.financingRecords.set(financingId, financing)
    
    return { value: true }
  },
  
  getFinancing: function (financingId) {
    return this.storage.financingRecords.get(financingId) || null
  },
  
  getRepaymentAmount: function (financingId) {
    if (!this.storage.financingRecords.has(financingId)) {
      return { error: 404 }
    }
    
    const financing = this.storage.financingRecords.get(financingId)
    const repaymentAmount = financing.amount + Math.floor((financing.amount * financing.interestRate) / 10000)
    
    return { value: repaymentAmount }
  },
  
  // Helper functions for token operations
  ftMint: function (amount, recipient) {
    const currentBalance = this.getTokenBalance(recipient)
    this.storage.tokenBalances.set(recipient, currentBalance + amount)
    return true
  },
  
  ftBurn: function (amount, sender) {
    const currentBalance = this.getTokenBalance(sender)
    if (currentBalance < amount) {
      return false
    }
    this.storage.tokenBalances.set(sender, currentBalance - amount)
    return true
  },
  
  getTokenBalance: function (account) {
    return this.storage.tokenBalances.get(account) || 0
  },
}

describe("Funding Contract", () => {
  beforeEach(() => {
    // Reset the mock environment
    mockContractEnv.storage.financingRecords = new Map()
    mockContractEnv.storage.financingCount = 0
    mockContractEnv.storage.tokenBalances = new Map()
    mockContractEnv.blockHeight = 100
    mockContractEnv.txSender = mockContractEnv.contractOwner
  })
  
  it("should request financing for a verified invoice", () => {
    const supplier = "ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG"
    const result = mockContractEnv.requestFinancing(1, 1000, 500, 200, supplier)
    
    expect(result.value).toBe(0)
    expect(mockContractEnv.storage.financingCount).toBe(1)
    
    const financing = mockContractEnv.getFinancing(0)
    expect(financing).not.toBeNull()
    expect(financing.invoiceId).toBe(1)
    expect(financing.amount).toBe(1000)
    expect(financing.interestRate).toBe(500) // 5%
    expect(financing.maturityDate).toBe(200)
    expect(financing.status).toBe("requested")
    expect(financing.funder).toBe(mockContractEnv.contractOwner)
    expect(financing.supplier).toBe(supplier)
    expect(financing.creationDate).toBe(100)
  })
  
  it("should not request financing for an unverified invoice", () => {
    const supplier = "ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG"
    const result = mockContractEnv.requestFinancing(0, 1000, 500, 200, supplier)
    
    expect(result.error).toBe(401)
    expect(mockContractEnv.storage.financingCount).toBe(0)
  })
  
  it("should approve financing", () => {
    const supplier = "ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG"
    const financingId = mockContractEnv.requestFinancing(1, 1000, 500, 200, supplier).value
    
    // Approve the financing
    const result = mockContractEnv.approveFinancing(financingId)
    
    expect(result.value).toBe(true)
    
    const financing = mockContractEnv.getFinancing(financingId)
    expect(financing.status).toBe("approved")
    
    // Check that tokens were minted to the supplier
    expect(mockContractEnv.getTokenBalance(supplier)).toBe(1000)
  })
  
  it("should not approve financing if not the funder", () => {
    const supplier = "ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG"
    const financingId = mockContractEnv.requestFinancing(1, 1000, 500, 200, supplier).value
    
    // Change the tx sender
    mockContractEnv.txSender = "ST3NBRSFKX28FQ2ZJ1MAKX58HKHSDGNV5NH7B0M3"
    
    // Try to approve the financing
    const result = mockContractEnv.approveFinancing(financingId)
    
    expect(result.error).toBe(403)
    
    const financing = mockContractEnv.getFinancing(financingId)
    expect(financing.status).toBe("requested")
    
    // Check that no tokens were minted
    expect(mockContractEnv.getTokenBalance(supplier)).toBe(0)
  })
  
  it("should calculate repayment amount correctly", () => {
    const supplier = "ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG"
    const financingId = mockContractEnv.requestFinancing(1, 1000, 500, 200, supplier).value
    
    const result = mockContractEnv.getRepaymentAmount(financingId)
    
    // 1000 + 5% interest = 1050
    expect(result.value).toBe(1050)
  })
})
