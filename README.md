# Tokenized Supply Chain Financing

# Tokenized Supply Chain Financing System

A blockchain-based system for supply chain financing using Clarity smart contracts.

## Overview

This project implements a tokenized supply chain financing system that allows suppliers to receive early payment for their invoices through a secure and transparent blockchain platform. The system uses Clarity smart contracts to manage the entire process from supplier and buyer verification to invoice creation, risk assessment, and financing.

## Smart Contracts

The system consists of five main smart contracts:

1. **Supplier Verification Contract**: Validates and manages supplier information
2. **Buyer Verification Contract**: Validates and manages buyer information
3. **Invoice Verification Contract**: Records and validates invoice documents
4. **Credit Risk Assessment Contract**: Evaluates payment reliability
5. **Funding Contract**: Manages early payment financing

## Features

- **Supplier and Buyer Registration**: Entities can register on the platform with their basic information
- **Verification Process**: Suppliers and buyers undergo verification to establish trust
- **Invoice Management**: Create, verify, and track invoices throughout their lifecycle
- **Risk Assessment**: Evaluate creditworthiness based on payment history, financial stability, and market sector risk
- **Financing Options**: Request and approve financing with transparent interest rates
- **Token-based Payments**: Use fungible tokens for financing and repayments
- **Transparent Status Tracking**: Monitor the status of invoices and financing requests

## Contract Details

### Supplier Verification Contract

This contract handles the registration and verification of suppliers in the system.

Key functions:
- `register-supplier`: Allows a supplier to register with their basic information
- `verify-supplier`: Verifies a supplier and assigns a credit score
- `get-supplier`: Retrieves supplier information
- `is-supplier-verified`: Checks if a supplier is verified

### Buyer Verification Contract

This contract handles the registration and verification of buyers in the system.

Key functions:
- `register-buyer`: Allows a buyer to register with their basic information
- `verify-buyer`: Verifies a buyer and assigns a credit score
- `get-buyer`: Retrieves buyer information
- `is-buyer-verified`: Checks if a buyer is verified

### Invoice Verification Contract

This contract manages invoices throughout their lifecycle.

Key functions:
- `create-invoice`: Creates a new invoice with supplier, buyer, amount, and due date
- `verify-invoice`: Verifies an invoice as legitimate
- `mark-invoice-paid`: Marks an invoice as paid
- `mark-invoice-financed`: Marks an invoice as financed
- `get-invoice`: Retrieves invoice information
- Various status check functions

### Credit Risk Assessment Contract

This contract evaluates the creditworthiness of entities in the system.

Key functions:
- `assess-risk`: Calculates a risk score based on multiple factors
- `get-risk-score`: Retrieves the risk assessment for an entity
- `is-credit-worthy`: Checks if an entity meets a specified creditworthiness threshold

### Funding Contract

This contract manages the financing process, including token minting and burning.

Key functions:
- `request-financing`: Initiates a financing request for an invoice
- `approve-financing`: Approves financing and mints tokens to the supplier
- `repay-financing`: Processes repayment and burns tokens
- `get-financing`: Retrieves financing information
- `get-repayment-amount`: Calculates the repayment amount with interest

## Testing

The project includes comprehensive tests for each contract using Vitest. The tests cover all major functionality and edge cases.

## Getting Started

1. Clone the repository
2. Run the tests to verify functionality
3. Deploy the contracts to your blockchain environment
4. Interact with the contracts through your preferred Clarity-compatible interface

## License

This project is licensed under the MIT License - see the LICENSE file for details.
### Tokenized Supply Chain Financing System

I'll create a tokenized supply chain financing system using Clarity (.clar) language with the requested contracts.

## Clarity Smart Contracts

```typescriptreact project="supply-chain-financing"
...
```

## System Architecture

The tokenized supply chain financing system consists of five interconnected Clarity smart contracts that work together to provide a secure and transparent platform for supply chain financing. Here's how they interact:

