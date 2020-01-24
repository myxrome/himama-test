<template>
  <div>
    <div class="text-center" v-if="current_clock_log">
      <h3>You are clocked in at {{ dateTimeToString(current_clock_log.clocked_in_at) }}</h3>
      <button type="button" class="button radius bordered shadow primary" v-on:click="clockOut">Clock Out</button>
    </div>
    <div class="text-center" v-else>
      <h3>You haven't been clocked in yet</h3>
      <button type="button" class="button radius bordered shadow primary" v-on:click="clockIn">Clock In</button>
    </div>
    <hr>
    <h3 class="text-center">Clock Log History</h3>
    <table class="radius bordered shadow">
      <thead>
      <tr class="text-center">
        <th class="text-center">#</th>
        <th class="text-center">Clock In</th>
        <th class="text-center">Clock Out</th>
        <th></th>
        <th></th>
      </tr>
      </thead>
      <tbody>
      <tr class="text-center" v-for="(clock_log, index) in completed_clock_logs">
        <template v-if="clock_log === editable_clock_log">
          <td>{{ index + 1 }}</td>
          <td><datetime type="datetime" :min-datetime="minDateTime(index)" :max-datetime="clock_log.clocked_out_at" v-model="clock_log.clocked_in_at"></datetime></td>
          <td><datetime type="datetime" :min-datetime="clock_log.clocked_in_at" :max-datetime="maxDateTime(index)" v-model="clock_log.clocked_out_at"></datetime></td>
          <td><button type="button" class="button radius bordered shadow primary" v-on:click="save(clock_log)">Save</button></td>
          <td><button type="button" class="button radius bordered shadow primary" v-on:click="cancelEdit">Cancel</button></td>
        </template>
        <template v-else>
          <td>{{ index + 1 }}</td>
          <td>{{ dateTimeToString(clock_log.clocked_in_at) }}</td>
          <td>{{ dateTimeToString(clock_log.clocked_out_at) }}</td>
          <td><button type="button" class="button radius bordered shadow primary" v-on:click="editClockLog(clock_log)">Edit</button></td>
          <td ><button type="button" class="button radius bordered shadow primary" v-on:click="destroy(clock_log)">Delete</button></td>
        </template>
      </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
  import axios from 'axios';
  import { DateTime } from 'luxon';
  import { Datetime } from 'vue-datetime';
  import 'vue-datetime/dist/vue-datetime.css'

export default {
  components: {
    datetime: Datetime
  },
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
      if (confirm('Are you sure to delete the record?')) {
        axios.delete('/clock_logs/' + log.id + '.json', { headers: { 'x-csrf-token': this.token() } }).
        then((response) => {
          this.refresh()
        }).catch((response) => {
          console.log(response)
        })
      }
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
        this.clock_logs.sort(function (left, right) {
          if (left.clocked_in_at < right.clocked_in_at) { return -1 }
          if (left.clocked_in_at > right.clocked_in_at) { return 1 }
          return 0;
        })
      }).catch((response) => {
        console.log(response)
      })
    },
    minDateTime: function(index) {
      if (this.clock_logs[index - 1] === undefined) {
        return null
      }
      return this.clock_logs[index - 1].clocked_out_at
    },
    maxDateTime: function(index) {
      if (this.clock_logs[index + 1] === undefined) {
        return new Date().toISOString()
      }
      return this.clock_logs[index + 1].clocked_in_at
    },
    dateTimeToString: function(datetime) {
      return DateTime.fromISO(datetime).toLocaleString(DateTime.DATETIME_MED)
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
