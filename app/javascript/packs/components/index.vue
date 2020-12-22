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
          v-bind:id="`row_task_${task.id}`"
          :key="index"
          class="list-unstyled"
        >
          <label v-bind:for="`task_${task.id}`">
            <input
              type="checkbox"
              @change="deleteTask(task.id)"
              v-bind:id="`task_${task.id}`"
            />
            <span>{{ task.name }}</span>
          </label>
          <span @click="deleteIncompleteTask(task.id)">
            <i class="fa fa-times text-danger delete-each-task"></i>
          </span>
          <!-- <span>{{ task.created_at }}</span> -->
        </li>
      </ul>
    </div>
    <!-- 完了済みタスク表示ボタン -->
    <div class="btn btn-warning mb-3" @click="displayFinishedTasks">
      Display finished tasks
    </div>
    <!-- 完了済みタスクを全削除ボタン -->
    <!-- <button @click="deleteAllCompleteTasks" class="btn btn-danger mb-3">Delete all finished tasks</button> -->
    <!-- 完了済みタスク一覧 -->
    <div id="finished-tasks" class="display_none">
      <ul>
        <li
          v-for="(task, index) in completeTasks"
          :key="index"
          class="list-unstyled donestyle"
        >
          <label v-bind:for="`task_${task.id}`">
            <input type="checkbox" v-bind:id="`task_${task.id}`" checked disabled />
            <span>{{ task.name }}</span>
          </label>
          <span @click="deleteEachCompleteTasks(task.id)">
            <i class="fa fa-times text-danger delete-each-task"></i>
          </span>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import axios from "axios";
export default {
  data: function () {
    return {
      tasks: [],
      newTask: "",
    };
  },
  mounted: function () {
    this.fetchTasks();
  },
  methods: {
    // タスクの一覧を表示
    fetchTasks: function () {
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
    // 新規タスクを追加
    createTask: function () {
      if (!this.newTask) return;
      axios.post("/api/tasks", { task: { name: this.newTask } }).then(
        (response) => {
          this.incompleteTasks.unshift(response.data.task);
          this.newTask = "";
        },
        (error) => {
          console.log(error);
        }
      );
    },
    // 着手済タスクの表示・非表示
    displayFinishedTasks: function () {
      document
        .querySelector("#finished-tasks")
        .classList.toggle("display_none");
    },
    //未着手タスクを着手済に移動
    deleteTask: function (task_id) {
      axios.put(`/api/tasks/ ${task_id}!`, { task: { is_done: true } }).then(
        (response) => {
          this.moveFinishedTask(task_id);
        },
        (error) => {
          console.log(error);
        }
      );
    },
    moveFinishedTask: function (task_id) {
      let el = document.querySelector("#row_task_" + task_id);
      let el_clone = el.cloneNode(true);
      el.classList.add("display_none");
      el_clone.getElementsByTagName("input")[0].setAttribute("disabled","disabled")
      el_clone.classList.add("donestyle");
      el_clone.removeAttribute("id");
      console.log(el_clone);
      let li = document.querySelector("#finished-tasks > ul > li:first-child");
      document.querySelector("#finished-tasks > ul").insertBefore(el_clone, li);
    },
    // 未着手のタスクを×で削除
    deleteIncompleteTask: function (task_id) {
      document.getElementById(`row_task_${task_id}`).remove();
    },
    // 着手済タスクを選択して削除
    deleteEachCompleteTasks: function (task_id) {
      axios.delete(`/api/tasks/${task_id}`).then(
        (response) => {
          const result = this.tasks.filter((task) => {
            return task.id != response.data.id;
          });
          this.tasks = result;
        },
        (error) => {
          console.log(error);
        }
      );
    },
  },

  computed: {
    incompleteTasks: function () {
      return this.tasks.filter((task) => !task.is_done);
    },
    completeTasks: function () {
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
  color: grey;
}

.delete-each-task {
  cursor: pointer;
}
</style>
