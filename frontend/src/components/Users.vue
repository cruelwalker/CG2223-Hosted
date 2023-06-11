<template>
  <div class="container">
    <welcomeview></welcomeview>
    <div class="user-list">
      <h3>Deactivate the desired user by clicking on the deactivate button</h3>
      <table>
        <thead>
          <tr>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Status</th>
            <th>Mobile Number</th>
            <th>Date of Birth</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="user in users" :key="user.id">
            <td>{{ user.firstName }}</td>
            <td>{{ user.lastName }}</td>
            <td>{{ user.status }}</td>
            <td>{{ user.mobileNumber }}</td>
            <td>{{ user.dateOfBirth }}</td>
            <td>
              <button @click="deactivateUser(user.id)">Deactivate</button>
              <button @click="editUser(user.id)">Edit</button>
            </td>
          </tr>
        </tbody>
      </table>
  <h2>Filter Users</h2>
  <table class="form-table">
    <tr>
      <td><label for="userName">User Name:</label></td>
      <td><input type="text" id="userName" v-model="userName" required></td>
    </tr>
    <tr>
      <td><label for="mobileNumber">mobileNumber:</label></td>
      <td><input type="text" id="mobileNumber" v-model="mobileNumber"></td>
    </tr>
    <tr>
      <td></td>
      <td><button type="submit" @click="getUsersByUserNameAndPhoneNumber">Filter</button>            </td>
    </tr>
  </table>
      <div v-if="deactivateUserError" class="error-message">{{ deactivateUserError }}</div>
      <div v-if="saveUserError" class="error-message">{{ saveUserError }}</div>

      <div v-if="editingUserId !== null" class="edit-form">
        <h3>Edit User</h3>
        <form @submit.prevent="saveUser">
          <div class="form-group">
            <label for="firstName">First Name:</label>
            <input type="text" id="firstName" v-model="editedUser.firstName" required>
          </div>
          <div class="form-group">
            <label for="lastName">Last Name:</label>
            <input type="text" id="lastName" v-model="editedUser.lastName" required>
          </div>
          <div class="form-group">
            <label for="mobileNumber">Mobile Number:</label>
            <input type="text" id="mobileNumber" v-model="editedUser.mobileNumber" required>
          </div>
          <div class="form-group">
            <label for="dateOfBirth">Date of Birth:</label>
            <input type="date" id="dateOfBirth" v-model="editedUser.dateOfBirth">
          </div>
          <div class="form-group">
            <label for="status">Status:</label>
            <input type="text" id="status" v-model="editedUser.status" required>
          </div>
          <div class="form-actions">
            <button type="submit">Save</button>
            <button type="button" @click="cancelEdit">Cancel</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import WelcomeView from './WelcomeView.vue'
const token = localStorage.getItem('bearerToken');
      const header = {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
        'Access-Control-Allow-Origin': 'http://localhost:8081/',
        'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE,PATCH,OPTIONS',
};
export default {
  name: 'Users',
  components: {
    welcomeview: WelcomeView
  },
  data() {
    return {
      users: [],
      editingUserId: null,
      editedUser: {
        firstName: '',
        lastName: '',
        mobileNumber: '',
        dateOfBirth: '',
        status: ''
      },
      deactivateUserError: '',
      saveUserError: '',
    }
  },
  mounted() {
    this.getUsers()
  },
  methods: {
    getUsers() {
      axios.defaults.headers.common['Authorization'] = 'Bearer ' + token;
      axios.get('http://localhost:8080/api/users')
        .then(response => {
          this.users = response.data;
        });
    },
    deactivateUser(id) {
      axios.delete(`http://localhost:8080/api/users/${id}`)
        .then(() => {
          this.getUsers();
        })
        .catch(error => {
          this.deactivateUserError = 'Failed to deactivate user: ' + error.response.data.message;
          setTimeout(() => {
            this.deactivateUserError = '';
          }, 3000);
        });
    },
    editUser(id) {
      this.editingUserId = id;
      const user = this.users.find(user => user.id === id);
      this.editedUser = {
        firstName: user.firstName,
        lastName: user.lastName,
        mobileNumber: user.mobileNumber,
        dateOfBirth: user.dateOfBirth,
        status: user.status
      };
    },
    saveUser() {
      if (this.editedUser.firstName.trim() === '' || this.editedUser.lastName.trim() === '') {
        this.saveUserError = 'First name and last name are required.';
        return; 
      }
       if (!isNaN(this.editedUser.firstName) || !isNaN(this.editedUser.lastName)) {
        this.saveUserError = 'First name and last name must contain only letters.';
        return; 
      }

      axios.put(`http://localhost:8080/api/users/${this.editingUserId}`, this.editedUser)
        .then(() => {
          this.editingUserId = null;
          this.editedUser = {
            firstName: '',
            lastName: '',
            mobileNumber: '',
            dateOfBirth: '',
            status: ''
          };
          this.getUsers();
        }).catch(error => {
          this.saveUserError = 'Failed to save user: ' + error.response.data.message;
          setTimeout(() => {
            this.saveUserError = '';
          }, 3000);
      });
    },
    cancelEdit() {
      this.editingUserId = null;
      this.editedUser = {
        firstName: '',
        lastName: '',
        mobileNumber: '',
        dateOfBirth: '',
        status: ''
      };
    },
    getUsersByUserNameAndPhoneNumber(){
      const filters = {
      mobileNumber: this.mobileNumber,
      userName: this.userName,
      };
      axios.get('http://localhost:8080/api/users/findUsers', { params: filters })
        .then(response => {
          const userData = response.data;
          this.users = Array.isArray(userData) ? userData : [userData];
        });
    }
  }
}
</script>

<style>
.container {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
}

.user-list {
  margin-top: 20px;
}

h3 {
  font-size: 20px;
  margin-bottom: 10px;
}

table {
  width: 100%;
  border-collapse: collapse;
}

table th,
table td {
  border: 1px solid #ccc;
  padding: 8px;
}

table th {
  background-color: #f4f4f4;
  font-weight: bold;
  text-align: left;
}

.edit-form {
  background-color: #fff;
  padding: 10px;
  margin-top: 10px;
}

.edit-form h3 {
  font-size: 18px;
  margin-bottom: 5px;
}

.form-group {
  margin-bottom: 10px;
}

.form-group label {
  display: block;
  font-weight: bold;
  margin-bottom: 5px;
}

.form-group input[type="text"],
.form-group input[type="date"] {
  width: 100%;
  padding: 5px;
  border: 1px solid #ccc;
  border-radius: 3px;
}

.form-actions {
  margin-top: 10px;
}

.form-actions button {
  padding: 8px 12px;
  background-color: #333;
  color: #fff;
  border: none;
  border-radius: 3px;
  cursor: pointer;
  margin-right: 5px;
}

.form-actions button[type="submit"]:hover,
.form-actions button[type="button"]:hover {
  background-color: #555;
}
.error-message {
  color: red;
  margin-top: 10px;
}
</style>
