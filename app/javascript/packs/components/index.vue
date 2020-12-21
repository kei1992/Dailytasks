<template>
  <div class="container">
    <!-- 新規作成部分 -->
    <div class="row mb-3">
      <div class="col">
        <input
          v-model="newTask"
          class="form-control"
          placeholder="Add your task!!"
        />
      </div>
      <div class="col">
        <div @click="createTask" class="btn btn-info">Add Task</div>
      </div>
    </div>
    <!-- リスト表示部分 -->
    <div>
      <ul>
        <li
          v-for="(task, index) in incompleteTasks"
          v-bind:id="'row_task_' + task.id"
          :key="index"
          class="list-unstyled"
        >
          <label v-bind:for="'task_' + task.id">
            <input type="checkbox" v-bind:id="'task_' + task.id" />
            <span>{{ task.name }}</span>
          </label>
          <span @click="deleteTask(task.id)">
            <i class="fa fa-times text-danger"></i>
          </span>
        </li>
      </ul>
    </div>
    <!-- 完了済みタスク表示ボタン -->
    <div class="btn btn-warning mb-3" @click="displayFinishedTasks">
      Display finished tasks
    </div>
    <!-- 完了済みタスクを全削除ボタン -->
    <button @click="deleteAllCompleteTask" class="btn btn-danger mb-3">
      Delete all finished tasks
    </button>
    <!-- 完了済みタスク一覧 -->
    <div id="finished-tasks" class="display_none">
      <ul>
        <li
          v-for="(task, index) in completeTasks"
          :key="index"
          class="list-unstyled donestyle"
        >
          <label v-bind:for="'task_' + task.id">
            <input type="checkbox" v-bind:id="'task_' + task.id" disabled />
            <span>{{ task.name }}</span>
          </label>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import axios from "axios";
export default {
  data: function() {
    return {
      tasks: [],
      newTask: "",
    };
  },
  // mountedはライフサイクルの一部。Vueインスタンスがマウントされたタイミングで実行
  mounted: function() {
    this.fetchTasks();
  },
  methods: {
    fetchTasks: function() {
      axios.get("/api/tasks").then(
        (response) => {
          for (let i = 0; i < response.data.tasks.length; i++) {
            this.tasks.push(response.data.tasks[i]);
          }
        },
        (error) => {
          console.log(error);
        }
      );
    },
    createTask: function() {
      if (!this.newTask) return;
      axios.post("/api/tasks", { task: { name: this.newTask } }).then(
        (response) => {
          this.tasks.unshift(response.data.task);
          this.newTask = "";
        },
        (error) => {
          console.log(error);
        }
      );
    },
    displayFinishedTasks: function() {
      document
        .querySelector("#finished-tasks")
        .classList.toggle("display_none");
    },
    deleteTask: function(task_id) {
      axios.put(`/api/tasks/ ${task_id}!`, { task: { is_done: true } }).then(
        (response) => {
          this.deleteIncompleteTask(task_id);
        },
        (error) => {
          window.alert("更新に失敗しました");
          console.log(error);
        }
      );
    },
    deleteIncompleteTask: function(task_id) {
      document.getElementById(`row_task_${task_id}`).remove();
    },
  },

  computed: {
    incompleteTasks: function() {
      return this.tasks.filter((task) => !task.is_done);
    },
    completeTasks: function() {
      return this.tasks.filter((task) => task.is_done);
    },
  },
};
</script>

<style>
.display_none {
  display: none;
}

.donestyle {
  text-decoration: line-through;
  color: lightgrey;
}
</style>
