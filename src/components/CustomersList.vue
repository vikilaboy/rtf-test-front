<template>
  <v-row align="center" class="list px-3 mx-auto">
      <v-col cols="12" sm="12">
      <v-row>
        <v-col cols="12" sm="9">
          <v-pagination
            v-model="page"
            :length="totalPages"
            total-visible="7"
            next-icon="mdi-menu-right"
            prev-icon="mdi-menu-left"
            @input="handlePageChange"
          ></v-pagination>
        </v-col>
      </v-row>
    </v-col>

    <v-col cols="12" sm="12">
      <v-card class="mx-auto" tile>
        <v-card-title>Customers</v-card-title>

        <v-data-table
          :headers="headers"
          :items="customers"
          :custom-sort="handleSortChange"
          disable-pagination
          :hide-default-footer="true"
        >
          <template v-slot:[`item.actions`]="{ item }">
            <v-icon small class="mr-2" @click="editCustomer(item.id)">
              mdi-pencil
            </v-icon>
            <v-icon small @click="deleteCustomer(item.id)">
              mdi-delete
            </v-icon>
          </template>
        </v-data-table>
      </v-card>
    </v-col>
  </v-row>
</template>

<script>
import CustomerDataService from "../services/CustomerDataService";
export default {
  name: "customergi-list",
  data() {
    return {
      customers: [],
      sortDesc: false,
      headers: [
        { text: "id", align: "start", sortable: false, value: "id" },
        { text: 'First name', sortable: true, value: 'first_name' },
       { text: 'Last name', value: 'last_name', sortable: true },
       { text: 'Email', value: 'email', sortable: true },
       { text: 'Phone', value: 'phone', sortable: true },
       { text: 'Priority', value: 'priority', sortable: true },
       { text: "Actions", value: "actions", sortable: false }
    ],

      page: 1,
      totalPages: 0,
      sort: ""
    };
  },
  methods: {
    getRequestParams(page, sort) {
      let params = {};

      if (page) {
        params["_p"] = page;
      }

      if (sort) {
        params["sort"] = sort;
      }

      return params;
    },

    retrieveCustomers() {
      const params = this.getRequestParams(
        this.page,
        this.sort
      );

      CustomerDataService.getAll(params)
        .then((response) => {
          console.log(response);

          const { data, last_page } = response.data;
          this.customers = data.map(this.getDisplayCustomer);
          this.totalPages = last_page;

          console.log(response.data);

          return true;
        })
        .catch((e) => {
          console.log(e);
        });
    },

    handleSortChange(items, column, isDesc) {
      if (column.length > 0 && this.sort !== (isDesc[0] ? "-" : "") + column[0]) {
        this.page = 1; // always first page
        this.sort = (isDesc[0] ? "-" : "") + column[0];
        this.retrieveCustomers();
      }
      return items;
    },

    handlePageChange(value) {
      this.page = value;
      this.retrieveCustomers();
    },

    refreshList() {
      this.retrieveCustomers();
    },

    editCustomer(id) {
      this.$router.push({ name: "customer-details", params: { id: id } });
    },

    deleteCustomer(id) {
      CustomerDataService.delete(id)
        .then(() => {
          this.refreshList();
        })
        .catch((e) => {
          console.log(e);
        });
    },

    getDisplayCustomer(customer) {
      return {
        id: customer.id,
        first_name: customer.first_name,
        last_name: customer.last_name,
        email: customer.email,
        phone: customer.phone,
        priority: customer.priority
      };
    },
  },
  mounted() {
    this.retrieveCustomers();
  },
};
</script>

<style>
.list {
  max-width: 860px;
}
</style>
