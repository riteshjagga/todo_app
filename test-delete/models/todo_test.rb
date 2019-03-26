require 'test_helper'

class TodoTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  test "should not save tag without title" do
    todo = Todo.new
    assert_not todo.save, "Saved the article without a title"
  end

  test "should report error" do
    # some_undefined_variable is not defined elsewhere in the test case
    assert_raises(NameError) do
      some_undefined_variable
    end
  end

end
