<template>
  <div class="submit-form mt-3 mx-auto">
    <p class="headline">Add Customer</p>

    <div v-if="!submitted">
      <v-form ref="form">
        <v-text-field
          v-model="customer.first_name"
          :rules="[(v) => !!v || 'First name is required']"
          label="First Name"
          required
        ></v-text-field>

        <v-text-field
          v-model="customer.last_name"
          :rules="[(v) => !!v || 'Last Name is required']"
          label="Last Name"
          required
        ></v-text-field>

        <v-text-field
          v-model="customer.email"
          :rules="[(v) => !!v || 'Email is required']"
          label="Email"
          required
        ></v-text-field>

        <v-text-field
          v-model="customer.phone"
          :rules="[(v) => !!v || 'Phone is required']"
          label="Phone"
          required
        ></v-text-field>

        <v-text-field
          v-model="customer.priority"
          :rules="[(v) => !!v || 'Priority is required']"
          label="Priority"
          hide-details
          single-line
          type="number"
          required
        />
      </v-form>

      <div class="alert-wrapper" v-if="this.errorMessage">
        <v-alert type="error" v-for="error in this.errorMessage" :key="error.id">
          {{ error[0] }}
        </v-alert>
      </div>

      <v-btn color="primary" class="mt-3" @click="saveCustomer">Submit</v-btn>
    </div>

    <div v-else>
      <v-card class="mx-auto">
        <v-card-title>
          Submitted successfully!
        </v-card-title>

        <v-card-subtitle>
          Click the button to add a new Customer.
        </v-card-subtitle>

        <v-card-actions>
          <v-btn color="success" @click="newCustomer">Add</v-btn>
        </v-card-actions>
      </v-card>
    </div>
  </div>
</template>

<script>
import CustomerDataService from "../services/CustomerDataService";

export default {
  name: "add-customer",
  data() {
    return {
      customer: {
        id: null,
        first_name: "",
        last_name: "",
        phone: "",
        email: "",
        priority: "",
        published: false,
      },
      errorMessage: [],
      submitted: false,
    };
  },
  methods: {
    saveCustomer() {
      var data = {
        first_name: this.customer.first_name,
        last_name: this.customer.last_name,
        phone: this.customer.phone,
        email: this.customer.email,
        priority: this.customer.priority
      };

      CustomerDataService.create(data)
        .then((response) => {
          this.customer.id = response.data.id;
          this.submitted = true;
        })
        .catch((e) => {
          this.errorMessage = e.response.data.errors;
        });
    },

    newCustomer() {
      this.submitted = false;
      this.customer = {};
    },
  },
};
</script>

<style>
.submit-form {
  max-width: 300px;
}
.alert-wrapper {
  margin-top: 20px;
}
</style>
