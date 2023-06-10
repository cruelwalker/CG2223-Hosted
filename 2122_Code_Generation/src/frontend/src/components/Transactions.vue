<template>
  <div>
   <welcomeview></welcomeview>

  <h1>Transactions</h1>
 <table>
      <thead>
        <tr>
          <th>Transaction ID</th>
          <th>user Id </th>
          <th>Sender IBAN</th>
          <th>Receiver IBAN</th>
          <th>Amount</th>
          <th>Date</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="transaction in transactions" :key="transaction.id">
          <td>{{ transaction.id }}</td>
          <td>{{ transaction.userId }}</td>
          <td>{{ transaction.fromIban }}</td>
          <td>{{ transaction.toIban }}</td>
          <td>{{ transaction.transferAmount }}</td>
          <td>{{ transaction.dateOfTransaction }}</td>
        </tr>
      </tbody>
    </table>
  <h2>Create Transaction</h2>
  <table class="form-table">
    <tr>
      <td><label for="transferAmount">Amount:</label></td>
      <td><input type="long" id="transferAmount" v-model="transferAmount" required></td>
    </tr>
    <tr>
      <td><label for="senderIban">Sender IBAN:</label></td>
      <td><input type="text" id="senderIban" v-model="senderIban" required></td>
    </tr>
    <tr>
      <td><label for="receiverIban">Receiver IBAN:</label></td>
      <td><input type="text" id="receiverIban" v-model="receiverIban" required></td>
    </tr>
    <tr>
      <td></td>
      <td><button type="submit" @click="createTransaction">Make Transaction</button>
            <span v-if="transactionSuccessMessage">Transaction created successfully!</span>
      </td>
    </tr>
  </table>

  <h2>Deposit</h2>
  <table class="form-table">
    <tr>
      <td><label for="depositAmount">Amount:</label></td>
      <td><input type="long" id="depositAmount" v-model="depositAmount" required></td>
    </tr>
    <tr>
      <td><label for="iban">IBAN:</label></td>
      <td><input type="text" id="iban" v-model="iban" required></td>
    </tr>
    <tr>
      <td></td>
      <td><button type="submit" @click="deposit">Deposit Money</button>
            <span v-if="depositSuccessMessage">Deposit successful!</span>
            </td>
    </tr>
  </table>

  <h2>Withdraw</h2>
  <table class="form-table">
    <tr>
      <td><label for="amount">Amount:</label></td>
      <td><input type="long" id="amount" v-model="amount" required></td>
    </tr>
    <tr>
      <td><label for="iban">IBAN:</label></td>
      <td><input type="text" id="iban" v-model="iban" required></td>
    </tr>
    <tr>
      <td></td>
      <td><button type="submit" @click="withdraw">Withdraw Money</button>
            <span v-if="withdrawSuccessMessage">Withdrawal successful!</span>
            </td>
    </tr>
  </table>

  <h2>Filter Transactions</h2>
  <table class="form-table">
    <tr>
      <td><label for="IBAN">Sender IBAN:</label></td>
      <td><input type="text" id="IBAN" v-model="IBAN" required></td>
    </tr>
    <tr>
      <td><label for="receiverIban">Receiver IBAN:</label></td>
      <td><input type="text" id="receiverIban" v-model="receiverIban"></td>
    </tr>
    <tr>
      <td><label for="from">From:</label></td>
      <td><input type="date" id="from" v-model="from"></td>
    </tr>
    <tr>
      <td><label for="to">To:</label></td>
      <td><input type="date" id="to" v-model="filterTo"></td>
    </tr>
    <tr>
      <td><label for="amount">Amount:</label></td>
      <td><input type="long" id="amount" v-model="amount"></td>
    </tr>
    <tr>
      <td></td>
      <td><button type="submit" @click="getFilteredTransactions">Filter</button>
            <span v-if="filterSuccessMessage">Transactions filtered successfully!</span>
            </td>
    </tr>
  </table>
  </div>
</template>

