import Vue from "vue";
import Router from "vue-router";

Vue.use(Router);

export default new Router({
  mode: "history",
  routes: [
    {
      path: "/",
      alias: "/c",
      name: "customers",
      component: () => import("./components/CustomersList")
    },
    {
      path: "/customer/:id",
      name: "customer-details",
      component: () => import("./components/Customer")
    },
    {
      path: "/add",
      name: "add",
      component: () => import("./components/AddCustomer")
    }
  ]
});
