
# Assignment 4 :- Multi-Signature Wallet



1. **Build:**

   ```bash
   forge build
   ```

2. **Test:**

   ```bash
   forge test
   ```

## Contract Overview

The `MultiSigWallet` contract is a multi-signature wallet that requires confirmation from a predefined number of owners before a transaction can be executed. Owners can submit transactions, confirm them, and, when the required number of confirmations is reached, execute the transactions.

## Variables

- **`owners`**: An array containing the addresses of the wallet owners.
- **`Confirmnum`**: The required number of confirmations for a transaction to be executed.
- **`transactions`**: An array of `Transaction` structures, representing submitted transactions.
- **`isConfirmed`**: A mapping to track which owners have confirmed a specific transaction.

## Events

- **`TransactionSubmitted`**: Triggered when a transaction is submitted.
- **`TransactionConfirmed`**: Triggered when a transaction is confirmed.
- **`TransactionExecuted`**: Triggered when a transaction is executed.

## Constructor

The constructor initializes the contract with the addresses of the wallet owners and sets the required number of confirmations.

## Functions

### `submitTransaction(address _to)`

- **Description**: Allows an owner to submit a transaction to the wallet.
- **Error Handling**: Checks for valid receiver's address and a transfer amount greater than 0.

### `confirmTransaction(uint _txId)`

- **Description**: Allows an owner to confirm a submitted transaction.
- **Error Handling**: Checks for a valid transaction ID and that the transaction is not already confirmed by the same owner.

### `executeTransaction(uint _txId)`

- **Description**: Executes a confirmed transaction.
- **Error Handling**: Checks for a valid transaction, that it hasn't been executed yet, and that the required number of confirmations is met.

### `isTransactionConfirmed(uint _txId)`

- **Description**: Checks if a transaction has received the required number of confirmations.
- **Returns**: Boolean indicating whether the transaction is confirmed.

### `totalTransactions()`

- **Description**: Returns the total number of transactions.

### `Confirmnumber()`

- **Description**: Returns the required number of confirmations for a transaction.

