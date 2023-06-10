<template>
  <div class="container">
    <welcomeview></welcomeview>
    <h3>Deactivate the desired account by clicking on the deactivate button</h3>
    <div class="table-container">
      <table class="table">
        <thead>
          <tr>
            <th>Account Id</th>
            <th>Account Type</th>
            <th>Account Status</th>
            <th>Transaction Limit</th>
            <th></th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="account in accounts" :key="account.id">
            <td>{{ account.id }}</td>
            <td>{{ account.accountType }}</td>
            <td>{{ account.accountStatus }}</td>
            <td>{{ account.transactionLimit }}</td>
            <td>
              <button @click="deactivateAccount(account.id)" >Deactivate</button>
            </td>
            <td>
              <button @click="editAccount(account.id)">Edit</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <div v-if="editingAccountId" class="form-container">
      <h3>Edit Account</h3>
      <form @submit.prevent="saveAccount">
        <label for="accountType">Account Type:</label>
        <input type="text" id="accountType" v-model="editedAccount.accountType" required>
        <label for="accountStatus">Account Status:</label>
        <input type="text" id="accountStatus" v-model="editedAccount.accountStatus" required>
        <label for="transactionLimit">Transaction Limit:</label>
        <input type="long" id="transactionLimit" v-model="editedAccount.transactionLimit" required>
        <label for="dayLimit">Day Limit:</label>
        <input type="long" id="dayLimit" v-model="editedAccount.dayLimit" required>
        <label for="absoluteLimit">Absolute Limit:</label>
        <input type="long" id="absoluteLimit" v-model="editedAccount.absoluteLimit" required>
        <button type="submit"  >Save</button>
      </form>
    </div>
    <div class="form-container">
      <h3>Get Balance</h3>
      <form @submit.prevent="balanceCheck">
        <label for="userId">User ID:</label>
        <input type="text" id="userId" v-model="userId" required>
        <label for="IBAN">IBAN:</label>
        <input type="text" id="IBAN" v-model="IBAN" required>
        <button type="submit">Check Balance</button>
        <p v-if="balanceResult">{{ balanceResult }}</p>
      </form>
    </div>
    <div class="form-container">
      <h3>Create Account</h3>
      <form @submit.prevent="createAccount">
        <label for="accountType">Account Type:</label>
        <input type="text" id="accountType" v-model="newAccount.accountType" required>
        <label for="userId">User ID:</label>
        <input type="text" id="userId" v-model="newAccount.userId" required>
        <button type="submit">Create</button>
        <p v-if="accountCreated">Account created successfully!</p>
      </form>
    </div>
    <div v-if="errorMessage" class="error-message">{{ errorMessage }}</div>

  </div>
</template>


  
  <script>
  import axios from 'axios';
  import WelcomeView from './WelcomeView.vue'
   const uuidPattern = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
   const token = localStorage.getItem('bearerToken');
   const header = {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`,
          'Access-Control-Allow-Origin': 'http://localhost:8081/',
          'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE,PATCH,OPTIONS',
    };
  
  axios.defaults.headers.common['Authorization'] = 'Bearer ' + token;
  export default {
    name: 'accounts',
    components: {
      welcomeview: WelcomeView
    },
    data() {
      return {
        accounts: [],
        editingAccountId: null,
        editedAccount: {
          accountType: '',
          accountStatus: '',
          transactionLimit: '',
          dayLimit: ''
        },
        userId: '', 
        IBAN: '', 
        balanceResult: '',
        newAccount: {
          accountType: '',
           userId: ''
        },
        accountCreated: false,
        errorMessage: ''
      }
    },
    mounted() {
      this.getAccounts()
    },
    methods: {
      getAccounts() {
        axios.get('http://localhost:8080/api/accounts', { headers: header })
          .then(response => {
            this.accounts = response.data;
          });
      },
      deactivateAccount
      (id) {
        axios.delete(`http://localhost:8080/api/accounts/${id}`)
          .then(() => {
            this.getAccounts();
          });
      },
      editAccount(id) {
        this.editingAccountId = id;
        const account = this.accounts.find(account => account.id === id);
        this.editedAccount = {
          accountType: account.accountType,
          accountStatus: account.accountStatus,
          transactionLimit: account.transactionLimit,
          dayLimit: account.dayLimit,
          absoluteLimit: account.absoluteLimit
        };
      },
      saveAccount() {
        axios.put(`http://localhost:8080/api/accounts/${this.editingAccountId}`, this.editedAccount)
          .then(() => {
            this.editingAccountId = null;
            this.editedAccount = {
              accountType: '',
              accountStatus: '',
              transactionLimit: '',
              dayLimit: '',
              absoluteLimit: ''
            };
            this.getAccounts();
          });
      },
      balanceCheck() {
        if (!uuidPattern.test(this.userId)) {
          this.errorMessage = 'Invalid userId format.';
          return;
        }
        if(!isNaN(this.IBAN)){
          this.errorMessage = 'Invalid IBAN format.';
          return;
        }
        const params = {
          userId: this.userId,
          IBAN: this.IBAN
        };

        axios.get('http://localhost:8080/api/accounts/balance', {
          headers: header,
          params: params
        })
          .then(response => {
            this.balanceResult = response.data;
            setTimeout(() => {
            this.balanceResult = '';
            }, 3000);
          })
          .catch(error => {
            this.errorMessage = 'Something went wrong: ' + error.response.data.message;
            setTimeout(() => {
            this.errorMessage = '';
            }, 3000);
          });
      },
      createAccount() {
        axios.post('http://localhost:8080/api/accounts', this.newAccount, { headers: header })
          .then(response => {
            console.log(response.data);
            this.getAccounts()
          })
          .catch(error => {
            console.error(error);
          });
      },
    }
  }
  </script>
  
  <style>
.container {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
}

.heading {
  font-size: 24px;
  margin-bottom: 20px;
}

.table-container {
  margin-top: 20px;
}

.table {
  width: 100%;
  border-collapse: collapse;
}

.table th,
.table td {
  padding: 10px;
  border-bottom: 1px solid #ccc;
  text-align: left;
}

.table th {
  background-color: #f5f5f5;
}

.table tr:hover {
  background-color: #f9f9f9;
}

.table button {
  background-color: #4CAF50;
  color: white;
  padding: 5px 10px;
  border: none;
  cursor: pointer;
}

.table button:hover {
  background-color: #3e8e41;
}

.form-container {
  margin-top: 20px;
  border-top: 1px solid #ccc;
  padding-top: 20px;
}

.form-container h3 {
  font-size: 20px;
  margin-bottom: 10px;
}

.form-container form {
  display: grid;
  grid-template-columns: 100px auto;
  grid-gap: 10px;
  align-items: center;
}

.form-container label {
  font-weight: bold;
}

.form-container input[type="text"],
.form-container input[type="long"] {
  padding: 5px;
  border: 1px solid #ccc;
  border-radius: 3px;
}

.form-container button[type="submit"] {
  padding: 10px 20px;
  background-color: #333;
  color: #fff;
  border: none;
  border-radius: 3px;
  cursor: pointer;
}

.form-container button[type="submit"]:hover {
  background-color: #555;
}
.error-message {
  color: red;
  margin-top: 10px;
}

  </style>
  