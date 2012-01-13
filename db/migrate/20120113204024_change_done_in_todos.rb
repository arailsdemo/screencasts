class ChangeDoneInTodos < ActiveRecord::Migration
  def up
    add_column :todos, :isDone, :boolean
    remove_column :todos, :done
  end

  def down
    remove_column :todos, :isDone
    add_column :todos, :done, :boolean
  end
end
