import { describe, it, expect, beforeEach } from "vitest"

// Mock Clarity contract environment
const mockContractEnv = {
  blockHeight: 100,
  txSender: "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM",
  contractOwner: "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM",
  
  // Mock storage
  storage: {
    suppliers: new Map(),
    suppliersCount: 0,
  },
  
  // Mock contract functions
  registerSupplier: function (name, address) {
    const supplierId = this.storage.suppliersCount
    
    this.storage.suppliers.set(supplierId, {
      name,
      address,
      verified: false,
      verificationDate: 0,
      creditScore: 0,
    })
    
    this.storage.suppliersCount++
    return { value: supplierId }
  },
  
  verifySupplier: function (supplierId, creditScore) {
    // Check if caller is contract owner
    if (this.txSender !== this.contractOwner) {
      return { error: 403 }
    }
    
    if (!this.storage.suppliers.has(supplierId)) {
      return { error: 404 }
    }
    
    const supplier = this.storage.suppliers.get(supplierId)
    supplier.verified = true
    supplier.verificationDate = this.blockHeight
    supplier.creditScore = creditScore
    
    this.storage.suppliers.set(supplierId, supplier)
    return { value: true }
  },
  
  getSupplier: function (supplierId) {
    return this.storage.suppliers.get(supplierId) || null
  },
  
  isSupplierVerified: function (supplierId) {
    const supplier = this.storage.suppliers.get(supplierId)
    return supplier ? supplier.verified : false
  },
}

describe("Supplier Verification Contract", () => {
  beforeEach(() => {
    // Reset the mock environment
    mockContractEnv.storage.suppliers = new Map()
    mockContractEnv.storage.suppliersCount = 0
    mockContractEnv.blockHeight = 100
    mockContractEnv.txSender = mockContractEnv.contractOwner
  })
  
  it("should register a new supplier", () => {
    const result = mockContractEnv.registerSupplier("Test Supplier", "123 Main St")
    
    expect(result.value).toBe(0)
    expect(mockContractEnv.storage.suppliersCount).toBe(1)
    
    const supplier = mockContractEnv.getSupplier(0)
    expect(supplier).not.toBeNull()
    expect(supplier.name).toBe("Test Supplier")
    expect(supplier.address).toBe("123 Main St")
    expect(supplier.verified).toBe(false)
  })
  
  it("should verify a supplier when called by contract owner", () => {
    // First register a supplier
    const supplierId = mockContractEnv.registerSupplier("Test Supplier", "123 Main St").value
    
    // Verify the supplier
    const result = mockContractEnv.verifySupplier(supplierId, 85)
    
    expect(result.value).toBe(true)
    
    const supplier = mockContractEnv.getSupplier(supplierId)
    expect(supplier.verified).toBe(true)
    expect(supplier.verificationDate).toBe(100) // Block height
    expect(supplier.creditScore).toBe(85)
  })
  
  it("should not verify a supplier if not called by contract owner", () => {
    // First register a supplier
    const supplierId = mockContractEnv.registerSupplier("Test Supplier", "123 Main St").value
    
    // Change tx sender to a different address
    mockContractEnv.txSender = "ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG"
    
    // Try to verify the supplier
    const result = mockContractEnv.verifySupplier(supplierId, 85)
    
    expect(result.error).toBe(403)
    
    const supplier = mockContractEnv.getSupplier(supplierId)
    expect(supplier.verified).toBe(false)
  })
  
  it("should check if a supplier is verified", () => {
    // First register a supplier
    const supplierId = mockContractEnv.registerSupplier("Test Supplier", "123 Main St").value
    
    // Initially not verified
    expect(mockContractEnv.isSupplierVerified(supplierId)).toBe(false)
    
    // Verify the supplier
    mockContractEnv.verifySupplier(supplierId, 85)
    
    // Now should be verified
    expect(mockContractEnv.isSupplierVerified(supplierId)).toBe(true)
  })
})