```mermaid
Supply Chain Financing System Architecture.download-icon {
            cursor: pointer;
            transform-origin: center;
        }
        .download-icon .arrow-part {
            transition: transform 0.35s cubic-bezier(0.35, 0.2, 0.14, 0.95);
             transform-origin: center;
        }
        button:has(.download-icon):hover .download-icon .arrow-part, button:has(.download-icon):focus-visible .download-icon .arrow-part {
          transform: translateY(-1.5px);
        }
        #mermaid-diagram-rciu{font-family:var(--font-geist-sans);font-size:12px;fill:#000000;}#mermaid-diagram-rciu .error-icon{fill:#552222;}#mermaid-diagram-rciu .error-text{fill:#552222;stroke:#552222;}#mermaid-diagram-rciu .edge-thickness-normal{stroke-width:1px;}#mermaid-diagram-rciu .edge-thickness-thick{stroke-width:3.5px;}#mermaid-diagram-rciu .edge-pattern-solid{stroke-dasharray:0;}#mermaid-diagram-rciu .edge-thickness-invisible{stroke-width:0;fill:none;}#mermaid-diagram-rciu .edge-pattern-dashed{stroke-dasharray:3;}#mermaid-diagram-rciu .edge-pattern-dotted{stroke-dasharray:2;}#mermaid-diagram-rciu .marker{fill:#666;stroke:#666;}#mermaid-diagram-rciu .marker.cross{stroke:#666;}#mermaid-diagram-rciu svg{font-family:var(--font-geist-sans);font-size:12px;}#mermaid-diagram-rciu p{margin:0;}#mermaid-diagram-rciu .label{font-family:var(--font-geist-sans);color:#000000;}#mermaid-diagram-rciu .cluster-label text{fill:#333;}#mermaid-diagram-rciu .cluster-label span{color:#333;}#mermaid-diagram-rciu .cluster-label span p{background-color:transparent;}#mermaid-diagram-rciu .label text,#mermaid-diagram-rciu span{fill:#000000;color:#000000;}#mermaid-diagram-rciu .node rect,#mermaid-diagram-rciu .node circle,#mermaid-diagram-rciu .node ellipse,#mermaid-diagram-rciu .node polygon,#mermaid-diagram-rciu .node path{fill:#eee;stroke:#999;stroke-width:1px;}#mermaid-diagram-rciu .rough-node .label text,#mermaid-diagram-rciu .node .label text{text-anchor:middle;}#mermaid-diagram-rciu .node .katex path{fill:#000;stroke:#000;stroke-width:1px;}#mermaid-diagram-rciu .node .label{text-align:center;}#mermaid-diagram-rciu .node.clickable{cursor:pointer;}#mermaid-diagram-rciu .arrowheadPath{fill:#333333;}#mermaid-diagram-rciu .edgePath .path{stroke:#666;stroke-width:2.0px;}#mermaid-diagram-rciu .flowchart-link{stroke:#666;fill:none;}#mermaid-diagram-rciu .edgeLabel{background-color:white;text-align:center;}#mermaid-diagram-rciu .edgeLabel p{background-color:white;}#mermaid-diagram-rciu .edgeLabel rect{opacity:0.5;background-color:white;fill:white;}#mermaid-diagram-rciu .labelBkg{background-color:rgba(255, 255, 255, 0.5);}#mermaid-diagram-rciu .cluster rect{fill:hsl(0, 0%, 98.9215686275%);stroke:#707070;stroke-width:1px;}#mermaid-diagram-rciu .cluster text{fill:#333;}#mermaid-diagram-rciu .cluster span{color:#333;}#mermaid-diagram-rciu div.mermaidTooltip{position:absolute;text-align:center;max-width:200px;padding:2px;font-family:var(--font-geist-sans);font-size:12px;background:hsl(-160, 0%, 93.3333333333%);border:1px solid #707070;border-radius:2px;pointer-events:none;z-index:100;}#mermaid-diagram-rciu .flowchartTitleText{text-anchor:middle;font-size:18px;fill:#000000;}#mermaid-diagram-rciu .flowchart-link{stroke:hsl(var(--gray-400));stroke-width:1px;}#mermaid-diagram-rciu .marker,#mermaid-diagram-rciu marker,#mermaid-diagram-rciu marker *{fill:hsl(var(--gray-400))!important;stroke:hsl(var(--gray-400))!important;}#mermaid-diagram-rciu .label,#mermaid-diagram-rciu text,#mermaid-diagram-rciu text>tspan{fill:hsl(var(--black))!important;color:hsl(var(--black))!important;}#mermaid-diagram-rciu .background,#mermaid-diagram-rciu rect.relationshipLabelBox{fill:hsl(var(--white))!important;}#mermaid-diagram-rciu .entityBox,#mermaid-diagram-rciu .attributeBoxEven{fill:hsl(var(--gray-150))!important;}#mermaid-diagram-rciu .attributeBoxOdd{fill:hsl(var(--white))!important;}#mermaid-diagram-rciu .label-container,#mermaid-diagram-rciu rect.actor{fill:hsl(var(--white))!important;stroke:hsl(var(--gray-400))!important;}#mermaid-diagram-rciu line{stroke:hsl(var(--gray-400))!important;}#mermaid-diagram-rciu :root{--mermaid-font-family:var(--font-geist-sans);}Supplier Verification ContractFunding ContractBuyer Verification ContractInvoice Verification ContractCredit Risk Assessment Contract
```