<script>
import axios from 'axios';
import WelcomeView from './WelcomeView.vue'
const token = localStorage.getItem('bearerToken');
const header = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Authorization': `Bearer ${token}`,
    'Access-Control-Allow-Origin': 'http://localhost:8081/',
    'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE,PATCH,OPTIONS',
};
export default {
    name: 'Transactions',
    components: {
        welcomeview: WelcomeView
    },
    data() {
    return {
      transactions: [],
        transactionSuccessMessage: '',
        depositSuccessMessage: '',
        withdrawSuccessMessage: '',
        filterSuccessMessage: ''
    };
  },
  mounted() {
    this.getTransactions();
  },
  methods: {
    getTransactions() {
        axios.defaults.headers.common['Authorization'] = 'Bearer ' + token;
        axios.get('http://localhost:8080/api/transactions', { headers: header })
          .then(response => {
            this.transactions = response.data;
          })
        .catch((error) => {
          console.log(error);
        });
    },
    createTransaction() {
    axios.post('http://localhost:8080/api/transactions/', {
      transferAmount: this.transferAmount,
      senderIban: this.senderIban,
      receiverIban: this.receiverIban
    })
    .then(() => {
      this.getTransactions();
      this.transactionSuccessMessage = 'Transaction created successfully!';
    })
    .catch(error => {
      console.error('Error creating transaction:', error);
    });
    },
    deposit(){
        if (!this.depositAmount || !this.iban) {
            return;
        }

        const depositData = {
          depositAmount: this.depositAmount,
         iban: this.iban
         };

        axios.post('http://localhost:8080/api/transactions/deposit', depositData)
            .then(response => {
            console.log('Deposit successful');
            this.depositSuccessMessage = 'Deposit successful!';
            setTimeout(() => {
            this.depositSuccessMessage = '';
            }, 3000);
        })
        .catch(error => {
            console.error('Deposit failed', error);
        })
        .finally(() => {
        this.depositAmount = '';
        this.iban = '';
        });
    },
    withdraw(){
        if (!this.amount || !this.iban) {
            return;
        }

        const depositData = {
        amount: this.amount,
         iban: this.iban
         };

        axios.post('http://localhost:8080/api/transactions/withdraw', depositData)
            .then(response => {
            console.log('withdraw successful');
            this.withdrawSuccessMessage = 'Withdrawal successful!';
        })
        .catch(error => {
            console.error('withdraw failed', error);
        })
        .finally(() => {
        this.amount = '';
        this.iban = '';
        });
    },
    getFilteredTransactions(){
       const filters = {
      IBAN: this.IBAN,
      ReceiverIBAN: this.ReceiverIBAN,
      from: this.from,
      to: this.to,
      amount: this.amount
      };

    axios.get(`http://localhost:8080/api/transactions/${this.IBAN}`, { params: filters })
      .then(response => {
        const filteredTransactions = response.data;
        this.transactions = filteredTransactions;

        this.filterSuccessMessage = 'Transactions filtered successfully!';

        setTimeout(() => {
          this.filterSuccessMessage = '';
        }, 3000);
      })
      .catch(error => {
        console.error('Error filtering transactions:', error);
      });
    }

  },
}
</script>
 
<style>
  h1 {
    font-size: 24px;
    margin-bottom: 20px;
  }

  h2 {
    font-size: 18px;
    margin-bottom: 10px;
  }

  form {
    margin-bottom: 20px;
  }

  form label {
    display: block;
    margin-bottom: 5px;
  }

  form input[type="number"],
  form input[type="text"],
  form input[type="date"] {
    padding: 5px;
    margin-bottom: 10px;
    width: 200px;
  }

  form button[type="submit"] {
    background-color: #4CAF50;
    color: white;
    padding: 5px 10px;
    border: none;
    cursor: pointer;
  }

  form button[type="submit"]:hover {
    background-color: #3e8e41;
  }

  table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
  }

  th,
  td {
    padding: 8px;
    text-align: left;
    border-bottom: 1px solid #ccc;
  }

  th {
    background-color: #f2f2f2;
  }

  /* Additional Styles for Transactions Page */

  .transaction-list {
    list-style: none;
    padding: 0;
    margin: 0;
  }

  .transaction-list li {
    padding: 10px;
    border-bottom: 1px solid #ccc;
  }

  .transaction-list button {
    background-color: #4CAF50;
    color: white;
    padding: 5px 10px;
    border: none;
    cursor: pointer;
  }

  .transaction-list button:hover {
    background-color: #3e8e41;
  }
  .form-table {
    margin-bottom: 20px;
  }

  .form-table td {
    padding: 5px;
  }

  .form-table label {
    display: block;
    margin-bottom: 5px;
  }

  .form-table input[type="number"],
  .form-table input[type="text"],
  .form-table input[type="date"] {
    padding: 5px;
    width: 200px;
  }

  .form-table button[type="submit"] {
    background-color: #4CAF50;
    color: white;
    padding: 5px 10px;
    border: none;
    cursor: pointer;
  }

  .form-table button[type="submit"]:hover {
    background-color: #3e8e41;
  }
  
</style>
