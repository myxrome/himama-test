<template>
  <div>
    <div v-if="current_clock_log">
      <p>Clocked in at {{ current_clock_log.clocked_in_at }}</p>
      <button v-on:click="clockOut">Clock Out</button>
    </div>
    <div v-else>
      <p>You haven't been clocked in yet</p>
      <button v-on:click="clockIn">Clock In</button>
    </div>
    <table>
      <thead>
        <tr>
          <th>Clock In</th>
          <th>Clock Out</th>
          <th></th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="clock_log in completed_clock_logs">
          <template v-if="clock_log === editable_clock_log">
            <td><input v-model="clock_log.clocked_in_at"></td>
            <td><input v-model="clock_log.clocked_out_at"></td>
            <td><button v-on:click="save(clock_log)">Save</button></td>
            <td><button v-on:click="cancelEdit">Cancel</button></td>
          </template>
          <template v-else>
            <td>{{ clock_log.clocked_in_at }}</td>
            <td>{{ clock_log.clocked_out_at }}</td>
            <td><button v-on:click="editClockLog(clock_log)">Edit</button></td>
            <td><button v-on:click="destroy(clock_log)">Delete</button></td>
          </template>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
  import axios from 'axios';

export default {
  data: function () {
    return {
      clock_logs: [],
      editable_clock_log: null,
    }
  },
  computed: {
    current_clock_log: function () {
      return this.clock_logs.find(function (log) {
        return log.clocked_out_at == null
      })
    },
    completed_clock_logs: function () {
      return this.clock_logs.filter(function (log) {
        return log.clocked_out_at != null
      })
    }
  },
  methods: {
    clockOut: function () {
      axios.put('/clock_logs/' + this.current_clock_log.id + '.json',
              { clocked_out_at: new Date().toISOString() },
              { headers: { 'x-csrf-token': this.token() } }).
      then((response) => {
        this.refresh()
      }).catch((response) => {
        console.log(response)
      })
    },
    clockIn: function() {
      axios.post('/clock_logs.json',
              { clocked_in_at: new Date().toISOString() },
              { headers: { 'x-csrf-token': this.token() } }).
      then((response) => {
        this.refresh()
      }).catch((response) => {
        console.log(response)
      })
    },
    save: function(log) {
      axios.put('/clock_logs/' + log.id + '.json',
              { clocked_in_at: log.clocked_in_at, clocked_out_at: log.clocked_out_at },
              { headers: { 'x-csrf-token': this.token() } }).
      then((response) => {
        this.refresh()
      }).catch((response) => {
        console.log(response)
      })
    },
    destroy: function(log) {
      axios.delete('/clock_logs/' + log.id + '.json', { headers: { 'x-csrf-token': this.token() } }).
      then((response) => {
        this.refresh()
      }).catch((response) => {
        console.log(response)
      })
    },
    editClockLog: function(log) {
      this.editable_clock_log = log;
    },
    cancelEdit: function() {
      this.editable_clock_log = null;
      this.refresh();
    },
    refresh: function () {
      axios.get('/clock_logs.json').then((response) => {
        this.clock_logs = response.data
      }).catch((response) => {
        console.log(response)
      })
    },
    token: function () {
      return document.querySelector("[name='csrf-token']").getAttribute("content");
    },
  },
  created: function () {
    this.refresh();
  },
}
</script>