## Process Flow

The typical flow for a financing transaction in this system:

```mermaid
Supply Chain Financing Process Flow.download-icon {
            cursor: pointer;
            transform-origin: center;
        }
        .download-icon .arrow-part {
            transition: transform 0.35s cubic-bezier(0.35, 0.2, 0.14, 0.95);
             transform-origin: center;
        }
        button:has(.download-icon):hover .download-icon .arrow-part, button:has(.download-icon):focus-visible .download-icon .arrow-part {
          transform: translateY(-1.5px);
        }
        FunderVerifierBuyerSupplierFunderVerifierBuyerSupplier#mermaid-diagram-rcj8{font-family:var(--font-geist-sans);font-size:12px;fill:#000000;}#mermaid-diagram-rcj8 .error-icon{fill:#552222;}#mermaid-diagram-rcj8 .error-text{fill:#552222;stroke:#552222;}#mermaid-diagram-rcj8 .edge-thickness-normal{stroke-width:1px;}#mermaid-diagram-rcj8 .edge-thickness-thick{stroke-width:3.5px;}#mermaid-diagram-rcj8 .edge-pattern-solid{stroke-dasharray:0;}#mermaid-diagram-rcj8 .edge-thickness-invisible{stroke-width:0;fill:none;}#mermaid-diagram-rcj8 .edge-pattern-dashed{stroke-dasharray:3;}#mermaid-diagram-rcj8 .edge-pattern-dotted{stroke-dasharray:2;}#mermaid-diagram-rcj8 .marker{fill:#666;stroke:#666;}#mermaid-diagram-rcj8 .marker.cross{stroke:#666;}#mermaid-diagram-rcj8 svg{font-family:var(--font-geist-sans);font-size:12px;}#mermaid-diagram-rcj8 p{margin:0;}#mermaid-diagram-rcj8 .actor{stroke:hsl(0, 0%, 83%);fill:#eee;}#mermaid-diagram-rcj8 text.actor>tspan{fill:#333;stroke:none;}#mermaid-diagram-rcj8 .actor-line{stroke:hsl(0, 0%, 83%);}#mermaid-diagram-rcj8 .messageLine0{stroke-width:1.5;stroke-dasharray:none;stroke:#333;}#mermaid-diagram-rcj8 .messageLine1{stroke-width:1.5;stroke-dasharray:2,2;stroke:#333;}#mermaid-diagram-rcj8 #arrowhead path{fill:#333;stroke:#333;}#mermaid-diagram-rcj8 .sequenceNumber{fill:white;}#mermaid-diagram-rcj8 #sequencenumber{fill:#333;}#mermaid-diagram-rcj8 #crosshead path{fill:#333;stroke:#333;}#mermaid-diagram-rcj8 .messageText{fill:#333;stroke:none;}#mermaid-diagram-rcj8 .labelBox{stroke:hsl(0, 0%, 83%);fill:#eee;}#mermaid-diagram-rcj8 .labelText,#mermaid-diagram-rcj8 .labelText>tspan{fill:#333;stroke:none;}#mermaid-diagram-rcj8 .loopText,#mermaid-diagram-rcj8 .loopText>tspan{fill:#333;stroke:none;}#mermaid-diagram-rcj8 .loopLine{stroke-width:2px;stroke-dasharray:2,2;stroke:hsl(0, 0%, 83%);fill:hsl(0, 0%, 83%);}#mermaid-diagram-rcj8 .note{stroke:#999;fill:#666;}#mermaid-diagram-rcj8 .noteText,#mermaid-diagram-rcj8 .noteText>tspan{fill:#fff;stroke:none;}#mermaid-diagram-rcj8 .activation0{fill:#f4f4f4;stroke:#666;}#mermaid-diagram-rcj8 .activation1{fill:#f4f4f4;stroke:#666;}#mermaid-diagram-rcj8 .activation2{fill:#f4f4f4;stroke:#666;}#mermaid-diagram-rcj8 .actorPopupMenu{position:absolute;}#mermaid-diagram-rcj8 .actorPopupMenuPanel{position:absolute;fill:#eee;box-shadow:0px 8px 16px 0px rgba(0,0,0,0.2);filter:drop-shadow(3px 5px 2px rgb(0 0 0 / 0.4));}#mermaid-diagram-rcj8 .actor-man line{stroke:hsl(0, 0%, 83%);fill:#eee;}#mermaid-diagram-rcj8 .actor-man circle,#mermaid-diagram-rcj8 line{stroke:hsl(0, 0%, 83%);fill:#eee;stroke-width:2px;}#mermaid-diagram-rcj8 .flowchart-link{stroke:hsl(var(--gray-400));stroke-width:1px;}#mermaid-diagram-rcj8 .marker,#mermaid-diagram-rcj8 marker,#mermaid-diagram-rcj8 marker *{fill:hsl(var(--gray-400))!important;stroke:hsl(var(--gray-400))!important;}#mermaid-diagram-rcj8 .label,#mermaid-diagram-rcj8 text,#mermaid-diagram-rcj8 text>tspan{fill:hsl(var(--black))!important;color:hsl(var(--black))!important;}#mermaid-diagram-rcj8 .background,#mermaid-diagram-rcj8 rect.relationshipLabelBox{fill:hsl(var(--white))!important;}#mermaid-diagram-rcj8 .entityBox,#mermaid-diagram-rcj8 .attributeBoxEven{fill:hsl(var(--gray-150))!important;}#mermaid-diagram-rcj8 .attributeBoxOdd{fill:hsl(var(--white))!important;}#mermaid-diagram-rcj8 .label-container,#mermaid-diagram-rcj8 rect.actor{fill:hsl(var(--white))!important;stroke:hsl(var(--gray-400))!important;}#mermaid-diagram-rcj8 line{stroke:hsl(var(--gray-400))!important;}#mermaid-diagram-rcj8 :root{--mermaid-font-family:var(--font-geist-sans);}Register on platformRegister on platformVerify supplier identity & creditVerify buyer identity & creditDeliver goods/servicesIssue invoiceApprove invoiceRequest early payment financingAssess risk & approve financingTransfer tokens (discounted amount)Pay full invoice amount at maturityRelease remaining amount (minus fees)
```

I've created a comprehensive tokenized supply chain financing system using Clarity smart contracts. The system includes:

1. **Supplier Verification Contract**: For validating and managing supplier information
2. **Buyer Verification Contract**: For validating and managing buyer information
3. **Invoice Verification Contract**: For recording and validating invoice documents
4. **Credit Risk Assessment Contract**: For evaluating payment reliability
5. **Funding Contract**: For managing early payment financing with token support
