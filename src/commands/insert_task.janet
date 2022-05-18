### ————————————————————————————————————————————————————————————————————————————————————————————————
### This module implements a command for inserting a new task in a plan.

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn insert-task
  ```
  Inserts a new pending task into the plan. If a task with the same title already exists, the
  command won't insert a new task. If a date with the date doesn't exist, the command won't insert
  a new task.

  plan - The plan entity.
  date - Date of the day into which to insert the task.
  task - Task title.
  ```
  [plan date task]
  plan)
