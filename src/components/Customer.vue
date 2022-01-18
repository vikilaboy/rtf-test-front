<template>
  <div v-if="currentCustomer" class="edit-form py-3">
    <p class="headline">Edit Customer</p>

    <v-form ref="form" v-model="valid" lazy-validation>
      <v-text-field
        v-model="currentCustomer.first_name"
        :rules="[(v) => !!v || 'First name is required']"
        label="First Name"
        required
      ></v-text-field>

      <v-text-field
        v-model="currentCustomer.last_name"
        :rules="[(v) => !!v || 'Last Name is required']"
        label="Last Name"
        required
      ></v-text-field>

      <v-text-field
        v-model="currentCustomer.email"
        :rules="[(v) => !!v || 'Email is required']"
        label="Email"
        required
      ></v-text-field>

      <v-text-field
        v-model="currentCustomer.phone"
        :rules="[(v) => !!v || 'Phone is required']"
        label="Phone"
        required
      ></v-text-field>

      <v-btn color="error" small class="mr-2" @click="deleteCustomer">
        Delete
      </v-btn>

      <v-btn color="success" small @click="updateCustomer">
        Update
      </v-btn>
    </v-form>

    <div class="alert-wrapper" v-if="this.errorMessage">
      <v-alert type="error" v-for="error in this.errorMessage" :key="error.id">
        {{ error[0] }}
      </v-alert>
    </div>

    <p class="mt-3">{{ message }}</p>
  </div>

  <div v-else>
    <br />
    <p>Please select a customer...</p>
  </div>
</template>

<script>
import CustomerDataService from "../services/CustomerDataService";

export default {
  name: "customer",
  data() {
    return {
      currentCustomer: null,
      message: "",
      errorMessage: [],
    };
  },
  methods: {
    getTutorial(id) {
      CustomerDataService.get(id)
        .then((response) => {
          this.currentCustomer = response.data;
        })
        .catch((e) => {
          console.log(e);
        });
    },

    updateCustomer() {
      var data = {
        first_name: this.currentCustomer.first_name,
        last_name: this.currentCustomer.last_name,
        phone: this.currentCustomer.phone,
        email: this.currentCustomer.email
      };

      CustomerDataService.update(this.currentCustomer.id, data)
        .then(() => {
          this.message = "The customer was updated successfully!";
        })
        .catch((e) => {
          this.errorMessage = e.response.data.errors;
        });
    },

    deleteCustomer() {
      CustomerDataService.delete(this.currentCustomer.id)
        .then(() => {
          this.$router.push({ name: "tutorials" });
        })
        .catch((e) => {
          console.log(e);
        });
    }
  },
  mounted() {
    this.message = "";
    this.getTutorial(this.$route.params.id);
  },
};
</script>

<style>
.edit-form {
  max-width: 300px;
  margin: auto;
}
.alert-wrapper {
  margin-top: 20px;
}
</style>
